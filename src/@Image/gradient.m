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
%   imfilter, fspecial
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% number of spatial dimensions
nd = this.getDimension();

% default filter for gradient: normalized sobel (2D or 3D)
if nd == 2
    sx = fspecial('sobel')/8;
else
    sx = Image.create3dGradientKernels();
end

% default output type
outputType = 'double';

% Process input arguments
for i=1:length(varargin)-1
    if strcmp(varargin{i}, 'filter')
        % another kernel for computing gradient was proposed
        sx = varargin{i+1};
        varargin(i:i+1) = [];
        continue;
        
    elseif strcmp(varargin{i}, 'outputType')
        % change data type of resulting gradient
        outputType = varargin{i+1};
        varargin(i:i+1) = [];
        continue;
    end    
end

% default options for computations
varargin = [{'replicate'}, {'conv'}, varargin];

if nd == 2
    % compute gradients in each main direction
    sy = sx';
    gx = imfilter(cast(this.data, outputType), sx, varargin{:});
    gy = imfilter(cast(this.data, outputType), sy, varargin{:});
    
elseif nd == 3
    % precompute kernels for other directions
    sy = permute(sx, [3 1 2]);
    sz = permute(sx, [2 3 1]);
    
    % compute gradients in each main direction
    gx = imfilter(cast(this.data, outputType), sx, varargin{:});
    gy = imfilter(cast(this.data, outputType), sy, varargin{:});
    gz = imfilter(cast(this.data, outputType), sz, varargin{:});
end



% Depending on number of output arguments, returns either a vector image,
% or each component of the gradient vector.
if nargout==1
    % compute gradient module
    if nd == 2
        res = Image(2, 'data', cat(4, gx, gy), 'parent', this);
    elseif nd == 3
        res = Image(3, 'data', cat(4, gx, gy, gz), 'parent', this);
    end
    varargout{1} = res;
    
else
    % return each component of the vector array
     varargout{1} = Image('data', gx, 'parent', this);
    varargout{2} = Image('data', gy, 'parent', this);
    if nd == 3
        varargout{3} = Image('data', gz, 'parent', this);
    end
end
