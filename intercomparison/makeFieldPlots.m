function makeFieldPlots(data_path)
%MAKEFIELDPLOTS Plot pressure field for each benchmark.
%
% DESCRIPTION:
%     makeFieldPlots generates example plots of the acoustic pressure field
%     for each of the benchmarks using the simulation results computed
%     using k-Wave. The generated comparison plots are saved as .eps files
%     in the field-plots sub-folder.
%
% INPUTS
%     data_path         - Path to intercomparison data.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 18 January 2022
%     last update       - 9 February 2022

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

narginchk(1, 1);

% check for folder
output_folder = 'field-plots';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% benchmark names
benchmark_names = getBenchmarkNames();

% loop over benchmarks 1 to 6
for bm_ind = 1:12
    
    % load field
    load([data_path filesep 'KWAVE' filesep 'PH1-' benchmark_names{bm_ind} '_KWAVE'], 'p_amp');
    
    % get grid size
    dx = 0.5e-3;
    [Nx, Ny] = size(p_amp);

    % define axis vectors for plotting
    x_vec = (0:(Nx-1)) * dx;
    y_vec = (-(Ny-1)/2:(Ny-1)/2) * dx;
    
    % plot
    figure;
    imagesc(1e3 * y_vec, 1e3 * x_vec, 1e-3 * p_amp);
    colormap(getColorMap);
    set(gca, 'FontSize', 14);
    xlabel('Lateral Position [mm]');
    ylabel('Axial Position [mm]');
    axis image;
    cb = colorbar;
    title(cb, '[kPa]');
    title(benchmark_names{bm_ind});
    
    saveas(gcf, [output_folder filesep 'PH1-' benchmark_names{bm_ind} '_FIELD'], 'epsc');
    
end

% loop over benchmarks 7 to 9
for bm_ind = 13:18
    
    % load field
    load([data_path filesep 'KWAVE' filesep 'PH1-' benchmark_names{bm_ind} '_KWAVE'], 'p_amp');
    
    % get grid size
    dx = 0.5e-3;
    [Nx, Ny, Nz] = size(p_amp);

    % define axis vectors for plotting
    x_vec = (0:(Nx-1)) * dx;
    y_vec = (-(Ny-1)/2:(Ny-1)/2) * dx;
    z_vec = (-(Nz-1)/2:(Nz-1)/2) * dx;
    
    % load brain mask
    if bm_ind < 15
        load([data_path '/SKULL-MAPS/skull_mask_bm7_dx_0.5mm.mat'], 'brain_mask', 'skull_mask');
    elseif bm_ind < 17
        load([data_path '/SKULL-MAPS/skull_mask_bm8_dx_0.5mm.mat'], 'brain_mask', 'skull_mask');
    else
        load([data_path '/SKULL-MAPS/skull_mask_bm9_dx_0.5mm.mat'], 'brain_mask', 'skull_mask');
    end
    
    % find maximum in brain
    p_amp_masked = p_amp;
    p_amp_masked(brain_mask ~= 1) = 0;
    [~, max_ind] = maxND(p_amp_masked);
    
    % plot fields (planes through peak of reference field in 3D)
    for ind = 1:2
            
        switch ind
            case 1
                field_plot = p_amp(:, :, max_ind(3));
                skull_plot = skull_mask(:, :, max_ind(3));
                plot_dim1 = 'X';
                plot_dim2 = 'Y';
                ax1 = x_vec;
                ax2 = y_vec;
            case 2
                field_plot = squeeze(p_amp(:, max_ind(2), :));
                skull_plot = squeeze(skull_mask(:, max_ind(2), :));
                plot_dim1 = 'X';
                plot_dim2 = 'Z';
                ax1 = x_vec;
                ax2 = z_vec;                    
            case 3
                field_plot = squeeze(p_amp(max_ind(1), :, :));
                skull_plot = squeeze(skull_mask(max_ind(1), :, :));
                plot_dim1 = 'Y';
                plot_dim2 = 'Z';
                ax1 = y_vec;
                ax2 = z_vec;
        end

        overlay_args = {...
            'LogComp', false, ...
            'ColorBar', true, ...
            'ColorBarTitle', '[kPa]', ...
            'ColorMap', 'parula', ...
            'Transparency', 0.9};
        
        for plt_ind = 1:2
            
            figure;
            if plt_ind == 1
                imagesc(ax2, ax1, 1e-3 * field_plot);
                colormap(getColorMap);
            else
                overlayPlot(ax2, ax1, single(skull_plot), 1e-3 * field_plot, overlay_args{:});
            end
            set(gca, 'FontSize', 14);
            xlabel(['Lateral Position (' plot_dim2 ') [mm]']);
            ylabel(['Axial Position (' plot_dim1 ') [mm]']);
            axis image;
            cb = colorbar;
            title(cb, '[kPa]');
            title(benchmark_names{bm_ind});
            
            if plt_ind == 1
                saveas(gcf, [output_folder filesep 'PH1-' benchmark_names{bm_ind} '_' plot_dim1 plot_dim2 '_FIELD'], 'epsc');
            else
                saveas(gcf, [output_folder filesep 'PH1-' benchmark_names{bm_ind} '_' plot_dim1 plot_dim2 '_OVERLAY'], 'epsc');
            end
            
        end
    end
end
