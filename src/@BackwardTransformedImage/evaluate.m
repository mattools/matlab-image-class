function [val isInside] = evaluate(this, varargin)
%EVALUATE Evaluate intensity of transformed image at a given physical position
%
% This function exists to have an interface comparable to Interpolator
% classes. Normal usage is to access data via getPixel() or getValue().
%
% VAL = interpolator.evaluate(POS);
% where POS is a Nx2 array containing alues of x- and y-coordinates
% of positions to evaluate image, return an array with as many
% values as POS.
%
% VAL = interpolator.evaluate(X, Y)
% X and Y should be the same size. The result VAL has the same size
% as X and Y.
%
% [VAL INSIDE] = interpolator.evaluate(...)
% Also return a boolean flag the same size as VAL indicating
% whether or not the given position as located inside the
% evaluation frame.
%

% eventually convert inputs to a single nPoints-by-ndims array
[point dim] = ImageFunction.mergeCoordinates(varargin{:});

% Compute transformed coordinates
point = this.transform.transformPoint(point);

% evaluate interpolated values
[val isInside] = this.interpolator.evaluate(point);

% convert to have the same size as inputs
val = reshape(val, dim);
isInside = reshape(isInside, dim);
end


