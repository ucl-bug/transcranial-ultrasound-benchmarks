function makeBoxPlots()
%MAKEBOXPLOTS Make comparison box plots.
%
% DESCRIPTION:
%     makeBoxPlots generates summary figures for the different
%     intercomparison metrics as box plots. These are the figures displayed
%     in the corresponding paper.
%
%     Note: versions with and without x-axis labels are generated. The
%     individual files were manually collated to create the figures in the
%     paper.
%
%     Assumes that difference metrics have already been computed by calling
%     computeAllMetrics, and that the output metric files are stored in the
%     metrics subfolder.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 17 January 2022
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
output_folder = 'box-plots';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% benchmark names
benchmark_names = getBenchmarkNames;
num_benchmarks = length(benchmark_names);

% model names
model_names = getModelNames;
num_models = length(model_names);

% index of k-Wave in names
kwave_ind = find(ismember(model_names, 'KWAVE'));

% indices excluding k-Wave
all_except_kwave = [1:kwave_ind - 1, kwave_ind + 1:length(model_names)];

for ind = 1:2

    close all;

    % preallocate
    if ind == 1
        
        % compare all with all
        max_amp_bm              = nan(num_benchmarks, num_models * num_models);
        max_pos_bm              = nan(num_benchmarks, num_models * num_models);
        linf_bm                 = nan(num_benchmarks, num_models * num_models);
        l2_bm                   = nan(num_benchmarks, num_models * num_models);
        focal_size_axial_bm     = nan(num_benchmarks, num_models * num_models);
        focal_size_lateral_bm   = nan(num_benchmarks, num_models * num_models);

        max_amp_code            = nan(num_models, num_benchmarks * num_models);
        max_pos_code            = nan(num_models, num_benchmarks * num_models);
        linf_code               = nan(num_models, num_benchmarks * num_models);
        l2_code                 = nan(num_models, num_benchmarks * num_models);
        focal_size_axial_code   = nan(num_models, num_benchmarks * num_models);
        focal_size_lateral_code = nan(num_models, num_benchmarks * num_models);
        
        stub = '_all';
        
    else
        
        % compare all with k-Wave
        max_amp_bm              = nan(num_benchmarks, num_models - 1);
        max_pos_bm              = nan(num_benchmarks, num_models - 1);
        linf_bm                 = nan(num_benchmarks, num_models - 1);
        l2_bm                   = nan(num_benchmarks, num_models - 1);
        focal_size_axial_bm     = nan(num_benchmarks, num_models - 1);
        focal_size_lateral_bm   = nan(num_benchmarks, num_models - 1);

        max_amp_code            = nan(num_models - 1, num_benchmarks);
        max_pos_code            = nan(num_models - 1, num_benchmarks);
        linf_code               = nan(num_models - 1, num_benchmarks);
        l2_code                 = nan(num_models - 1, num_benchmarks);
        focal_size_axial_code   = nan(num_models - 1, num_benchmarks);
        focal_size_lateral_code = nan(num_models - 1, num_benchmarks);
        
        stub = '_kwave';
        
        % remove k-Wave from code names
        model_names(kwave_ind) = [];
        
    end

    % loop over benchmarks
    for bm_ind = 1:num_benchmarks

        load(['metrics/PH1-' benchmark_names{bm_ind} '-METRICS'], 'max_amp_perc', 'max_pos_mm', ...
            'l2_perc', 'linf_perc', ...
            'focal_size_6dB_x_mm', 'focal_size_6dB_y_mm', 'focal_size_6dB_z_mm');

        % exclude comparison with self
        if ind == 1
            max_amp_perc       (eye(size(max_amp_perc)) == 1) = nan;
            max_pos_mm         (eye(size(max_amp_perc)) == 1) = nan;
            linf_perc          (eye(size(max_amp_perc)) == 1) = nan;
            l2_perc            (eye(size(max_amp_perc)) == 1) = nan;
            focal_size_6dB_x_mm(eye(size(max_amp_perc)) == 1) = nan;
            focal_size_6dB_y_mm(eye(size(max_amp_perc)) == 1) = nan;
            focal_size_6dB_z_mm(eye(size(max_amp_perc)) == 1) = nan;
        end

        % average focal size differences
        if bm_ind <= num_models
            focal_size_lateral = abs(focal_size_6dB_y_mm);
        else
            focal_size_lateral = (abs(focal_size_6dB_y_mm) + abs(focal_size_6dB_z_mm)) ./ 2;
        end
        
        if ind == 1

            max_amp_bm              (bm_ind, 1:numel(max_pos_mm)) = max_amp_perc(:);
            max_pos_bm              (bm_ind, 1:numel(max_pos_mm)) = max_pos_mm(:);
            linf_bm                 (bm_ind, 1:numel(max_pos_mm)) = linf_perc(:);
            l2_bm                   (bm_ind, 1:numel(max_pos_mm)) = l2_perc(:);
            focal_size_axial_bm     (bm_ind, 1:numel(max_pos_mm)) = abs(focal_size_6dB_x_mm(:));
            focal_size_lateral_bm   (bm_ind, 1:numel(max_pos_mm)) = focal_size_lateral(:);

            st_ind = 1 + (bm_ind - 1) * num_models;

            max_amp_code            (:, st_ind:st_ind + num_models - 1) = max_amp_perc;
            max_pos_code            (:, st_ind:st_ind + num_models - 1) = max_pos_mm;
            linf_code               (:, st_ind:st_ind + num_models - 1) = linf_perc;
            l2_code                 (:, st_ind:st_ind + num_models - 1) = l2_perc;
            focal_size_axial_code   (:, st_ind:st_ind + num_models - 1) = abs(focal_size_6dB_x_mm);
            focal_size_lateral_code (:, st_ind:st_ind + num_models - 1) = focal_size_lateral;
            
        else
            
            max_amp_bm              (bm_ind, :) = max_amp_perc(kwave_ind, all_except_kwave);
            max_pos_bm              (bm_ind, :) = max_pos_mm(kwave_ind, all_except_kwave);
            linf_bm                 (bm_ind, :) = linf_perc(kwave_ind, all_except_kwave);
            l2_bm                   (bm_ind, :) = l2_perc(kwave_ind, all_except_kwave);
            focal_size_axial_bm     (bm_ind, :) = abs(focal_size_6dB_x_mm(kwave_ind, all_except_kwave));
            focal_size_lateral_bm   (bm_ind, :) = focal_size_lateral(kwave_ind, all_except_kwave);

            max_amp_code            (:, bm_ind) = max_amp_perc(kwave_ind, all_except_kwave).';
            max_pos_code            (:, bm_ind) = max_pos_mm(kwave_ind, all_except_kwave).';
            linf_code               (:, bm_ind) = linf_perc(kwave_ind, all_except_kwave).';
            l2_code                 (:, bm_ind) = l2_perc(kwave_ind, all_except_kwave).';
            focal_size_axial_code   (:, bm_ind) = abs(focal_size_6dB_x_mm(kwave_ind, all_except_kwave).');
            focal_size_lateral_code (:, bm_ind) = focal_size_lateral(kwave_ind, all_except_kwave).';
            
        end

    end

    img_format = 'epsc';

    % ==============
    % focal pressure
    % ==============

    figure;
    boxchart(max_amp_bm.');
    box on;
    grid on;
    set(gca, 'YScale', 'log', 'XTickLabel', benchmark_names);
    xtickangle(45);
    ylabel('Difference in Focal Pressure [%]');

    saveas(gcf, [output_folder filesep 'focal_pressure_benchmarks' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_pressure_benchmarks' stub '_no_xaxis'], img_format);
    
    figure;
    boxchart(max_amp_code.');
    box on;
    grid on;
    set(gca, 'YScale', 'log', 'XTickLabel', model_names); %, 'YLim', [0.1, 100]);
    xtickangle(45);
    ylabel('Difference in Focal Pressure [%]');

    saveas(gcf, [output_folder filesep 'focal_pressure_codes' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_pressure_codes' stub '_no_xaxis'], img_format);

    % ==============
    % focal position
    % ==============

    figure;
    boxchart(max_pos_bm.');
    box on;
    grid on;
    set(gca, 'XTickLabel', benchmark_names);
    xtickangle(45);
    ylabel('Difference in Focal Position [mm]');

    saveas(gcf, [output_folder filesep 'focal_position_benchmarks' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_position_benchmarks' stub '_no_xaxis'], img_format);

    figure;
    boxchart(max_pos_code.');
    box on;
    grid on;
    set(gca, 'XTickLabel', model_names);
    xtickangle(45);
    ylabel('Difference in Focal Position [mm]');

    saveas(gcf, [output_folder filesep 'focal_position_codes' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_position_codes' stub '_no_xaxis'], img_format);

    % ==============
    % linf
    % ==============

    figure;
    boxchart(linf_bm.');
    box on;
    grid on;
    set(gca, 'YScale', 'log', 'XTickLabel', benchmark_names);
    xtickangle(45);
    ylabel('Relative L^\infty [%]');

    saveas(gcf, [output_folder filesep 'linf_benchmarks' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'linf_benchmarks' stub '_no_xaxis'], img_format);

    figure;
    boxchart(linf_code.');
    box on;
    grid on;
    set(gca, 'YScale', 'log', 'XTickLabel', model_names);
    xtickangle(45);
    ylabel('Relative L^\infty  [%]');

    saveas(gcf, [output_folder filesep 'linf_codes' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'linf_codes' stub '_no_xaxis'], img_format);

    % ==============
    % l2
    % ==============

    figure;
    boxchart(l2_bm.');
    box on;
    grid on;
    set(gca, 'YScale', 'log', 'XTickLabel', benchmark_names);
    xtickangle(45);
    ylabel('Relative L^2 [%]');

    saveas(gcf, [output_folder filesep 'l2_benchmarks' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'l2_benchmarks' stub '_no_xaxis'], img_format);

    figure;
    boxchart(l2_code.');
    box on;
    grid on;
    set(gca, 'YScale', 'log', 'XTickLabel', model_names);
    xtickangle(45);
    ylabel('Relative L^2  [%]');

    saveas(gcf, [output_folder filesep 'l2_codes' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'l2_codes' stub '_no_xaxis'], img_format);

    % ==============
    % focal size
    % ==============

    figure;
    boxchart(focal_size_axial_bm.');
    box on;
    grid on;
    set(gca, 'XTickLabel', benchmark_names);
    xtickangle(45);
    ylabel('Difference in Axial Focal Size [mm]');

    saveas(gcf, [output_folder filesep 'focal_size_axial_benchmarks' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_size_axial_benchmarks' stub '_no_xaxis'], img_format);

    figure;
    boxchart(focal_size_axial_code.');
    box on;
    grid on;
    set(gca, 'XTickLabel', model_names);
    xtickangle(45);
    ylabel('Difference in Axial Focal Size [mm]');

    saveas(gcf, [output_folder filesep 'focal_size_axial_codes' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_size_axial_codes' stub '_no_xaxis'], img_format);

    figure;
    boxchart(focal_size_lateral_bm.');
    box on;
    grid on;
    set(gca, 'XTickLabel', benchmark_names);
    xtickangle(45);
    ylabel('Difference in Lateral Focal Size [mm]');

    saveas(gcf, [output_folder filesep 'focal_size_lateral_benchmarks' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_size_lateral_benchmarks' stub '_no_xaxis'], img_format);

    figure;
    boxchart(focal_size_lateral_code.');
    box on;
    grid on;
    set(gca, 'XTickLabel', model_names);
    xtickangle(45);
    ylabel('Difference in Lateral Focal Size [mm]');

    saveas(gcf, [output_folder filesep 'focal_size_lateral_codes' stub], img_format);
    
    set(gca, 'Xticklabel', []);
    scaleFig(1, 0.65);
    saveas(gcf, [output_folder filesep 'focal_size_lateral_codes' stub '_no_xaxis'], img_format);
    
end

close all;
