
% Here is an example that reads in infection and fatalities from STL City
% and loads them into a new matrix covidstlcity_full
% In addition to this, you have other matrices for the other two regions in question

covidstlmetro_full = double(table2array(COVID_STLmetro(:,[5:6])))%./(100000*(STLmetroPop));
covidstlmetro_1 = double(table2array(COVID_STLmetro(1:118,[5:6])))%./(100000*(STLmetroPop));
covidstlmetro_2 = double(table2array(COVID_STLmetro(119:217,[5:6])))%./(100000*(STLmetroPop));
covidstlmetro_3 = double(table2array(COVID_STLmetro(218:240,[5:6])))%./(100000*(STLmetroPop));

covidkcmetro_full = double(table2array(COVID_KCmetro(:,[5:6])))%./(100000*KCmetroPop);
covidkcmetro_1 = double(table2array(COVID_KCmetro(1:110,[5:6])))%./(100000*KCmetroPop);
covidkcmetro_2 = double(table2array(COVID_KCmetro(111:240,[5:6])))%./(100000*KCmetroPop);

covidremainmo_full = double(table2array(COVID_remainMO(:,[5:6])))%./(100000*remainMOPop);
covidremainmo_1 = double(table2array(COVID_remainMO(1:100,[5:6])))%./(100000*remainMOPop);
covidremainmo_2 = double(table2array(COVID_remainMO(101:180,[5:6])))%./(100000*remainMOPop);
covidremainmo_3 = double(table2array(COVID_remainMO(181:235,[5:6])))%./(100000*remainMOPop);

len = min([length(covidstlmetro_full(:, 1)), length(covidkcmetro_full(:, 1)), length(covidremainmo_full(:, 1))]);
coviddata = cat(2, covidstlmetro_full(1:len, :), covidkcmetro_full(1:len, :), covidremainmo_full(1:len, :)); % TO SPECIFY
t = len; % TO SPECIFY
pop = 100000 * (STLmetroPop + KCmetroPop + remainMOPop); % TO SPECIFY

coviddata = coviddata ./ pop;
% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput_network(x,t,coviddata);

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [];
b = [];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Af = zeros(1, 31);
Af(10) = 1;
Af(11) = 1;
Af(12) = 1;
Af(13) = 1;
bf = [1];

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = zeros(1, 31);
ub = ub + 1;
ub(12) = 0;
ub(13) = 0;
ub(14:31) = 0.1;
lb = zeros(1, 31);

% Specify some initial parameters for the optimizer to start from
x0 = zeros(1, 31); 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you 
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub)

Y_fit = siroutput_full_network(x,t);

casesModel_1 = 1 - Y_fit(:, 1);
deathsModel_1 = Y_fit(:, 4);
casesModel_2 = 1 - Y_fit(:, 5);
deathsModel_2 = Y_fit(:, 8);
casesModel_3 = 1 - Y_fit(:, 9);
deathsModel_3 = Y_fit(:, 12);

% Make some plots that illustrate your findings.
figure;
set(gca, "linewidth", 2);
hold on;
plot(casesModel_1 * pop, "linewidth", 2);
plot(deathsModel_1 * pop, "linewidth", 2);
plot(coviddata(:, 1:2) * pop, "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
title("Modeled vs. Actual COVID-19 Data in STL Metro", 'fontsize', 14);
legend("Model Cases", "Model Deaths", "Cases", "Deaths");
xlabel("Time (days)");
ylabel("Number of Individuals");
figure;
set(gca, "linewidth", 2);
hold on;
plot(casesModel_2 * pop, "linewidth", 2);
plot(deathsModel_2 * pop, "linewidth", 2);
plot(coviddata(:, 3:4) * pop, "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
title("Modeled vs. Actual COCID-19 Data in KC Metro", 'fontsize', 14);
legend("Model Cases", "Model Deaths", "Cases", "Deaths");
xlabel("Time (days)");
ylabel("Number of Individuals");
figure;
set(gca, "linewidth", 2);
hold on;
plot(casesModel_3 * pop, "linewidth", 2);
plot(deathsModel_3 * pop, "linewidth", 2);
plot(coviddata(:, 5:6) * pop, "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
title("Modeled vs. Actual COVID-19 Data in Remain MO", 'fontsize', 14);
legend("Model Cases", "Model Deaths", "Cases", "Deaths");
xlabel("Time (days)");
ylabel("Number of Individuals");