function name = createNewName(obj, pattern)
% Create a new name from current image name and a string pattern.
%
%   NAME = createNewName(IMG, PATTERN)
%   Returns a new name, based on the following rule:
%   * if image name is not empty, return sprintf(PATTERN, IMG.Name)
%   * otherwise, return empty
%
%   Example
%     obj.Name = 'baseName';
%     newName = createNewName(obj, '%s-processed');
%     newName
%         'baseName-processed'
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-01-05,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.

name = '';
if ~isempty(obj.Name)
    name = sprintf(pattern, obj.Name);
end
