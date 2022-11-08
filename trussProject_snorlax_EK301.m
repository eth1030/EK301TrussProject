% defining connection matrix C
j = 5; %# of joints
m = 7; %# of members

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
