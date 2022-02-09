function model_names = getModelNames()
%GETMODELNAMES Return names for each model.
%
% DESCRIPTION:
%     getModelNames returns a cell array of the model names. Each model
%     must have a corresponding folder with the same name in the
%     intercomparison data directory. To add a new model to the
%     intercomparison, add the data to the data directory, add the model
%     name here, and then run processAll.
%
% OUTPUTS
%     model_names       - Cell array of model names.
%
% ABOUT:
%     author            - Bradley Treeby
%     date              - 19 January 2022
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

model_names = {...
    'BABELVISCOFDTD', ...
    'FULLWAVE', ...
    'GMFDTD', ...
    'HAS', ...
    'JWAVE', ...
    'KWAVE', ...
    'MSOUND', ...
    'OPTIMUS', ...
    'SALVUS', ...
    'SIM4LIFE', ...
    'STRIDE'};
