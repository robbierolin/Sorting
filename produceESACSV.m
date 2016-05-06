%--------------------------------------------------------------------------
% Description:      Produces CSVs that can be used as input to ESA.
%--------------------------------------------------------------------------
addpath('Sorting Methods');
rng(1,'twister'); % For reproducibility.
%% Initialize parameters.
maxValue = 1e8; % Maximum value of an element in a list.
% minSize = 1; % Size of smallest list.
% maxSize = 1e4 + 1; % Size of largest list.
% sizeGap = 1000; % Size interval between lists.
sizes = round(sqrt(10).^[1:6]);
maxSize = max(sizes);
instancesPerSize = 101; % Number of instances to generate per size.
numSizes = length(sizes);
numInstances = instancesPerSize*numSizes; % Total number of instances to generate.
algorithms = {'bubble' 'bucket' 'cocktail' 'comb' 'heap' 'insertion' 'merge' 'quick' 'radix' 'selection' 'shell'};
numAlgorithms = numel(algorithms); % Number of algorithms that will be run on each input.


% Load Instances.
load('Instances.mat', 'I');


load('data.mat', 'D');


algorithmIndex = [2 5 7 9 11];
numAlgorithms = numel(algorithmIndex);

biggersizes = round(10^3 * sqrt(10).^[1:4]);
for i = 1:numAlgorithms
   index = algorithmIndex(i);
   algorithmData = squeeze(D(index, :, :));
   algorithmDataColumn = reshape(algorithmData', [numInstances 1]);
   sizeColumn = reshape(repmat(sizes, [instancesPerSize 1]), [numInstances 1]);
   
   Ibig = generateInstances(11, 10^8, biggersizes, 0);
   Dbig = squeeze(runSorts(Ibig, algorithms(index), 4, 11, 0));
   algorithmBigDataColumn = reshape(Dbig', [44 1]);
   bigSizeColumn = reshape(repmat(biggersizes, [11 1]), [44 1]);
   
   M = [(1:numInstances)' sizeColumn algorithmDataColumn];
   Mbig = [(numInstances+1:numInstances+44)' bigSizeColumn algorithmBigDataColumn ];
   
   M = [M; Mbig];
   
   csvwrite(strcat(algorithms{index}, '.csv'), M);
end


