function varargout = subsasgn(obj, subs, value)
% Overrides subsasgn function for Image objects.
%
%   RES = subsasgn(IMG, SUBS, VAL)
%
%   Example
%   subsasgn
%
%   See also
%   subsref, end
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

s1 = subs(1);
type = s1.type;
if strcmp(type, '.')
    % in case of dot reference, use builtin
    
    % if some output arguments are asked, use specific processing
    if nargout > 0
        varargout = cell(1);
        varargout{1} = builtin('subsasgn', obj, subs, value);    
    else
        builtin('subsasgn', obj, subs, value);
    end
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);
    if ns == 1
        % one index: use linearised image

        % check that indices are within image bound
        obj.Data(s1.subs{:});

        obj.Data(s1.subs{1}) = value;

    elseif ns == 2
        % two indices: parse x and y indices

        % check that indices are within image bound
        obj.Data(s1.subs{:});
        
        % extract corresponding data, and 
        if isa(value, 'Image')
            value = value.Data;
        else
            % numerical array area transposed to comply with matlab representation
            value = value';
        end
        obj.Data(s1.subs{:}) = value;
        
    elseif ns == 3
        % two indices: parse x y and z indices

        % check that indices are within image bound
        obj.Data(s1.subs{:});
        
        % parse x, y, z indices
        ind1 = s1.subs{1};
        ind2 = s1.subs{2};
        ind3 = s1.subs{3};
        
        % extract corresponding data, and permute to comply with matlab
        % array representation
        obj.Data(ind1, ind2, ind3, :, :) = permute(value, [2 1 3]);
        
    else
        error('Image:subsasgn', ...
            'Too many indices');
    end
elseif strcmp(type, '{}')
    error('Image:subsasgn', ...
        'Can not manage braces reference');
else
    error('Image:subsasgn', ...
        ['Can not manage such reference: ' type]);
end

if nargout > 0
    varargout{1} = obj;
end
