baseCase = x;
today = Y_fit(101, :);
initial = cat(2, baseCase(1:3), today);
control = initial;

best = [0, 0, 0];
for d = 0:0.000001:baseCase(2)
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

control = initial;
control(1) = control(1) - best(1);
control(2) = control(2) - best(2);

%%

baseCase_sim = siroutput_full(baseCase, 465);
control_sim = siroutput_full(control, 365);

casesOG = (1 - baseCase_sim(:, 1)) * pop;
deathsOG = baseCase_sim(:, 4) * pop;
casesControl = (1 - control_sim(:, 1)) * pop;
deathsControl = control_sim(:, 4) * pop;

casesPrevented = casesOG(465) - casesControl(365)
deathsPrevented = (baseCase_sim(465, 4) - control_sim(365, 4)) * pop

figure;
set(gca, "linewidth", 2);
hold on
% Make some plots that illustrate your findings.
plot(casesOG, "linewidth", 2);
plot(deathsOG, "linewidth", 2);
plot(coviddata, "linewidth", 2);
plot([100:464], casesControl, "linewidth", 2);
plot([100:464], deathsControl, "linewidth", 2);
set(gca, "fontsize", 15);
legend("Model Cases", "Model Deaths", "Actual Cases", "Actual Deaths", "Model Cases with Intervention", "Model Deaths with Intervention", "location", "northwest");
ylabel("Number of Individuals");
xlabel("Time (days)");