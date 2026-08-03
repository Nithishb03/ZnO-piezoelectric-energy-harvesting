%% ==== 1. Distance matrix (8×8) ====
D = [
0.000000 1.978896 3.208455 1.973016 5.205709 4.945495 3.208455 7.178725;
1.978896 0.000000 1.973016 3.208455 6.129678 5.205709 3.232693 8.030753;
3.208455 1.973016 0.000000 4.945495 8.030753 7.178725 5.205709 9.959851;
1.973016 3.208455 4.945495 0.000000 3.232693 3.208455 1.978896 5.205709;
5.205709 6.129678 8.030753 3.232693 0.000000 1.978896 3.208455 1.973016;
4.945495 5.205709 7.178725 3.208455 1.978896 0.000000 1.973016 3.208455;
3.208455 3.232693 5.205709 1.978896 3.208455 1.973016 0.000000 4.945495;
7.178725 8.030753 9.959851 5.205709 1.973016 3.208455 4.945495 0.000000];

% Atom labels in order (from your log): Zn O Zn O Zn O Zn O
atomLabels = {'Zn1','O2','Zn3','O4','Zn5','O6','Zn7','O8'};
n = size(D,1);

%% ==== 2. Input-orientation coordinates (Å) ====
coords = [ ...
0.000000  1.875989  2.602855;   % 1 Zn
1.624654  0.937994  1.973016;   % 2 O
1.624654  0.937994  0.000000;   % 3 Zn
0.000000  1.875989  4.575870;   % 4 O
0.000000  1.875989  7.808564;   % 5 Zn
1.624654  0.937994  7.178725;   % 6 O
1.624654  0.937994  5.205709;   % 7 Zn
0.000000  1.875989  9.781579];  % 8 O

%% ==== 3. Prepare figure with three panels ====
figure('Color','w');
tl = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

%% --- Panel 1: Distance-matrix heatmap ---
nexttile(tl,[1 1]);   % big tile
imagesc(D);
axis equal tight;
colormap('turbo');    % nice smooth colormap
colorbar;
xlabel('Atom index'); ylabel('Atom index');
title('ZnO Distance Matrix (Å)');

set(gca,'XTick',1:n,'XTickLabel',atomLabels,...
        'YTick',1:n,'YTickLabel',atomLabels,...
        'TickLabelInterpreter','none','FontSize',9);

% overlay numerical values
for i = 1:n
    for j = 1:n
        text(j,i,sprintf('%.2f',D(i,j)),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','middle',...
            'Color','w','FontSize',7,'FontWeight','bold');
    end
end

% focus colour scale on 0–10 Å
clim([0 10]);

%% --- Panel 2: Histogram of distances ---
nexttile(tl);
% take only upper triangle without zeros
upperIdx = triu(true(n),1);
allD = D(upperIdx);
histogram(allD,10);
xlabel('Distance (Å)');
ylabel('Count');
title('Distribution of Inter-atomic Distances');
grid on;

%% --- Panel 3: 3D structure with bonds ---
nexttile(tl);
hold on;

% split Zn and O for colouring
isZn = contains(atomLabels,'Zn');
isO  = contains(atomLabels,'O');

% plot atoms
scatter3(coords(isZn,1),coords(isZn,2),coords(isZn,3),80,'b','filled');
scatter3(coords(isO,1), coords(isO,2), coords(isO,3), 80,'r','filled');

% draw bonds for "short" distances (e.g. < 2.1 Å ≈ Zn–O)
bondCutoff = 2.1;
for i = 1:n
    for j = i+1:n
        if D(i,j) > 0 && D(i,j) < bondCutoff
            plot3(coords([i j],1),coords([i j],2),coords([i j],3),...
                  '-k','LineWidth',1.5);
        end
    end
end

xlabel('X (Å)'); ylabel('Y (Å)'); zlabel('Z (Å)');
title('3D ZnO Fragment (DFT geometry)');
legend({'Zn','O','Zn–O bond'},'Location','bestoutside');
axis equal;
grid on;
view(45,25);

%% Optional: save high-resolution figure
% exportgraphics(gcf,'ZnO_visualization.png','Resolution',300);
