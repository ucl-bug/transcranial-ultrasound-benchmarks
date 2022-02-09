function max_amp = getMaximumPressure(data_path)
%GETMAXIMUMPRESSUE Extract maximum pressure for each benchmark.
%
% DESCRIPTION:
%     getMaximumPressure extracts the maximum pressure values anywhere in
%     the field for all benchmarks from the k-Wave results.
%
% INPUTS
%     data_path         - Path to intercomparison data.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 1 February 2022
%     last update       - 8 February 2022

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
benchmark_names = getBenchmarkNames();

% loop over benchmarks
max_amp = zeros(18, 1);
for bm_ind = 1:18
    
    % load field and extract max
    load([data_path '/KWAVE/PH1-' benchmark_names{bm_ind} '_KWAVE'], 'p_amp');
    max_amp(bm_ind) = max(p_amp(:));
    
end
