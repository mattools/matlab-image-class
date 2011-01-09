classdef NelderMeadSimplexOptimizer < Optimizer
%NELDERMEADSIMPLEXOPTIMIZER Simplex optimizer adapted from Numerical Recipes 3
%
%   OPT = NelderMeadSimplexOptimizer()
%
%   Example
%   % Run the simplex otpimizer on the Rosenbrock function
%     optimizer = NelderMeadSimplexOptimizer([0 0], [.01 .01]);
%     optimizer.setCostFunction(@rosenbrock);
%     [xOpt value] = optimizer.startOptimization();
%     xOpt
%       xOpt =
%           0.9993    0.9984
%     value
%       value =
%           5.5924e-006
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    % maximum number of iterations
    nIter = 200;
    
    % tolerance on function value 
    ftol = 1e-5;
    
    % delta in each direction
    deltas; 
    
    % the inner simplex, as a (ND+1)-by-ND array
    simplex;
    
    % the vector of function evaluations
    evals;
    
    % the sum of the vertex coordinates
    psum;
    
    % number of function evaluation
    numFunEvals;
end

%% Constructor
methods
    function this = NelderMeadSimplexOptimizer(varargin)
        %Create a new Simplex Optimizer
        %
        % OPT = NelderMeadSimplexOptimizer(PARAMS0, DELTA);
        % PARAMS0 is the initial set of parameters
        % DELTA is the variation of parameters in each direction, given
        % either as a scalar, or as a row vector with the same size as the
        % parameter vector.
        %
        
        %this = this@Optimizer(varargin{:});
        
        if nargin~=2
            error('Simplex optimizer constructor requires 2 input arguments');
        end
        
        % setup initial optimal value
        this.params = varargin{1};
        
        % setup vector of variation amounts in each direction
        del = varargin{2};
        if length(del)==1
            this.deltas = del * ones(size(this.params));
        else
            this.deltas = varargin{2};
        end
        
    end % end of constructor
end

%% Private functions
methods (Access = private)
    function initializeSimplex(this)
        % Initialize the simplex. 
        % This is a (ND+1)-by-ND array containing the coordinates of a
        % vertex on each row.
        
        nd = length(this.params);
        
        this.simplex = repmat(this.params, nd+1, 1);
        for i=1:nd
            this.simplex(i+1, i) = this.params(i) + this.deltas(i);
        end
        
        % compute sum of vertices coordinates
        this.psum = sum(this.simplex, 1);

        % evaluate function for each vertex of the simplex
        this.evals = zeros(nd+1, 1);
        for i=1:nd+1
            this.evals(i) = this.costFunction(this.simplex(i, :));
        end
        
        this.numFunEvals = 0;

   end
    
    function [ptry ytry] = evaluateReflection(this, ihi, fac)
        % helper function that evaluates the value of the function at the
        % reflection of point with index ihi
        %
        % [PTRY YTRY] = evaluateReflection(PT_INDEX, FACTOR)
        % PT_INDEX index of the vertex that is updated
        % FACTOR expansion (>1), reflection (<0) or contraction (0<F<1)
        %   factor 
        % PTRY is the new computed point
        % YTRY is the function evaluation at the newly evaluated point
        
        % compute weighting factors
        nd = length(this.params);
        fac1 = (1 - fac) / nd;
        fac2 = fac1 - fac;
         
        % position of the new candidate point
        ptry = this.psum * fac1 - this.simplex(ihi, :) * fac2;
        
        % evaluate function value
        ytry = this.costFunction(ptry);
        this.numFunEvals = this.numFunEvals + 1;

    end

    function updateSimplex(this, ihi, pTry, yTry)
        this.evals(ihi) = yTry;
        this.psum = this.psum - this.simplex(ihi, :) + pTry ;
        this.simplex(ihi, :) = pTry;
    end
    
    function contractSimplex(this, indLow)
        
        nd = length(this.params);
        
        pLow = this.simplex(indLow,:);
        for i = [1:indLow-1 indLow+1:nd]
            this.simplex(i, :) = (this.simplex(i,:) + pLow) * .5;
            this.evals(i) = this.costFunction(this.simplex(i,:));
        end
        
        this.numFunEvals = this.numFunEvals + nd;

    end
    
end % private methods

end % classdef