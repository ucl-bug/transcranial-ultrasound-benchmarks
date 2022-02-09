function rasterizeSkullMeshes(dx_vec)
%RASTERIZESKULLMESHES Rasterize skull stl files.
%
% DESCRIPTION:
%     rasterizeSkullMeshes loads the .stl files for the inner and outer
%     surface of the skull used for the intercomparison benchmarks, and
%     converts this to a grid based binary mask. The script requires
%     requires the iso2mesh toolbox from:
%
%         http://iso2mesh.sourceforge.net/cgi-bin/index.cgi
%
%     The skull geometry is loaded using stlread, and then rotated based on
%     an affine transform matrix to move the skull relative to the
%     transducer. Two target positions are used: (1) the foveal
%     representation of the primary visual cortex (V1), and (2) the hand
%     area of the primary motor cortex (M1). The generated comparison plots
%     are saved as .mat files in the skull-cartesian sub-folder.
%
%     In the generated files, the transducer is assumed to be positioned in
%     Cartesian space at [0, 0, 0], which corresponds to the centre of the
%     grid in x/y, and the first grid point in z.
% 
%     For the intercomparison (see data files), the following grid spacings
%     were generated:
%
%         1.0    = 3  PPW
%         0.5    = 6  PPW
%         0.25   = 12 PPW
%         0.1875 = 18 PPW
%         0.125  = 24 PPW
%         0.1    = 30 PPW
%
% EXAMPLE USAGE:
%     rasterizeSkullMeshes(0.5)
%
% INPUTS:
%     dx_vec        - Scalar grid spacing in mm (assumed to isotropic).
%
% ABOUT:
%     author        - Bradley Treeby
%     date          - 7 March 2021
%     last update   - 8 February 2022

% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or (at your
% option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program. If not, see <https://www.gnu.org/licenses/>.

% check for output folder
output_folder = 'skull-cartesian';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% =========================================================================
% GENERATE WHOLE SKULL FILES
% =========================================================================

% target position to load
%   1: V1
%   2: M1
for pos = 1:2

    % --------------------------------------------
    % Load and transform stl files
    % --------------------------------------------
    
    % filename
    if pos == 1
        filename_stub = 'v1';
    else
        filename_stub = 'm1';
    end
    
    disp(['Loading and transforming stl files for ' filename_stub ' target... ']);
    start_time = clock;

    % read stl (note units in mm)
    skull_outer_tr = stlread('skull-stl/skull_outer.stl');
    skull_inner_tr = stlread('skull-stl/skull_inner.stl');

    % load the affine transform matrix
    load(['skull-stl/affine_transform_' filename_stub], 'affine_transform');

    % transform stl points for outer surface using affine matrix
    skull_outer_points_transformed = zeros(size(skull_outer_tr.Points));
    for idx = 1:size(skull_outer_tr.Points, 1)
        vec = affine_transform * [skull_outer_tr.Points(idx, :).'; 1]; %#ok<*MINV>
        skull_outer_points_transformed(idx, :) = vec(1:3);
    end

    % transform stl points for inner surface using affine matrix
    skull_inner_points_transformed = zeros(size(skull_inner_tr.Points));
    for idx = 1:size(skull_inner_tr.Points, 1)
        vec = affine_transform * [skull_inner_tr.Points(idx, :).'; 1];
        skull_inner_points_transformed(idx, :) = vec(1:3);
    end
    
    disp(['completed in ' num2str(etime(clock, start_time)) 's']);

    % --------------------------------------------
    % Convert stl points to grid-based binary mesh
    % --------------------------------------------

    % loop over grid spacings
    for ind = 1:length(dx_vec)

        % set grid spacing
        dx = dx_vec(ind);
        disp(['Generating whole head ' filename_stub ' mesh for dx = ' num2str(dx) ' mm... ']);
        start_time = clock;

        % define rasterisation grid (this must cover the whole head or surf2vol
        % won't work)
        xi = -180:dx:180;
        yi = xi;
        zi = 0:dx:300;

        % convert stl files using iso2mesh - returns files on ndgrid(xi, yi, zi) so
        % indexed as [x, y, z]. This is not the same as MATLAB's 3D plotting
        % functions which use mesh grid, so x and y are reversed.
        skull_outer = uint8(surf2vol(skull_outer_points_transformed, skull_outer_tr.ConnectivityList, xi, yi, zi, 'fill', 1));
        brain_mask  = uint8(surf2vol(skull_inner_points_transformed, skull_inner_tr.ConnectivityList, xi, yi, zi, 'fill', 1));

        % build skull mask by subtracting inner volume from outer volume
        skull_mask = (skull_outer - brain_mask) > 0;
        brain_mask = brain_mask > 0; % convert to logical

        % permute so transducer points in the x-direction
        skull_mask = permute(skull_mask, [3, 2, 1]);
        brain_mask = permute(brain_mask, [3, 2, 1]);
        xi = zi;
        zi = yi;

        % save mesh
        save([output_folder filesep 'skull_mask_' filename_stub '_dx_' num2str(dx) 'mm.mat'], ...
            'xi', 'yi', 'zi', 'dx', 'skull_mask', 'brain_mask', '-v7.3');

        disp(['completed in ' num2str(etime(clock, start_time)) 's']);

    end
end

% =========================================================================
% TRIM CARTESIAN MESHES FOR BM7
% =========================================================================

% loop over grid sizes
for ind = 1:length(dx_vec)
    
    disp(['Trimming mesh for BM7, dx = ' num2str(dx) 'mm... ']);
    start_time = clock;
    
    % load the skull
    dx = dx_vec(ind);
    load([output_folder filesep 'skull_mask_v1_dx_' num2str(dx) 'mm.mat'], ...
        'xi', 'yi', 'zi', 'skull_mask', 'brain_mask');
    
    % trim
    x1 = 0;
    x2 = 120;
    y1 = -35;
    y2 = 35;
    z1 = -35;
    z2 = 35;

    [~, x1_ind] = find(xi == x1);
    [~, x2_ind] = find(xi == x2);
    [~, y1_ind] = find(yi == y1);
    [~, y2_ind] = find(yi == y2);
    [~, z1_ind] = find(zi == z1);
    [~, z2_ind] = find(zi == z2);

    xi = xi(x1_ind:x2_ind);
    yi = yi(y1_ind:y2_ind);
    zi = zi(z1_ind:z2_ind);

    skull_mask = skull_mask(x1_ind:x2_ind, y1_ind:y2_ind, z1_ind:z2_ind);
    brain_mask = brain_mask(x1_ind:x2_ind, y1_ind:y2_ind, z1_ind:z2_ind);

    % trim stray parts of skull from bottom of domain in x-direction
    Nx = size(skull_mask, 1);
    skull_mask(ceil(Nx/2):Nx, :, :) = 0;
    brain_mask(ceil(Nx/2):Nx, :, :) = 1;

    % save mesh
    save([output_folder filesep 'skull_mask_bm7_dx_' num2str(dx) 'mm.mat'], ...
        'xi', 'yi', 'zi', 'dx', 'skull_mask', 'brain_mask', '-v7.3');
    
    disp(['completed in ' num2str(etime(clock, start_time)) 's']);
    
end

% =========================================================================
% TRIM CARTESIAN MESHES FOR BM8
% =========================================================================

% loop over grid sizes
for ind = 1:length(dx_vec)
    
    disp(['Trimming mesh for BM7, dx = ' num2str(dx) 'mm... ']);
    start_time = clock;
    
    % load the skull
    dx = dx_vec(ind);
    load([output_folder filesep 'skull_mask_v1_dx_' num2str(dx) 'mm.mat'], ...
        'xi', 'yi', 'zi', 'skull_mask', 'brain_mask');
    
    % trim
    x1 = 0;
    x2 = 225;
    y1 = -85;
    y2 = 85;
    z1 = -95;
    z2 = 95;

    [~, x1_ind] = find(xi == x1);
    [~, x2_ind] = find(xi == x2);
    [~, y1_ind] = find(yi == y1);
    [~, y2_ind] = find(yi == y2);
    [~, z1_ind] = find(zi == z1);
    [~, z2_ind] = find(zi == z2);

    xi = xi(x1_ind:x2_ind);
    yi = yi(y1_ind:y2_ind);
    zi = zi(z1_ind:z2_ind);    
    
    skull_mask = skull_mask(x1_ind:x2_ind, y1_ind:y2_ind, z1_ind:z2_ind);
    brain_mask = brain_mask(x1_ind:x2_ind, y1_ind:y2_ind, z1_ind:z2_ind);

    % save mesh
    save([output_folder filesep 'skull_mask_bm8_dx_' num2str(dx) 'mm.mat'], ...
        'xi', 'yi', 'zi', 'dx', 'skull_mask', 'brain_mask', '-v7.3');
    
    disp(['completed in ' num2str(etime(clock, start_time)) 's']);
    
end

% =========================================================================
% TRIM CARTESIAN MESHES FOR BM9
% =========================================================================

% loop over grid sizes
for ind = length(dx_vec)
    
    disp(['Trimming mesh for BM7, dx = ' num2str(dx) 'mm... ']);
    start_time = clock;    
    
    % load the skull
    dx = dx_vec(ind);
    load([output_folder filesep 'skull_mask_m1_dx_' num2str(dx) 'mm.mat'], ...
        'xi', 'yi', 'zi', 'skull_mask', 'brain_mask');
    
    % trim
    x1 = 0;
    x2 = 212;
    y1 = -112;
    y2 = 112;
    z1 = -92;
    z2 = 92;

    [~, x1_ind] = find(xi == x1);
    [~, x2_ind] = find(xi == x2);
    [~, y1_ind] = find(yi == y1);
    [~, y2_ind] = find(yi == y2);
    [~, z1_ind] = find(zi == z1);
    [~, z2_ind] = find(zi == z2);

    xi = xi(x1_ind:x2_ind);
    yi = yi(y1_ind:y2_ind);
    zi = zi(z1_ind:z2_ind);
    
    skull_mask = skull_mask(x1_ind:x2_ind, y1_ind:y2_ind, z1_ind:z2_ind);
    brain_mask = brain_mask(x1_ind:x2_ind, y1_ind:y2_ind, z1_ind:z2_ind);

    % save mesh
    save([output_folder filesep 'skull_mask_bm9_dx_' num2str(dx) 'mm.mat'], ...
        'xi', 'yi', 'zi', 'dx', 'skull_mask', 'brain_mask', '-v7.3');
    
    disp(['completed in ' num2str(etime(clock, start_time)) 's']);
    
end
