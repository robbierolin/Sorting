function x = combsort(x)
%--------------------------------------------------------------------------
% Syntax:       sx = combsort(x);
%               
% Inputs:       x is a vector of length n
%               
% Outputs:      sx is the sorted (ascending) version of x
%               
% Description:  This function sorts the input array x in ascending order
%               using the comb sort algorithm
%               
% Complexity:   O(n)            best-case performance
%               O(n^2 / 2^p)    average-case performance
%               O(n^2)          worst-case performance
%               O(1)            auxiliary space
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         January 5, 2014
%--------------------------------------------------------------------------

% Knobs
shrink = 1.3; % shrink > 1

% Comb sort
n = length(x);
gap = n;
swapped = true;
while ((gap > 1) || (swapped == true))
    % Update gap
    gap = max(floor(gap / shrink),1);
    
    % Bubble sort with given gap
    i = 1;
    swapped = false;
    while ((i + gap) <= n)
        if (x(i) > x(i + gap))
            x = swap(x,i,i + gap);
            swapped = true;
        end
        i = i + 1;
    end
end

end

function x = swap(x,i,j)
% Swap x(i) and x(j)
% Note: In practice, x xhould be passed by reference

val = x(i);
x(i) = x(j);
x(j) = val;

end
