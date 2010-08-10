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
    
    % if some output arguments are asked, use specific processing
    if nargout>0
        varargout = cell(nargout, 1);
        varargout{:} = builtin('subsref', this, subs);
    else
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
    elseif ns==3
        % three indices: parse x y and z indices 
        % (there is no need to parse ':', as it will be processed by data's
        % subsref method) 

        % parse x, y and z index
        ind1 = s1.subs{1};
        ind2 = s1.subs{2};
        ind3 = s1.subs{3};
        
        % extract corresponding data, and permute to comply with matlab
        % array representation
        varargout{1} = permute(this.data(ind1, ind2, ind3), [2 1 3]);
    else
        error('Image3D:subsref', ...
            'wrong number of indices');
    end
else
    error('Image3D:subsref', ...
        'can not manage such reference');
end

