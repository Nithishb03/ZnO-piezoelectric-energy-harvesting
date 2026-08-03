clc; clear; close all;

%% ===== ATOMIC DATA FROM GAUSSIAN (STANDARD ORIENTATION) =====
% [AtomNumber, AtomicNumber, X, Y, Z]
atoms = [
    1 30 -0.963346 -1.622504  0.000000;
    2  8  0.912643 -2.252343  0.000000;
    3 30  0.912643 -4.225359  0.000000;
    4  8 -0.963346  0.350512  0.000000;
    5 26 -0.963346  3.583205  0.000000;
    6  8  0.912643  2.953366  0.000000;
    7 30  0.912643  0.980350  0.000000;
    8  8 -0.963346  5.556221  0.000000;
];

coords = atoms(:,3:5);
Z = atoms(:,2);

%% ===== COLOR & SIZE DEFINITIONS =====
colors = zeros(length(Z),3);
sizes  = zeros(length(Z),1);

for i = 1:length(Z)
    switch Z(i)
        case 30  % Zn
            colors(i,:) = [0.1 0.3 0.9]; % blue
            sizes(i) = 120;
        case 8   % O
            colors(i,:) = [0.9 0.1 0.1]; % red
            sizes(i) = 90;
        case 26  % Fe
            colors(i,:) = [0.1 0.8 0.1]; % green
            sizes(i) = 140;
    end
end

%% ===== BOND DETECTION =====
bond_threshold = 2.2; % Å (Zn–O / Fe–O range)
bonds = [];

for i = 1:size(coords,1)
    for j = i+1:size(coords,1)
        d = norm(coords(i,:) - coords(j,:));
        if d < bond_threshold
            bonds = [bonds; i j];
        end
    end
end

%% ===== 3D VISUALIZATION =====
figure('Color','w','Position',[100 100 900 700]);
hold on; grid on;

% Plot atoms
scatter3(coords(:,1), coords(:,2), coords(:,3), ...
         sizes, colors, 'filled');

% Plot bonds
for k = 1:size(bonds,1)
    i = bonds(k,1);
    j = bonds(k,2);
    plot3([coords(i,1), coords(j,1)], ...
          [coords(i,2), coords(j,2)], ...
          [coords(i,3), coords(j,3)], ...
          'k-', 'LineWidth', 2);
end

% Labels
for i = 1:length(Z)
    if Z(i)==30
        lbl = 'Zn';
    elseif Z(i)==8
        lbl = 'O';
    else
        lbl = 'Fe';
    end
    text(coords(i,1)+0.1, coords(i,2)+0.1, coords(i,3), ...
         sprintf('%s%d',lbl,i), 'FontSize',10);
end

%% ===== VIEW SETTINGS =====
axis equal
xlabel('X (Å)','FontSize',12);
ylabel('Y (Å)','FontSize',12);
zlabel('Z (Å)','FontSize',12);
title('3D Structure of Fe-Doped ZnO (Gaussian Standard Orientation)','FontSize',14)

view(45,25);
camlight headlight
lighting gouraud
rotate3d on
hold off;