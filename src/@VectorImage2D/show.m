function show(this, varargin)
% Shows image on current axis
% Image is displayed in its physical extent, based on image origin
% and spacing.
%

options = varargin;

% compute physical extents
xdata = this.getXData();
ydata = this.getYData();

% compute data to display
dat = this.getDisplayData();

% compute grayscale extent within image
valMin = min(dat(:));
valMax = max(dat(:));

% If image contains both positive and negative values, use 0-centered
% gray display
if valMin<0
    absMax = max(abs(valMin), valMax);
    valMin = -absMax;
    valMax = absMax;
end

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


% display image with approriate spatial reference
imshow(dat, options{:}, 'XData', xdata, 'YData', ydata);

% check extent of image
extent = getPhysicalExtent(this);
xl = xlim;
xl = [min(xl(1), extent(1)) max(xl(2), extent(2))];
yl = ylim;
yl = [min(yl(1), extent(3)) max(yl(2), extent(4))];
xlim(xl); ylim(yl);
end

