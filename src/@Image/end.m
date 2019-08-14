function ind = end(obj, k, n)
% Determine last index when accessing an image.
%
%   See Also
%     subsref, subsasgn
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


if n==1
    ind = numel(obj.Data);
elseif n<=5
    ind = size(obj.Data, k);
else
    error('Image:end', ...
        'not enough dimension in Image object');
end

