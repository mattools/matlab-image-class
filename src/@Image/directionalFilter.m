function res = directionalFilter(this, varargin)
%DIRECTIONALFILTER Apply and combine several directional filters
%
%   Apply a directional filter, with linear structural element, and 
%   compute min or max of results. Result is the same type as input
%   image 'img'.
%
%   Classical uses of such filters is max of opening, which performs
%   good enhancement of lines.
%
%   For the use of median or mean filters, we also provides immedian and
%   immean functions, which have syntax similar to imopen or imclose.
%
%   Usage
%   RES = imdirfilter(SRC, 'mean', 'max', 20, 8);
%   % computes the mean in each 8 directions, 
%   % with linear structuring element of length 20, 
%   % and keep the max value over all directions.
%   
%   RES = imdirfilter(SRC, 'mean', 'max', 20, 8, 3);
%   % Specifies width of the line (obtained by dilation).
%
%
%   See also
%   meanFilter, medianFilter
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% default values

% operation to apply on each direction
op1 = 'open';

% how to combine direction results
op2 = 'max';

% number of directions
Nd = 32;

% length of the line, in pixels
N = 65;

% width of the line, in pixels
w = 1;


%% Process input parameters

% first operation
if ~isempty(varargin)
    op1 = varargin{1};
end

% other arguments
if length(varargin) > 1
    
    var = varargin{2};    
    if ischar(var)
        % third argument is name of second operator
        op2 = var;
        
        % fourth argument is length of the line
        if length(varargin) > 2
            N = varargin{3};
        end
        % fifth argument is number of directions
        if length(varargin) > 3
            Nd = varargin{4};
        end
        % sixth argument is width of the line
        if length(varargin) > 4
            w = varargin{5};
        end
        
    else
        % third argument is length of the line
        N = varargin{2};
        
        % fourth argument is number of directions
        if length(varargin)>2
            Nd = varargin{3};
        end
        % fifth argument is width of the line
        if length(varargin)>3
            w = varargin{4};
        end
    end
end


%% Initialisations

% associate function handles to op1 and op2
if ischar(op1)
    switch lower(op1)
        case 'open'
            op1 = @imopen;
        case 'close'
            op1 = @imclose;
        case 'mean'
            op1 = @immean;
        case 'median'
            op1 = @immedian;
        otherwise
            error(['Unknown string operator : ' op1]);
    end
end

% memory allocation, creating result the same type as input
if strcmp(op2, 'max')
    % fill image with zeros
    if islogical(this.data)
        res = false(size(this.data));
    else
        res = zeros(size(this.data), class(this.data)); %#ok<ZEROLIKE>
    end
    
elseif strcmp(op2, 'min')
    % fill image with ones
    if islogical(this.data)
        res = true(size(this.data));
        
    elseif isinteger(this.data)
        res = zeros(size(this.data), class(this.data)); %#ok<ZEROLIKE>
        res(:) = intmax(type);
        
    else
        res = zeros(size(this.data), class(this.data)); %#ok<ZEROLIKE>
        res(:) = inf;
        
    end
else
    error('don''t know how to manage "%s" operator', op2);
end


%% Iteration on directions

% iterate on each directions
for d = 1:Nd
    % compute structuring element
    theta = (d - 1) * 180 / Nd;
    se = getnhood(strel('line', N, theta));
    
    % eventually dilate by a ball
    if w > 1
        se = imdilate(se, ones(3*ones(1, ndims(this.data))), 'full');
    end
    
    % keep max or min along all directions
    res = feval(op2, res, feval(op1, this.data, se));
end


%% create result image

res = Image('data', res, 'parent', this);


function res = immean(img, filtre, varargin)
%IMMEAN Compute mean value in the neighboorhood of each pixel
%
%   RES = immean(IMG, SE)
%   Compute the mean filter of image IMG, using structuring element SE.
%   The goal of this function is to provide the same interface as for
%   other image filters (imopen, imerode ...), and to allow the use of 
%   mean filter with user-defined structuring element. 
%   This function can be used for directional filtering.
%
%
%   RES = immean(IMG, SE, PADOPT) also specify padding option. PADOPT can
%   be one of X (numeric value), 'symmetric', 'replicate', 'circular', see
%   imfilter for details. Default is 'replicate'.
%
%   See Also : IMMEDIAN, IMDIRFILTER, MEDFILT2, ORDFILT2
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 16/02/2004.
%

%   HISTORY
%   17/02/2004 : add support for 'strel' objects.
%   20/02/2004 : add PADOPT option, and documentation.

% transform STREL object into single array
if isa(filtre, 'strel')
    filtre = getnhood(filtre);
end

% get Padopt option
padopt = 'replicate';
if ~isempty(varargin)
    padopt=varargin{1};
end

% perform filtering
res = imfilter(img, filtre./sum(filtre(:)), padopt);


function res = immedian(img, filtre, varargin)
%IMMEDIAN Compute median value in the neighboorhood of each pixel
%
%   RES = immedian(IMG, SE)
%   Compute the median filter of image IMG, using structuring element SE.
%   The goal of this function is to provide the same interface as for
%   other image filters (imopen, imerode ...), and to allow the use of 
%   median filter with user-defined structuring element. 
%   This function can be used for directional filtering.
%
%
%   RES = immedian(IMG, SE, PADOPT) also specify padding option. PADOPT can
%   be either 'zeros' or 'SYMMETRIC', see medfilt2 or ordfilt2 for details.
%
%   See Also: IMMEAN, IMDIRFILTER, MEDFILT2, ORDFILT2
%
%
%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 16/02/2004.
%

%   HISTORY
%   17/02/2004: add support for 'strel' objects.
%   20/02/2004: add 'padopt' option, and documentation


% transform STREL object into single array
if isa(filtre, 'strel')
    filtre = getnhood(filtre);
end

% get padopt option.
padopt = 'zeros'; % default for standard median filtering in matlab
if ~isempty(varargin)
    padopt = varargin{1};
end

% perform filtering
order = ceil(sum(filtre(:))/2);
res = ordfilt2(img, order, filtre, padopt);
