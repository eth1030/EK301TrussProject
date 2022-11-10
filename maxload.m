%% Based off Validation Problem
% Tm = Rm * Wl

% calculate live load
Wl = 25; %Live load applied to joint D
Rm = T(1:13) / Wl;
disp("Rm:")
disp(Rm);

% calculate P-crit
length = r(1:13);

Pcrit = 2945 ./ (length.^2);
disp("Pcrit: ")
disp(Pcrit);

% calculate Wfailure
Wfailure = -Pcrit' ./ Rm;
disp("Wfailure");
disp(Wfailure);

% find minimum Wfailure
Wfailure(Wfailure==-Inf) = max(Wfailure);
Wfailure = abs(Wfailure);
buckle = min(Wfailure);
fprintf("max load : %f\n", buckle);
B = Wfailure == buckle;
indice = find(B);
fprintf("member: %d\n",indice);
