function res = cat(dim, this, varargin)
%CAT Concate images along specified dimension
%
%   RES = cat(DIM, IMG1, IMG2)
%
%   Example
%   cat
%
%   See also
%   vertcat, horzcat, repmat, catChannels
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

data = this.data;

for i = 1:length(varargin)
    var = varargin{i};    
    data = cat(dim, data, var.data);
end

res = Image('data', data);
