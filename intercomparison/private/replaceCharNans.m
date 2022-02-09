function char_array = replaceCharNans(char_array)
%REPLACECHARNANS Replace NaN with en-dash in char array.
%
% DESCRIPTION:
%     replaceCharNans replaces all instances of 'NaN' in the given char
%     array with '  -'.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 1 February 2022
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

% loop over char array and replace NaN with -
for ind = 1:size(char_array, 1)
    char_array(ind, :) = strrep(char_array(ind, :), 'NaN', '  -');
end
