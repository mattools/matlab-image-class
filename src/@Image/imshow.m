function imshow(this, varargin)
% Shows image on current axis
%
% This function is provided for consistency with Matlab syntax. It is
% preferable to use the "show" function directly.
%

warning('oolip:deprecated', 'Please use the "show" function directly');

show(this, varargin{:});