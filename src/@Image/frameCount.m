function nf = frameCount(obj)
% Return the number of frames in the image.
%
%   NF = frameCount(IMG);
%   or
%   NF = IMG.frameCount
%   
%
%   Example
%   frameNumber
%
%   See also
%     frame, channelCount, elementSize
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nf = obj.DataSize(5);
