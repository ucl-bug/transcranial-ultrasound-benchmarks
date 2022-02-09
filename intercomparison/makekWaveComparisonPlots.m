function makekWaveComparisonPlots(data_path)
%MAKEKWAVECOMPARISONPLOTS Plot comparisons against k-Wave.
%
% DESCRIPTION:
%     makekWaveComparisonPlots sets up and calls compareTwo for all
%     benchmarks and all models using k-Wave results as a reference. The
%     generated comparison plots are saved as .png files in the
%     kwave-comparison-plots sub-folder.
%
% INPUTS:
%     data_path         - Path to intercomparison data.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 18 January 2022
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
close all;

% check for folder
output_folder = 'kwave-comparison-plots';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% list of model names
model_names = getModelNames;

% loop over benchmarks
for bm_ind = 1:6
    
    % loop over sources
    for sc_ind = 1:2

        % loop over models
        for model_ind = 1:length(model_names)
            compareTwo('KWAVE', model_names{model_ind}, bm_ind, sc_ind, data_path, true);

            filename = [output_folder filesep 'PH1-BM' num2str(bm_ind) '-SC' num2str(sc_ind) '_' model_names{model_ind}];

            saveas(gcf, [filename '_PROFILES'], 'png');
            close(gcf);
            saveas(gcf, [filename '_FIELD'], 'png');
            close(gcf);

        end
    end
end

% loop over benchmarks
for bm_ind = 7:9
    
    % loop over sources
    for sc_ind = 1:2

        % loop over codes
        for model_ind = 1:length(model_names)
            
            try
                compareTwo('KWAVE', model_names{model_ind}, bm_ind, sc_ind, data_path, true);

                filename = [output_folder filesep 'PH1-BM' num2str(bm_ind) '-SC' num2str(sc_ind) '_' model_names{model_ind}];

                if sc_ind == 1
                    saveas(gcf, [filename '_PROFILES'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FOCAL_VOLUME_YZ'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FIELD_YZ'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FOCAL_VOLUME_XZ'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FIELD_XZ'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FOCAL_VOLUME_XY'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FIELD_XY'], 'png');
                    close(gcf);
                else
                    saveas(gcf, [filename '_PROFILES'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FIELD_YZ'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FIELD_XZ'], 'png');
                    close(gcf);
                    saveas(gcf, [filename '_FIELD_XY'], 'png');
                    close(gcf);
                end

            catch ME
                disp(ME);
            end
            
        end
    end
end