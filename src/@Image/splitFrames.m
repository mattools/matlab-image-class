function varargout = splitFrames(obj)
% Split the different frames of a movie.
%
%   [F1, F2, F3 ... ] = splitFrames(IMG)
%
%   See also
%     catFrames, frame, splitChannels
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nf = size(obj, 5);
varargout = cell(1, nf);

for i = 1:nf
    varargout{i} = frame(obj, i);
end
