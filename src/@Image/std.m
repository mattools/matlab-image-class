function res = std(obj)
% Standard deviation of image values
%
%   See also
%     mean, var
%

res = std(double(obj.Data(:)));
