%--------------------------------------------------------------------------
% Description:      Performs a comparative performance analysis of a set of
%                   sorting functions.  Randomly generates a set of sorting
%                   instances (lists of nonnegative integers) and collects
%                   data of how long each sorting function takes to run on 
%                   each instance. Generates a Solution Cost Distribution 
%                   for each algorithm and displays all of them in a 
%                   figure.  Performs a scaling analysis on each algorithm 
%                   and displays a figure with the functions that best fit 
%                   how each algorithm empirically scales with input size.
%                   Creates a per-input selector and compares the
%                   performance to a per-set selector and a perfect
%                   selector.
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
% numSizes = floor((maxSize - minSize)/sizeGap) + 1; % Number of sizes of lists.
numSizes = length(sizes);
numInstances = instancesPerSize*numSizes; % Total number of instances to generate.
% algorithms = {'bubble' 'bucket' 'cocktail' 'comb' 'counting' 'heap' 'insertion' 'merge' 'quick' 'radix' 'selection' 'shell'};
algorithms = {'bubble' 'bucket' 'cocktail' 'comb' 'heap' 'insertion' 'merge' 'quick' 'radix' 'selection' 'shell'};
% algorithms = {'shell' 'bucket' 'merge'}; % Set of algorithms to run.
numAlgorithms = numel(algorithms); % Number of algorithms that will be run on each input.
% sizes = minSize:sizeGap:maxSize; % Set of sizes of inputs to generate.



%% Get instances.
% Generate Instances.
disp('Started generating inputs...');
% I = generateInstances(instancesPerSize,maxValue,sizes,1);
disp('...Finished Generating inputs');

% Load Instances.
load('Instances.mat', 'I');



% Get data.
% Collect data.
% D = runSorts(I, algorithms, numSizes, instancesPerSize,1);

% Load data.
% disp('Started loading data...');
load('data.mat', 'D');
% disp('...Finished loading data');

%% SCDs
algorithmIndex = 1:11;
numAlgorithms = length(algorithmIndex);
a = zeros(numAlgorithms, 1);
figure; hold on;
for i=1:numAlgorithms
    size(D(algorithmIndex(i),:,:));
%     y = reshape((D(algorithmIndex(i),:,:)), [numSizes*instancesPerSize 1]);
    for j=2:2:6
        y = reshape((D(algorithmIndex(i),j,:)), [instancesPerSize 1]);
        a(i) = plotSCD(y, algorithms{algorithmIndex(i)}, j);
    end

end
legend(a,algorithms(algorithmIndex), 'Location', 'SouthEast');

%% Get summary statistics.
% Calculate means, medians
medians = getQuantiles(D,0.5,numAlgorithms,numSizes,instancesPerSize);
% means = getMeans(D,numAlgorithms,numSizes,instancesPerSize);

%% Plot empirical scaling curves
algorithmIndex = [2 5 7 9 11];
numAlgorithms = length(algorithmIndex);
figure; hold on;
a = zeros(numAlgorithms,1);
for i=1:numAlgorithms
   a(i) = plot((sizes),(medians(algorithmIndex(i),:)), '-*'); 
%    color = get(a(i), 'color');
%    plot(sizes, medians(i,:), '*', 'color', color);
end
legend(a,algorithms(algorithmIndex), 'Location', 'NorthWest');
xlabel('Input Size');
ylabel('Running Time [Seconds]');
title('Empirical Scaling Curves');

%% Scaling Analyses.
algorithmIndex = [2 5 7 9 11];
numAlgorithms = length(algorithmIndex);
% Run function to perform scaling analysis, fitting both polynomial,
% exponential (both 2-parameter) and choosing one with lower RMSE.
fits = cell(numAlgorithms);
fitTypes = cell(numAlgorithms);
for i=1:numAlgorithms
    index = algorithmIndex(i);
   [f,type,newsizes,lo,hi] = scalingAnalysis(sizes',medians(index,:)',maxValue,algorithms{index}); 
   fits{i} = f;
   fitTypes{i} = type;
end
%%
graphScalingAnalyses(fits,fitTypes,maxSize*100000,algorithms(algorithmIndex),newsizes,lo,hi);

%% Explore effect of maxSize
algorithms = {'shell', 'merge', 'bucket'};
numAlgorithms = numel(algorithms);
xs = {};
ys = {};
zs = {};

% Plot effect for each algorithm over multiple list sizes.
for i=1:numAlgorithms
   [x,y,z] = maxEffect(algorithms(i)); 
   xs{i} = x;
   ys{i} = y;
   zs{i} = z;
end
%%
% Plot surface for all algorithms.
figure; hold on;
cs = {'red', 'blue', 'green'};
for i = 1:numAlgorithms
    surf(xs{i},ys{i}, zs{i}, 'FaceColor',cs{i},'EdgeColor','black');
    camlight left;
    lighting phong
%     colormap(map{i})
end
legend(algorithms, 'southeast');
ylabel('Maximum Element');
xlabel('Input Size');
zlabel('Running Time [Seconds]');
title('Parameter Response Surfaces for Various Sorting Algorithms');
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');

%% Find subset of surfaces that are below all other surfaces.
hasDominatingSubset = 0;
dominatingSubset = [];
for i=1:(numAlgorithms-1)
   combos = combntns(1:numAlgorithms, i);
   numCombos = size(combos, 1);
   for j=1:numCombos
      subset = combos(j,:); 
      if numel(subset) > 1
          upperBound = max(zs{subset});
      else
          upperBound = zs{subset};
      end
      
      otherSurfaces = setdiff(1:numAlgorithms, subset);
      if numel(otherSurfaces) > 1
          lowerBound = min(zs{otherSurfaces});
      else
          lowerBound = zs{otherSurfaces};
      end
      
      if all(all(upperBound < lowerBound))
          dominatingSubset = subset;
          hasDominatingSubset = 1;
          break;
      end
   end
   if hasDominatingSubset
       break;
   end
end
dominatingSubset
%% Per-input algorithm selector
Selector;
