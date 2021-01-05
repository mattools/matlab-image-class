function res = opening(obj, varargin)
% Morphological opening of an image.
%
%
%   Example
%     img = Image.read('rice.png');
%     imgO = closing(img, ones(5, 5));
%     show(imgO)
%
%   See Also
%     closing, erosion, dilation, whiteTopHat
%

% default structuring element
if nargin == 1
    varargin = {defaultStructuringElement(obj)};
end

% process data buffer, using Matlab Image processing Toolbox
data = imopen(getBuffer(obj), varargin{:});

% create new image object for storing result
name = createNewName(obj, '%s-op');
res = Image(data, 'Parent', obj, 'Name', name);
