
% Here is an example that reads in infection and fatalities from STL City
% and loads them into a new matrix covidstlcity_full
% In addition to this, you have other matrices for the other two regions in question

covidstlmetro_full = double(table2array(COVID_STLmetro(:,[5:6])));
covidstlmetro_1 = double(table2array(COVID_STLmetro(1:118,[5:6])));
covidstlmetro_2 = double(table2array(COVID_STLmetro(119:217,[5:6])));
covidstlmetro_3 = double(table2array(COVID_STLmetro(218:240,[5:6])));

covidkcmetro_full = double(table2array(COVID_KCmetro(:,[5:6])));
covidkcmetro_1 = double(table2array(COVID_KCmetro(1:110,[5:6])));
covidkcmetro_2 = double(table2array(COVID_KCmetro(111:240,[5:6])));

covidremainmo_full = double(table2array(COVID_remainMO(:,[5:6])));
covidremainmo_1 = double(table2array(COVID_remainMO(1:100,[5:6])));
covidremainmo_2 = double(table2array(COVID_remainMO(101:180,[5:6])));
covidremainmo_3 = double(table2array(COVID_remainMO(181:235,[5:6])));

covidstlcity = double(table2array(COVID_STLcity(129:229,[5:6])));

coviddata = covidstlmetro_full; % TO SPECIFY
t = length(coviddata(:, 1)); % TO SPECIFY
pop = 100000*(STLmetroPop); % TO SPECIFY
% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput(x,t,coviddata, pop);

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
Af = [0, 0, 0, 1, 1, 1, 1];
bf = [1];

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [1, 1, 1, 1, 1, 1, 1]';
lb = [0, 0, 0, 0, 0, 0, 0]';

% Specify some initial parameters for the optimizer to start from
x0 = [0.003, 0.004, 0.66, 1, 0, 0, 0]; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you 
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub)

Y_fit = siroutput_full(x,t);

casesModel = (1 - Y_fit(:, 1)) * pop;
deathsModel = Y_fit(:, 4) * pop;
figure;
hold on
% Make some plots that illustrate your findings.
plot(casesModel);
plot(deathsModel);
plot(coviddata);
legend("Model Cases", "Model Deaths", "Cases", "Deaths");