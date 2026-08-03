%% ============================================================
% Fe-Doped ZnO Cluster – Combined Electronic Structure Analysis
% Gaussian Output Based Visualization
% ============================================================

clear; clc; close all;

%% ---------------- ATOMIC STRUCTURE ----------------
atoms = {'Zn1','O2','Zn3','O4','Fe5','O6','Zn7','O8'};
Znum  = [30 8 30 8 26 8 30 8];

coords = [
 -0.963346  -1.622504   0.000000;
  0.912643  -2.252343   0.000000;
  0.912643  -4.225359   0.000000;
 -0.963346   0.350512   0.000000;
 -0.963346   3.583205   0.000000;
  0.912643   2.953366   0.000000;
  0.912643   0.980350   0.000000;
 -0.963346   5.556221   0.000000
];

%% ---------------- MULLIKEN CHARGES ----------------
charges = [ ...
  0.533170
 -0.836745
  0.517950
 -0.772180
  0.759643
 -0.723586
  0.908983
 -0.387235
];

%% ---------------- HOMO–LUMO DATA ----------------
HOMO = -0.21755;   % Hartree
LUMO = -0.12631;   % Hartree
gap_eV = (LUMO - HOMO) * 27.2114;

%% ---------------- DIPOLE MOMENT ----------------
dipole = [-1.5465  -10.8824  0.0];  % Debye

%% ============================================================
% COMBINED FIGURE
% ============================================================
figure('Color','w','Position',[100 100 1400 900]);

%% ============================================================
% SUBPLOT 1: 3D STRUCTURE + BONDS + DIPOLE
% ============================================================
subplot(2,2,[1 3]);
hold on; axis equal; grid on;

colZn = [0.2 0.4 1];
colO  = [1 0.2 0.2];
colFe = [0.9 0.5 0.1];

for i = 1:length(Znum)
    if Znum(i) == 30
        scatter3(coords(i,1),coords(i,2),coords(i,3),120,colZn,'filled');
    elseif Znum(i) == 8
        scatter3(coords(i,1),coords(i,2),coords(i,3),120,colO,'filled');
    else
        scatter3(coords(i,1),coords(i,2),coords(i,3),160,colFe,'filled');
    end
    text(coords(i,1),coords(i,2),coords(i,3),atoms{i},'FontSize',9);
end

% Bonds
for i = 1:8
    for j = i+1:8
        if norm(coords(i,:) - coords(j,:)) < 2.2
            plot3([coords(i,1) coords(j,1)], ...
                  [coords(i,2) coords(j,2)], ...
                  [coords(i,3) coords(j,3)], 'k','LineWidth',1.6);
        end
    end
end

% Dipole vector
quiver3(0,0,0,dipole(1),dipole(2),dipole(3),...
        'LineWidth',3,'Color','g','MaxHeadSize',1);
text(dipole(1),dipole(2),dipole(3), ...
     sprintf('Dipole = %.2f D',norm(dipole)),...
     'Color','g','FontWeight','bold');

xlabel('X (Å)'); ylabel('Y (Å)'); zlabel('Z (Å)');
title('Fe-Doped ZnO – 3D Structure, Bonds & Dipole','FontWeight','bold');
view(35,25);
lighting gouraud; camlight headlight;
hold off;

%% ============================================================
% SUBPLOT 2: MULLIKEN CHARGE DISTRIBUTION
% ============================================================
subplot(2,2,2);
bar(charges,'LineWidth',1.2);
colormap([0 0.3 0.9; 0.9 0 0]);
grid on;

xticks(1:8); xticklabels(atoms);
ylabel('Mulliken Charge (e)');
title('Mulliken Charge Distribution','FontWeight','bold');
yline(0,'k--');

%% ============================================================
% SUBPLOT 3: HOMO–LUMO ENERGY LEVELS
% ============================================================
subplot(2,2,4);
hold on;

plot([0 1],[HOMO HOMO],'b','LineWidth',4);
plot([0 1],[LUMO LUMO],'r','LineWidth',4);

text(1.05,HOMO,'HOMO','Color','b','FontWeight','bold');
text(1.05,LUMO,'LUMO','Color','r','FontWeight','bold');

text(0.2,(HOMO+LUMO)/2, ...
     sprintf('Gap = %.2f eV',gap_eV),...
     'FontSize',12,'FontWeight','bold');

xlim([-0.2 1.6]);
ylim([HOMO-0.05 LUMO+0.05]);
ylabel('Energy (Hartree)');
set(gca,'XTick',[]);
grid on;
title('HOMO–LUMO Energy Levels','FontWeight','bold');
hold off;

%% ============================================================
disp('✔ Combined Fe-Doped ZnO Electronic Structure Visualization Complete');