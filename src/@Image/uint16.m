function res = uint16(this)
%UINT16 Get the same image but with data stored as uint16
%   
%   IMG16 = uint16(IMG);
%
%   Example
%     img = Image.read('cameraman.tif');
%     img2 = uint16(img);
%     show(img2);
%
%   See also
%   Image/getBuffer
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

res = Image('data', uint16(this.data), 'parent', this);
