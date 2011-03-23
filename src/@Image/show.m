function varargout = show(this, varargin)
% Shows image on current axis
% Image is displayed in its physical extent, based on image origin
% and spacing.
%

if this.dimension~=2
    % compute number of image dimension
    nd = sum(this.dataSize(1:3)>1);
    if nd==2
        img = this.squeeze();
        img.show(varargin{:});
        return;
    else
        error('Method "show" can be applied only to 2D images');
    end
end

options = varargin;

data = this.getDisplayData();

% if double, adjust grayscale extent
if isfloat(data)
    options = updateDisplayRangeOptions(data, options);
end

% compute physical extents
xdata = this.getXData();
ydata = this.getYData();

% display image with approriate spatial reference
h = imshow(data, 'XData', xdata, 'YData', ydata, options{:});

% check extent of image
extent = this.getPhysicalExtent();
xl = xlim;
xl = [min(xl(1), extent(1)) max(xl(2), extent(2))];
yl = ylim;
yl = [min(yl(1), extent(3)) max(yl(2), extent(4))];
xlim(xl); ylim(yl);


% eventually returns handle to image object
if nargout > 0
    varargout = {h};
end

function options = updateDisplayRangeOptions(data, options)

% compute grayscale extent within image
valMin = double(min(data(:)));
valMax = double(max(data(:)));

% If image contains both positive and negative values, use 0-centered
% gray display
if valMin<0
    absMax = max(abs(valMin), valMax);
    valMin = -absMax;
    valMax = absMax;
end

% in case of an image with the same value everywhere, use [0 1]
if abs(valMin-valMax)<1e-12
    valMin = 0;
    valMax = 1;
end

% set up the default range, or the user-specified range
valRange = [valMin valMax];
if ~isempty(options)
    opt1 = options{1};
    if isnumeric(opt1)
        if size(opt1, 1)==1 || isempty(opt1)
            valRange = opt1;
            options(1) = [];
        end
    end
end

options = [{'DisplayRange', valRange}, options];
