function varargout = gradient(obj, varargin)
% Compute gradient of intensity image.
%
%   GIMG = gradient(IMG)
%   Compute the gradient of the image IMG. The result is a vector image,
%   containing in each channel the gradient for a direction.
%   Uses normalised sobel kernel by default.
%
%   GIMG = gradient(IMG, SIGMA)
%   Specifies the range of the gradient, and computes the size of the
%   kernel automatically.
%
%
%   Example
%     % compute and display gradient of cameraman
%     img = Image.read('cameraman.tif');
%     grad = gradient(img);
%     % display the norm of the gradient
%     show(grad);
%
%     % also display individual channels
%     gradX = channel(grad, 1); 
%     gradY = channel(grad, 2); 
%     figure; 
%     subplot(1, 2, 1); show(gradX); title('Grad X');
%     subplot(1, 2, 2); show(gradY); title('Grad Y');
%
%   See also
%     filter, fspecial, norm, channel
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
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
nd = ndims(obj);

% default filter for gradient: normalised sobel (2D or 3D)
if nd <= 2
    if sigma == 0
        % Default 2D case: normalised sobel matrix
        sx = fspecial('sobel')/8;
    else
        % compute kernel based on specified sigma value
        Nx = ceil((3*sigma));
        lx = (-Nx:Nx)';
        sy = exp(-((lx / sigma) .^2) * .5);
        sx = -(lx / sigma) .* sy;
        sx = sx * sy';
        
        % normalisation to have sum of positive values equal to 1
        sx = sx / sum(sx(sx > 0));
    end
    channelNames = {'gradX', 'gradY'};
    
elseif nd == 3
    if sigma == 0
        % Default 3D case: normalisation of 2 classical sobel matrices
        base = [1 2 1]' * [1 2 1];
        base = base / sum(base(:))/2;
        sx = permute(cat(3, base, zeros(3, 3), -base), [3 2 1]);
        
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
        
        % normalisation to have sum of positive values equal to 1
        sx = sx / sum(sx(sx > 0));
    end
    channelNames = {'gradX', 'gradY', 'gradZ'};
    
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
    gx = imfilter(cast(obj.Data, outputType), sx, varargin{:});
    gy = imfilter(cast(obj.Data, outputType), sy, varargin{:});
    
elseif nd == 3
    % precompute kernels for other directions
    sy = permute(sx, [3 1 2]);
    sz = permute(sx, [2 3 1]);
    
    % compute gradients in each main direction
    gx = imfilter(cast(obj.Data, outputType), sx, varargin{:});
    gy = imfilter(cast(obj.Data, outputType), sy, varargin{:});
    gz = imfilter(cast(obj.Data, outputType), sz, varargin{:});
end


% Depending on number of output arguments, returns either a vector image,
% or each component of the gradient vector.
if nargout == 1
    % Create a new 2D or 3D vector image
    if nd == 2
        res = Image('data', cat(4, gx, gy), ...
            'parent', obj, 'type', 'vector', 'channelNames', channelNames);
    elseif nd == 3
        res = Image('data', cat(4, gx, gy, gz), ...
            'parent', obj, 'type', 'vector', 'channelNames', channelNames);
    end
    varargout{1} = res;
    
else
    % return each component of the vector array
    varargout{1} = Image('data', gx, 'parent', obj, 'type', 'intensity');
    varargout{2} = Image('data', gy, 'parent', obj, 'type', 'intensity');
    if nd == 3
        varargout{3} = Image('data', gz, 'parent', obj, 'type', 'intensity');
    end
end
