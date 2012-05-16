function res = meanFilter(this, se, varargin)
%MEANFILTER Compute mean value in the neighboorhood of each pixel
%
%   RES = meanFilter(IMG, SE);
%   Compute the mean filter of image IMG, using structuring element SE.
%   The goal of this function is to provide the same interface as for
%   other image filters (imopen, imerode ...), and to allow the use of 
%   mean filter with user-defined structuring element. 
%   This function can be used for directional filtering.
%
%
%   RES = meanFilter(IMG, SE, PADOPT); 
%   also specify padding option. PADOPT can be one of:
%     X (numeric value)
%     'symmetric'
%     'replicate'
%     'circular'
%   see imfilter for details. Default is 'replicate'. 
%
%   See also:
%   medianFilter, gaussianFilter, filter, imfilter
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% transform STREL object into single array
if strcmp(class(se), 'strel')
    se = getnhood(se);
end

% get Padopt option
padopt = 'replicate';
if ~isempty(varargin)
    padopt = varargin{1};
end

% adapt structuring element
se = permute(se, [2 1 3]) ./ sum(se(:));

% perform filtering
data = imfilter(this.data, se, padopt);

% create result image
res = Image('data', data, 'parent', this);
