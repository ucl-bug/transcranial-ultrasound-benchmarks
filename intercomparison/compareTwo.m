function metrics = compareTwo(model1_name, model2_name, bm, sc, data_path, plot_fields)
%COMPARETWO Compare two results for a given benchmark.
%
% DESCRIPTION:
%     compareTwo sets up and calls computeDifferenceMetrics for the given
%     benchmark, loading the data from the specified intercomparison
%     folder. The model names must much the names used for folders /
%     datasets in the specified data_path (e.g., 'KWAVE').
%
% EXAMPLE USAGE:
%     metrics = compareTwo('KWAVE', 'STRIDE', 7, 1, 'C:\DATA', true);
%
% INPUTS:
%     model1_name       - Name of first model.
%     model2_name       - Name of second model.
%     bm                - Benchmark number.
%     sc                - Source number.
%     data_path         - Path to intercomparison data.
%
% OPTIONAL INPUTS
%     plot_fields       - Boolean controlling whether fields are plotted
%                         (default = true).
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 22 July 2021
%     last update       - 8 February 2022

% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or (at
% your option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
% General Public License for more details.
% 
% You should have received a copy of the GNU Lesser General Public License
% along with this program. If not, see <https://www.gnu.org/licenses/>.

% optional inputs
narginchk(5, 6);
if (nargin < 6) || (isempty(plot_fields))
    plot_fields = true;
end

% literals
dx = 0.5e-3;                    % grid spacing
exit_plane_index_sc1 = 20;      % starting point for comparisons
exit_plane_index_sc2 = 2;       % starting point for comparisons
lateral_profile_index = 121;    % position to take lateral profiles for sc = 2 

% specify the path to the two datasets
filename1 = [data_path filesep model1_name filesep 'PH1-BM' num2str(bm) '-SC' num2str(sc) '_' model1_name];
filename2 = [data_path filesep model2_name filesep 'PH1-BM' num2str(bm) '-SC' num2str(sc) '_' model2_name];

% load data for field 1
field1_p_amp = [];
if exist([filename1 '.mat'], 'file')
    field1 = load(filename1);
    if isfield(field1, 'p_amp')
        field1_p_amp = field1.p_amp;
    else
        disp(['Couldn''t find p_amp in file for ' model1_name]);
    end
elseif exist([filename1 '.h5'], 'file')
    field1_p_amp = h5read([filename1 '.h5'], '/p_amp');
else
    error(['Couldn''t find file for ' model1_name]);
end

% load data for field 2
field2_p_amp = [];
if exist([filename2 '.mat'], 'file')
    field2 = load(filename2);
    if isfield(field2, 'p_amp')
        field2_p_amp = field2.p_amp;
    else
        disp(['Couldn''t find p_amp in file for ' model2_name]);
    end
elseif exist([filename2 '.h5'], 'file')
    field2_p_amp = h5read([filename2 '.h5'], '/p_amp');
else
    error(['Couldn''t find file for ' model2_name]);
end

% temporary hack to make BabelVisco results the correct size
if bm > 6
    if strcmp(model1_name, 'BABELVISCOFDTD')
        field1_p_amp = permute(field1_p_amp, [3 2 1]);
    end
    if strcmp(model2_name, 'BABELVISCOFDTD')
        field2_p_amp = permute(field2_p_amp, [3 2 1]);
    end
end

% make sure data is the same size
if ~all(size(field1_p_amp) == size(field2_p_amp))
    error(['The two fields ' model1_name ' and ' model2_name ' are not the same size.']);
end

% set brain mask
if bm > 6
    
    % load brain mask from file
    load([data_path '/SKULL-MAPS/skull_mask_bm' num2str(bm) '_dx_0.5mm.mat'], 'brain_mask');
    
else
    
    % specify brain mask manually
    brain_start_index = 2 + round(30e-3/dx) + round(6.5e-3/dx);
    brain_mask = zeros(size(field1_p_amp));
    brain_mask(brain_start_index:end, :, :) = 1; 
    
end

% exit plane index
if sc == 1
    exit_plane_index = exit_plane_index_sc1;
else
    exit_plane_index = exit_plane_index_sc2;
end

% compute metrics
if bm == 1
    input_args = {...
        'ExitPlaneIndex', exit_plane_index, ...
        'FocalMask', brain_mask};
elseif sc == 2
    input_args = {...
        'ExitPlaneIndex', exit_plane_index, ...
        'FocalMask', brain_mask, ...
        'LateralProfileIndex', lateral_profile_index};
elseif bm < 7
    input_args = {...
        'ExitPlaneIndex', exit_plane_index, ...
        'FocalMask', brain_mask};
else
    input_args = {...
        'ExitPlaneIndex', exit_plane_index, ...
        'FocalMask', brain_mask, ...
        'VolumeMetrics', true};
end
metrics = computeDifferenceMetrics(model1_name, field1_p_amp, model2_name, field2_p_amp, dx, ...
    input_args{:}, 'Plot', plot_fields);
