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

nd = ndims(obj);

% string pattern for size (space dimensions)
pattern = ['%d' repmat(' x %d', 1, nd-1)];
pattern = [ pattern '%s %s'];

% optionnaly adds time dimension
frames = '';
nf = size(obj, 5);
if nf == 1
    frames = [' (x ' num2str(nf, '%d') ')'];
end

% concatenate with image type
string = sprintf(pattern, size(obj, 1:ndims(obj)), frames, class(obj));
