function extent = getPhysicalExtent(this)
%GETPHYSICALEXTENT  Return image extent in physical coordinates
%
%   EXTENT = img.getPhysicalExtent();
%
%   result in the form:
%   [xmin xmax ymin ymax] for 2D images, or
%   [xmin xmax ymin ymax zmin zmax] for 3D images
%
%   Example
%   img = Image2D.read('cameraman.tif');
%   img.getPhysicalExtent()
%   ans =
%       -0.5000  255.5000   -0.5000  255.5000
%
%   See also
%   getDimension, getSize
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = getDimension(this);

% extract base data
sz = this.dataSize(1:nd);
sp = this.calib.spacing(1:nd);
or = this.calib.origin(1:nd);

% put extent in array
extent = (([zeros(nd, 1) sz']-.5).* [sp' sp'] + [or' or'])';

% change array shape to get a single row
extent = extent(:)';
