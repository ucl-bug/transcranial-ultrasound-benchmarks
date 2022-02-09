function [bm, sc] = benchmarkind2sub(bm_lin_ind)
%BENCHMARKIND2SUB Convert linear index to BM and SC.
%
% DESCRIPTION:
%     Converts a linear benchmark index to the corresponding BM and SC
%     values.
%
% INPUTS
%     bm_lin_ind        - Linear benchmark index (1 to 18).
%
% OUTPUTS:
%     bm                - Benchmark number (1 to 9).
%     sc                - Source number (1 or 2).
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 20 January 2022
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

if rem(bm_lin_ind, 2)
    sc = 1;
else
    sc = 2;
end

bm = ceil(bm_lin_ind/2);