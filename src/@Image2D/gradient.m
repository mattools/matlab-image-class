function varargout = gradient(this, varargin)
%GRADIENT Compute gradient of planar image
%
%   GIMG = IMG.gradient()
%   Compute the graident of the image IMG. The result is a vector image,
%   containing in each channel the gradient for a direction.
%
%   Example
%     % compute and display gradient of cameraman
%     img = Image.read('cameraman.tif');
%     grad = img.gradient;
%     grad.show;
%
%   See also
%   VectorImage2D, imfilter, fspecial
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% default filter for gradient: normalized sobel
% (direction is gradient over direction 1, that correspond to x-direction
% in Image2D convention for data buffer)
sx = fspecial('sobel')/8;

% check if another gradient filter is proposed
for i=1:length(varargin)-1
    if strcmp(varargin{i}, 'filter')
        sx = varargin{i+1};
        varargin(i:i+1) = [];
        break;
    end
end

% default options for computations
varargin = [{'replicate'}, {'conv'}, varargin];

% compute gradients in each main direction
sy = sx';
gx = imfilter(double(this.data), sx, varargin{:});
gy = imfilter(double(this.data), sy, varargin{:});

% Depending on number of output arguments, returns either the gradient
% module, or each component of the gradient vector.
if nargout==1
    % compute gradient module
    res = VectorImage2D('data', cat(3, gx, gy), 'parent', this);
    varargout{1} = res;
else
    % return each component of the vector array
    imgx = Image2D('data', gx, 'parent', this);
    imgy = Image2D('data', gy, 'parent', this);
    varargout{1} = imgx;
    varargout{2} = imgy;
end
