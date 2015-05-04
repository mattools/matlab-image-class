function [data1, data2, parent, name1, name2] = parseInputCouple(this, that, inp1, inp2)
%PARSEINPUTCOUPLE Extract numeric data from image inputs
%
%   [DATA1 DATA2 PARENT NAME1 NAME2] = parseInputCouple(THIS, THAT)
%   This function is used to parse inputs of functions that accept two
%   arguments, that can be either image or numeric array, in any order.
%   This function aims at extracting numeric data, and a pointer to an
%   Image object.
%
%   THIS and THAT can be either Image classes or numeric arrays. At least
%   one of these must be of class Image.
%   The function returns:
%   DATA1 is either the data array THIS, or the field "data" if THIS is an
%   instance of Image class
%   DATA2 is either the data array THAT, or the field "data" if THAT is an
%   instance of Image class
%   PARENT is a reference to THIS if it is an Image instance, or to THAT
%   otherwise.
%   
%
%   Example
%     [data1 data2 this] = parseInputCouple(this, that);
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2011-08-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

name1 = '';
name2 = '';

% extract info from first input
if isa(this, 'Image')
    parent = this;
    name1 = this.name;
    data1 = this.data;
    
else
    parent = that;
    data1 = permute(this, [2 1 3:5]);
    
    if nargin >= 3
        name1 = inp1;
    end
    if isempty(name1)
        if isscalar(this)
            name1 = num2str(this);
        else
            name1 = '?';
        end
    end
end

% extract info from second input
if isa(that, 'Image')
    name2 = that.name;
    data2 = that.data;
    
else
    data2 = permute(that, [2 1 3:5]);
    
    if nargin >= 4
        name2 = inp2;
    end
    if isempty(name2)
        if isscalar(that)
            name2 = num2str(that);
        else
            name2 = '?';
        end
    end
end
