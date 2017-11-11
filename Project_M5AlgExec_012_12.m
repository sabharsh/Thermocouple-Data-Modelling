function Project_M5AlgExec_012_12()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
%	This function models and plots 4 sets of temperature vs time data of
%	thermocouples. Its also computes the SSE values of each model.
%
% Function Call
% 	Project_M5AlgExec_012_12()
%
% Input Arguments
%	None
%
% Output Arguments
%	None
%
% Assigment Information
%   Assignment:    M4
%   Author:        Sabharsh Singh Sidhu, ssidhu@purdue.edu
%  	Team ID:       012-12
%  	Contributor:   None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
tic;
data = csvread('fos_time_histories.csv',0,0); % importing data

time = data(:,1); % Extracts time vector from data set into variable time
y(:,1:100) = data(:,2:101); % Extracts all of the temperature hisory data and stores into the variable y 


%% ____________________
%% CALCULATIONS
for index = 1:100
    fprintf('Thermocouple %.0f (Temperature History %.0f):\n',ceil(index/20),index); % prints out which temperature history and which thermocouple
    % fprintf('%.0f: ',index);
    [tau(index),SSE(index)] = Project_M5Algorithm_012_12(y(:,index),time); % Calls the algorithm by passing the y values for a certain thermocouple and the time vector, recieves and stores tau and SSE in seperate vectors for every thermocouple
end

FOS1_mean_tau = mean(tau(1:20));%calculates the mean tau value for thermocouple 1 
FOS2_mean_tau = mean(tau(21:40));%calculates the mean tau value for thermocouple 2
FOS3_mean_tau = mean(tau(41:60));%calculates the mean tau value for thermocouple 3
FOS4_mean_tau = mean(tau(61:80));%calculates the mean tau value for thermocouple 4
FOS5_mean_tau = mean(tau(81:100));%calculates the mean tau value for thermocouple 5

FOS1_std_tau = std(tau(1:20));%calculates the standard deviation for thermocouple 1
FOS2_std_tau = std(tau(21:40));%calculates the standard deviation for thermocouple 2
FOS3_std_tau = std(tau(41:60));%calculates the standard deviation for thermocouple 3
FOS4_std_tau = std(tau(61:80));%calculates the standard deviation for thermocouple 4
FOS5_std_tau = std(tau(81:100));%calculates the standard deviation for thermocouple 5

FOS1_mean_SSE = mean(SSE(1:20));%calculates the SSE for thermocouple 1 by averaging the SSE values for each time history
FOS2_mean_SSE = mean(SSE(21:40));%calculates the SSE for thermocouple 2 by averaging the SSE values for each time history
FOS3_mean_SSE = mean(SSE(41:60));%calculates the SSE for thermocouple 3 by averaging the SSE values for each time history
FOS4_mean_SSE = mean(SSE(61:80));%calculates the SSE for thermocouple 4 by averaging the SSE values for each time history
FOS5_mean_SSE = mean(SSE(81:100));%calculates the SSE for thermocouple 5 by averaging the SSE values for each time history

mean_tau_values = [FOS1_mean_tau, FOS2_mean_tau, FOS3_mean_tau, FOS4_mean_tau, FOS5_mean_tau]; % makes a vector containing the 5 tau mean values

[SSE,SST,R_squared] = Project_M5Regression_012_12(tau,mean_tau_values); % does the regression analysis

%% ____________________
%% PLOTS

%% ____________________
%% FORMATTED TEXT DISPLAYS
fprintf('\nTemperature-Time Data Analysis is as Follows:-\n');
fprintf('\t\tMean of tau (s)\t\tSt. Dev. in Tau (s)\t\tMean of SSE ((degree Celsius)^2)\n');
fprintf('FOS-1\t%.2f\t\t\t\t%.3f\t\t\t\t\t%.3f\n',FOS1_mean_tau,FOS1_std_tau,FOS1_mean_SSE); % prints analysis of FOS 1
fprintf('FOS-2\t%.2f\t\t\t\t%.3f\t\t\t\t\t%.3f\n',FOS2_mean_tau,FOS2_std_tau,FOS2_mean_SSE); % prints analysis of FOS 2
fprintf('FOS-3\t%.2f\t\t\t\t%.3f\t\t\t\t\t%.3f\n',FOS3_mean_tau,FOS3_std_tau,FOS3_mean_SSE); % prints analysis of FOS 3
fprintf('FOS-4\t%.2f\t\t\t\t%.3f\t\t\t\t\t%.3f\n',FOS4_mean_tau,FOS4_std_tau,FOS4_mean_SSE); % prints analysis of FOS 4
fprintf('FOS-5\t%.2f\t\t\t\t%.3f\t\t\t\t\t%.3f\n',FOS5_mean_tau,FOS5_std_tau,FOS5_mean_SSE); % prints analysis of FOS 5

fprintf('\nRegression Analysis of Cost-Tau Relationship Model:-\n');
fprintf('SSE = %.3f dollars^2\n',SSE); % printing the SSE
fprintf('SST = %.3f dollars^2\n',SST); % printing the SST
fprintf('R^2 = %.3f\n\n',R_squared); % printing the R squared
toc
end