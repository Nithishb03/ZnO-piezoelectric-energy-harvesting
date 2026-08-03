%% ==========================================================
%  3D Multipole Tensor Visualization (Gaussian Output)
%  Dipole | Quadrupole | Octapole | Hexadecapole
% ==========================================================

clear; clc; close all;

figure('Color','k','Position',[100 100 1400 900]);

%% ===================== 1. DIPOLE MOMENT =====================
subplot(2,2,1)
hold on; axis equal; grid on;
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w')

dipole = [-1.5465, -10.8824, 0.0]; % Debye

quiver3(0,0,0, dipole(1),dipole(2),dipole(3), ...
    'LineWidth',3,'Color','c','MaxHeadSize',0.6);

scatter3(0,0,0,60,'w','filled')

xlabel('X'); ylabel('Y'); zlabel('Z');
title('Dipole Moment Vector','Color','w','FontSize',14)

view(35,25)
camlight headlight
lighting gouraud
hold off

%% ===================== 2. QUADRUPOLE =====================
subplot(2,2,2)
hold on; axis equal off
set(gca,'Color','k')

Q = [-71.4037   -0.0835     0;
     -0.0835  -109.5668    0;
      0         0        -74.9540];

[evec, evals] = eig(Q);
[a,b,c] = deal(abs(evals(1,1)),abs(evals(2,2)),abs(evals(3,3)));

[x,y,z] = ellipsoid(0,0,0,a,b,c,60);
surf(x,y,z,'FaceAlpha',0.9,'EdgeColor','none')
colormap(gca,hot)

rotate3d on
title('Quadrupole Tensor Ellipsoid','Color','w','FontSize',14)

camlight right
lighting phong
hold off

%% ===================== 3. OCTAPOLE =====================
subplot(2,2,3)
hold on; axis equal off
set(gca,'Color','k')

[X,Y,Z] = sphere(80);

O = ...
    5.3880*X.^3 ...
  -417.3494*Y.^3 ...
  +6.3355*X.*Y.^2 ...
  -30.6007*X.^2.*Y;

surf(X.*O,Y.*O,Z.*O, ...
    'EdgeColor','none','FaceAlpha',0.85)

colormap(gca,autumn)
rotate3d on
title('Octapole Moment (3D Anisotropy)','Color','w','FontSize',14)

camlight left
lighting phong
hold off

%% ===================== 4. HEXADECAPOLE =====================
subplot(2,2,4)
hold on; axis equal off
set(gca,'Color','k')

H = ...
   -466.9314*X.^4 ...
  -6090.8533*Y.^4 ...
  -820.9691*X.^2.*Y.^2 ...
  +284.3957*X.^3.*Y;

surf(X.*H,Y.*H,Z.*H, ...
    'EdgeColor','none','FaceAlpha',0.9)

colormap(gca,parula)
rotate3d on
title('Hexadecapole Moment (Higher-Order Tensor)','Color','w','FontSize',14)

camlight right
lighting phong
hold off

%% ===================== FINAL TITLE =====================
sgtitle('3D Multipole Tensor Visualization','Color','w','FontSize',18,'FontWeight','bold');

disp('✔ Multipole tensor visualization completed successfully')