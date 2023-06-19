clear
close all
clc

%% Dynamics
A1 = [1.6 2; -4 -1.8];
A2 = [-1.8 4; -2 1.6];
nx = size(A1,1);

% a
alpha = 0:0.01:1;
As = zeros(nx,nx,length(alpha));
for i = 1:length(alpha)
    As(:,:,i) = alpha(i)*A1 + (1-alpha(i))*A2;
end

figure
hold on
for i = 1:length(alpha)
    plot(eig(As(:,:,i)),'ro')
end
xlim([-1,1])
ylim([-3,3])
grid on