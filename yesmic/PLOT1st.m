close all;
clc;

a = -45e-5; b = 5e-5;     % x bounds
c = -5e-5; d = 5e-5;      % y bounds
e = -5e-5; f = 5e-5;        % z bounds
aE = 3.5e-5;  % radii for ellipsoid-shaped head
bE = 3e-5;
cE = 3e-5;
%n = 2; m = 5; l = 5;      % x, y, z increment for plotting or '(n+1)*(m+1)*(l+1)' points
n = 15; m = 2; l = 15;
Nr = 30;     % Nr number of points on tail
micnum = 20;    %'micnum+1' number of microvilli
micincr = 0.2;  %increment of microvilli segments or '0.8/micincr+1' points
lamlen = 0.8;

ptnum = 4;  %number of points plotted around the center point at each angle
r = 2.5e-6;   %radius of the spherical particle
points = 3; %number of points


track1 = [];
track2 = [];
track3 = [];
    
    
fidField = fopen('Field.txt', 'r');
%fidField1 = fopen('Field1.txt', 'r');
%fidField2 = fopen('Field2.txt', 'r');
%fidField3 = fopen('Field3.txt', 'r');
fidXtail = fopen('Xtail.txt', 'r');
fidNXmic1 = fopen('NXmic1.txt', 'r');
fidNXmic2 = fopen('NXmic2.txt', 'r');
fidNXmic3 = fopen('NXmic3.txt', 'r');
fidNring = fopen('Nring.txt', 'r');
fidParticles = fopen('Particles.txt', 'r');
    
%fig=figure;
%aviobj = avifile('yesmic3plane.avi');

for i = 1:50
    %FIELD
    Fieldtemp = fscanf(fidField, '%f', [(n+1)*(m+1)*(l+1), 6]);
    %Fieldtemp1 = fscanf(fidField1, '%f', [(n+1)*(m+1)*(l+1), 6]);
    %Fieldtemp2 = fscanf(fidField2, '%f', [(n+1)*(m+1)*(l+1), 6]);
    %Fieldtemp3 = fscanf(fidField3, '%f', [(n+1)*(m+1)*(l+1), 6]);
    quiver3(Fieldtemp(:,1), Fieldtemp(:,2), Fieldtemp(:,3), Fieldtemp(:,4), Fieldtemp(:,5), Fieldtemp(:,6), 'autoscalefactor', 2, 'color', 'b');
    hold on;
    %quiver3(Fieldtemp1(:,1), Fieldtemp1(:,2), Fieldtemp1(:,3), Fieldtemp1(:,4), Fieldtemp1(:,5), Fieldtemp1(:,6), 'autoscalefactor', 2, 'color', 'b');
    %hold on;
    %quiver3(Fieldtemp2(:,1), Fieldtemp2(:,2), Fieldtemp2(:,3), Fieldtemp2(:,4), Fieldtemp2(:,5), Fieldtemp2(:,6), 'autoscalefactor', 2, 'color', 'b');
    %hold on;
    %quiver3(Fieldtemp3(:,1), Fieldtemp3(:,2), Fieldtemp3(:,3), Fieldtemp3(:,4), Fieldtemp3(:,5), Fieldtemp3(:,6), 'autoscalefactor', 2, 'color', 'b');
    %hold on;
    
    %TAIL
    Xtailtemp = fscanf(fidXtail, '%f', [Nr, 3]);
    plot3(Xtailtemp(:,1),Xtailtemp(:,2),Xtailtemp(:,3), 'g.-', 'linewidth', 3);
    %hold on;
    
    %MICROVILLI
    NXmic1temp = fscanf(fidNXmic1, '%f', [lamlen/micincr+1, micnum+1]);
    NXmic2temp = fscanf(fidNXmic2, '%f', [lamlen/micincr+1, micnum+1]);
    NXmic3temp = fscanf(fidNXmic3, '%f', [lamlen/micincr+1, micnum+1]);
    plot3(NXmic1temp, NXmic2temp, NXmic3temp, 'c.-', 'linewidth', 3);
    %hold on;
    %PLOT RING
    Nringtemp = fscanf(fidNring, '%f', [micnum+1, 3]);
    plot3(Nringtemp(:,1),Nringtemp(:,2),Nringtemp(:,3), 'g.-', 'linewidth', 1);
    %connect ends of microvilli to ring
    Nring1new = [Nringtemp(:,1)'; NXmic1temp(1,:)];
    Nring2new = [Nringtemp(:,2)'; NXmic2temp(1,:)];
    Nring3new = [Nringtemp(:,3)'; NXmic3temp(1,:)];
    plot3(Nring1new, Nring2new, Nring3new, 'c.-', 'linewidth', 3);
    
    %HEAD
    [xh, yh, zh] = ellipsoid(Xtailtemp(Nr), 0, 0, aE, bE, cE);
    surfl(xh, yh, zh, 'light');
    colormap cool;
    shading flat;
    
    %PLOT PARTICLES
    Particlestemp = fscanf(fidParticles, '%f', [points, 3]);
    track1 = [track1; Particlestemp(1,:)];
    track2 = [track2; Particlestemp(2,:)];
    track3 = [track3; Particlestemp(3,:)];
    plot3(track1(:,1), track1(:,2), track1(:,3), 'r.-', 'linewidth', 1);
    plot3(track2(:,1), track2(:,2), track2(:,3), 'm.-', 'linewidth', 1);
    plot3(track3(:,1), track3(:,2), track3(:,3), 'y.-', 'linewidth', 1); 
    %plot_particle(Particlestemp, r, ptnum);
    
    xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
    axis equal;
    axis([a b c d e f]);
    view(45,25);
    %view(0,90);
    pause(0.01);
    hold off;
    
    %frame = getframe(fig);              % get movie frames
    %aviobj = addframe(aviobj, frame);
    
end
fclose(fidField);
%fclose(fidField1);
%fclose(fidField2);
%fclose(fidField3);
fclose(fidXtail);
fclose(fidNXmic1);
fclose(fidNXmic2);
fclose(fidNXmic3);
fclose(fidNring);
fclose(fidParticles);

%close(fig);                          % close the figure
%aviobj = close(aviobj); 