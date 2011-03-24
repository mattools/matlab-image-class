function res = absdiff(this, arg)
%ABSDIFF Compute absolute difference between 2 images
%
%   Usage
%   DIFF = absdiff(I1, I2);
%   DIFF = I1.absdiff(I2);
%
%   Example
%   absdiff
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if isa(arg, 'Image')
    arg = arg.data;
end

newData = imabsdiff(this.data, cast(arg, class(this.data)));

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
