function res = max(obj, varargin)
% Compute the maximal value within image.
%
%   M = max(IMG);
%
%   Example
%     img = Image.read('rice.png');
%     max(img)
%     ans =
%        204
%
%   See also
%     mean, median, min, orthogonalProjection
%

if isempty(varargin)
    % compute minimal value within image
    
    if size(obj, 4) == 1
        % case of grayscale image
        res = max(obj.Data(:));
        
    else
        % case of color or vector images
        nc = channelCount(obj);
        res = zeros(1, nc);
        for i = 1:nc
            dat = obj.Data(:,:,:,i,:);
            res(i) = max(dat(:));
        end
    end
    
    return;
end


% compute the minimum image between image and second argument

% extract data
[data1, data2, parent, name1, name2] = parseInputCouple(obj, varargin{1}, ....
    inputname(1), inputname(2));

% compute new data
class0 = class(parent.Data);
newData = max(cast(data1, class0), cast(data2, class0));

% create result image
newName = strcat('max(', name1, ',', name2, ')');
res = Image('data', newData, 'parent', parent, 'name', newName);
