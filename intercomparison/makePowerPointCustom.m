function makePowerPointCustom(folder_name, model1_name, model2_name)
%MAKEPOWERPOINTSCUSTOM Make comparison PowerPoint file between two models.
%
% DESCRIPTION:
%     makePowerPointCustom generates a comparison file between two specific
%     models for all benchmarks.
%
%     The files are generated first as .pptx, and then converted to pdf
%     using pptview. This requires the MATLAB Report Generator.
%
%     It is assumed that comparison plots have already been generated using
%     makeComparisonPlotsCustom. Any missing benchmarks are skipped.
%
% EXAMPLE USAGE:
%     makePowerPointCustom('stride-optimus-comparison-plots', 'STRIDE',
%     'OPTIMUS');
%
% INPUTS:
%     folder_name       - Path to comparison plots. The generated
%                         comparison file is saved in the same directory.
%     model1_name       - Name of first model.
%     model2_name       - Name of second model.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 25 January 2022
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

% benchmark names
benchmark_names = getBenchmarkNames;

% import the PPT API Package
import mlreportgen.ppt.*

% =============
% MODEL REPORTS
% =============

% create file
filename = [folder_name filesep model2_name '-REF-' model1_name];
ppt = Presentation(filename, 'private/intercomparison_template.pptx');

% add title slide
titleSlide = add(ppt, 'Title Slide');
replace(titleSlide, 'Title', model2_name);
replace(titleSlide, 'Subtitle', ['Difference plots against ' model1_name]);

% loop over benchmarks
for bm_ind = 1:length(benchmark_names)

    sc1 = rem(bm_ind, 2);

    try

        if bm_ind < 13

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', benchmark_names{bm_ind});
            replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-FIELD.png']));

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', benchmark_names{bm_ind});
            replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-PROFILES.png']));

        else

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', benchmark_names{bm_ind});
            replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-FIELD_XY.png']));

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', benchmark_names{bm_ind});
            replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-FIELD_XZ.png']));

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', benchmark_names{bm_ind});
            replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-FIELD_YZ.png']));

            if sc1

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-FOCAL_VOLUME_XY.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-FOCAL_VOLUME_XZ.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-FOCAL_VOLUME_YZ.png']));  

            end

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', benchmark_names{bm_ind});
            replace(pictureSlide, 'Picture', Picture([folder_name filesep 'PH1-' benchmark_names{bm_ind} '-' model2_name '-REF-' model1_name '-PROFILES.png']));

        end

    catch ME
        disp(ME);
    end

end

% close the file
close(ppt);

% convert to pdf
if ispc
    pptview(filename, 'converttopdf');
end
    
% remove all powerpoint files
if ispc
    delete('supplementary-material/*.pptx');
end