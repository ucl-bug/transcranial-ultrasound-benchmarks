function makePowerPoints(data_path)
%MAKEPOWERPOINTS Make comparison PowerPoint files.
%
% DESCRIPTION:
%     makePowerPoints generates supplementary information pdf files,
%     including:
%         1. A summary file for each benchmark, with comparison plots for
%            all models against KWAVE.
%         2. A summary file for benchmarks 1 and 2, with comparison plots
%            for all models against FOCUS.
%         3. A summary file for each model, with comparison plots for all
%            benchmarks against KWAVE. 
%         4. A cross-comparison summary, with cross-comparisons between all
%            model pairs for all benchmarks.
%
%     The files are generated first as .pptx, and then converted to pdf
%     using pptview. This requires the MATLAB Report Generator.
%
%     It is assumed that comparison plots have already been generated using
%     makekWaveComparisonPlots, makeCrossComparisonPlots, and
%     makeFocusComparisonPlots. Any missing benchmarks are skipped.
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

% benchmark names
benchmark_names = getBenchmarkNames;
num_benchmarks = length(benchmark_names);

% check for folder
output_folder = 'supplementary-material';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% import the PPT API Package
import mlreportgen.ppt.*

% ==================================
% CROSS-COMPARISON SUMMARY
% ==================================

% create file
filename = [output_folder filesep 'CROSS-COMPARISON-SUMMARY'];
ppt = Presentation(filename, 'private/intercomparison_template.pptx');

% add title slide
titleSlide = add(ppt, 'Title Slide');
replace(titleSlide, 'Title', 'CROSS COMPARISON SUMMARY');
replace(titleSlide, 'Subtitle', 'Cross comparison plots for each benchmark');    
    
% loop over benchmarks
for bm_ind = 1:num_benchmarks
    
    % cross comparison
    pictureSlide = add(ppt, 'Picture');
    replace(pictureSlide, 'Picture', Picture(['cross-comparison-plots/PH1-' benchmark_names{bm_ind} '_CROSS_COMPARISON.png']));
    
end

% close the file
close(ppt);

% convert to pdf
if ispc
    pptview(filename, 'converttopdf');
end

% ==================================
% MODEL REPORTS - KWAVE AS REFERENCE
% ==================================

% list of model names
model_names = getModelNames;

% index of k-Wave in names
kwave_ind = find(ismember(model_names, 'KWAVE'));

% remove k-Wave from code names
model_names(kwave_ind) = []; %#ok<FNDSB>

% loop over model names
for model_ind = 1:length(model_names)

    % create file
    filename = [output_folder filesep model_names{model_ind} '-REF-KWAVE'];
    ppt = Presentation(filename, 'private/intercomparison_template.pptx');
    
    % add title slide
    titleSlide = add(ppt, 'Title Slide');
    replace(titleSlide, 'Title', model_names{model_ind});
    replace(titleSlide, 'Subtitle', 'Difference plots against KWAVE');
    
    % get metrics
    metrics_table = makeMetricsTableModel(model_names{model_ind});
    metrics_table = Table(metrics_table);
    metrics_table.FontSize = '10pt';
    
    % add table
    tableSlide = add(ppt, 'Title and Content');
    replace(tableSlide, 'Title', 'Comparison Metrics Against KWAVE');
    contents = find(ppt,'Content');
    replace(contents(1), metrics_table);    
    
    % loop over benchmarks
    for bm_ind = 1:num_benchmarks
        
        sc1 = rem(bm_ind, 2);
        
        try
        
            if bm_ind < 13

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_PROFILES.png']));

            else

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD_XY.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD_XZ.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD_YZ.png']));

                if sc1
                
                    pictureSlide = add(ppt, 'Title and Picture');
                    replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                    replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FOCAL_VOLUME_XY.png']));

                    pictureSlide = add(ppt, 'Title and Picture');
                    replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                    replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FOCAL_VOLUME_XZ.png']));

                    pictureSlide = add(ppt, 'Title and Picture');
                    replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                    replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FOCAL_VOLUME_YZ.png']));  
                    
                end

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', benchmark_names{bm_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_PROFILES.png']));

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
    
end
 
% ======================================
% BENCHMARK REPORTS - KWAVE AS REFERENCE
% ======================================

