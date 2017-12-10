function ang = angle(this)
%ANGLE Returns the phase angles, in radians, of an image with complex elements
%
%   PHASE = angle(I)
%
%   Example
%     ang
%
%   See also
%     gradient, norm
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-09-29,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

real = getBuffer(channel(this, 1));
imag = getBuffer(channel(this, 2));

ang = Image(atan2(imag, real));
