j = 7; %# of joints
m = 11; %# of members

%input_c is a matrix of the joints connected to a member NOTE: Put joints
%from increasing order so 1 2, 8 10, 3 7. Not: 8 1, 7 3
input_c = [
    1 6, %member 1
    1 2, %member 2
    2 3, %member 3
    3 4, %member 4
    2 6, %member 5
    3 7, %member 6
    3 6, %member 7
    6 7, %member 8
    4 7, %member 9
    4 5, %member 10
    5 7, %member 11
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
y2 = 5; %y2 reaction at joint 5

Sx(x1, 1) = 1;
Sy(y1, 2) = 1;
Sy(y2, 3) = 1;

%Position of joints
X = [0 2 5 8 10 2 8]; %in meters
Y = [0 2 2 2 0 0 0]; %in meters 

%loads in x and y axis
L = [
    0; %1x
    0; %2x
    0; %3x
    0; %4x
    0; %5x
    0; %6x
    0; %7x
    0; %1y
    0; %2y
    0; %3y
    0; %4y
    0; %5y
    0; %6y
    100  %7y
    ];

