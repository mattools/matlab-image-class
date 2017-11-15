function clearCalibration(this)
%CLEARCALIBRATION Clears the spatial calibration of an image
%
%   clearCalibration(IMG)
%
%   Example
%   img = Image.read('coins.png');
%   img.spacing = [.5 .5];
%   isCalibrated(img)
%   ans =
%      logical
%       1
%   clearCalibration(img);
%   isCalibrated(img)
%   ans =
%      logical
%       0
%
%   See also
%     isCalibrated, physicalExtent, physicalSize
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-11-15,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

nd = ndims(this);
this.origin     = ones(1, nd);
this.spacing    = ones(1, nd);
this.unitName   = '';
this.calibrated = false;
