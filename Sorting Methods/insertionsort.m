function x = insertionsort(x)
%--------------------------------------------------------------------------
% Syntax:       sx = insertionsort(x);
%               
% Inputs:       x is a vector of length n
%               
% Outputs:      sx is the sorted (ascending) version of x
%               
% Description:  This function sorts the input array x in ascending order
%               using the insertion sort algorithm
%               
% Complexity:   O(n)      best-case performance
%               O(n^2)    average-case performance
%               O(n^2)    worst-case performance
%               O(1)      auxiliary space
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         January 5, 2014
%--------------------------------------------------------------------------

% Insertion sort
n = length(x);
for j = 2:n
    pivot = x(j);
    i = j;
    while ((i > 1) && (x(i - 1) > pivot))
        x(i) = x(i - 1);
        i = i - 1;
    end
    x(i) = pivot;
end

end
