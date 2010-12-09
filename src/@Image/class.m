function classname = class(this)
%CLASS Class name of the Image object, including image type
%
%   CLASS_NAME = class(input)
%   This function is overloaded to give more information within the
%   workspace.
%
%   Example
%   img = Image.read('cameraman.tif');
%   class(img)
%   ans =
%       grayscale Image
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

classname = [this.type ' Image'];
