clc; clear; close all;

%% ===================== DIPOLE MOMENT =====================
dipole = [4.7908, 13.8348, 0.0000];

figure('Color','k','Position',[100 100 1200 900]);
subplot(2,2,1)
quiver3(0,0,0,dipole(1),dipole(2),dipole(3),...
    'LineWidth',3,'Color','c','MaxHeadSize',2);
grid on; axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Dipole Moment Vector','Color','w');
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w');

%% ===================== QUADRUPOLE MOMENT =====================
Q = [ -3.6482  -8.1199   0;
      -8.1199  -5.9143   0;
       0        0        9.5624 ];

subplot(2,2,2)
[evec,eval] = eig(Q);
[X,Y,Z] = ellipsoid(0,0,0,eval(1,1),eval(2,2),eval(3,3),40);
surf(X,Y,Z,'FaceAlpha',0.7,'EdgeColor','none');
colormap parula
lighting phong; camlight
title('Quadrupole Tensor Ellipsoid','Color','w');
axis equal
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w');

%% ===================== OCTAPOLE MOMENT =====================
% Directional intensity approximation
subplot(2,2,3)

theta = linspace(0,pi,60);
phi   = linspace(0,2*pi,60);
[TH,PH] = meshgrid(theta,phi);

R = abs( ...
    64.8268*sin(TH).^3.*cos(PH).^3 + ...
    366.6718*sin(TH).^3.*sin(PH).^3 + ...
    147.9038*sin(TH).*cos(PH).*sin(PH).^2 );

[X,Y,Z] = sph2cart(PH, pi/2-TH, R);

surf(X,Y,Z,R,'EdgeColor','none');
colormap turbo
lighting phong; camlight
axis equal
title('Octapole Moment (3D Anisotropy)','Color','w');
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w');

%% ===================== HEXADECAPOLE MOMENT =====================
subplot(2,2,4)

R4 = abs( ...
   -1017.8992*sin(TH).^4.*cos(PH).^4 + ...
   -4780.5874*sin(TH).^4.*sin(PH).^4 + ...
   -1081.0093*sin(TH).^2.*cos(PH).^2.*sin(PH).^2 );

[X4,Y4,Z4] = sph2cart(PH, pi/2-TH, R4);

surf(X4,Y4,Z4,R4,'EdgeColor','none');
colormap hot
lighting phong; camlight
axis equal
title('Hexadecapole Moment (Higher-Order Tensor)','Color','w');
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w');

sgtitle('3D Multipole Tensor Visualization','Color','w','FontSize',16)