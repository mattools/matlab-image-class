function res = ctranspose(this)
%CTRANSPOSE Overload the ctranspose function (for 2D images only)
%
%   TRANSP = ctranspose(IMG)
%   TRANSP = IMG'
%
%   Example
%   ctranspose
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% check dimension
nd = getDimension(this);
if nd>2
    error('ctranspose is not defined for Images with dimension greater than 2');
end

% permute data array
dat = permute(this.data, [2 1 3:5]);

res = Image(nd, 'data', dat, 'parent', this);
