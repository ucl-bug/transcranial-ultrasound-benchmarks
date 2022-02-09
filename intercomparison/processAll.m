function processAll(data_path)
%PROCESSALL Run all processing scripts.
%
% DESCRIPTION:
%     processAll runs all intercomparison processing scripts. This
%     generates the paper plots and supplementary materials.
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

% compute metrics
computeAllMetrics(data_path);
close all;

% make box plots
makeBoxPlots();
close all;

% make cross comparison plots
makeCrossComparisonPlots();
close all;

% make example field plots
makeFieldPlots(data_path);
close all;

% make k-Wave comparison plots
makekWaveComparisonPlots(data_path);
close all;

% make focus comparison plots
makeFocusComparisonPlots(data_path);
close all;

% generate power point files
makePowerPoints(data_path);
close all;
