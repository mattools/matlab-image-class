function res = erosion(obj, varargin)
% Morphological erosion of an image.
%
%
%   Example
%     img = Image.read('rice.png');
%     imgE = erosion(img, ones(5, 5));
%     show(imgE)
%
%   See Also
%     dilation, opening, closing, morphoGradient
%


% default structuring element
if nargin == 1
    varargin = {defaultStructuringElement(obj)};
end

% process data buffer, using Matlab Image processing Toolbox
data = imerode(getBuffer(obj), varargin{:});

% create new image object for storing result
name = createNewName(obj, '%s-ero');
res = Image(data, 'Parent', obj, 'Name', name);
