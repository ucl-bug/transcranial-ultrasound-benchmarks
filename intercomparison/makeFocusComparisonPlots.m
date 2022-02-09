function makeFocusComparisonPlots(data_path)
%MAKEFOCUSCOMPARISONPLOTS Plot comparisons against FOCUS for BM1.
%
% DESCRIPTION:
%     makeFocusComparisonPlots sets up and calls compareTwo for benchmarks
%     1 and 2 using FOCUS results as a reference, and saves the generated
%     comparison plots as .png files in the focus-comparison-plots
%     sub-folder.
%
% INPUTS:
%     data_path         - Path to intercomparison data.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 19 January 2022
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

close all;

% check for folder
output_folder = 'focus-comparison-plots';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% list of model names
model_names = getModelNames;

% loop over benchmarks
for bm_ind = 1:2

    % loop over sources
    for sc_ind = 1:2

        % loop over models
        for model_ind = 1:length(model_names)
            compareTwo('FOCUS', model_names{model_ind}, bm_ind, sc_ind, data_path, true);

            filename = [output_folder filesep 'PH1-BM' num2str(bm_ind) '-SC' num2str(sc_ind) '_' model_names{model_ind}];

            saveas(gcf, [filename '_PROFILES'], 'png');
            close(gcf);
            saveas(gcf, [filename '_FIELD'], 'png');
            close(gcf);

        end
    end
end
