function res = absdiff(obj, arg)
% Absolute difference between 2 images.
%
%   Usage
%   DIFF = absdiff(I1, I2);
%
%   Example
%   absdiff
%
%   See also
%     abs
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if isa(arg, 'Image')
    arg = arg.Data;
end

newData = imabsdiff(obj.Data, cast(arg, class(obj.Data)));

res = Image('data', newData, 'parent', obj);
