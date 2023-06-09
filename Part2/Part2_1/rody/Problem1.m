clear
close all
clc
set(0,'defaulttextInterpreter','latex')

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

% figure
% hold on
% for i = 1:length(alpha)
%     plot(eig(As(:,:,i)),'ro')
% end
% xlim([-1,1])
% ylim([-3,3])
% grid on

%% b
eps = 0:0.01:1;
modEig = zeros(length(eps),length(alpha),2);
epsUnstable = 0;
alphaUnstable = 0;
found = 0;

for p = 1:length(eps)
    for q = 1:length(alpha)
        Ab = expm(alpha(q)*eps(p)*A2) * expm((1-alpha(q))*eps(p)*A1);
        eigAb = eig(Ab);
        modEig(p,q,1) = abs(eigAb(1));
        modEig(p,q,2) = abs(eigAb(2));
    
        if modEig(p,q,1) > 1 || modEig(p,q,2) > 1
            epsUnstable = eps(p);
            alphaUnstable = alpha(q);
            found = 1;
            break;
        end
    end
    if found == 1, break; end
end

modEigPlot = zeros(length(eps),2);
if epsUnstable ~= 0 && alphaUnstable ~= 0
    for p = 1:length(eps)
        Ab = expm(alphaUnstable*eps(p)*A2) * expm((1-alphaUnstable)*eps(p)*A1);
        eigAb = eig(Ab);
        modEigPlot(p,1) = abs(eigAb(1));
        modEigPlot(p,2) = abs(eigAb(2));
    end
end

figure; hold on
plot(eps,modEigPlot(:,1),'color',[0.9 0.1 0.1],'LineWidth',1.2)
plot(eps,modEigPlot(:,2),'--','color',[0.05 0.7 0.05],'LineWidth',1.2)
grid on
xlim([0 1])
ylim([0 3.5])
legend('$|\lambda_1|$','$|\lambda_2|$','interpreter','latex','location','northwest')
xlabel('Periodic switching time $\varepsilon$ [time unit]')
ylabel('Modulus of eigenvalues $\lambda_i$ [-]')

%% c
tau1 = 0:0.01:1.5;
tau2 = 0:0.01:1.5;

stabAk = zeros(length(tau1),length(tau2),1);
for p = 1:length(tau1)
    for q = 1:length(tau2)
        Ak = expm(A2*tau2(q)) * expm(A1*tau1(p));
        eigAk = eig(Ak);
        if abs(eigAk(1)) < 1 && abs(eigAk(2)) < 1
            stabAk(p,q,:) = 1; % Schur stable
        else
            stabAk(p,q,:) = 0; % unstable
        end
    end
end

% Plot
map = [0.9 0.1 0.1; 0.05 0.7 0.05];

[Tau1, Tau2] = meshgrid(tau1, tau2);
figure
scatter(Tau1(:),Tau2(:),10,stabAk(:),'filled')
colormap(map)
colorbar('Ticks',[0 0.25 0.5 0.75 1],'TickLabels',{'','Unstable','','Stable'.''},'TickLabelInterpreter','latex')
xlabel('Time in mode 1 $\tau_1$ [time units]')
ylabel('Time in mode 2 $\tau_2$ [time units]')
xlim([0 1.5])
ylim([0 1.5])

