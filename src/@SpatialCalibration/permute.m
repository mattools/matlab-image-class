function res = permute(this, order)
% Permute the elements of spatial calibration
%
%   CALIB2 = permute(CALIB, ORDER)
%   ORDER is a row vector with ND elements, containing a permutation of
%   values from 1 to ND.
%   
%
%   Example
%   permute
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% compute new data
newSpacing  = this.spacing(order);
newOrigin   = this.origin(order);

% cerate new object
res = SpatialCalibration(newSpacing, newOrigin);

% setup other fields
res.calibrated  = this.calibrated;
res.unitName    = this.unitName;
