function varargout = gradient(this, varargin)
%GRADIENT Compute gradient of a 3D image
%
%   output = gradient(input)
%
%   Example
%   gradient
%
%   See also
%   imfilter, fspecial
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% default filter for gradient: normalised sobel
% sx = fspecial('sobel')/8; % (old for 2D)
sx = repmat(fspecial('sobel')/8/3, [1 1 3]);

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

% precompute kernels for other directions
sy = permute(sx, [3 1 2]);
sz = permute(sx, [2 3 1]);

% compute gradients in each main direction
gx = imfilter(cast(this.data, outputType), sx, varargin{:});
gy = imfilter(cast(this.data, outputType), sy, varargin{:});
gz = imfilter(cast(this.data, outputType), sz, varargin{:});

% Depending on number of output arguments, returns either a new gradient
% image, or each component of the gradient vector.
if nargout==1
    % create new vector image
    res = VectorImage3D('data', cat(4, gx, gy, gz), 'parent', this);
    varargout{1} = res;
else
    % return each component of the vector array
    varargout{1} = {Image3D('data', gx, 'parent', this)};
    varargout{2} = {Image3D('data', gy, 'parent', this)};
    varargout{3} = {Image3D('data', gz, 'parent', this)};
end
