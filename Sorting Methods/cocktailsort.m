function x = cocktailsort(x)
%--------------------------------------------------------------------------
% Syntax:       sx = cocktailsort(x);
%               
% Inputs:       x is a vector of length n
%               
% Outputs:      sx is the sorted (ascending) version of x
%               
% Description:  This function sorts the input array x in ascending order
%               using the cocktail sort algorithm
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

% Cocktail sort
n = length(x);
ll = 0;
uu = n - 1;
swapped = true;
while (swapped == true)
    % Forward bubble sort pass
    swapped = false;
    ll = ll + 1;
    for i = ll:uu
        if (x(i) > x(i + 1))
            x = swap(x,i,i + 1);
            swapped = true;
        end
    end
    if (swapped == true)
        % Backwards bubble sort pass
        swapped = false;
        uu = uu - 1;
        for i = uu:-1:ll
            if (x(i) > x(i + 1))
                x = swap(x,i,i + 1);
                swapped = true;
            end
        end
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
