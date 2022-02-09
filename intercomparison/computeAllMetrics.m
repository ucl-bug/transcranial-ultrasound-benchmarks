function computeAllMetrics(data_path)
%COMPUTEALLMETRICS Compute all difference metrics.
%
% DESCRIPTION:
%     computeAllMetrics sets up and calls compareTwo for all benchmarks and
%     all pairs of models, and saves the comparisons for each benchmark as
%     separate .mat files into the 'metrics' folder. The list of models
%     used is returned by getModelNames.
%
% INPUTS:
%     data_path         - Path to intercomparison data.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 17 January 2022
%     last update       - 9 February 2022

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

narginchk(1, 1);

% check for folder
if ~exist('metrics', 'dir')
    mkdir('metrics');
end

% all models
model_names = getModelNames;

% number of models
num_models = length(model_names);

% loop over benchmarks
for bm = 1:9

    % loop over sources
    for sc = 1:2

        % preallocate outputs
        linf_perc             = nan(num_models, num_models);
        l2_perc               = nan(num_models, num_models);
        max_amp_perc          = nan(num_models, num_models);
        max_pos_mm            = nan(num_models, num_models);
        focal_size_6dB_x_mm   = nan(num_models, num_models);
        focal_size_6dB_y_mm   = nan(num_models, num_models);
        focal_size_6dB_z_mm   = nan(num_models, num_models);
        focal_volume_6dB_perc = nan(num_models, num_models);

        % loop over model names
        for ind1 = 1:num_models
            for ind2 = 1:num_models

                % compute metrics
                try
                    metrics = compareTwo(model_names{ind1}, model_names{ind2}, ...
                        bm, sc, data_path, false);

                    % store differences
                    linf_perc(ind1, ind2)           = metrics.linf_perc;
                    l2_perc(ind1, ind2)             = metrics.l2_perc;
                    max_amp_perc(ind1, ind2)        = metrics.max_amp_perc;
                    max_pos_mm(ind1, ind2)          = metrics.max_pos_mm;
                    focal_size_6dB_x_mm(ind1, ind2) = metrics.focal_size_6dB_x_mm;
                    focal_size_6dB_y_mm(ind1, ind2) = metrics.focal_size_6dB_y_mm;
                    if bm > 6
                        focal_size_6dB_z_mm(ind1, ind2) = metrics.focal_size_6dB_z_mm;
                    end
                    if (bm > 6) && (sc == 1)
                        focal_volume_6dB_perc(ind1, ind2) = metrics.focal_volume_6dB_perc;
                    end

                catch ME
                    disp(ME);
                    disp('Setting metrics to nan');
                end

            end 
        end

        % filename
        filename = ['metrics/PH1-BM' num2str(bm) '-SC' num2str(sc) '-METRICS'];

        % save the data
        save(filename, ...
            'model_names', ...
            'bm', ...
            'sc', ...
            'linf_perc', ...
            'l2_perc', ...
            'max_amp_perc', ...
            'max_pos_mm', ...
            'focal_size_6dB_x_mm', ...
            'focal_size_6dB_y_mm', ...
            'focal_size_6dB_z_mm', ...
            'focal_volume_6dB_perc', ...
            '-v7.3');

    end
end
