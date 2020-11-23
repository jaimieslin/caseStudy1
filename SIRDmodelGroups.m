%% Creates vectors for S, I, R, and D that represent a time series.

t = 100; % Number of time steps

x1 = [100; 0; 0; 0]; % Initial conditions for population 1
x2 = [200; 0; 0; 0]; % Initial conditions for population 2
x3 = [150; 0; 0; 0]; % Initial conditions for population 3
x = cat(1, x1, x2, x3);

A1 = [ 0.95, 0.04, 0, 0; % Within-population changes for population 1
       0.05, 0.85, 0, 0;
          0, 0.10, 1, 0;
          0, 0.01, 0, 1];
A2 = [ 0.92, 0, 0, 0; % Within-population changes for population 2
       0.08, 0.78, 0, 0;
          0, 0.2, 1, 0;
          0, 0.02, 0, 1];
A3 = [ 0.95, 0.04, 0, 0; % Within-population changes for population 3
       0.05, 0.85, 0, 0;
          0, 0.10, 1, 0;
          0, 0.01, 0, 1];
      
A = blkdiag(A1, A2, A3);
      
T = zeros(12);
T(1, 1) = 0.94; % Chance that susceptible person in pop. 1 stays in pop. 1
T(1, 5) = 0.03; % Chance that susceptible person in pop. 1 goes to pop. 2
T(1, 9) = 0.03; % Chance that susceptible person in pop. 1 goes to pop. 3
T(5, 1) = 0.03; % Chance that susceptible person in pop. 2 goes to pop. 1
T(5, 5) = 0.94; % Chance that susceptible person in pop. 2 stays in pop. 2
T(5, 9) = 0.03; % Chance that susceptible person in pop. 2 goes to pop. 3
T(9, 1) = 0.03; % Chance that susceptible person in pop. 3 goes to pop. 1
T(9, 5) = 0.03; % Chance that susceptible person in pop. 3 goes to pop. 2
T(9, 9) = 0.94; % Chance that susceptible person in pop. 3 stays in pop. 3
T(2, 2) = 0.98; % Chance that infected person in pop. 1 stays in pop. 1
T(2, 6) = 0.01; % Chance that infected person in pop. 1 goes to pop. 2
T(2, 10) = 0.01; % Chance that infected person in pop. 1 goes to pop. 3
T(6, 2) = 0.01; % Chance that infected person in pop. 2 goes to pop. 1
T(6, 6) = 0.98; % Chance that infected person in pop. 2 stays in pop. 2
T(6, 10) = 0.01; % Chance that infected person in pop. 2 goes to pop. 3
T(10, 2) = 0.01; % Chance that infected person in pop. 3 goes to pop. 1
T(10, 6) = 0.01; % Chance that infected person in pop. 3 goes to pop. 2
T(10, 10) = 0.98; % Chance that infected person in pop. 3 stays in pop. 3
T(3, 3) = 0.94; % Chance that recovered person in pop. 1 stays in pop. 1
T(3, 7) = 0.03; % Chance that recovered person in pop. 1 goes to pop. 2
T(3, 11) = 0.03; % Chance that recovered person in pop. 1 goes to pop. 3
T(7, 3) = 0.03; % Chance that recovered person in pop. 2 goes to pop. 1
T(7, 7) = 0.94; % Chance that recovered person in pop. 2 stays in pop. 2
T(7, 11) = 0.03; % Chance that recovered person in pop. 2 goes to pop. 3
T(11, 3) = 0.03; % Chance that recovered person in pop. 3 goes to pop. 1
T(11, 7) = 0.03; % Chance that recovered person in pop. 3 goes to pop. 2
T(11, 11) = 0.94; % Chance that recovered person in pop. 3 stays in pop. 3

% Dead people will stay in the same place
T(4, 4) = 1;
T(8, 8) = 1;
T(12, 12) = 1;

B = T * A;
     
[S, I, R, D] = sirdGroups(x, B, t);

%% Plots the epidemic.

figure;
set(gca, "linewidth", 2);
hold on;
plot(S(1, :), "linewidth", 2);
plot(I(1, :), "linewidth", 2);
plot(R(1, :), "linewidth", 2);
plot(D(1, :), "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
legend("Susceptible", "Infected", "Recovered", "Deceased");
title("SIRD Model Simulation for Population 1");
ylabel("Number of Individuals");
xlabel("Time (steps)");
exportgraphics(gca, "modelPop1.eps", "Resolution", 300);
figure;
set(gca, "linewidth", 2);
hold on;
plot(S(2, :), "linewidth", 2);
plot(I(2, :), "linewidth", 2);
plot(R(2, :), "linewidth", 2);
plot(D(2, :), "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
legend("Susceptible", "Infected", "Recovered", "Deceased");
title("SIRD Model Simulation for Population 2");
ylabel("Number of Individuals");
xlabel("Time (steps)");
exportgraphics(gca, "modelPop2.eps", "Resolution", 300);
figure;
set(gca, "linewidth", 2);
hold on;
plot(S(3, :), "linewidth", 2);
plot(I(3, :), "linewidth", 2);
plot(R(3, :), "linewidth", 2);
plot(D(3, :), "linewidth", 2);
hold off;
set(gca, "fontsize", 15);
legend("Susceptible", "Infected", "Recovered", "Deceased");
title("SIRD Model Simulation for Population 3");
ylabel("Number of Individuals");
xlabel("Time (steps)");
exportgraphics(gca, "modelPop3.eps", "Resolution", 300);
%% Models and epidemic given an initial condition and rates of death, infection,
%  recovery, etc.

function [S, I, R, D] = sirdGroups(x, B, t)
S = zeros(3, t+1);
I = zeros(3, t+1);
R = zeros(3, t+1);
D = zeros(3, t+1);
S(1, 1) = x(1);
I(1, 1) = x(2);
R(1, 1) = x(3);
D(1, 1) = x(4);
S(2, 1) = x(5);
I(2, 1) = x(6);
R(2, 1) = x(7);
D(2, 1) = x(8);
S(3, 1) = x(9);
I(3, 1) = x(10);
R(3, 1) = x(11);
D(3, 1) = x(12);
for i = 1:t
    x = B * x;
    S(1, i+1) = x(1);
    I(1, i+1) = x(2);
    R(1, i+1) = x(3);
    D(1, i+1) = x(4);
    S(2, i+1) = x(5);
    I(2, i+1) = x(6);
    R(2, i+1) = x(7);
    D(2, i+1) = x(8);
    S(3, i+1) = x(9);
    I(3, i+1) = x(10);
    R(3, i+1) = x(11);
    D(3, i+1) = x(12);
end

end