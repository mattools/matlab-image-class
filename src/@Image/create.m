function img = create(varargin)
%CREATE Static constructor of new images
%
%   Syntax
%   IMG = Image.create(SIZE, TYPE);
%   IMG = Image.create(SIZE);
%   IMG = Image.create(DATA);
%   IMG = Image.create(DATA, PARAM, VALUE...);
%
%   Description
%   IMG = Image.create(SIZE, TYPE);
%   Create a new image with size given by SIZE, and data type specified by
%   TYPE. SIZE is a row vector with as many elements as the image
%   dimension.
%
%   Example
%   create
%
%   See also
%   Image/read
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% check inputs
if isempty(varargin)
    error('should specify at least one input argument');
end

% extract basic data for creating image
var1 = varargin{1};
data = [];
if isnumeric(var1)
    varargin(1) = [];
    if size(var1, 1)==1
        % first argument is the image size
        imageSize = var1;
        nd = length(imageSize);
        
        % determines type
        type = 'uint8';
        if nargin==2
            type = varargin{2};
            varargin{1} = [];
        end
        
        % create empty data buffer
        if ~strcmp(type, 'logical')
            data = zeros(imageSize([2 1 3:nd]), type);
        else
            data = false(imageSize([2 1 3:nd]));
        end
        
    else
        % first argument is image data
        imageSize = size(var1);
        nd = length(imageSize);
        data = permute(var1, [2 1 3:nd]);
    end
    
elseif ischar(var1)
    % first argument is a string, so we iterate over argument pairs to find
    % which one contains data
    for i=1:length(varargin)
        if ~ischar(varargin{i})
            continue;
        end
        if strcmp(varargin{i}, 'data')
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
            nd = nd-1;
            imageSize(end) = [];
            if nd==2
                data = permute(data, [1 2 4 3 5]);
            end
        end
        
    else
        % non processed arguments will given to constructor
        arguments = [arguments , varargin(1:2)]; %#ok<AGROW>
    end
    
    varargin(1:2) = [];
end


% call constructor depending on image dimension
nd = length(imageSize);
img = Image(nd, 'data', data, arguments{:});

