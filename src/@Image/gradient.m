function varargout = gradient(this, varargin)
%GRADIENT Compute gradient of intensity image
%
%   GIMG = gradient(IMG)
%   Compute the gradient of the image IMG. The result is a vector image,
%   containing in each channel the gradient for a direction.
%
%   Example
%     % compute and display gradient of cameraman
%     img = Image.read('cameraman.tif');
%     grad = gradient(img);
%     show(grad);
%
%   See also
%   Image/filter, fspecial, Image/norm

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2010-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% default sigma
sigma = 0;

% default output type
outputType = 'double';

% check if the width of the kernel is specified
if ~isempty(varargin)
    var1 = varargin{1};
    if isnumeric(var1) && isscalar(var1)
        sigma = var1;
        varargin(1) = [];
    end
end

% number of spatial dimensions
nd = ndims(this);

% default filter for gradient: normalised sobel (2D or 3D)
if nd <= 2
    if sigma == 0
        % Default 2D case: normalised sobel matrix
        sx = fspecial('sobel')'/8;
    else
        % compute kernel based on specified sigma value
        Nx = ceil((3*sigma));
        lx = -Nx:Nx;
        sy = exp(-((lx / sigma) .^2) * .5);
        sx = -(lx / sigma) .* sy;
        sx = sy' * sx;
        sx = sx / sum(sx(sx > 0));
    end
    
elseif nd == 3
    if sigma == 0
        % Default 3D case: normalisation of 2 classical sobel matrices
        base = [1 2 1]' * [1 2 1];
        base = base / sum(base(:))/2;
        sx = permute(cat(3, base, zeros(3, 3), -base), [2 3 1]);
        
    else
        % compute kernel based on specified sigma value
        Nx = ceil((3*sigma));
        lx = -Nx:Nx;
        sy = exp(-((lx / sigma) .^2) * .5);
        sx = -(lx / sigma) .* sy;
        sz = permute(sy, [3 1 2]);

        n = length(lx);
        tmp = zeros(n, n , n);
        for i = 1:n
            tmp(:,:,i) = sz(i) * sy' * sx;
        end
        sx = tmp;
        sx = sx / sum(sx(sx > 0));
    end
    
else
    error('Input image must have 2 or 3 dimensions');
end

% Process input arguments
for i = 1:length(varargin)-1
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
if nargout == 1
    % Create a new 2D or 3D vector image
    if nd == 2
        res = Image('data', cat(4, gx, gy), ...
            'parent', this, 'type', 'vector');
    elseif nd == 3
        res = Image('data', cat(4, gx, gy, gz), ...
            'parent', this, 'type', 'vector');
    end
    varargout{1} = res;
    
else
    % return each component of the vector array
    varargout{1} = Image('data', gx, 'parent', this, 'type', 'vector');
    varargout{2} = Image('data', gy, 'parent', this, 'type', 'vector');
    if nd == 3
        varargout{3} = Image('data', gz, 'parent', this, 'type', 'vector');
    end
end
