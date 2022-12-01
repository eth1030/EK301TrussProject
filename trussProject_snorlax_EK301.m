fprintf("EK301, Section A3, Snorlax: Emily D., Emika H., Christian S., 11/11/2022.\n")
% 
%j = 8; %# of joints
%m = 13; %# of members

%input_c is a matrix of the joints connected to a member NOTE: Put joints
%from increasing order so 1 2, 8 10, 3 7. Not: 8 1, 7 3
filename = "Truss_final.json"; %design 53 greatest (41,7,39)
fid = fopen(filename);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
data = jsondecode(str);
data.supports();

j = size(data.nodes, 1);
m = size(data.members, 1);

X = zeros(1,j);
Y = zeros(1,j);

%Creating position vectors
for i = 1:j
    new_nodes = split(data.nodes(i), ",");
    X(1,i) = str2num(new_nodes{1,1});
    Y(1,i) = str2num(new_nodes{2,1});

end

%Creating member matrix
input_c = zeros(m,2);
for i = 1:m
    new_member = split(data.members(i), ",");
    input_c(i,1) = str2num(new_member{1,1})+1;
    input_c(i,2) = str2num(new_member{2,1})+1;
end
% % 
% % input_c = [
% %     1 3, %member 1
% %     3 4, %member 2
% %     2 4, %member 3
% %     3 5, %member 4
% %     4 5, %member 5
% %     4 6, %member 6
% %     5 6, %member 7
% %     2 6, %member 8
% %     7 8,  %member 9
% %     5 7, %member 10
% %     3 7, %member 11
% %     3 8, %member 12
% %     1 8 %member 13
% %     ];

C = zeros(j, m);

for r = 1:size(input_c,1)
    C(input_c(r,1), r) = 1;
    C(input_c(r,2), r) = 1;

end

Sx = zeros(j, 3); %matrix along the x-axis
Sy = zeros(j, 3); %matrix along the y-axis

%reaction forces
x1 = 1; %x1 reaction at joint 1
y1 = 1; %y1 reaction at joint 1
y2 = 2; %y2 reaction at joint 2

Sx(x1, 1) = 1;
Sy(y1, 2) = 1;
Sy(y2, 3) = 1;

%Position of joints
%X = [0 30 12 19 19 25 12 4]; %in meters
%Y = [0 0 0 0 10 6 11 7]; %in meters 

%loads in x and y axis
new_forces = split(data.forces, ",");
L = zeros(2*j, 1);
L(j+str2num(new_forces{1,1})+1,1) = abs(str2num(new_forces{3,1}));

j = size(C,1);
m = size(C, 2);

% length of members in vectors
r = zeros(1,m);

input_c = zeros(m, 2);
for i = 1:m
    input_c(i,:) = find(C(:,i)).';
end


for i = 1:m
    r(i) = sqrt((X(input_c(i,2))-X(input_c(i,1)))^2 + (Y(input_c(i,2))-Y(input_c(i,1)))^2);
end

% error check length
short = r < 7;
short = find(short,1);
long = r > 15;
long = find(long,1);
msg = 'Member length is under 7 inches.';
msg2 = 'Member length is above 15 inches.';

if (short)
    error(msg);
end
if (long)
    error(msg2);
end

% matrix A that is populated by coefficients of the force for the respective
% member tension
Cx = C;
Cy = C;

for rows = 1:size(input_c,1)
    Cx(input_c(rows,1), rows) = (X(input_c(rows,2))-X(input_c(rows,1)))/r(rows);
    Cx(input_c(rows,2), rows) = (X(input_c(rows,1))-X(input_c(rows,2)))/r(rows);
end

for rows = 1:size(input_c,1)
    Cy(input_c(rows,1), rows) = (Y(input_c(rows,2))-Y(input_c(rows,1)))/r(rows);
    Cy(input_c(rows,2), rows) = (Y(input_c(rows,1))-Y(input_c(rows,2)))/r(rows);
end


% Calculating for the tensions/rxn forces
A = [Cx Sx; Cy Sy];

A_inv = inv(A);

T = A_inv*L;
fprintf("Load: "+sum(L)+" oz\n")

% Displaying tension forces and identifying the tension/compression forces
fprintf("Member forces in oz:\n")
for t = 1:size(T,1)-3
    if(T(t,1) < 0)
        fprintf("m"+t+": "+T(t,1)+" (C)\n")
    elseif(T(t,1) > 0)
        fprintf("m"+t+": "+T(t,1)+" (T)\n") 
    else
        fprintf("m"+t+": "+T(t,1)+"\n")
    end
end

% Displaying reaction forces
fprintf("Reaction forces in oz:\n")
fprintf("Sx1"+": "+T(m+1,1)+"\n")
fprintf("Sy1"+": "+T(m+2,1)+"\n")
fprintf("Sy2"+": "+T(m+3,1)+"\n")

length = r(1:size(T,1)-3);

Pcrit = 2945 ./ (length.^2);

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
Wfailure(Wfailure<0) = max(Wfailure);
buckle = min(Wfailure);
fprintf("max load : %f\n", buckle);
%B = Wfailure == buckle;

%Plotting the trusses
figure();
for i = 1:m
 
    A = [X(input_c(i,1)),X(input_c(i,2))];
    
    B = [Y(input_c(i,1)),Y(input_c(i,2))];
    
    if (i ~= find(Wfailure == buckle))
        if(T(i,1) < 0)
            plot(A,B,'r','LineWidth',4);
        elseif(T(i,1) > 0)
            plot(A,B,'b','LineWidth',4);
        end
    else
        plot(A,B,'g','LineWidth',4);
    end
    %label(h,'centered label','location','bottom')
    hold on;
    axis([-30,5, 0,30]);
end

legend('compression (green is 1st to buckle)','tesion')

cost = 10*j + 1*sum(r);
fprintf("Cost of truss: $"+cost+"\n");
fprintf("Theoretical max load/cost ratio in oz/$: "+ buckle/cost+"\n")
