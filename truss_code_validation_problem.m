%truss Project Computational Method Validation Problem
% defining connection matrix C
j = 8; %# of joints
m = 13; %# of members

%input_c is a matrix of the joints connected to a member NOTE: Put joints
%from increasing order so 1 2, 8 10, 3 7. Not: 8 1, 7 3
input_c = [
    1 2, %member 1
    1 3, %member 2
    2 3, %member 3
    2 4, %member 4
    3 4, %member 5
    4 5, %member 6
    3 5, %member 7
    3 6, %member 8
    5 6, %member 9
    5 7, %member 10
    6 7, %member 11
    7 8, %member 12
    6 8, %member 13
    ];

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
y2 = 8; %y2 reaction at joint 8

Sx(x1, 1) = 1;
Sy(y1, 2) = 1;
Sy(y2, 3) = 1;

%Position of joints
X = [0 0 4 4 8 8 12 12]; %in meters
Y = [0 4 4 8 8 4 4 0]; %in meters 

%length of members in vectors
r = zeros(1,m);
for i = 1:m
    r(i) = sqrt((X(input_c(i,2))-X(input_c(i,1)))^2 + (Y(input_c(i,2))-Y(input_c(i,1)))^2);
end

joint_weight = 3; %weight is applied on this joint
wx = 0; %weight force 0N in x direction
wy = 25; %weight force 25N in y direction
Lx = zeros(j, 1);
Lx(joint_weight) = wx; %weight force on joint 3
Ly = zeros(j, 1);
Ly(joint_weight) = wy;  %weight force on joint 3


%matrix A that is populated by coefficients of the force for the respective
%member tension
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


%Calculating for the tensions/rxn forces
A = [Cx Sx; Cy Sy];

A_inv = inv(A);

L = [Lx; Ly];

T = A_inv*L;


%Displaying tension forces and identifying the tension/compression forces
for t = 1:size(T,1)-3
    if(T(t,1) < 0)
        fprintf("T"+t+" = "+T(t,1)+"N (compression)\n")
    elseif(T(t,1) > 0)
           fprintf("T"+t+" = "+T(t,1)+"N (tension)\n") 
    else
        fprintf("T"+t+" = "+T(t,1)+"N\n")
    end
end

%Displaying reaction forces
fprintf("RX1"+" = "+T(m+1,1)+"N\n")
fprintf("RY1"+" = "+T(m+2,1)+"N\n")
fprintf("RY2"+" = "+T(m+3,1)+"N\n")

