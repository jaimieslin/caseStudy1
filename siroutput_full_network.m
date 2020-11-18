%% This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate

function f = siroutput_full_network(x,t)

% Here is a suggested framework for x.  However, you are free to deviate
% from this if you wish.

% set up transmission constants
k_infections_1 = x(1);
k_fatality_1 = x(2);
k_recover_1 = x(3);
k_infections_2 = x(4);
k_fatality_2 = x(5);
k_recover_2 = x(6);
k_infections_3 = x(7);
k_fatality_3 = x(8);
k_recover_3 = x(9);

% set up initial conditions
ic_susc = x(10);
ic_inf = x(11);
ic_rec = x(12);
ic_fatality = x(13);

% Set up SIRD within-population transmission matrix
A1 = [ 1 - k_infections_1,                            0, 0, 0;
          k_infections_1, 1 - (k_recover_1 + k_fatality_1), 0, 0;
                     0,                    k_recover_1, 1, 0;
                     0,                   k_fatality_1, 0, 1];
                 
A2 = [ 1 - k_infections_2,                            0, 0, 0;
          k_infections_2, 1 - (k_recover_2 + k_fatality_2), 0, 0;
                     0,                    k_recover_2, 1, 0;
                     0,                   k_fatality_2, 0, 1];
A3 = [ 1 - k_infections_3,                            0, 0, 0;
          k_infections_3, 1 - (k_recover_3 + k_fatality_3), 0, 0;
                     0,                    k_recover_3, 1, 0;
                     0,                   k_fatality_3, 0, 1];
                 
A = blkdiag(A1, A2, A3);

T = zeros(12);
T(1, 1) = 1 - (x(14) + x(15)); % Chance that susceptible person in pop. 1 stays in pop. 1
T(1, 5) = x(14); % Chance that susceptible person in pop. 1 goes to pop. 2
T(1, 9) = x(15); % Chance that susceptible person in pop. 1 goes to pop. 3
T(5, 1) = x(16); % Chance that susceptible person in pop. 2 goes to pop. 1
T(5, 5) = 1 - (x(16) + x(17)); % Chance that susceptible person in pop. 2 stays in pop. 2
T(5, 9) = x(17); % Chance that susceptible person in pop. 2 goes to pop. 3
T(9, 1) = x(18); % Chance that susceptible person in pop. 3 goes to pop. 1
T(9, 5) = x(19); % Chance that susceptible person in pop. 3 goes to pop. 2
T(9, 9) = 1 - (x(18) + x(19)); % Chance that susceptible person in pop. 3 stays in pop. 3
T(2, 2) = 1 - (x(20) + x(21)); % Chance that infected person in pop. 1 stays in pop. 1
T(2, 6) = x(20); % Chance that infected person in pop. 1 goes to pop. 2
T(2, 10) = x(21); % Chance that infected person in pop. 1 goes to pop. 3
T(6, 2) = x(22); % Chance that infected person in pop. 2 goes to pop. 1
T(6, 6) = 1 - (x(22) + x(23)); % Chance that infected person in pop. 2 stays in pop. 2
T(6, 10) = x(23); % Chance that infected person in pop. 2 goes to pop. 3
T(10, 2) = x(24); % Chance that infected person in pop. 3 goes to pop. 1
T(10, 6) = x(25); % Chance that infected person in pop. 3 goes to pop. 2
T(10, 10) = 1 - (x(24) + x(25)); % Chance that infected person in pop. 3 stays in pop. 3
T(3, 3) = 1 - (x(26) + x(27)); % Chance that recovered person in pop. 1 stays in pop. 1
T(3, 7) = x(26); % Chance that recovered person in pop. 1 goes to pop. 2
T(3, 11) = x(27); % Chance that recovered person in pop. 1 goes to pop. 3
T(7, 3) = x(28); % Chance that recovered person in pop. 2 goes to pop. 1
T(7, 7) = 1 - (x(28) + x(29)); % Chance that recovered person in pop. 2 stays in pop. 2
T(7, 11) = x(29); % Chance that recovered person in pop. 2 goes to pop. 3
T(11, 3) = x(30); % Chance that recovered person in pop. 3 goes to pop. 1
T(11, 7) = x(31); % Chance that recovered person in pop. 3 goes to pop. 2
T(11, 11) = 1 - (x(30) + x(31)); % Chance that recovered person in pop. 3 stays in pop. 3

 % Dead people will stay in the same place
T(4, 4) = 1;
T(8, 8) = 1;
T(12, 12) = 1;

A = T * A;

B = zeros(12,1);

% Set up the vector of initial conditions
x0 = [ic_susc, ic_inf, ic_rec, ic_fatality, ic_susc, ic_inf, ic_rec, ic_fatality, ic_susc, ic_inf, ic_rec, ic_fatality];

% simulate the SIRD model for t time-steps
sys_sir_base = ss(A,B,eye(12),zeros(12,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

% return the output of the simulation
f = y;

end