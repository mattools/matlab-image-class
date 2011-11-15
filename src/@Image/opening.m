function res = opening(this, varargin)
%OPENING Morphological opening of an image
%
%   See Also
%     closing, erosion, dilation, whiteTopHat

% process data buffer, using Matlab Image processing Toolbox
data = imopen(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
