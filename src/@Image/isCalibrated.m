function b = isCalibrated(this)
%ISCALIBRATED Check if an image has a spatial calibration
%
%   B = img.isCalibrated();
%
%   Example
%     img = Image2D.read('cameraman.tif');
%     img.isCalibrated
%     ans = 
%       0
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

b = this.calibrated;