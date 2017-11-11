# Thermocouple-Data-Modelling

Execution: Run Project_AlgExec.m in MATALB to view the modelling and analysis.

## Introduction

I created an algorithm to analyse 100 data sets that contain time histories over a period of 10 seconds and the corresponding temperatures measured from thermocouple sensors. The algorithm is supposed to calculate the components of yL, yH, ts, and 𝜏 and create a model of the data. The criteria for success is having low SSE values as well as a good fitting plot; additionally, actual parameter values for 4 data set are provided as well.

The algorithm takes in data from the thermocouple, smoothens it using moving averages, and creates a model from the temperature-time data. The algorithm then returns values of SSE, 𝜏, yL, yH, and ts.

One critical decision was the I decided to smoothen the noisy data using moving averages with a window of five elements. This was particularly an advantage because it allowed as to compute the various parameters with greater ease. Working on the noisy data was not a reliable method since my techniques of calculation were thrown off due to the jagged data points with random inconsistencies. One improvement I made in this regard is I removed a nested loop to reduce the execution time and improve the efficiency.

The second critical decision was that I categorized the data into four types of trends. I compared the temperature of the last data point to the first data point to check whether the data set is heating or cooling. Cooling data was set to negative trend whereas heating data was set to a positive trend. In addition, the slope of the data set over the last few seconds is also considered. If it is more than a certain threshold, the trend is set to 2 with the appropriate sign, otherwise the trend is set to 1 with the appropriate sign. This is one of the improvements I made in our algorithm and is described in more detail in the procedure and particularly helped me deal with the different types of data differently.

Lastly, I decided to compute tau using 2 different approached, one for heating and one for cooling. For the cooling data, I took 36.8% of the absolute difference between yL and yH whereas for the heating data I took 62.3% of the absolute difference between yL and yH. The allowed me to accurately compute the tau value and hence compute and plot the model values.

## Procedure

Our algorithm can be broken down into numerous simple steps which are as follow:

Step 1: The algorithm smoothens the noisy data. The concept of moving averages is used taking a window of 5 elements.

Step 2: The algorithm checks the trend of the data by comparing the last data point to the first one. If the last temperature value is greater than the first one, the trend is increasing/heating (trend is positive), otherwise the trend is decreasing/cooling (trend is negative). It also checks the slope over the last 3.33 seconds to check stability. If the slope is below 0.75, trend is set to 1 with appropriate sign, otherwise the trend is set to 2 with appropriate sign. 

Step 3: The ts is calculated by computing which data point has the greatest change (decrease for cooling or increase for heating) in temperature in the subsequent data points. The change in a 30th of the total data points is considered at a time. The time at the data point which has the greatest change in temperature after it is ts.

Step 4: The yH for cooling data or yL for heating is then calculated by taking the mean of temperature values from 0 to ts.

Step 5: The yL for cooling or yH for heating is then calculated. For data that reaches stability (trend = -1 or 1), this value computes by taking the mode of all the temperature values in the second half of the 10 second time interval, that is the last 5 seconds. For data that doesn’t reach stability (trend = -2 or 2), this value is calculated by taking a mean of the last few values, 10 to be exact. 

Step 6: Finally, 𝜏 is calculated in two steps, first ytau is calculated is follows:
ytau = 0.368 * (yH - yL) + yL (for cooling) or ytau = 0.632 * (yH - yL) + yL (for heating)
Then, ts is subtracted from time corresponding to the ytau value to obtain 𝜏. 

Step 7: The model values are calculated using the equations provided in the guidelines keeping the trend in mind since there are different equations for cooling and heating data.

## Figures and Plots

All figures and plots are contained in the file "plots_and_figures.pdf"

## Results

Application of the algorithm to various datasets is exhibited below:

Figure 1 shows a plot of the modelled and the actual data of FOS thermocouple prices. The model is to show a correlation between values of 𝛕 and prices of FOS thermocouple which is that cost increases exponentially as the time constant value decreases.

Table 1 shows the model parameters of clean and noisy data sets where the thermocouple was originally placed in cold water (heating data set). The accuracy is shown in the low values of the SSE where a lower SSE means less error between my model and the actual results.

Table 2 shows the model parameters of clean and noisy data sets where the thermocouple was originally placed in hot water (cooling data set). This table also shows the accuracy of the algorithm through the use of SSE. 

Table 3 displays the statistics for my model of 𝛕 and price of the several thermocouples and the improvement of this model from my previous algorithm. The table shows the reduced standard deviation of 𝛕, mean of 𝛕, and mean SSE values for each thermocouple indicating improvement.

## Interpretation

I believe that one source of error for the experiments might be the brief time that the thermocouple is in the air when switching from hot to cold water, or cold to hot water or when the thermocouple might not be completely submerged. This can be seen in many data plots where the temperature reading does not stabilize. The algorithm doesn’t anticipate the temperature to stabilize as the time approaches 10 seconds, however, it is not able to distinguish between un-stabilized and stabilized data with 100% accuracy which is another source of error.

I believe that the thermocouples from FOS are fairly priced, and perform well for what you pay for, and for $15 the thermocouple does perform well as shown from its low time constant. The thermocouples are very consistent with their performance and pricing. As the performance increases exponentially the pricing does as well which is reasonable.

## References

"System Dynamics - Time Constants." System Dynamics - Time Constants. N.p., n.d. Web. 19 Apr. 2017. http://www.facstaff.bucknell.edu/mastascu/eLessonsHTML/SysDyn/SysDyn3TCBasic.htm
