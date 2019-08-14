function res = filter(obj, h, varargin)
% Apply linear filter on the image.
%
%   IMGF = filter(IMG, H);
%   Apply the linear filter H to the image, and stores the result in IMGF.
%   This function is manly a wrapper to the "imfilter" function.
%
%   IMGF = filter(IMG, H, OPTION1, OPTION2...);
%   Apply filtering options such as given in imfilter.
%
%   
%   see also
%     boxFilter, gaussianFilter, medianFilter, gradient, imfilter
%

% choose default options
if isempty(varargin)
    varargin = {'replicate'};
end

% eventually convert kernel
h = double(h);

% create new image with result of filtering
res = Image(...
    'data', imfilter(obj.Data, h, varargin{:}), ...
    'parent', obj);
