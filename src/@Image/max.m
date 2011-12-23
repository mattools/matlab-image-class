function res = max(this, varargin)
% Computes the maximal value within image

if isempty(varargin)
    % compute minimal value within image
    
    if size(this, 4) == 1
        % case of grayscale image
        res = max(this.data(:));
        
    else
        % case of color or vector images
        nc = channelNumber(this);
        res = zeros(1, nc);
        for i = 1:nc
            dat = this.data(:,:,:,i,:);
            res(i) = max(dat(:));
        end
    end
    
    return;
end


% compute the minimum image between image and second argument

% extract data
[data1 data2 parent name1 name2] = parseInputCouple(this, varargin{1}, ....
    inputname(1), inputname(2));

% compute new data
class0 = class(parent.data);
newData = max(cast(data1, class0), cast(data2, class0));

% create result image
newName = strcat('max(', name1, ',', name2, ')');
nd = ndims(this);
res = Image(nd, 'data', newData, 'parent', parent, 'name', newName);
