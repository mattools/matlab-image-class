function varargout = show(obj, varargin)
% Shows image on current axis.
%
% Image is displayed in its physical extent, based on image Origin and
% Spacing properties.
%

%% parse input arguments

% default values
showTitle = true;
showAxisNames = true;

% parse options
options = {};
while length(varargin) > 1
    if strcmp(varargin{1}, 'showAxisNames')
    else
        options = [options, varargin(1:2)]; %#ok<AGROW>
    end
    varargin(1:2) = [];
end
% options = varargin;


% Check image dimension: should be 2, or can be squeezed to 2.
if obj.Dimension ~= 2
    % compute number of image dimension
    nd = sum(obj.DataSize(1:3) > 1);
    if nd == 2
        img = squeeze(obj);
        show(img, varargin{:});
        return;
        
    else
        error('Method "show" can be applied only to 2D images');
    end
end

%% Prepare data
data = getDisplayData(obj);

% if double, adjust grayscale extent
if isfloat(data)
    options = updateDisplayRangeOptions(data, options);
end

% compute physical extents
xdata = xData(obj);
ydata = yData(obj);


%% Display data

% display image with approriate spatial reference
h = imshow(data, 'XData', xdata, 'YData', ydata, options{:});

% check extent of image
extent = physicalExtent(obj);
xl = xlim;
xl = [min(xl(1), extent(1)) max(xl(2), extent(2))];
yl = ylim;
yl = [min(yl(1), extent(3)) max(yl(2), extent(4))];
xlim(xl); ylim(yl);


%% Annotate 

% show title
if ~isempty(obj.Name) && showTitle
    title(obj.Name);
end

% show axis names
if ~isempty(obj.AxisNames) && length(obj.AxisNames) >= 2 && showAxisNames
    xlabel(obj.AxisNames{1})
    ylabel(obj.AxisNames{2})
end


%% post-processing

% eventually returns handle to image object
if nargout > 0
    varargout = {h};
end


%% Inner functions
function options = updateDisplayRangeOptions(data, options)

% compute grayscale extent within image
valMin = double(min(data(:)));
valMax = double(max(data(:)));

% If image contains both positive and negative values, use 0-centered
% gray display
if valMin < 0
    absMax = max(abs(valMin), valMax);
    valMin = -absMax;
    valMax = absMax;
end

% in case of an image with the same value everywhere, use [0 1]
if abs(valMin-valMax) < 1e-12
    valMin = 0;
    valMax = 1;
end

% set up the default range, or the user-specified range
valRange = [valMin valMax];
if ~isempty(options)
    opt1 = options{1};
    if isnumeric(opt1)
        if size(opt1, 1) == 1 || isempty(opt1)
            valRange = opt1;
            options(1) = [];
        end
    end
end

options = [{'DisplayRange', valRange}, options];
