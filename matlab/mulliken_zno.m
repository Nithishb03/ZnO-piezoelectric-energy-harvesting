clc; clear; close all;

% Atom labels and types
atomLabels = {'Zn1','O2','Zn3','O4','Zn5','O6','Zn7','O8'};
elem       = {'Zn','O','Zn','O','Zn','O','Zn','O'};

% Mulliken charges
q = [ 0.689735, -0.685269, 0.447080, -0.736880, ...
      0.702446, -0.683498, 0.713230, -0.446844 ];

nAtoms = numel(q);

colZn = [0 0.2 0.9];
colO  = [0.9 0 0];

figure('Color','w','Position',[200 200 700 400]);
b = bar(q,'FaceColor','flat');
grid on; hold on;

for i = 1:nAtoms
    if strcmp(elem{i},'Zn')
        b.CData(i,:) = colZn;
    else
        b.CData(i,:) = colO;
    end
end

set(gca,'XTick',1:nAtoms,'XTickLabel',atomLabels,'FontSize',11);
xlabel('Atom','FontSize',12);
ylabel('Mulliken Charge (e^-)','FontSize',12);
title('Mulliken Charge Distribution in ZnO Cluster','FontSize',14);
yline(0,'k--','LineWidth',1);

% Optional: save
% exportgraphics(gcf,'ZnO_mulliken_charges.png','Resolution',300);
