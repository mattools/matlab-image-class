function res = uint32(obj)
% Get the same image but with data stored as uint32.
%   
%   IMG32 = uint32(IMG);
%
%   Example
%     img = Image.read('cameraman.tif');
%     img2 = uint32(img);
%     show(img2);
%
%   See also
%     getBuffer, uint8, uint16, double
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

res = Image('data', uint32(obj.Data), 'parent', obj);

% set type
res.Type = 'grayscale';
