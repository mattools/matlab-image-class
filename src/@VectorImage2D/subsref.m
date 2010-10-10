function varargout = subsref(this, subs)
%SUBSREF Overrides subsref method for VectorImage2D objects
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
        [varargout{:}] = builtin('subsref', this, subs);
    else
        builtin('subsref', this, subs);
        if exist('ans', 'var')
            varargout = {ans}; %#ok<NOANS>
        end
    end
    
elseif strcmp(type, '()')
    % In case of parens reference, index the inner data
    
    % different processing if 1 or 2 indices are used
    ns = length(s1.subs);
    if ns==1
        % one index: use linearised image
        ind = s1.subs{1};
        varargout = {this.data(ind)};

    elseif ns==2 || ns==3
        % two indices: parse x and y indices 
        % (there is no need to parse ':', as it will be processed by data's
        % subsref method) 

        % parse x and y indices
        ind1 = s1.subs{1};
        ind2 = s1.subs{2};
        
        if ns==2
            % extract corresponding data, and transpose to comply with
            % matlab representation
            varargout{1} = permute(this.data(ind1, ind2, :), [2 1 3]);
            %varargout = {this.data(ind1, ind2, :)};
        else
            % parse band index 
            ind3 = s1.subs{3};
            varargout{1} = permute(this.data(ind1, ind2, ind3), [2 1 3]);
            %varargout = {this.data(ind1, ind2, ind3)};
        end
    else
        error('VectorImage2D:subsref', ...
            'too many indices');
    end
else
    error('VectorImage2D:subsref', ...
        'can not manage such reference');
end

