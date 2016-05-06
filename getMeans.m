function [ means ] = getMeans( D, numAlgorithms, numSizes, instancesPerSize)
%--------------------------------------------------------------------------
% Inputs:           D is a numAlgorithms x numSizes x instancesPerSize
%                       array of runtime data (seconds) of multiple 
%                       algorithms over a set of instances
%                   numAlgorithms is the number of algorithms for which
%                       data was collected (integer)
%                   numSizes is the number of different sizes of instances
%                       (integer)
%                   instancesPerSize is the number of instances per size
%                       (integer)
%           
% Outputs:          means is a numAlgorithms x numSizes array that contains
%                       the mean running time (in seconds) of multiple 
%                       algorithms over multiple instance sizes
%
% Description:      Collect the mean running times for various algorithms
%                        and for various instance sizes from data.
%--------------------------------------------------------------------------
means = zeros(numAlgorithms, numSizes);
for i=1:numAlgorithms
    Di = reshape(D(i,:,:), [numSizes instancesPerSize]);
    means(i, :) = mean(Di,2);
end
end

