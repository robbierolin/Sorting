function [ l ] = sorter( algorithm, l )
%--------------------------------------------------------------------------
% Inputs:           algorithm is the name of the algorithm to use to sort
%                       the list (string)
%                   l is a list of numbers to be sorted
%           
% Outputs:          l is a sorted copy of the input list
%
% Description:      Sort a list of numbers using a given algorithm.
%--------------------------------------------------------------------------
if strcmp(algorithm, 'bubble')
    l = bubblesort(l);
elseif strcmp(algorithm, 'bucket')
    l = bucketsort(l);
elseif strcmp(algorithm, 'cocktail')
    l = cocktailsort(l);
elseif strcmp(algorithm, 'comb')
   l = combsort(l);
elseif strcmp(algorithm, 'counting')
    r = 1e6; % Upper bound on max(l)
    l =countingsort(l, r);
elseif strcmp(algorithm, 'heap')
    l = heapsort(l);
elseif strcmp(algorithm, 'insertion')
    l = insertionsort(l);
elseif strcmp(algorithm, 'merge')
    l = mergesort(l);
elseif strcmp(algorithm, 'quick')
    l = quicksort(l);
elseif strcmp(algorithm, 'radix')
    l = radixsort(l);
elseif strcmp(algorithm, 'selection')
    l = selectionsort(l);
elseif strcmp(algorithm, 'shell')
    l = shellsort(l);   
end

end

