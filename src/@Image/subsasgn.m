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
    if nargout > 0
        varargout = cell(1);
        varargout{1} = builtin('subsasgn', this, subs, value);    
    else
        builtin('subsasgn', this, subs, value);
    end
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);
    if ns == 1
        % one index: use linearised image

        % check that indices are within image bound
        this.data(s1.subs{:});

        this.data(s1.subs{1}) = value;

    elseif ns == 2
        % two indices: parse x and y indices

        % check that indices are within image bound
        this.data(s1.subs{:});
        
        % extract corresponding data, and transpose to comply with matlab
        % representation
        this.data(s1.subs{:}) = value';
        
    elseif ns == 3
        % two indices: parse x y and z indices

        % check that indices are within image bound
        this.data(s1.subs{:});
        
        % parse x, y, z indices
        ind1 = s1.subs{1};
        ind2 = s1.subs{2};
        ind3 = s1.subs{3};
        
        % extract corresponding data, and permute to comply with matlab
        % array representation
        this.data(ind1, ind2, ind3, :, :) = permute(value, [2 1 3]);
        
    else
        error('Image:subsasgn', ...
            'Too many indices');
    end
else
    error('Image:subsasgn', ...
        'Can not manage such reference');
end

if nargout>0
    varargout{1} = this;
end
