function res = filter(this, varargin)
%FILTER Applies linear filter on the image

%res = Image.create(this);
res = Image.create(...
    'data', imfilter(this.data, varargin{:}), ...
    'parent', this);
