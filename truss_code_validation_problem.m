%truss Project Computational Method Validation Problem
% defining connection matrix C
j = 8; %# of joints
m = 13; %# of members

%input_c is a matrix of the joints connected to a member
input_c = [
    1 2, %member 1
    1 3, %member 2
    2 3, %member 3
    3 4, %member 4
    2 4, %member 5
    2 5, %member 6
    4 5  %member 7
    ];

C = zeros(j, m);

for r = 1:size(input_c,1)
    C(input_c(r,1), r) = 1;
    C(input_c(r,2), r) = 1;

end

Sy = zeros(j, 3); %matrix along the y-axis
Sx = zeros(j, 3); %matrix along the x-axis

X = 
%Y = 

m = 1.7; %1.7lb
w = m*(32.2); %finding weight force
L = [0, 0, 0, 0, 0, 0, w, 0, 0, 0].'
