clear
close all
clc

%% Dynamics
A1 = [1/2 1/2; -1/4 -5/4];
A2 = [5/6 5/3; -2/3  1/6];
B1 = [ 0; 3];
B2 = [-2; 1];
C1 = [0 1];
C2 = [1/3 2/3];

nx = size(A1,1);

%% a
% LMI Variables
Zvar = sdpvar(2,2);
Y1var = sdpvar(1,2);
Y2var = sdpvar(1,2);

% Conditions
Lp = Zvar >= 1e-9;
Lf1 = [Zvar (Zvar*A1' + Y1var'*B1'); (A1*Zvar + B1*Y1var) Zvar] >= 0;
Lf2 = [Zvar (Zvar*A2' + Y2var'*B2'); (A2*Zvar + B2*Y2var) Zvar] >= 0;
L = [Lf1,Lf2,Lp]; 

% Solve
opts = sdpsettings('solver','sdpt3');
diagnostics = optimize(L,[],opts);
disp(diagnostics.info)
if diagnostics.problem == 0
 disp('Feasible')
elseif diagnostics.problem == 1
 disp('Infeasible')
else
 disp('Something else happened')
end

check(L)

pause(1)

% Results
Z = value(Zvar);
P = Z\eye(nx); % faster than inv(Z)
disp(eig(P))

Y1 = value(Y1var);
Y2 = value(Y2var);
K1 = Y1*P;
K2 = Y2*P;
disp(eig(Z - (Z*A1' + Y1'*B1')*P*(A1*Z + B1*Y1)));
disp(eig(Z - (Z*A2' + Y2'*B2')*P*(A2*Z + B2*Y2)));

%% b Common QLF
pause
clear
close all
clc

A1 = [1/2 1/2; -1/4 -5/4];
A2 = [5/6 5/3; -2/3  1/6];
B1 = [ 0; 3];
B2 = [-2; 1];
C1 = [0 1];
C2 = [1/3 2/3];

nx = size(A1,1);

% observability
% W = sym('W',[2 2]);
% obsv  = A1'*W*A1 - W + C1'*C1 == 0;
% obsvCheck = solve(obsv,W);
% Wresult = [double(obsvCheck.W1_1) double(obsvCheck.W1_2); double(obsvCheck.W2_1) double(obsvCheck.W2_2)];
% eig(Wresult)
O1 = rref([C1; C1*A1]);
O2 = rref([C2; C2*A2]);

% LMI Variables
Pvar = sdpvar(2,2);
Y1var = sdpvar(2,1);
Y2var = sdpvar(2,1);

% Conditions
Lp = Pvar >= 1e-9;
Lf1 = [Pvar (A1'*Pvar - C1'*Y1var'); (Pvar*A1 - Y1var*C1) Pvar] >= 0;
Lf2 = [Pvar (A2'*Pvar - C2'*Y2var'); (Pvar*A2 - Y2var*C2) Pvar] >= 0;
L = [Lf1,Lf2,Lp]; 

% Solve
opts = sdpsettings('solver','sdpt3');
diagnostics = optimize(L,[],opts);
disp(diagnostics.info)
if diagnostics.problem == 0
 disp('Feasible')
elseif diagnostics.problem == 1
 disp('Infeasible')
else
 disp('Something else happened')
end

check(L)

pause(1)

% Results
P = value(Pvar);
disp(eig(P))

Y1 = value(Y1var);
Y2 = value(Y2var);
L1 = inv(P)*Y1;
L2 = inv(P)*Y1;
% disp(eig(P - (A1'*P - C1'*Y1')*inv(P)*(P*A1 - Y1*C1)));
disp(eig(P - (A2'*P - C2'*Y2')*inv(P)*(P*A2 - Y2*C2)));