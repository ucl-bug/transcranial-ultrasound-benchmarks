function metrics_table = makeMetricsTableModel(model_name)
%MAKEMETRICSTABLEMODEL Return table with metrics for specified model and
%all benchmarks against KWAVE.
%
% DESCRIPTION:
%     makeMetricsTableModel extracts difference metrics for the
%     specified model and all benchmarks using KWAVE as a reference and
%     returns results as a table. The difference metrics are loaded using
%     the data files saved by computeAllMetrics, and saved in the metrics
%     sub-folder.
%
% INPUTS:
%     model_name        - Model intercomparison label.
%
% OUTPUTS:
%     metrics_table     - Table with computed metrics for each benchmark.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 20 January 2022
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

% list of model names
model_names = getModelNames;

% index of k-Wave in names
kwave_ind = find(ismember(model_names, 'KWAVE'));

% index of model in names
model_ind = find(ismember(model_names, model_name));

% benchmark names
benchmark_names = getBenchmarkNames;

% preallocation
linf_perc_vals              = zeros(18, 1);
l2_perc_vals                = zeros(18, 1);
max_amp_perc_vals           = zeros(18, 1);
max_pos_mm_vals             = zeros(18, 1);
focal_size_6dB_x_mm_vals    = zeros(18, 1);
focal_size_6dB_y_mm_vals    = zeros(18, 1);
focal_size_6dB_z_mm_vals    = zeros(18, 1);
focal_volume_6dB_perc_vals  = zeros(18, 1);

% loop over benchmarks
for bm_ind = 1:18

    % load comparison metrics
    load(['metrics/PH1-' benchmark_names{bm_ind} '-METRICS'], ...
        'max_amp_perc', 'max_pos_mm', ...
        'l2_perc', 'linf_perc', ...
        'focal_size_6dB_x_mm', 'focal_size_6dB_y_mm', 'focal_size_6dB_z_mm', ...
        'focal_volume_6dB_perc');
    
    % copy relevant value
    linf_perc_vals(bm_ind) = linf_perc(kwave_ind, model_ind);
    l2_perc_vals(bm_ind) = l2_perc(kwave_ind, model_ind);
    max_amp_perc_vals(bm_ind) = max_amp_perc(kwave_ind, model_ind);
    max_pos_mm_vals(bm_ind) = max_pos_mm(kwave_ind, model_ind);
    focal_size_6dB_x_mm_vals(bm_ind) = focal_size_6dB_x_mm(kwave_ind, model_ind);
    focal_size_6dB_y_mm_vals(bm_ind) = focal_size_6dB_y_mm(kwave_ind, model_ind);
    focal_size_6dB_z_mm_vals(bm_ind) = focal_size_6dB_z_mm(kwave_ind, model_ind);
    focal_volume_6dB_perc_vals(bm_ind) = focal_volume_6dB_perc(kwave_ind, model_ind);

end

% create table
metrics_table = table(...
    linf_perc_vals, ...
    l2_perc_vals, ...
    max_amp_perc_vals, ...
    max_pos_mm_vals, ...
    focal_size_6dB_x_mm_vals, ...
    focal_size_6dB_y_mm_vals, ...
    focal_size_6dB_z_mm_vals, ...
    focal_volume_6dB_perc_vals);
metrics_table = varfun(@(x) num2str(x, 2), metrics_table);
metrics_table = varfun(@replaceCharNans, metrics_table);
metrics_table.Properties.RowNames = benchmark_names;
metrics_table.Properties.VariableNames = {...
    'Relative Linf [% of max]', ...
    'Relative L2 [%]', ...
    'Difference in Focal Pressure [%]', ...
    'Difference in Focal Position [mm]', ...
    'Difference in Axial Focal Size (X) [mm]', ...
    'Difference in Lateral Focal Size (Y) [mm]', ...
    'Difference in Lateral Focal Size (Z) [mm]', ...
    'Difference in Focal Volume [%]'};
