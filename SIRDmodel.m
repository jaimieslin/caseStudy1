%% Creates vectors for S, I, R, and D that represent a time series.

t = 100; % Number of time steps

x = [1; 0; 0; 0]; % Initial conditions

A = [ 0.95, 0.04, 0, 0;
      0.05, 0.85, 0, 0;
         0, 0.10, 1, 0;
         0, 0.01, 0, 1];
     
[S, I, R, D] = sird(x, A, t);

%% Plots the epidemic.

figure;
hold on
plot(S);
plot(I);
plot(R);
plot(D);
legend("Susceptible", "Infected", "Recovered", "Deceased");
title("SIRD Model Simulation");
ylabel("Fraction of Population");
xlabel("Time (steps)");
%% Models and epidemic given an initial condition and rates of death, infection,
%  recovery, etc.

function [S, I, R, D] = sird(x, A, t)
S = zeros(1, t+1);
I = zeros(1, t+1);
R = zeros(1, t+1);
D = zeros(1, t+1);
S(1) = x(1);
I(1) = x(2);
R(1) = x(3);
D(1) = x(4);
for i = 1:t
    x = A * x;
    S(i+1) = x(1);
    I(i+1) = x(2);
    R(i+1) = x(3);
    D(i+1) = x(4);
end

end