function sx = countingsort(x,r)
%--------------------------------------------------------------------------
% Syntax:       sx = countingsort(x,r);
%               
% Inputs:       x is a vector of length n containing integers in the range
%               [1,...,r]
%               
%               r is an upper bound on max(x)
%               
% Outputs:      sx is the sorted (ascending) version of x
%               
% Description:  This function sorts the input array x in ascending order
%               using the counting sort algorithm
%               
% Complexity:   O(n)    best-case performance
%               O(n)    average-case performance
%               O(n)    worst-case performance
%               O(n)    auxiliary space
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         January 5, 2014
%--------------------------------------------------------------------------

% Compute histogram
n = numel(x);
C = zeros(r,1);
for j = 1:n
    C(x(j)) = C(x(j)) + 1;
end

% Convert to cumulative values
for i = 2:r
    C(i) = C(i) + C(i - 1);
end

% Sort the array
sx = nan(n,1);
for j = n:-1:1
    sx(C(x(j))) = x(j);
    C(x(j)) = C(x(j)) - 1;
end

end
