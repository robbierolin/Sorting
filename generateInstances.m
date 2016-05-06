function I = generateInstances(numInstance, maxValue, sizes, saveFlag)
%--------------------------------------------------------------------------
% Inputs:           numInstance is the number of instances to
%                       generate per size (integer)
%                   maxValue is the largest possible integer to appear in a
%                       list (integer)
%                   sizes is a vector of which sizes of lists to generate
%                   saveFlag is 1 if the instances should be stored to disk
%                       and 0 otherwise
%           
% Outputs:          I is a 2D cell array where the first dimension indexes
%                       different size instances and the second dimension 
%                       indexes different lists of a given size
%
% Description:      Generates a set of lists of integers to use as 
%                   instances in a comparison between sorting algorithms.
%                   Each element in a list if generated uniformily at 
%                   random on the interval [0, maxValue].
%--------------------------------------------------------------------------
rng(1);    
I = {};
for j = 1:length(sizes)
    s = sizes(j);
    X = {};
    for i=1:numInstance
        X = {X{1:end} randi(maxValue,1,s)};
    end
    I = {I{1:end} X};
end
if saveFlag
    save('Instances.mat', 'I', '-v7.3');
end
end

