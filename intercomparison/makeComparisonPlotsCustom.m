function makeComparisonPlotsCustom(data_path, output_folder, model1_name, model2_name)
%MAKECOMPARISONPLOTSCUSTOM Plot comparisons between two models.
%
% DESCRIPTION:
%     makeComparisonPlotsCustom sets up and calls compareTwo for all
%     benchmarks for the specified pair of models. The generated comparison
%     plots are saved as .png files in the specified sub-folder.
%
% EXAMPLE USAGE:
%     makeComparisonPlotsCustom('C:\DATA',
%     'stride-optimus-comparison-plots', 'STRIDE', 'OPTIMUS'); 
%
% INPUTS:
%     data_path         - Path to intercomparison data.
%     output_folder     - Folder to store images in.
%     model1_name       - Name of first model.
%     model2_name       - Name of second model.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 18 January 2022
%     last update       - 8 February 2022

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

narginchk(4, 4);
close all;

% check for folder
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% loop over benchmarks
for bm_ind = 1:6
    
    % loop over sources
    for sc_ind = 1:2

        compareTwo(model1_name, model2_name, bm_ind, sc_ind, data_path, true);

        filename = [output_folder filesep 'PH1-BM' num2str(bm_ind) '-SC' num2str(sc_ind) '-' model2_name '-REF-' model1_name];

        saveas(gcf, [filename '-PROFILES'], 'png');
        close(gcf);
        saveas(gcf, [filename '-FIELD'], 'png');
        close(gcf);

    end
end

% loop over benchmarks
for bm_ind = 7:9
    
    % loop over sources
    for sc_ind = 1:2
        try
            compareTwo(model1_name, model2_name, bm_ind, sc_ind, data_path, true);

            filename = [output_folder filesep 'PH1-BM' num2str(bm_ind) '-SC' num2str(sc_ind) '-' model2_name '-REF-' model1_name];

            if sc_ind == 1
                saveas(gcf, [filename '-PROFILES'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FOCAL_VOLUME_YZ'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FIELD_YZ'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FOCAL_VOLUME_XZ'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FIELD_XZ'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FOCAL_VOLUME_XY'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FIELD_XY'], 'png');
                close(gcf);
            else
                saveas(gcf, [filename '-PROFILES'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FIELD_YZ'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FIELD_XZ'], 'png');
                close(gcf);
                saveas(gcf, [filename '-FIELD_XY'], 'png');
                close(gcf);
            end
        catch ME
            disp(ME);
        end
    end
end