clc; clear; close all;

% Standard orientation coordinates
coords = [
0.937994   -1.716799    0.000000
-0.937994  -2.346638    0.000000
-0.937994  -4.319653    0.000000
0.937994    0.256217    0.000000
0.937994    3.488910    0.000000
-0.937994   2.859071    0.000000
-0.937994   0.886056    0.000000
0.937994    5.461926    0.000000
];

% Atom labels
elem = {'Zn','O','Zn','O','Zn','O','Zn','O'};

% Colors for elements
colors = containers.Map({'Zn','O'}, {[0 0 1], [1 0 0]}); % Blue = Zn, Red = O

figure; hold on; grid on;

% Plot atoms
for i = 1:length(elem)
    scatter3(coords(i,1), coords(i,2), coords(i,3), 200, colors(elem{i}), 'filled');
    text(coords(i,1), coords(i,2), coords(i,3), sprintf(' %s%d', elem{i}, i), ...
        'FontSize',12,'FontWeight','bold','Color','k');
end

% Draw bonds based on realistic threshold
maxBond = 2.2; % Å (Zn–O bond length)
n = size(coords,1);

for i = 1:n
    for j = i+1:n
        d = norm(coords(i,:) - coords(j,:));
        if d < maxBond && ~strcmp(elem{i}, elem{j})   % FIXED LOGIC
            plot3([coords(i,1), coords(j,1)], ...
                  [coords(i,2), coords(j,2)], ...
                  [coords(i,3), coords(j,3)], ...
                  'k-', 'LineWidth', 2);
        end
    end
end

xlabel('X (Å)');
ylabel('Y (Å)');
zlabel('Z (Å)');
title('3D Structure of ZnO (Gaussian Output - Standard Orientation)');
axis equal;
view(45,20);