% loop over benchmarks
for bm_ind = 1:num_benchmarks

    % list of model names
    model_names = getModelNames;
    
    % index of k-Wave in names
    kwave_ind = find(ismember(model_names, 'KWAVE'));

    % remove k-Wave from code names
    model_names(kwave_ind) = []; %#ok<FNDSB>
    
    % create file
    filename = [output_folder filesep 'PH1-' benchmark_names{bm_ind} '-REF-KWAVE'];
    ppt = Presentation(filename, 'private/intercomparison_template.pptx');
    
    % add title slide
    titleSlide = add(ppt, 'Title Slide');
    replace(titleSlide, 'Title', ['PH1-' benchmark_names{bm_ind}]);
    replace(titleSlide, 'Subtitle', 'Difference plots against KWAVE');
    
    % cross comparison
    pictureSlide = add(ppt, 'Title and Picture 2');
    replace(pictureSlide, 'Title', 'Cross Comparison');
    replace(pictureSlide, 'Picture', Picture(['cross-comparison-plots/PH1-' benchmark_names{bm_ind} '_CROSS_COMPARISON.png']));
    
    % get metrics
    [bm, sc] = benchmarkind2sub(bm_ind);
    metrics_table = makeMetricsTableBenchmark(bm, sc);
    metrics_table = Table(metrics_table);
    metrics_table.FontSize = '10pt';
    
    % add table
    tableSlide = add(ppt, 'Title and Content');
    replace(tableSlide, 'Title', 'Comparison Metrics Against KWAVE');
    contents = find(ppt,'Content');
    replace(contents(1), metrics_table);
    
    % loop over model names
    for model_ind = 1:length(model_names)
        
        sc1 = rem(bm_ind, 2);
        
        try
        
            if bm_ind < 13

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', model_names{model_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', model_names{model_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_PROFILES.png']));

            else

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', model_names{model_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD_XY.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', model_names{model_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD_XZ.png']));

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', model_names{model_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD_YZ.png']));

                if sc1
                
                    pictureSlide = add(ppt, 'Title and Picture');
                    replace(pictureSlide, 'Title', model_names{model_ind});
                    replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FOCAL_VOLUME_XY.png']));

                    pictureSlide = add(ppt, 'Title and Picture');
                    replace(pictureSlide, 'Title', model_names{model_ind});
                    replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FOCAL_VOLUME_XZ.png']));

                    pictureSlide = add(ppt, 'Title and Picture');
                    replace(pictureSlide, 'Title', model_names{model_ind});
                    replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FOCAL_VOLUME_YZ.png']));  
                    
                end

                pictureSlide = add(ppt, 'Title and Picture');
                replace(pictureSlide, 'Title', model_names{model_ind});
                replace(pictureSlide, 'Picture', Picture(['kwave-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_PROFILES.png']));

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
    
end

% ======================================
% BENCHMARK REPORTS - FOCUS AS REFERENCE
% ======================================

% loop over benchmarks
for bm_ind = 1:4

    % list of model names
    model_names = getModelNames;
    
    % create file
    filename = [output_folder filesep 'PH1-' benchmark_names{bm_ind} '-REF-FOCUS'];
    ppt = Presentation(filename, 'private/intercomparison_template.pptx');
    
    % add title slide
    titleSlide = add(ppt, 'Title Slide');
    replace(titleSlide, 'Title', ['PH1-' benchmark_names{bm_ind}]);
    replace(titleSlide, 'Subtitle', 'Difference plots against FOCUS');
    
    % get metrics against FOCUS
    switch bm_ind
        case 1
            metrics_table = makeMetricsTableFocus(1, 1, data_path);
        case 2
            metrics_table = makeMetricsTableFocus(1, 2, data_path);
        case 3
            metrics_table = makeMetricsTableFocus(2, 1, data_path);
        case 4
            metrics_table = makeMetricsTableFocus(2, 2, data_path);
    end
    metrics_table = Table(metrics_table);
    metrics_table.FontSize = '10pt';
    
    % add table
    tableSlide = add(ppt, 'Title and Content');
    replace(tableSlide, 'Title', 'Comparison Metrics Against FOCUS');
    contents = find(ppt,'Content');
    replace(contents(1), metrics_table);
    
    % loop over model names
    for model_ind = 1:length(model_names)
        try

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', model_names{model_ind});
            replace(pictureSlide, 'Picture', Picture(['focus-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_FIELD.png']));

            pictureSlide = add(ppt, 'Title and Picture');
            replace(pictureSlide, 'Title', model_names{model_ind});
            replace(pictureSlide, 'Picture', Picture(['focus-comparison-plots/PH1-' benchmark_names{bm_ind} '_' model_names{model_ind} '_PROFILES.png']));

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
    
end

% remove all powerpoint files
if ispc
    delete('supplementary-material/*.pptx');
end
