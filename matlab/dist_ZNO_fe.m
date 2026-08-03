%% ==========================================================
%  Fe-Doped ZnO – Unified Structural Visualization
%  Distance Matrix + Histogram + 3D Geometry
%  Units: Angstrom
%% ==========================================================

clear; clc; close all;

%% ---------------- ATOMIC DATA ----------------
atoms = {'Zn','O','Zn','O','Fe','O','Zn','O'};
Z = [30 8 30 8 26 8 30 8];

coords = [
    0.000000   1.875989   2.602855;
    1.624654   0.937994   1.973016;
    1.624654   0.937994   0.000000;
    0.000000   1.875989   4.575870;
    0.000000   1.875989   7.808564;
    1.624654   0.937994   7.178725;
    1.624654   0.937994   5.205709;
    0.000000   1.875989   9.781579
];

N = size(coords,1);

%% ---------------- DISTANCE MATRIX ----------------
D = zeros(N);
for i = 1:N
    for j = 1:N
        D(i,j) = norm(coords(i,:) - coords(j,:));
    end
end

distVals = D(triu(true(N),1));

%% ==========================================================
%  COMBINED FIGURE
%% ==========================================================
figure('Color','w','Position',[50 50 1400 600]);

%% -------- SUBPLOT 1: Distance Matrix --------
subplot(1,3,1)
imagesc(D);
colormap(turbo);
colorbar;
title('Distance Matrix (Å)','FontSize',14,'FontWeight','bold');
xlabel('Atom Index'); ylabel('Atom Index');
set(gca,'XTick',1:N,'YTick',1:N,...
    'XTickLabel',atoms,'YTickLabel',atoms,'FontSize',11);
axis square;

textStrings = string(round(D,2));
textStrings(D==0) = "";
[x,y] = meshgrid(1:N);
text(x(:),y(:),textStrings(:),...
    'HorizontalAlignment','center','Color','w','FontSize',9);

%% -------- SUBPLOT 2: Distance Distribution --------
subplot(1,3,2)
histogram(distVals,12,...
    'FaceColor',[0.2 0.6 0.8],...
    'EdgeColor','k','LineWidth',1.2);
xlabel('Distance (Å)','FontSize',12);
ylabel('Count','FontSize',12);
title('Inter-Atomic Distance Distribution',...
      'FontSize',14,'FontWeight','bold');
grid on;

%% -------- SUBPLOT 3: 3D Structure --------
subplot(1,3,3)
hold on; axis equal; grid on;

% Colors
colZn = [0.2 0.4 1.0];
colO  = [1.0 0.2 0.2];
colFe = [0.9 0.5 0.1];

for i = 1:N
    if Z(i) == 30
        scatter3(coords(i,1),coords(i,2),coords(i,3),120,colZn,'filled');
    elseif Z(i) == 8
        scatter3(coords(i,1),coords(i,2),coords(i,3),120,colO,'filled');
    else
        scatter3(coords(i,1),coords(i,2),coords(i,3),160,colFe,'filled');
    end
end

% Bonds
bondThresh = 2.2;
for i = 1:N
    for j = i+1:N
        if D(i,j) < bondThresh
            plot3([coords(i,1) coords(j,1)],...
                  [coords(i,2) coords(j,2)],...
                  [coords(i,3) coords(j,3)],...
                  'k','LineWidth',1.6);
        end
    end
end

xlabel('X (Å)'); ylabel('Y (Å)'); zlabel('Z (Å)');
title('3D Fe-Doped ZnO Geometry','FontSize',14,'FontWeight','bold');

view(35,25);
lighting gouraud;
camlight headlight;

legend({'Zn','O','Fe'},'Location','northeastoutside');
hold off;

%% ==========================================================
disp('✔ Unified Fe-Doped ZnO Visualization Completed');