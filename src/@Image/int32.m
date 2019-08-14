function res = int32(obj)
% Get the same image but with data stored as double.
%   
%   IMG32 = int32(IMG);
%
%   Example
%     img = Image.read('cameraman.tif');
%     img2 = int32(img);
%     show(img2);
%
%   See also
%     uint8, double, Image/getBuffer
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

res = Image('data', int32(obj.Data), 'parent', obj);
