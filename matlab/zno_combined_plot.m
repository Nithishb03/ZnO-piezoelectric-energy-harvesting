clc; clear; close all;

%% === DATA FROM GAUSSIAN OUTPUT ===

% Atom labels and types
atomLabels = {'Zn1','O2','Zn3','O4','Zn5','O6','Zn7','O8'};
elem       = {'Zn','O','Zn','O','Zn','O','Zn','O'};

% Standard orientation coordinates (Angstroms)
coords = [ ...
   0.937994  -1.716799   0.000000 ;  % 1 Zn
  -0.937994  -2.346638   0.000000 ;  % 2 O
  -0.937994  -4.319653   0.000000 ;  % 3 Zn
   0.937994   0.256217   0.000000 ;  % 4 O
   0.937994   3.488910   0.000000 ;  % 5 Zn
  -0.937994   2.859071   0.000000 ;  % 6 O
  -0.937994   0.886056   0.000000 ;  % 7 Zn
   0.937994   5.461926   0.000000 ]; % 8 O

nAtoms = size(coords,1);

% Mulliken charges
q = [ 0.689735, -0.685269, 0.447080, -0.736880, ...
      0.702446, -0.683498, 0.713230, -0.446844 ];

% HOMO / LUMO eigenvalues (Hartree) from your log
HOMO = -0.20747;
LUMO = -0.19459;
hartree_to_eV = 27.2114;
gap_eV = (LUMO - HOMO) * hartree_to_eV;

% Dipole moment components (Debye)
dipole = [ 1.5529, -13.3566, 0.0 ];  % X, Y, Z
dipole_mag = norm(dipole);

% Colors
colZn = [0 0.2 0.9];
colO  = [0.9 0 0];

%% === FIGURE LAYOUT ===
figure('Color','w','Position',[100 100 1100 800]);
tl = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

%% === PANEL 1: 3D STRUCTURE + BONDS + DIPOLE (LEFT, BIG) ===
nexttile(tl,[2 1]);   % big tile on left
hold on; grid on;

% Plot atoms
for i = 1:nAtoms
    if strcmp(elem{i},'Zn')
        c = colZn; s = 180;
    else
        c = colO;  s = 140;
    end
    scatter3(coords(i,1),coords(i,2),coords(i,3), ...
             s,'filled','MarkerFaceColor',c,'MarkerEdgeColor','k');
    text(coords(i,1),coords(i,2),coords(i,3)+0.20, ...
         atomLabels{i},'HorizontalAlignment','center', ...
         'FontSize',9,'FontWeight','bold');
end

% Draw Zn–O bonds based on distance threshold
maxBond = 2.2;  % Å (typical Zn–O bond length ~1.9–2.0)
for i = 1:nAtoms
    for j = i+1:nAtoms
        d = norm(coords(i,:) - coords(j,:));
        if d < maxBond && ~strcmp(elem{i}, elem{j})
            plot3([coords(i,1) coords(j,1)], ...
                  [coords(i,2) coords(j,2)], ...
                  [coords(i,3) coords(j,3)], ...
                  'k-','LineWidth',2);
        end
    end
end

% Draw dipole arrow (scaled) from geometric center
center  = mean(coords,1);
if dipole_mag < 1e-8
    dip_dir = [0 1 0];  % avoid division by zero (not your case)
else
    dip_dir = dipole / dipole_mag;
end
scale   = 3.0;
quiver3(center(1),center(2),center(3), ...
        dip_dir(1)*scale, dip_dir(2)*scale, dip_dir(3)*scale, ...
        'LineWidth',2.5,'Color',[0 0.6 0],'MaxHeadSize',0.7);

% Dipole text
text(center(1),center(2)-1.0,center(3)+0.2, ...
     sprintf('Dipole = %.2f D', dipole_mag), ...
     'Color',[0 0.6 0],'FontWeight','bold','FontSize',11);

xlabel('X (Å)');
ylabel('Y (Å)');
zlabel('Z (Å)');
title('ZnO Cluster – 3D Structure, Bonds & Dipole','FontSize',12);
axis equal;
view(45,25);

%% === PANEL 2: MULLIKEN CHARGE BAR PLOT (TOP-RIGHT) ===
nexttile(tl,2);
b = bar(q,'FaceColor','flat');
grid on; hold on;

for i = 1:nAtoms
    if strcmp(elem{i},'Zn')
        b.CData(i,:) = colZn;
    else
        b.CData(i,:) = colO;
    end
end

set(gca,'XTick',1:nAtoms,'XTickLabel',atomLabels,'FontSize',10);
xlabel('Atom','FontSize',11);
ylabel('Mulliken Charge (e^-)','FontSize',11);
title('Mulliken Charge Distribution','FontSize',12);
yline(0,'k--','LineWidth',1);

%% === PANEL 3: HOMO–LUMO ENERGY DIAGRAM (BOTTOM-RIGHT) ===
nexttile(tl,4);
hold on; grid on;

% Plot HOMO and LUMO as horizontal segments
xH = [1 2];
plot(xH, [HOMO HOMO],'LineWidth',3,'Color',colZn);   % blue-ish for HOMO
plot(xH, [LUMO LUMO],'LineWidth',3,'Color',colO);    % red for LUMO

% Annotate HOMO/LUMO
text(1.5, HOMO+0.001, 'HOMO', ...
     'HorizontalAlignment','center','VerticalAlignment','bottom', ...
     'FontWeight','bold','Color',colZn);
text(1.5, LUMO+0.001, 'LUMO', ...
     'HorizontalAlignment','center','VerticalAlignment','bottom', ...
     'FontWeight','bold','Color',colO);

% Show band gap
midY = (HOMO + LUMO)/2;
text(2.25, midY, sprintf('Gap = %.2f eV', gap_eV), ...
     'FontSize',11,'FontWeight','bold','Color',[0.2 0.2 0.2]);

ylim([HOMO-0.05, LUMO+0.05]);
xlim([0.5 2.8]);
set(gca,'XTick',[]);
ylabel('Energy (Hartree)','FontSize',11);
title('HOMO–LUMO Energy Levels','FontSize',12);

%% === OVERALL TITLE ===
title(tl,'DFT Analysis of ZnO Cluster: Structure, Charges, and Energy Levels', ...
      'FontSize',14,'FontWeight','bold');

% Optional: save high resolution
% exportgraphics(gcf,'ZnO_combined_analysis.png','Resolution',300);
