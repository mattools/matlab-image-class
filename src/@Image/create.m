function img = create(varargin)
% Static constructor of new images.
%
%   Syntax
%   IMG = Image.create(SIZE, DATACLASS);
%   IMG = Image.create(SIZE);
%   IMG = Image.create(DATA);
%   IMG = Image.create(DATA, PARAM, VALUE...);
%
%   Description
%   IMG = Image.create(SIZE, DATACLASS);
%   Create a new image with size given by SIZE, and data type specified by
%   DATACLASS. SIZE is a row vector with as many elements as the image
%   dimension.
%
%   Example
%     img = Image.create([200 200], 'uint8');
%     show(img);
%
%
%   See also
%     read, ones, zeros
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% check inputs
if isempty(varargin)
    error('Should specify at least one input argument');
end

var1 = varargin{1};

% test for copy constructor
if isa(var1, 'Image')
    warning('Image:deprecated', ...
        'deprecated syntax, use public constructor instead');
    img = Image.create(var1.Data, 'parent', var1);
    return;
end

% extract basic data for creating image
data = [];
if isnumeric(var1) || islogical(var1)
    if size(var1, 1) == 1
        % first argument is the image size
        imageSize = var1;
        nd = length(imageSize);
        
        % determines type
        type = 'uint8';
        if nargin == 2
            type = varargin{2};
            varargin(2) = [];
        end
        
        % create empty data buffer
        if strcmp(type, 'logical') || strcmp(type, 'binary')
            % case of binary image
            data = false(imageSize);
        else
            % case of grayscale image
            data = zeros(imageSize, type);
        end
        
    else
        % first argument is image data
        imageSize = size(var1);
        nd = length(imageSize);
        data = permute(var1, [2 1 3:nd]);
    end
    varargin(1) = [];
    
elseif ischar(var1)
    % first argument is a string, so we iterate over argument pairs to find
    % which one contains data
    for i = 1:length(varargin)
        if ~ischar(varargin{i})
            continue;
        end
        
        if strcmpi(varargin{i}, 'data')
            data = varargin{i+1};
            imageSize = size(data);
            varargin(i:i+1) = [];
            break;
        end
    end
end

% process specific options
arguments = {};
while length(varargin)>1
    param = varargin{1};
    if ~ischar(param)
        error('Expected parameter name');
    end
    
    if strcmpi(param, 'vector')
        value = varargin{2};
        if value 
            nd = nd - 1;
            imageSize(end) = [];
            if nd == 2
                data = permute(data, [1 2 4 3 5]);
            end
        end
        
    else
        % non processed arguments are passed to the constructor
        arguments = [arguments, varargin(1:2)]; %#ok<AGROW>
    end
    
    varargin(1:2) = [];
end

% call constructor depending on image dimension
nd = length(imageSize);
img = Image(nd, 'data', data, arguments{:});
