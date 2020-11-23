%% Load and set up data, input parameters to fit model to.

clear;
load("COVIDdata.mat");

% STL Metro data
covidstlmetro_full = double(table2array(COVID_STLmetro(:,[5:6])));
covidstlmetro_1 = double(table2array(COVID_STLmetro(1:118,[5:6])));
covidstlmetro_2 = double(table2array(COVID_STLmetro(119:217,[5:6])));
covidstlmetro_3 = double(table2array(COVID_STLmetro(218:240,[5:6])));

% KC Metro data
covidkcmetro_full = double(table2array(COVID_KCmetro(:,[5:6])));
covidkcmetro_1 = double(table2array(COVID_KCmetro(1:110,[5:6])));
covidkcmetro_2 = double(table2array(COVID_KCmetro(111:240,[5:6])));

% Remain MO data
covidremainmo_full = double(table2array(COVID_remainMO(:,[5:6])));
covidremainmo_1 = double(table2array(COVID_remainMO(1:100,[5:6])));
covidremainmo_2 = double(table2array(COVID_remainMO(101:180,[5:6])));
covidremainmo_3 = double(table2array(COVID_remainMO(181:235,[5:6])));

% Inputs to be specified for fmincon to fit to
len = min([length(covidstlmetro_full(:, 1)), length(covidkcmetro_full(:, 1)), length(covidremainmo_full(:, 1))]); % TO SPECIFY
coviddata = cat(2, covidstlmetro_full(1:len, :), covidkcmetro_full(1:len, :), covidremainmo_full(1:len, :)); % TO SPECIFY
pop = 100000 * (STLmetroPop + KCmetroPop + remainMOPop); % TO SPECIFY

t = len;
coviddata = coviddata ./ pop;

% Cost function
sirafun= @(x)siroutput_network(x,t,coviddata);

%% Set up constraints and initial conditions for fmincon

% Set A and b to impose a parameter inequality constraint of the form A*x < b
A = [];
b = [];


% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Initial conditions should sum to 1
Af = zeros(1, 31);
Af(10) = 1;
Af(11) = 1;
Af(12) = 1;
Af(13) = 1;
bf = [1];


% Set upper and lower bounds on the parameters
% lb < x < ub
% All disease rates and conditions should be between 0 and 1, except initial recovered
% and dead should be 0. Travel rates should be less than 0.1.
ub = zeros(1, 31);
ub = ub + 1;
ub(12) = 0;
ub(13) = 0;
ub(14:31) = 0.1;
lb = zeros(1, 31);

% Specify some initial parameters for the optimizer to start from
x0 = zeros(1, 31); 
%% Run fmincon to find best model fit and simulate model

x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub)

Y_fit = siroutput_full_network(x, t);

%% Plot results

% Determine total cases and total deaths from SIRD model simulation.
casesModel_1 = 1 - Y_fit(:, 1);
deathsModel_1 = Y_fit(:, 4);
casesModel_2 = 1 - Y_fit(:, 5);
deathsModel_2 = Y_fit(:, 8);
casesModel_3 = 1 - Y_fit(:, 9);
deathsModel_3 = Y_fit(:, 12);

% Plot modeled vs. actual cases and deaths in each subpopulation.
figure;
set(gca, "linewidth", 2);
hold on;
plot(casesModel_1 * pop, "linewidth", 2);
plot(deathsModel_1 * pop, "linewidth", 2);
plot(coviddata(:, 1:2) * pop, "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
title("Modeled vs. Actual COVID-19 Data in STL Metro", 'fontsize', 14);
legend("Model Cases", "Model Deaths", "Cases", "Deaths", "location", "northwest");
xlabel("Time (days)");
ylabel("Number of Individuals");
exportgraphics(gca, "networkSTLmetro.eps", "Resolution", 300);
figure;
set(gca, "linewidth", 2);
hold on;
plot(casesModel_2 * pop, "linewidth", 2);
plot(deathsModel_2 * pop, "linewidth", 2);
plot(coviddata(:, 3:4) * pop, "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
title("Modeled vs. Actual COVID-19 Data in KC Metro", 'fontsize', 14);
legend("Model Cases", "Model Deaths", "Cases", "Deaths", "location", "northwest");
xlabel("Time (days)");
ylabel("Number of Individuals");
exportgraphics(gca, "networkKCmetro.eps", "Resolution", 300);
figure;
set(gca, "linewidth", 2);
hold on;
plot(casesModel_3 * pop, "linewidth", 2);
plot(deathsModel_3 * pop, "linewidth", 2);
plot(coviddata(:, 5:6) * pop, "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
title("Modeled vs. Actual COVID-19 Data in Remain MO", 'fontsize', 14);
legend("Model Cases", "Model Deaths", "Cases", "Deaths", "location", "northwest");
xlabel("Time (days)");
ylabel("Number of Individuals");
exportgraphics(gca, "networkremainMO.eps", "Resolution", 300);