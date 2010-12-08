function dim = getElementSize(this, varargin)
%GETELEMENTSIZE Return channel and frame number of an image element
%
%   DIM = getElementSize(IMG)
%
%   Example
%   getElementSize
%
%   See also
%   getSize, getDataSize, getChannelNumber
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isempty(varargin)
    dim = this.dataSize(4:5);
    
else
    d = varargin{1};
    if d > 2
        error('Second argument must be 1 or 2');
    end
    dim = this.dataSize(d + 3);
end
