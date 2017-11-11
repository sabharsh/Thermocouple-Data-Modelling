function [tau,SSE,yL,yH,ts] = Project_Algorithm(y,time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
% Program Description 
%	This function models the temperature vs time data of a thermocouple and
%	returns the tau values and the SSE values.
%
% Function Call
% 	[tau,SSE,yL,yH,ts] = Project_Algorithm(y,time)
%
% Input Arguments
%	1. y:           stores the temperature/y values [values in degree celsius]
%    2. time:        stores the time values corresponding to the temperature
%                    values [values in seconds]
%
% Output Arguments
%	1. tau:         stores the tau values [values in seconds]
%    2. SSE:         stores the SSE for each model of each temperature
%                    history
%
% Assigment Information
%    Author:        Sabharsh Singh Sidhu, ssidhu@purdue.edu
%  	Contributor:   None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
numPoints = length(y); % stores the number of data points
halfOfNumPoints = round(numPoints/2,0); % stores the rounded value of half the number of data points (used for calculating yL for cooling and yH for heating)
thirtythOfNumPoints = round(numPoints/30,0); % stores the rounded value of a thirtyth of the number of data points (used for calculating sudequent change in y values)
thirdOfNumPoints = round(numPoints/3,0); % stores the rounded value of a hundredth of the number of data points (used for calculating sudequent change in y values)

%% ____________________
%% CALCULATIONS

% Smoothening the data
ysmooth = y; % stores the y values in ysmooth (ysmooth will stores the smoothened y values)
% for index1 = [1:5] REMOVED this for loop to improve the efficiency of the algorithm and REDUCE RUN TIME
for index2 = [3:numPoints-2]
    ysmooth(index2) = mean(ysmooth(index2-2:index2+2)); % replaces current y value with mean of 5 y values centered at that y value
end
% end

% Finding the trend of the data as it is required while copmuting the parameters

endslope = (ysmooth(numPoints)-ysmooth(numPoints-thirdOfNumPoints)) / (time(numPoints)-time(numPoints-thirdOfNumPoints)); % calculates the slope of the plot over the last 2 seconds (last tenth data points)

if(y(numPoints) > y(1)) % for increasing trend (adding to hot water/heating) 
    if(abs(endslope) >= 0.75) % if temperature changes more than 5 degrees in the last two second
        trend = 2;
    else
        trend = 1;
    end
else  % for decreasing trend (adding to cold water/cooling)
    if(abs(endslope) >= 0.75) % if temperature changes more than 5 degrees in the last two second
        trend = -2;
    else
        trend = -1;
    end
end

% Calculates the increase in consecutive pairs of y values to find ts later
ychange(1:numPoints-1) = 0;
for index = 1:numPoints-1
    ychange(index) = ysmooth(index+1) - ysmooth(index); % computes the change in consecutive y values
end

% Calculates greatest subsequent increase/decrease in y values to find ts
jump = 0; % stores greatest increase (in case of heating)
drop = 0; % stores smallest (most -ve) decrease (in case of cooling)
for index = 1:numPoints-thirtythOfNumPoints
    sum_change = sum(ychange(index:index+thirtythOfNumPoints-1)); % computes and stores the sum of a fifth of the consecutive y changes starting at y(index)
    if(sum_change > jump && trend > 0) % if data is heating and consecutive sum is greater than the previous one
        pos = index; % stores position of ts in vector time 
        jump = sum_change; % updates jump
    elseif (sum_change < drop && trend < 0) % if data is heating and consecutive sum is smaller than the previous one
        pos = index; % stores position of ts in vector time
        drop = sum_change; % updates drop
    end
end
ts = time(pos); % finds ts in time vector and stores in ts


if(trend > 0) % for increasing trend (heating)
    yL = mean(ysmooth(1:pos)); % calculates yL for increasing trend
    if (trend == 1)
        yH = mode(round(ysmooth(halfOfNumPoints:numPoints),1)); % calculates yH for increasing trend by splitting the data into two halves
    else
        yH = mean(ysmooth(numPoints-9:numPoints)); % calculates yH for increasing trend which doesn't reach stability by taking theman mean of the last 10 y values
    end
    % calculates tau for increasing trend
    y_tau = 0.632 * (yH - yL) + yL; % stores the y value corresponding to 63.2% of the difference between yH and yL
    y_tau_pos = find(round(ysmooth,0) == round(y_tau,0)); % finds positions of y_tau in y vector
    t_tau = mean(time(y_tau_pos)); % stores the time value corresponding to 63.2% of the difference between yH and yL by taking mean of time values at positions y_tau_pos
    tau = t_tau - ts; % computes tau
    
    % calculates model y values for increasing trend using equation (1) from Project Introduction
    ymodel(1:numPoints) = 0;
    for index = 1:numPoints
        if(time(index) < ts)
            ymodel(index) = yL;
        else
            ymodel(index) = yL + (yH - yL)*(1 - exp((ts-time(index))/tau));
        end
    end
% For decreasing trend (cooling)
elseif (trend < 0)
    yH = mean(y(1:pos)); % calculates yL for increasing trend
    if (trend == -1)
        yL = mode(round(y(halfOfNumPoints:numPoints),1)); % calculates yL for increasing trend by splitting the data into two halves
    else
        yL = mean(ysmooth(numPoints-9:numPoints)); % calculates yL for increasing trend which doesn't reach stability by taking theman mean of the last 10 y values
    end
    y_tau = 0.368 * (yH - yL) + yL; % stores the y value corresponding to 36.8% of the difference between yH and yL
    y_tau_pos = find(round(ysmooth,0) == round(y_tau,0)); % finds positions of y_tau in y vector
    t_tau = mean(time(y_tau_pos)); % stores the time value corresponding to 63.2% of the difference between yH and yL by taking mean of time values at positions y_tau_pos
    tau = t_tau - ts; % computes tau
    
    % calculates model y values for increasing trend using equation (2) from Project Introduction
    ymodel(1:numPoints) = 0;
    for index = 1:numPoints
        if(time(index) < ts)
            ymodel(index) = yH;
        else
            ymodel(index) = yL + (yH - yL)*(exp((ts-time(index))/tau));
        end
    end
end

% Computes the SSE
SSE = sum((y - ymodel').^2) / length(y);

%% ____________________
%% PLOTS

%% ____________________
%% FORMATTED TEXT DISPLAYS
fprintf('ts = %.2f seconds\n',ts); % printing ts
fprintf('yL = %.2f degree Celsius\n',yL); % printing yL
fprintf('yH = %.2f degree Celsius\n',yH); % printing yH
fprintf('Tau = %.2f seconds\n',tau); % printing tau
fprintf('SSE = %.3f (degree Celsius)^2\n\n',SSE); % printing SSE
% fprintf('Trend = %.0f\n\n',trend); % printing trend
end