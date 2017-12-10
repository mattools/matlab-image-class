function res = uint8(this)
%UINT8 Get the same image but with data stored as uint8
%   
%   IMG8 = uint8(IMG);
%
%   Example
%     img = Image.read('cameraman.tif');
%     img2 = uint8(img);
%     show(img2);
%
%   See also
%     getBuffer, double, uint16, int16
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

res = Image('data', uint8(this.data), 'parent', this);

% set type
res.type = 'grayscale';
