function varargout = subsref(this, subs)
%SUBSREF Overrides subsref function for Image objects
%   output = subsref(input)
%
%   Example
%   subsref
%
%   See also
%   subsasgn, end
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract reference type
s1 = subs(1);
type = s1.type;

% switch between reference types
if strcmp(type, '.')
    % in case of dot reference, use builtin
    
    % check if we need to return output or not
    if nargout>0
        % if some output arguments are asked, pre-allocate result
        varargout = cell(nargout, 1);
        [varargout{:}] = builtin('subsref', this, subs);
    else
        % call parent function, and eventually return answer
        builtin('subsref', this, subs);
        if exist('ans', 'var')
            varargout{1} = ans; %#ok<NOANS>
        end
    end
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    varargout{1} = 0;
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);
    if ns==1
        % one index: use linearised image
        varargout{1} = this.data(s1.subs{1});
        
    elseif ns==2
        % two indices: parse x and y indices 
        
        % extract corresponding data, and transpose to comply with matlab
        % representation
        varargout{1} = this.data(s1.subs{:})';
        
    elseif ns==3
        % three indices: parse x y z indices 
        
        % parse x, y and z index
        ind1 = s1.subs{1};
        ind2 = s1.subs{2};
        ind3 = s1.subs{3};
        
        % extract corresponding data, and permute to comply with matlab
        % array representation
        varargout{1} = permute(this.data(ind1, ind2, ind3, :, :), ...
            [2 1 3:5]);
        
    else
        varargout{1} = permute(this.data(s1.subs{:}), [2 1 3:5]);
    end
    
else
    error('Image:subsref', ...
        'can not manage such reference');
end

