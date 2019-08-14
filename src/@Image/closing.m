function res = closing(obj, varargin)
% Morphological closing of an image.
%
%   Example
%     img = Image.read('rice.png');
%     imgC = closing(img, ones(5, 5));
%     show(imgC)
%
%   See Also
%     opening, erosion, dilation, blackTopHat

% default structuring element
if nargin == 1
    varargin = {defaultStructuringElement(obj)};
end

% process data buffer, using Matlab Image processing Toolbox
data = imclose(getBuffer(obj), varargin{:});

% create new image object for storing result
res = Image(data, 'parent', obj);
