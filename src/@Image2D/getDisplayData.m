function data = getDisplayData(this)
%GETDISPLAYDATA Returns a data array that can be used for display
%
%   DAT = img.getDisplayData()
%
%   For scalar image, the inner data array is simply returned.
%
%   Example
%   getDisplayData
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

data = this.data';