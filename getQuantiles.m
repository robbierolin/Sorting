function [ quantiles ] = getQuantiles( D, p, numAlgorithms, numSizes, instancesPerSize)
%--------------------------------------------------------------------------
% Inputs:           D is a numAlgorithms x numSizes x instancesPerSize
%                       array of runtime data (seconds) of multiple 
%                       algorithms over a set of instances
%                   p is the quantile of the running times to collect (0,1)
%                   numAlgorithms is the number of algorithms for which
%                       data was collected (integer)
%                   numSizes is the number of different sizes of instances
%                       (integer)
%                   instancesPerSize is the number of instances per size
%                       (integer)
%           
% Outputs:          quantiles is a numAlgorithms x numSizes array that 
%                       contains the p-th quantile running time (in 
%                       seconds) of multiple algorithms over multiple 
%                       instance sizes
%
% Description:      Collect the p-th quantile running times for various 
%                       algorithms and for various instance sizes from 
%                       data.
%--------------------------------------------------------------------------
quantiles = zeros(numAlgorithms, numSizes);
for i=1:numAlgorithms
    Di = reshape(D(i,:,:), [numSizes instancesPerSize]);
    quantiles(i, :) = quantile(Di,p,2);
end
end

