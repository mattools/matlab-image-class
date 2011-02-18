function res = filter(this, h, varargin)
%FILTER Applies linear filter on the image
%
%   usage
%   IMGF = IMG.filter(H);
%   Apply the linear filter H to the image, and stores the result in IMGF.
%   H can be 
%   IMG.filter(H, OPTION1, OPTION2...);
%
%   
%   see also
%   imfilter
%

% choose default options
if isempty(varargin)
    varargin = {'replicate'};
end

% eventually convert kernel
h = double(h);

% create new image with result of filtering
res = Image.create(...
    'data', imfilter(this.data, h, varargin{:}), ...
    'parent', this);
