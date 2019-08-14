function res = clone(obj)
% Create a deep-copy of an Image object.
%
%   output = clone(input)
%
%   Example
%   clone
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% create new image object for storing result
res = Image('data', obj.Data, 'parent', obj);
