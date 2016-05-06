function [] = graphScalingAnalyses( fits,fitTypes,maxX,algorithms,sizes,lo,hi )
%--------------------------------------------------------------------------
% Inputs:           fits is a cell array of best-fit functions to the
%                       empirical runtime data of various algorthims
%                   fitTypes is a cell array where each element gives 
%                       information about the corresponding element of fits 
%                       with the same index. An element of fitTypes will 
%                       either be an 1,2,3,or 4 to indicate the degree of 
%                       the best-fit function, or 5 to indicate that the 
%                       function is a 2-parameter exponential  
%                   maxX is the largest value to be shown on the x-axis
%                       (integer)
%                   algorithms is the set of the names of the algorithms
%                       (cell array of strings)
%                   sizes is the set of sizes for which data was collected
%                       (integer)
%                   medians is a numel(algorithms) x numel(sizes) array
%                       that contains the median runtime (in seconds) for
%                       various algorithms and for various instance sizes
%           
% Outputs:          Displays a figure.
%
% Description:      Displays a figure with the best-fit functions and 90%
%                   confidence intervals of empirical runtime data for
%                   various algorithms and for various input sizes, 1
%                   curve per algorithm, graphed over input size.
%--------------------------------------------------------------------------

numAlgorithms = numel(algorithms);
numSizes = numel(sizes);

% Graph all scaling analyses
figure; hold on;
xlim([0 maxX]);
colors = {'r-' 'm-' 'bl-' 'k-' 'c-'};
for i=1:numAlgorithms
   c = colors{i};
   fit = fits{i};
   type = fitTypes{i};
   if type == 1
      l = fit;
      p = plot([1 maxX], l*[1 maxX]);
      color = get(p, 'color');
%       boundColor = lightenColor(color, .5);
%       plot([1 maxX], lo*[1 maxX], 'color', boundColor);
%       plot([1 maxX], hi*[1 maxX], 'color', boundColor);
%       plot(1:maxExtrapSize, l*(1:maxExtrapSize), 'color', color);
   else

      ci = predint( fit, 10.^[1:8], 0.90, 'observation' );
      set(gca, 'XScale', 'log');
      p = plot(fit, c);
      set(gca, 'XScale', 'log');
%       color = get(p, 'color');
%       boundColor = lightenColor(color, .5);
%       plot(10.^[1:8], ci(:,1), 'color', boundColor);
%       plot(10.^[1:8], ci(:,2), 'color', boundColor);
%       plot(fit, color);
   end
end

title('Scaling Functions for Sorting Algorithms');
xlabel('Input Size');
ylabel('Running Time [Seconds]');
% Legend should be (algorithm,UCB,LCB,algorithm,UCB,LCB,...)
% legendEntries = {'90% UCB', '90% LCB'};
ScaleLegend = {};
for i = 1:numAlgorithms
%   ScaleLegend = {ScaleLegend{1:end} algorithms{i} legendEntries{1:2}}; 
    ScaleLegend = {ScaleLegend{1:end} algorithms{i}}; 
end
legend(ScaleLegend, 'Location', 'NorthWest');


end

