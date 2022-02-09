function metrics_table = makeMetricsTableFocus(bm, sc, data_path)
%MAKEMETRICSTABLEFOCUS Return table with metrics for specified
%benchmark and all models against FOCUS.
%
% DESCRIPTION:
%     makeMetricsTableBenchmark calculates difference metrics for the
%     specified benchmark using FOCUS as a reference and returns results as
%     a table. The difference metrics are computed using
%     computeDifferenceMetrics.
%
% INPUTS:
%     bm                - Benchmark number (1 to 2).
%     sc                - Source number (1 or 2).
%     data_path         - Path to intercomparison data.
%
% OUTPUTS:
%     metrics_table     - Table with computed metrics for each model.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 18 March 2021
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

% number of models
num_models = length(model_names);

% produce plots
plot_comparisons = false;

% load reference solution
field1 = load([data_path '/FOCUS/PH1-BM' num2str(bm) '-SC' num2str(sc) '_FOCUS.mat']);
field1_name = 'FOCUS';

% grid size
dx = 0.5e-3;

% skip the first part of the field from the comparison
if sc == 1
    input_args = {'ExitPlaneIndex', 20};
else
    brain_mask = zeros(size(field1.p_amp));
    brain_mask(35:end, :) = 1;    
    input_args = {'ExitPlaneIndex', 2, 'FocalMask', brain_mask};
end

% preallocate variable names
linf    = nan(num_models, 1);
l2      = nan(num_models, 1);
max_amp = nan(num_models, 1);
max_pos = nan(num_models, 1);
focal_l = nan(num_models, 1);
focal_w = nan(num_models, 1);

% loop over model names
for ind = 1:num_models

    % construct filename
    filename = [data_path '/' model_names{ind} '/PH1-BM' num2str(bm) '-SC' num2str(sc) '_' model_names{ind}];

    % load data
    field2_p_amp = [];
    field2_name = model_names{ind};
    if exist([filename '.mat'], 'file')
        field2 = load(filename);
        if isfield(field2, 'p_amp')
            field2_p_amp = field2.p_amp;
        else
            disp(['Couldn''t find p_amp in file for ' model_names{ind}]);
        end
    elseif exist([filename '.h5'], 'file')
        field2_p_amp = h5read([filename '.h5'], '/p_amp');
    end

    % compute errors
    if isempty(field2_p_amp)
        disp(['Couldn''t find file for ' model_names{ind}]);
    elseif any(size(field1.p_amp) ~= size(field2_p_amp))
        disp(['Data for ' model_names{ind} ' is the wrong size']);
    else
        metrics = computeDifferenceMetrics(field1_name, field1.p_amp, field2_name, field2_p_amp, dx, ...
            input_args{:}, 'Plot', plot_comparisons);
        linf(ind)    = metrics.linf_perc;
        l2(ind)      = metrics.l2_perc;
        max_amp(ind) = metrics.max_amp_perc;
        max_pos(ind) = metrics.max_pos_mm;
        focal_l(ind) = metrics.focal_size_6dB_x_mm;
        focal_w(ind) = metrics.focal_size_6dB_y_mm;
    end

end

metrics_table = table(linf, l2, max_amp, max_pos, focal_l, focal_w);
metrics_table = varfun(@(x) num2str(x, 2), metrics_table);
metrics_table = varfun(@replaceCharNans, metrics_table);
metrics_table.Properties.RowNames = model_names;
metrics_table.Properties.VariableNames = {...
    'Relative Linf [% of max]', ...
    'Relative L2 [%]', ...
    'Difference in Focal Pressure [%]', ...
    'Difference in Focal Position [mm]', ...
    'Difference in Axial Focal Size [mm]', ...
    'Difference in Lateral Focal Size [mm]'};
