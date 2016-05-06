function [ p ] = plotSCD( y, name, j )
%--------------------------------------------------------------------------
% Inputs:           y is an array of runtime data (in seconds) to 
%                       create an empirical CDF from
%                   name is the name of the algorithm
%                   j is an identifier for the size of the lists being
%                       plotted
%           
% Outputs:          p is the object returned by MATLABs plot function when
%                       called on the CDF created from y
%
% Description:      Plots the CDF and 95% confidence intervals of an array
%                   of runtime data.  
%--------------------------------------------------------------------------

[f,x,flo,fup] = ecdf(y);
p = plot(x,f);
csvwrite(strcat(name,num2str(j),'CDF.csv'), [x f flo fup]);
lineColor = get(p,'color');

% Use lighter colour for confidence intervals.
boundColor = lightenColor(lineColor, .5);
plot(x,flo,'Color', boundColor);
plot(x,fup,'Color', boundColor);

% Plot the cdf again so it is on top of CIs.
plot(x,f,'Color',lineColor);

% Labels
title('Solution Cost Distributions (CDFs)');
xlabel('Running Time [seconds]');
end

