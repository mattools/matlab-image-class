function dim = elementSize(this, varargin)
%ELEMENTSIZE Return channel and frame number of an image element
%
%   DIM = elementSize(IMG)
%   Returns the dimension of an individual element (pixel or voxel) in the
%   image IMG. The dimension of an element is equal to the number of
%   channels (color, vector...) multiplied by the number of frames.
%
%   DIM = elementSize(IMG, 1)
%   Returns the number of channels.
%
%   DIM = elementSize(IMG, 2)
%   Returns the number of frames (temporal positions) in image.
%
%   Example
%   img = Image.read('peppers.png');
%   elementSize(img)
%   ans =
%        3   1
%
%   See also
%   size, dataSize, channelNumber
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isempty(varargin)
    dim = this.dataSize(4:5);
    
else
    d = varargin{1};
    if d > 2
        error('Second argument must be 1 or 2');
    end
    dim = this.dataSize(d + 3);
end
