function show(this, varargin)
% Shows image on current axis
% Image is displayed in its physical extent, based on image origin
% and spacing.
%

options = varargin;

% compute physical extents
xdata = [0 this.dataSize(1)-1]*this.spacing(1) + this.origin(1);
ydata = [0 this.dataSize(2)-1]*this.spacing(2) + this.origin(2);

% compute data to display
% use vector norm
dat = zeros(this.dataSize);
nc = this.getComponentNumber();
for i=1:nc
    dat = dat + this.data(:,:,i)'.^2;
end
dat = sqrt(dat);

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

