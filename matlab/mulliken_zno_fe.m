%% ==========================================================
%  Mulliken Charge Analysis – Fe-Doped ZnO
%  Single Professional Figure
% ==========================================================

clear; clc; close all;

%% ---------------- INPUT DATA ----------------
atoms = {'Zn1','O2','Zn3','O4','Fe5','O6','Zn7','O8'};
elements = {'Zn','O','Zn','O','Fe','O','Zn','O'};

charges = [ ...
     0.684834;
    -0.694234;
     0.394817;
    -0.748457;
     0.783360;
    -0.696242;
     0.766213;
    -0.490290 ];

N = numel(charges);

%% ---------------- COLORS ----------------
colZn = [0.1 0.3 0.9];
colO  = [0.9 0.1 0.1];
colFe = [0.95 0.6 0.1];

barColors = zeros(N,3);
for i = 1:N
    if strcmp(elements{i},'Zn')
        barColors(i,:) = colZn;
    elseif strcmp(elements{i},'O')
        barColors(i,:) = colO;
    else
        barColors(i,:) = colFe;
    end
end

%% ==========================================================
%  SINGLE FIGURE WITH MULTIPLE PANELS
% ==========================================================
figure('Color','w','Position',[100 100 1400 800]);

tiledlayout(2,2,'Padding','compact','TileSpacing','compact');

%% ==========================================================
%  PANEL 1: Mulliken Charge Bar Plot
% ==========================================================
nexttile;
b = bar(charges,'FaceColor','flat','LineWidth',1.2);
b.CData = barColors;

yline(0,'k--','LineWidth',1.2);

set(gca,'XTick',1:N,'XTickLabel',atoms,'FontSize',11);
ylabel('Mulliken Charge (e)','FontSize',13);
title('Mulliken Charge Distribution','FontSize',15,'FontWeight','bold');

grid on;

for i = 1:N
    text(i,charges(i)+0.05*sign(charges(i)),...
        sprintf('%.2f',charges(i)),...
        'HorizontalAlignment','center',...
        'FontSize',10,'FontWeight','bold');
end

%% ==========================================================
%  PANEL 2: Charge Magnitude Histogram
% ==========================================================
nexttile;
histogram(charges,8,...
    'FaceColor',[0.2 0.6 0.8],...
    'EdgeColor','k','LineWidth',1.2);

xlabel('Charge (e)','FontSize',13);
ylabel('Count','FontSize',13);
title('Charge Distribution Histogram','FontSize',15,'FontWeight','bold');
grid on;

%% ==========================================================
%  PANEL 3: Charge vs Atom Index
% ==========================================================
nexttile;
plot(1:N,charges,'o-','LineWidth',2,...
     'MarkerSize',8,'MarkerFaceColor','k');

yline(0,'k--','LineWidth',1.2);
set(gca,'XTick',1:N,'XTickLabel',atoms,'FontSize',11);

xlabel('Atom Index','FontSize',13);
ylabel('Mulliken Charge (e)','FontSize',13);
title('Charge Trend Across Cluster','FontSize',15,'FontWeight','bold');

grid on;

%% ==========================================================
%  PANEL 4: Element-wise Charge Summary
% ==========================================================
nexttile;

Zn_charge = charges(strcmp(elements,'Zn'));
O_charge  = charges(strcmp(elements,'O'));
Fe_charge = charges(strcmp(elements,'Fe'));

means = [mean(Zn_charge), mean(O_charge), mean(Fe_charge)];

bar(means,'FaceColor','flat','LineWidth',1.5);
set(gca,'XTick',1:3,'XTickLabel',{'Zn','O','Fe'},'FontSize',12);

colset = [colZn; colO; colFe];
for i = 1:3
    barColors2(i,:) = colset(i,:);
end
set(gca,'ColorOrder',barColors2,'NextPlot','replacechildren');

ylabel('Average Mulliken Charge (e)','FontSize',13);
title('Average Charge by Element','FontSize',15,'FontWeight','bold');
grid on;

%% ==========================================================
sgtitle('Mulliken Charge Analysis – Fe-Doped ZnO Cluster',...
        'FontSize',18,'FontWeight','bold');

disp('✔ Mulliken charge visualization completed');