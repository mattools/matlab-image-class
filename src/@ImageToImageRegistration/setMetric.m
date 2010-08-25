function setMetric(this, metric)
%SETMETRIC Setup metric used by registration
%
%   REG.setMetric(METRIC)
%   METRIC should be an instance of ImageToImageMetric, and should use
%   references to same fixed image, same moving image, and same transform
%   as this registration algorithm.
%
%   Example
%   setMetric
%
%   See also
%   setFixedImage
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

this.metric = metric;
