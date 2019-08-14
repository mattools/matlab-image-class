function res = ctranspose(obj)
% Overload the ctranspose function (for 2D images only).
%
%   TRANSP = ctranspose(IMG)
%   TRANSP = IMG'
%
%   Example
%     img = Image.read('cameraman.tif');
%     img2 = img';
%     show(img2);
%
%   See also
%     size, permute
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% check dimension
nd = ndims(obj);
if nd > 2
    error('ctranspose is not defined for Images with dimension greater than 2');
end

% permute data array
dat = permute(obj.Data, [2 1 3:5]);

res = Image('data', dat, 'parent', obj);
