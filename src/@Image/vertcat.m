function res = vertcat(this, varargin)
%vertcat Horizontal concatenation of images
%
%   RES = vertcat(IMG1, IMG2)
%   RES = [IMG1 ; IMG2];
%
%   Example
%   vertcat
%
%   See also
%   horzcat, repmat, cat
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

data = this.data;
name = this.name;

for i = 1:length(varargin)
    var = varargin{i};    
    data = [data var.data]; %#ok<AGROW>
    
    name = strcat(name, '+', var.name);
end

res = Image(...
    'data', data, ...
    'parent', this, ...
    'name', name);
