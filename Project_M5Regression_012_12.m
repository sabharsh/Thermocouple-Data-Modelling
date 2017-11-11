function [SSE,SST,R_squared] = Project_M5Regression_012_12(tau_values,mean_tau_values)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
%	This function uses the tau mean values to values given in M3 Memo to
%	generate a model for the cost and time constant relationship.
%	It then plots the model using all the hundred tau values anf calculates
%	the SSE, SST and R squared.
%
% Function Call
% 	[SSE,SST,R_squared] = Project_M5Regression_012_12(tau_values,mean_tau_values)
%
% Input Arguments
%	1. tau_values:      stores the tau values of all 100 temperature histories
%   2. mean_tau_values: stores the mean tau values of each thermocouple
%
% Output Arguments
%	1. SSE:             stores the SSE value
%   2. SST:             stores the SST value
%   3. R_squared:       stores the r squared value
%
% Assigment Information
%   Assignment:    M3
%   Author:        Sabharsh Singh Sidhu, ssidhu@purdue.edu
%  	Team ID:       012-12
%  	Contributor:   None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
cost_values = [linspace(15.77,15.77,20), linspace(10.61,10.61,20), linspace(2.69,2.69,20), linspace(1.23,1.23,20), linspace(0.11,0.11,20)]; % cost values each repeated 20 times to have have same dimensions as the tau vector
cost_values_for_mean = [15.77,10.61,2.69,1.23,0.11]; % cost values without repition

%% ____________________
%% CALCULATIONS
% Sorting the tau values to enable us to plot a consistent model (with the
% plot going to and fro due to unsorted data)
tau_values = sort(tau_values);

% The data is best represented by an EXPONENTIAL function as it gaves a
% roughly straight line with the semilogy plot

% Calculating the model values
model_coeffs = polyfit(mean_tau_values,log10(cost_values_for_mean),1); % calculate the linearized model  coefficients
slope = model_coeffs(1); % initializing the slope
intercept = model_coeffs(2); % initializing the y intercept
cost_linearized_model = polyval(model_coeffs,tau_values); % computing the linearized modelled cost values
cost_model = 10.^cost_linearized_model; % converting the linearized modelled cost values to the exponential cost values

equation = ['y = ', num2str(10^(intercept)), ' * 10^{',num2str(slope),'x}']; % initializing string which stores the equation

% Computing SSE, SST and R squared
SSE = sum((cost_values - cost_model).^2);        % Calculates SSE for model
SST = sum((cost_values - mean(cost_values)).^2); % Calculates SST for cost values
R_squared = 1 - SSE / SST;             % Calculates R squared the cost

%% ____________________
%% PLOTS
% The data is best represented by an exponentinal function as it gaves a
% roughly straight line with the semilogy plot

figure(1); % creates figure
plot(tau_values,cost_values,'b*'); % plots the tau values againt the actual cost values
hold on; % holds on to same plot
plot(tau_values,cost_model,'r-'); % plots the tau values againt the modeled cost values
title('Cost and Time Constant Relationship of the Thermocouples'); % adds title
xlabel('Tau Values [seconds]'); % adds label to x axis
ylabel('Cost Values [USD]'); % adds label to y axis
text(0.8,5,equation,'Color','red'); % adds the equation of the model as text in red color to match the model
legend('Actual Cost Data Points','Cost Model '); % adds the legend
grid on; % adds grid

%% ____________________
%% FORMATTED TEXT DISPLAYS
% fprintf('y = %.2f * 10^(%.2fx)', 10^(intercept),slope); % printing equation

end