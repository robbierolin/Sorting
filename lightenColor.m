function [ c ] = lightenColor( c,alpha )
%--------------------------------------------------------------------------
% Inputs:           c is an array with 3 elements between zero and one that
%                       correspond to an rgb colour,
%                   alpha is a number between zero and one indicating how 
%                       much to lighten the colour c, alpha=1 will return
%                       white and alpha=0 will return c  
%           
% Outputs:          c is an array with 3 elements between zero and one that
%                       correspond to an rbg colour
%
% Description:      Lighten an rgb colour by a given percentage.
%--------------------------------------------------------------------------


c = (1-alpha) *(c) + alpha;



end

