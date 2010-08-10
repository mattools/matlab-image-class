function varargout = subsasgn(this, subs, value)
%subsasgn Overrides subsasgn function for Image objects
%   output = subsasgn(input)
%
%   Example
%   subsasgn
%
%   See also
%   subsref, end
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

s1 = subs(1);
type = s1.type;
if strcmp(type, '.')
    % in case of dot reference, use builtin
    
    % if some output arguments are asked, use specific processing
    if nargout>0
        varargout = cell(1);
        varargout{1} = builtin('subsasgn', this, subs);    
    else
        builtin('subsasgn', this, subs);
    end
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);
    if ns==1
        % one index: use linearised image
%         ind = s1.subs{1};
%         if strcmp(ind, ':')
%             ind = 1:numel(this.data);
%         end
        this.data(s1.subs{1}) = value;

    elseif ns==2
        % two indices: parse x and y indices

%         % parse x index
%         ind1 = s1.subs{1};
%         if strcmp(ind1, ':')
%             ind1 = 1:size(this.data, 1);
%         end
%         
%         % parse y index
%         ind2 = s1.subs{2};
%         if strcmp(ind2, ':')
%             ind2 = 1:size(this.data, 2);
%         end
        
        % extract corresponding data, and transpose to comply with matlab
        % representation
        this.data(s1.subs{:}) = value';
    else
        error('Image2D:subsasgn', ...
            'too many indices');
    end
else
    error('Image2D:subsasgn', ...
        'can not manage such reference');
end

if nargout>0
    varargout{1} = this;
end