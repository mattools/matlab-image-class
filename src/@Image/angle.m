function ang = angle(obj)
% Return the phase angles, in radians, of an image with complex elements.
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

% retrieve components
imgA = channel(obj, 1);
imgB = channel(obj, 2);

% create result image
name = createNewName(obj, '%s-angle');
ang = Image('Data', atan2(imgA.Data, imgB.Data), 'Parent', obj, 'Name', name);
