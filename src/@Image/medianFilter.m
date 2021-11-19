function res = medianFilter(obj, se, varargin)
% Compute median value in the neighboorhood of each pixel.
%
%   RES = medianFilter(IMG2D, [M N])
%   RES = medianFilter(IMG3D, [M N P])
%   Applies median filtering to the input image, by computing the median
%   value in the square or cubic neighborhood of each image element. 
%
%   RES = medianFilter(IMG, SE)
%   Compute the median filter of image IMG, using structuring element SE.
%   The goal of this function is to provide the same interface as for
%   other image filters (opening, erosion...), and to allow the use of 
%   median filter with user-defined structuring element. 
%   This function can be used for directional filtering.
%
%   RES = medianFilter(IMG, SE, PADOPT) 
%   also specify padding option. PADOPT can be one of:
%     'zeros'
%     'ones'
%     'symmetric' 
%   see ordfilt2 for details. Default is 'symmetric' (contrary to the
%   default for ordfilt2).
%
%   Implementation notes
%   When neighborhood is given as a 1-by-2 or 1-by-3 array, the methods is
%   a wrapper for the medfilt2 or medfilt3 function. Otherwise, the
%   ordfilt2 function ise used.
%
%   Example
%     % apply median filtering on rice image
%     img = Image.read('rice.png');
%     imgf = medianFilter(img, [3 3]);
%     figure; show(imgf);
%   
%   See also:
%     meanFilter, ordfilt2, median
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% transform STREL object into single array
if isa(se, 'strel')
    se = getnhood(se);
end

% get Padopt option
padopt = 'symmetric';
if ~isempty(varargin)
    padopt = varargin{1};
end

if isnumeric(se) && all(size(se) == [1 2]) && obj.Dimension == 2
    % if input corresponds to filter size, use medfilt2
    data = medfilt2(obj.Data, se([2 1]));
    
elseif isnumeric(se) && all(size(se) == [1 3]) && obj.Dimension == 3
    % process the 3D case, only for cubic neighborhoods
    data = medfilt3(obj.Data, se([2 1 3]));
    
else
    % otherwise, use the ordfilt2 function by choosing the order according
    % to SE size.
    
    % rotate structuring element
    se = permute(se, [2 1 3:5]);
    
    % perform filtering
    order = ceil(sum(se(:)) / 2);
    data = ordfilt2(obj.Data, order, se, padopt);
end

% create result image
name = createNewName(obj, '%s-medianFilt');
res = Image('Data', data, 'Parent', obj, 'Name', name);
