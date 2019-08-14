function extent = physicalExtent(obj)
% Return image extent in physical coordinates.
%
%   EXT = physicalExtent(IMG);
%   Result EXT is in the form:
%   * [xmin xmax ymin ymax] for 2D images, or
%   * [xmin xmax ymin ymax zmin zmax] for 3D images
%
%   Example
%   img = Image2D.read('cameraman.tif');
%   physicalExtent(img)
%   ans =
%       -0.5000  255.5000   -0.5000  255.5000
%
%   See also
%     ndims, size, physicalSize, isCalibrated, clearCalibration
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = ndims(obj);

% extract base data
sz = obj.DataSize(1:nd);
sp = obj.Spacing;
or = obj.Origin;

% put extent in array
extent = (([zeros(nd, 1) sz']-.5).* [sp' sp'] + [or' or'])';

% change array shape to get a single row
extent = extent(:)';
