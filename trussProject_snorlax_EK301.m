fprintf("EK301, Section A3, Snorlax: Emily D., Emika H., Christian S., 11/11/2022.\n")

j = size(C,1);
m = size(C, 2);

%length of members in vectors
r = zeros(1,m);

input_c = zeros(m, 2);
for i = 1:m
    input_c(i,:) = find(C(:,i)).';
end


for i = 1:m
    r(i) = sqrt((X(input_c(i,2))-X(input_c(i,1)))^2 + (Y(input_c(i,2))-Y(input_c(i,1)))^2);
end



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

T = A_inv*L;

fprintf("Load: "+sum(L)+" oz\n")

%Displaying tension forces and identifying the tension/compression forces
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

%Displaying reaction forces
fprintf("Reaction forces in oz:\n")
fprintf("Sx1"+": "+T(m+1,1)+"\n")
fprintf("Sy1"+": "+T(m+2,1)+"\n")
fprintf("Sy2"+": "+T(m+3,1)+"\n")

cost = 10*j + 1*sum(r)*39.37;
fprintf("Cost of truss: $"+cost+"\n");
fprintf("Theoretical max load/cost ration in oz/$: "+ sum(L)/cost+"\n")

