function show(this, varargin)
% Shows image on current axis
% Image is displayed in its physical extent, based on image origin
% and spacing.
%

options = varargin;

% compute physical extents
calib = this.getSpatialCalibration();
xdata = [0 this.dataSize(1)-1]*calib.spacing(1) + calib.origin(1);
ydata = [0 this.dataSize(2)-1]*calib.spacing(2) + calib.origin(2);

% if double, adjust grayscale extent 
if isfloat(this.data)
    options = updateDisplayRangeOptions(this, options);
end

% display image with approriate spatial reference
imshow(this.data', options{:}, 'XData', xdata, 'YData', ydata);

% check extent of image
extent = this.getPhysicalExtent();
xl = xlim;
xl = [min(xl(1), extent(1)) max(xl(2), extent(2))];
yl = ylim;
yl = [min(yl(1), extent(3)) max(yl(2), extent(4))];
xlim(xl); ylim(yl);


function options = updateDisplayRangeOptions(img, options)

% compute grayscale extent within image
valMin = img.min();
valMax = img.max();

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
