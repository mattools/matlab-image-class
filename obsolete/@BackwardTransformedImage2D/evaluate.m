function [val isInside] = evaluate(this, point, varargin)
% Evaluate intensity of transformed image at a given physical position
%
% This function exists to have an interface comparable to Interpolator
% classes. Normal usage is to access data via getPixel() or getValue().
%
% VAL = INTERP.evaluate(POS);
% where POS is a Nx2 array containing alues of x- and y-coordinates
% of positions to evaluate image, return an array with as many
% values as POS.
%
% VAL = INTERP.evaluate(X, Y)
% X and Y should be the same size. The result VAL has the same size
% as X and Y.
%
% [VAL INSIDE] = INTERP.evaluate(...)
% Also return a boolean flag the same size as VAL indicating
% whether or not the given position as located inside the
% evaluation frame.
%

% eventually convert inputs from x and y to a list of points
dim = [size(point,1) 1];
if ~isempty(varargin)
    var = varargin{1};
    if sum(size(var)~=size(point))==0
        dim = size(point);
        point = [point(:) var(:)];
    end
end

% Compute transformed coordinates
point = this.trans.transformPoint(point);

% evaluate interpolated values
[val isInside] = this.interp.evaluate(point);

% convert to have the same size as inputs
val = reshape(val, dim);
isInside = reshape(isInside, dim);
