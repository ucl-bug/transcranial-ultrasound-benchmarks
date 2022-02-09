function makeCrossComparisonPlots()
%MAKECROSSCOMPARISONPLOTS Make cross comparison plots.
%
% DESCRIPTION:
%     makeCrossComparisonPlots generates summary figures for the different
%     intercomparison metrics as cross comparison plots. The generated
%     plots are saved as .png files in the cross-comparison-plots
%     sub-folder.
%
%     Assumes that difference metrics have already been computed by calling
%     computeAllMetrics.
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

% check for folder
output_folder = 'cross-comparison-plots';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% benchmark names
benchmark_names = getBenchmarkNames();
num_benchmarks = length(benchmark_names);
model_names = getModelNames();
num_codes = length(model_names);

% loop over benchmarks
for bm_ind = 1:num_benchmarks
   
    load(['metrics/PH1-' benchmark_names{bm_ind} '-METRICS'], ...
        'sc', ...
        'max_amp_perc', 'max_pos_mm', ...
        'l2_perc', 'linf_perc', 'model_names', ...
        'focal_size_6dB_x_mm', 'focal_size_6dB_y_mm', 'focal_size_6dB_z_mm');
    
    % average focal size differences
    if bm_ind <= 12
        focal_size_lateral = abs(focal_size_6dB_y_mm);
    else
        focal_size_lateral = (abs(focal_size_6dB_y_mm) + abs(focal_size_6dB_z_mm)) ./ 2;
    end

    if bm_ind <= 4    
        c_sc = [0 10];
    else
        c_sc = [0 100];
    end
    
    figure;

    if sc == 1
        num_plot_c = 3;
    else
        num_plot_c = 2;
    end

    plot_ind = 1;
    subplot(2, num_plot_c, plot_ind);
    imagesc(linf_perc, c_sc);
    axis image;
    colorbar;
    title('Relative L^\infty [%]');
    set(gca, 'XTick', 1:num_codes, 'XTickLabel', model_names, ...
        'YTick', 1:num_codes, 'YTickLabel', model_names);
    xtickangle(45);
    ytickangle(45);

    plot_ind = plot_ind + 1;
    subplot(2, num_plot_c, plot_ind);
    imagesc(max_amp_perc, [0, 10]);
    axis image;
    colorbar;
    title('Difference in Focal Pressure [%]');
    set(gca, 'XTick', 1:num_codes, 'XTickLabel', model_names, ...
        'YTick', 1:num_codes, 'YTickLabel', model_names);
    xtickangle(45);
    ytickangle(45);

    if sc == 1
        plot_ind = plot_ind + 1;
        subplot(2, num_plot_c, plot_ind);
        imagesc(abs(focal_size_6dB_x_mm));
        axis image;
        colorbar;
        title('Difference in Axial Focal Size [mm]');
        set(gca, 'XTick', 1:num_codes, 'XTickLabel', model_names, ...
            'YTick', 1:num_codes, 'YTickLabel', model_names);
        xtickangle(45);
        ytickangle(45);
    end

    plot_ind = plot_ind + 1;
    subplot(2, num_plot_c, plot_ind);
    imagesc(l2_perc, c_sc);
    axis image;
    colorbar;
    title('Relative L^2 [%]');
    set(gca, 'XTick', 1:num_codes, 'XTickLabel', model_names, ...
        'YTick', 1:num_codes, 'YTickLabel', model_names);
    xtickangle(45);
    ytickangle(45);

    if sc == 1
        plot_ind = plot_ind + 1;
        subplot(2, num_plot_c, plot_ind);
        imagesc(abs(max_pos_mm));
        axis image;
        colorbar;
        title('Difference in Focal Position [mm]');
        set(gca, 'XTick', 1:num_codes, 'XTickLabel', model_names, ...
            'YTick', 1:num_codes, 'YTickLabel', model_names);
        xtickangle(45);
        ytickangle(45);
    end

    plot_ind = plot_ind + 1;
    subplot(2, num_plot_c, plot_ind);
    imagesc(focal_size_lateral);
    axis image;
    colorbar;
    title('Difference in Lateral Focal Size [mm]');
    set(gca, 'XTick', 1:num_codes, 'XTickLabel', model_names, ...
        'YTick', 1:num_codes, 'YTickLabel', model_names);
    xtickangle(45);
    ytickangle(45);

    scaleFig(2.5, 2)

    colormap(parula(5));

    sgtitle(['PH1-' benchmark_names{bm_ind}]);
    
    saveas(gcf, [output_folder filesep 'PH1-' benchmark_names{bm_ind} '_CROSS_COMPARISON'], 'png');
    
end