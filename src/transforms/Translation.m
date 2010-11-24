classdef Translation < AffineTransform
%TRANSLATION Defines a translation in ND space
%   
%   Representation of a translation transform in ND space.
%   The translation vector is stored by the class, and the transformation
%   matrix is computed when needed.
%
%   For a parameterized translation, see TranslationModel class.
%
%   Example
%   % Creates a 3D translation 
%   T = Translation([3 4 5]);
%
%   See also
%   AffineTransform, TranslationModel
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the translation vector, stored as a row vector
    u;
end

%% Abstract methods
methods
    function this = Translation(varargin)
        %TRANSLATION Class constructor
        %
        % T = Translation(VEC)
        % where VEC is a row vector, initialize translation with vector VEC
        %
        % T = Translation(V1, V2...)
        % Initialize each component separately. Each component must be a
        % scalar.
        %
        % T = Translation;
        % Initialize with 2D translation with (0,0) vector.
        %
        % T = Translation(T0)
        % copy constructor from another Translation object/
        
        if nargin==0
            % empty constructor, initialize to (0,0) 2D translation
            this.u = [0 0];
            return;
        end
        
        if isa(varargin{1}, 'Translation')
            % copy constructor
            var = varargin{1};
            this.u = var.u;
        elseif isnumeric(varargin{1})
            var = varargin{1};
            if size(var, 2) == 1
                % initialize with separate scalar parameters
                this.u = zeros(1, nargin);
                for i=1:nargin
                    this.u(i) = varargin{i};
                end
            else
                % initialize with bundled parameters
                this.u = var;
            end
        else
            error('Wrong parameter when constructing a Composed transform');
        end
    end
    
    function mat = getAffineMatrix(this)
        % Returns the (ND+1)*(nd+1) affine matrix representing translation
        nd = length(this.u);
        mat = eye(nd+1);
        mat(1:end-1, end) = this.u(:);
    end
    
end % end methods

end % end classdef
