function string = char(obj)
% Return a character representation of obj image object.
%
%   RES = char(IMG)
%
%   Example
%   char
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = getDimension(obj);

pattern = repmat('%d x ', 1, nd);
pattern(end-2:end) = [];
pattern = [ pattern ' %s'];

string = sprintf(pattern, getSize(obj), class(obj));
