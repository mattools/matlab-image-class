function res = dilation(obj, varargin)
% Morphological dilation of an image.
%
%   Example
%     img = Image.read('rice.png');
%     imgD = dilation(img, ones(5, 5));
%     show(imgD)
%
%   See Also
%     erosion, opening, closing, morphoGradient
%

% default structuring element
if nargin == 1
    varargin = {defaultStructuringElement(obj)};
end

% process data buffer, using Matlab Image processing Toolbox
data = imdilate(getBuffer(obj), varargin{:});

% create new image object for storing result
res = Image(data, 'parent', obj);
