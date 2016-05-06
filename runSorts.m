function [ D ] = runSorts(I, algorithms, numSizes, instancesPerSize,saveFlag)
%--------------------------------------------------------------------------
% Inputs:           I is a 2D cell array containing various randomly
%                       generated lists (of integers) of various sizes
%                   algorithms is a cell array where each element is a 
%                       string of the name of an algorithm for which 
%                       data will be collected.
%                   numSizes is the number of different sizes of instances
%                       (integer)
%                   instancesPerSize is the number of instances per size
%                       (integer)
%                   saveFlag is 1 if the data should be stored to disk and
%                       0 otherwise
%           
% Outputs:          D is a numel(algorithms) x numSizes x instancesPerSize
%                       array of runtime data (in seconds) that contains
%                       the CPU time taken to sort each instance of
%                       various sizes with each algorithm.
%
% Description:      Collects the runtime (in seconds) of sorting each 
%                   instance with each algorithm. MATLABs timeit function 
%                   is used to measure elapsed time.  This function works 
%                   by running each input multiple times with the same 
%                   function and recording the mean wallclock time taken 
%                   for the function on the input.  We refrain from using 
%                   cputime since this function only provides precision up 
%                   to 0.01 seconds.
%--------------------------------------------------------------------------
D = zeros(numel(algorithms), numSizes, instancesPerSize);
for size = 1:numSizes
    for instanceNum = 1:instancesPerSize
        for j=randperm(numel(algorithms))
            i = I{size}{instanceNum};
            f = @() sorter(algorithms{j}, i);
            D(j,size,instanceNum) = timeit(f);
        end
    end
    fprintf('Size %d inputs finished sorting\n', size);
end
if saveFlag
    save('Data.mat', 'D');
end

end

