function x = quicksort(x)
%--------------------------------------------------------------------------
% Syntax:       sx = quicksort(x);
%               
% Inputs:       x is a vector of length n
%               
% Outputs:      sx is the sorted (ascending) version of x
%               
% Description:  This function sorts the input array x in ascending order
%               using the quicksort algorithm
%               
% Complexity:   O(n * log(n))    best-case performance
%               O(n * log(n))    average-case performance
%               O(n^2)           worst-case performance
%               O(log(n))        auxiliary space (stack)
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         January 5, 2014
%--------------------------------------------------------------------------

% Knobs
kk = 15; % Insertion sort threshold, kk >= 1

% Quicksort
n = length(x);
x = quicksorti(x,1,n,kk);

end

function x = quicksorti(x,ll,uu,kk)
% Sort x(ll:uu) via quick sort 
% Note: In practice, x xhould be passed by reference

% Select pivot and partition data around it
[x mm] = partition(x,ll,uu);

% Divide-and-conquer
if ((mm - ll) <= kk)
    % Sort x(ll:(mm - 1)) via insertion sort 
    x = insertionsorti(x,ll,mm - 1);
else
    % Sort x(ll:(mm - 1)) via quick sort 
    x = quicksorti(x,ll,mm - 1,kk);
end
if ((uu - mm) <= kk)
    % Sort x((mm + 1):uu) via insertion sort 
    x = insertionsorti(x,mm + 1,uu);
else
    % Sort x((mm + 1):uu) via quick sort 
    x = quicksorti(x,mm + 1,uu,kk);
end

end

function [x mm] = partition(x,ll,uu)
% Partition x(ll:uu) around index mm
% Note: In practice, x xhould be passed by reference

%--------------------------------------------------------------------------
% Select pivot
%--------------------------------------------------------------------------
% Method 1: Median-of-3 pivot
pp = medianofthree(x,ll,uu); % Median-of-three pivot index

% Method 2: Random pivot
%pp = randi([ll uu]); % Random pivot index
%--------------------------------------------------------------------------

% Partition around pivot
x = swap(x,ll,pp);
mm = ll;
for j = (ll + 1):uu
    if (x(j) < x(ll))
        mm = mm + 1;
        x = swap(x,mm,j);
    end
end
x = swap(x,ll,mm);

end

function pp = medianofthree(x,ll,uu)
% Compute median of {x(ll),x(mm),x(uu)}
% Note: In practice, x xhould be passed by reference

% Middle element (avoiding overflow)
mm = ll + floor((uu - ll) / 2);

% Compute median of {x(ll),x(mm),x(uu)}
if (x(ll) <= x(mm))
    if (x(uu) >= x(mm))
        pp = mm;
    elseif (x(uu) >= x(ll))
        pp = uu;
    else
        pp = ll;
    end
else
    if (x(uu) >= x(ll))
        pp = ll;
    elseif (x(uu) >= x(mm))
        pp = uu;
    else
        pp = mm;
    end
end

end

function x = insertionsorti(x,ll,uu)
% Sort x(ll:uu) via insertion sort 
% Note: In practice, x xhould be passed by reference

% Insertion sort
for j = (ll + 1):uu
    pivot = x(j);
    i = j;
    while ((i > ll) && (x(i - 1) > pivot))
        x(i) = x(i - 1);
        i = i - 1;
    end
    x(i) = pivot;
end

end

function x = swap(x,i,j)
% Swap x(i) and x(j)
% Note: In practice, x xhould be passed by reference

val = x(i);
x(i) = x(j);
x(j) = val;

end
