function metrics_table = makeMetricsTableBenchmark(bm, sc)
%MAKEMETRICSTABLEBENCHMARK Return table with metrics for specified
%benchmark and all models against KWAVE.
%
% DESCRIPTION:
%     makeMetricsTableBenchmark extracts difference metrics for the
%     specified benchmark and all models using KWAVE as a reference and
%     returns results as a table. The difference metrics are loaded using
%     the data files saved by computeAllMetrics, and saved in the metrics
%     sub-folder.
%
% INPUTS:
%     bm                - Benchmark number (1 to 9).
%     sc                - Source number (1 or 2).
%
% OUTPUTS:
%     metrics_table     - Table with computed metrics for each model.
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

% indices excluding k-Wave
all_except_kwave = [1:kwave_ind - 1, kwave_ind + 1:length(model_names)];

% remove k-Wave from model names
model_names(kwave_ind) = [];

% load comparison metrics
load(['metrics/PH1-BM' num2str(bm) '-SC' num2str(sc) '-METRICS'], ...
    'max_amp_perc', 'max_pos_mm', ...
    'l2_perc', 'linf_perc', ...
    'focal_size_6dB_x_mm', 'focal_size_6dB_y_mm', 'focal_size_6dB_z_mm', ...
    'focal_volume_6dB_perc');

% create table
metrics_table = table(...
    linf_perc(kwave_ind, all_except_kwave).', ...
    l2_perc(kwave_ind, all_except_kwave).', ...
    max_amp_perc(kwave_ind, all_except_kwave).', ...
    max_pos_mm(kwave_ind, all_except_kwave).', ...
    focal_size_6dB_x_mm(kwave_ind, all_except_kwave).', ...
    focal_size_6dB_y_mm(kwave_ind, all_except_kwave).', ...
    focal_size_6dB_z_mm(kwave_ind, all_except_kwave).', ...
    focal_volume_6dB_perc(kwave_ind, all_except_kwave).');
metrics_table = varfun(@(x) num2str(x, 2), metrics_table);
metrics_table = varfun(@replaceCharNans, metrics_table);
metrics_table.Properties.RowNames = model_names;
metrics_table.Properties.VariableNames = {...
    'Relative Linf [% of max]', ...
    'Relative L2 [%]', ...
    'Difference in Focal Pressure [%]', ...
    'Difference in Focal Position [mm]', ...
    'Difference in Axial Focal Size (X) [mm]', ...
    'Difference in Lateral Focal Size (Y) [mm]', ...
    'Difference in Lateral Focal Size (Z) [mm]', ...
    'Difference in Focal Volume [%]'};
