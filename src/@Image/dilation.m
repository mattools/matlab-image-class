function res = dilation(this, varargin)
%DILATION Morphological dilation of an image
%
%   See Also
%     erosion, opening, closing, morphoGradient
%

% default structuring element
if nargin == 1
    varargin = {defaultStructuringElement(this)};
end

% process data buffer, using Matlab Image processing Toolbox
data = imdilate(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image(data, 'parent', this);
