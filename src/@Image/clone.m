function res = clone(obj)
% Create a deep-copy of an Image object.
%
%   RES = clone(IMG)
%   Return a new Image, initialized with same data values as in IMG.
%
%
%   Example
%     img = Image.read('rice.png');
%     img2 = clone(img);
%     all(size(img) == size(img2))
%     ans =
%          1
%     strcmp(class(img.Data), class(img2.Data))
%     ans =
%          1
%
%   See also
%     read, zeros, ones
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% create new image object for storing result
res = Image('data', obj.Data, 'parent', obj);
