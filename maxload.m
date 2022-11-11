%% Based off Validation Problem
%% calculate live load
Wl = 27.2; %Live load applied to joint D
Rm = T(1:size(T,1)-3) ./ Wl;
%disp(T(1:size(T,1)-3));
%disp("Rm:")
%disp(Rm);

%% calculate P-crit
length = r(1:size(T,1)-3);

Pcrit = 2945 ./ (length.^2);
%disp("Pcrit: ")
%disp(Pcrit');

%% calculate Wfailure
Pcrit = Pcrit';
%Wfailure = -Pcrit./ Rm;
Wfailure = rdivide(-Pcrit,Rm);
%disp("Wfailure");
%disp(Wfailure);

%% find minimum Wfailure
Wfailure(Wfailure==-Inf) = max(Wfailure);
%disp(Wfailure);
Wfailure = abs(Wfailure);
buckle = min(Wfailure);
fprintf("max load : %f\n", buckle);
B = Wfailure == buckle;
%disp(B);
indice = find(B);
fprintf("member: %d\n",indice);
