function res = clearBorders(this, varargin)
%CLEARBORDERS Remove borders of a binary or grayscale image
%
%   Note: Deprecated, use the 'killBorder' function instead.
%
%   RES = clearBorders(IMG)
%   RES = clearBorders(IMG, CONN)
%
%   Example
%   clearBorders
%
%   See also
%     reconstruction
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

warning('Image:deprecated', ...
    'method "clearBorders" is deprecated, use "killBorders" instead');

% default connectivity
conn = 4;
if ndims(this) == 3
    conn = 8;
end

% case of connectivity specified by user
if ~isempty(varargin)
    conn = varargin{1};
end

% call matlab function
newData = imclearborder(this.data, conn);

% create resulting image
res = Image('data', newData, 'parent', this);
