function nf = frameNumber(obj)
% Return the number of frames in the image.
%
%   NF = frameNumber(IMG);
%   or
%   NF = IMG.frameNumber
%   
%
%   Example
%   frameNumber
%
%   See also
%     frame, channelNumber, elementSize
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nf = obj.DataSize(5);
