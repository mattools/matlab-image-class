function [img2 isInside] = backwardTransform(this, transfo, varargin)
%BACKWARDTRANSFORM  Apply (backward) a geometric transformation to an image
%
%   RES = IMG.backwardTransform(TRANSFO)
%   RES = backwardTransform(IMG, TRANSFO)
%
%   Example
%   backwardTransform
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = getDimension(this);

% default interpolator
if nd==2
    interpolator = LinearInterpolator2D(this);
else
    interpolator = LinearInterpolator3D(this);
end

% default values for output coordinates
dim = this.getSize();
sp = this.getSpacing();
or = this.getOrigin();
lx = (0:dim(1)-1)*sp(1) + or(1);
ly = (0:dim(2)-1)*sp(2) + or(2);

% parses optional parameters
while length(varargin)>=2
    key = varargin{1};
    switch(key)
        case 'interpolator'
            % choose another interpolator
            switch varargin{2}
                case 'linear'
                    if nd==2
                        interpolator = LinearInterpolator2D(this);
                    else
                        interpolator = LinearInterpolator3D(this);
                    end

                otherwise
                    error('Unknown interpolator type');
            end
        case 'udata'
            % set up x coord for target pixels
            lx = varargin{2};
        case 'vdata'
            % set up y coord for target pixels
            ly = varargin{2};
        otherwise
            error('Unknown option for transformImage: %s', key);
    end
    varargin(1:2) = [];
end

% coordinate grid
[x y] = meshgrid(lx, ly);

% if transform is a 3x3 matrix, transform to a function pointer
if isnumeric(transfo)
    mat = transfo;
    N = length(x(:));
    transfo = @(x) (mat*([x ones(N, 1)]'))';
elseif isa(transfo, 'Transform')
    transfo = @(x) transfo.transformPoint(x);
end

% transform points
tp = transfo([x(:) y(:)]);
tp = tp(:, 1:2);

% allocate memory for result data
if islogical(this.data)
    res = false(size(x));
else
    res = zeros(size(x), class(this.data));
end

% fillup result buffer with interpolated values
[vals isInside] = interpolator.evaluate(tp);
res(isInside) = vals(isInside);

% create image object for storing result
img2 = Image(this);
img2.data = res';
img2.setOrigin([lx(1) ly(1)]);
img2.setSpacing([lx(2)-lx(1) ly(2)-ly(1)]);

