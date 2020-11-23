%% Finds the best interventions strategy based off cost and benefit functions.
%  YOU MUST RUN base_sir_fit.m PRIOR TO RUNNING THIS IN ORDER TO HAVE THE
%  CORRECT VARIABLES (x, Y_fit) IN YOUR WORKSPACE.

% Sets up initial conditions
baseCase = x;
today = Y_fit(101, :);
initial = cat(2, baseCase(1:3), today);
control = initial;


% Iterates over all possible values of infection and death rates, with precision
% of 1 x 10^-7. Finds the best relative benefit over a 1 year simulation and
% saves the change in infection and death rate.
best = [0, 0, 0];
for d = 0:0.0000001:baseCase(2)
    for i = 0:0.0000001:baseCase(1)
        
        control = initial;
        
        control(1) = control(1) - i;
        control(2) = control(2) - d;
        
        initial_sim = siroutput_full(initial, 365);
        control_sim = siroutput_full(control, 365);
        
        dI = initial_sim(:, 2) - control_sim(:, 2);
        dD = initial_sim(:, 4) - control_sim(:, 4);
        gamma = control(1) / initial(1);
        beta = control(2) / initial(2);
        
        benefit = 10 * norm(dI) + 10 * norm(dD);
        cost = 800 * (1 - gamma) * ((norm(dI)).^2) + 800 * (1 - beta) * ((norm(dD)).^2);
        total = benefit - cost;
        
        if total > best(3)
            best = [i, d, total];
        end
    end
end

% Sets up the control scenario
control = initial;
control(1) = control(1) - best(1);
control(2) = control(2) - best(2);

%% Simulates and plots the results using siroutput_full.

baseCase_sim = siroutput_full(baseCase, 465);
control_sim = siroutput_full(control, 365);

% Calculates total cases and deaths based on SIRD model simulation 
casesOG = (1 - baseCase_sim(:, 1)) * pop;
deathsOG = baseCase_sim(:, 4) * pop;
casesControl = (1 - control_sim(:, 1)) * pop;
deathsControl = control_sim(:, 4) * pop;

% Calculates cases and deaths prevented by control
casesPrevented = casesOG(465) - casesControl(365)
deathsPrevented = (baseCase_sim(465, 4) - control_sim(365, 4)) * pop

%% Plots results.

figure;
set(gca, "linewidth", 2);
hold on
plot(casesOG, "linewidth", 2);
plot(deathsOG, "linewidth", 2);
plot(coviddata, "linewidth", 2);
plot([100:464], casesControl, "linewidth", 2);
plot([100:464], deathsControl, "linewidth", 2);
set(gca, "fontsize", 15);
legend("Model Cases", "Model Deaths", "Actual Cases", "Actual Deaths", "Model Cases with Intervention", "Model Deaths with Intervention", "location", "northwest");
title("Effects of Intervention on COVID-19 Cases and Deaths", "fontsize", 13);
ylabel("Number of Individuals");
xlabel("Time (days)");
tb = annotation("textbox", [.5, .1, .3, .3], "string", {"Cases Prevented: 2,637", "Deaths Prevented: 134"}, "fitboxtotext", "on"); 
tb.FontSize = 15;
tb.LineWidth = 2;
exportgraphics(gca, "costvsbenefit.eps", "Resolution", 300);

%% Outputs for intervention.mat

A = [1 - baseCase(1), 0, 0, 0;
     baseCase(1), 1 - (baseCase(2) + baseCase(3)), 0, 0;
     0, baseCase(3), 1, 0;
     0, baseCase(2), 0, 1];
 
A_new = [1 - control(1), 0, 0, 0;
     control(1), 1 - (control(2) + control(3)), 0, 0;
     0, control(3), 1, 0;
     0, control(2), 0, 1];

x0 = [control(4), control(5), control(6), control(7)];
