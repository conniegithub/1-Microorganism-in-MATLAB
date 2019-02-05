clc; clear all;

t = 0;    %set initial time
Dt = 0.000000005; %time step
a = -45e-5; b = 5e-5;     % x bounds
c = -5e-5; d = 5e-5;      % y bounds
e = -5e-5; f = 5e-5;        % z bounds
hv = (a+b)/2; % axis bounds for the plane of velocity field
%n = 2; m = 5; l = 5;      % x, y, z increment for plotting or '(n+1)*(m+1)*(l+1)' points
n = 15; m = 2; l = 15;

mu = 1; % sets mu value
k = 5000;    %spring constant
Ltail = 1e-5;
Lmic = 3.75e-6;   %resting distance, in this case, it is the same between every two consecutive points
ep = Ltail; % sets epsilon value

%TAIL
Nr = 30;     % 'Nr - 1' number of points on tail
N = Nr - 1;     %number of intervals
alpha = 0.9;      %declare constants for the tail functions
beta = 8e-6;
K = sqrt((1-alpha^2)/beta^2);   %to achieve inextensibility
Q = 500;
s = 0;

%MICROVILLI
micnum = 20;    %'micnum+1' number of microvilli
micincr = 0.2;  %increment of microvilli segments or '0.8/micincr+1' points
new = [];

%HEAD
aE = 3.5e-5;  % radii for ellipsoid-shaped head
bE = 3e-5;
cE = 3e-5;

%PARTICLES
particles = [-3e-4 -3e-5 -2e-5;-2e-4 0 1e-5;-2.5e-4 1e-5 -1e-5];
%particles = rand(5,3);
%particles(:,1) = a + particles(:,1)*(b-a);
%particles(:,2) = c + particles(:,2)*(d-c);
%particles(:,3) = e + particles(:,3)*(f-e);

Fi = [0 0 0];     %initial force on head
T = [0 0 0];   %initial torque
% initial tail position matrix, force, and microvillis positions
Xtail = childress_tail(alpha, beta, K, s, Q, t, Ltail, Nr);
Center = [Xtail(Nr,1), 0, 0];
[Nring, NXmic] = initial_mic(aE, bE, cE, Center, micnum, micincr);


%~~~~~~~~~~~~~~~~~WRITE~~~~~TO~~~~~TEXT~~~~~FILES~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fidXtail = fopen('Xtail.txt', 'w');
    fprintf(fidXtail, '%12.10f %12.10f %12.10f\n', Xtail);
fclose(fidXtail);

fidNXmic1 = fopen('NXmic1.txt', 'w');
    fprintf(fidNXmic1, '%12.10f', NXmic(:,:,1));
fclose(fidNXmic1);
fidNXmic2 = fopen('NXmic2.txt', 'w');
    fprintf(fidNXmic2, '%12.10f', NXmic(:,:,2));
fclose(fidNXmic2);
fidNXmic3 = fopen('NXmic3.txt', 'w');
    fprintf(fidNXmic3, '%12.10f', NXmic(:,:,3));
fclose(fidNXmic3);

fidNring = fopen('Nring.txt', 'w');
    fprintf(fidNring, '%12.10f %12.10f %12.10f\n', Nring);
fclose(fidNring);

fidParticles = fopen('Particles.txt', 'w');
    fprintf(fidParticles, '%12.10f %12.10f %12.10f\n', particles);
fclose(fidParticles);

fidField = fopen('Field.txt', 'w');
fclose(fidField);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fidXtail = fopen('Xtail.txt', 'a');
fidNXmic1 = fopen('NXmic1.txt', 'a');
fidNXmic2 = fopen('NXmic2.txt', 'a');
fidNXmic3 = fopen('NXmic3.txt', 'a');
fidNring = fopen('Nring.txt', 'a');
fidParticles = fopen('Particles.txt', 'a');

for timestep = 1:50
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    %get force at current positions
    [prescribedUtail] = get_prescribedU(alpha, beta, K, s, Q, t, Ltail, Nr);   
    NFmic = mic_force(NXmic, Nring, Lmic, k);
    %NFmic = zeros(size(NFmic));
    Ftail = get_force_3d_anyf_mic(ep,mu,Xtail, NXmic, prescribedUtail,NFmic);
    %Ftail = zeros(size(Ftail));
    NUmic = get_Umic(Xtail, Ftail, NXmic, NFmic, ep, mu, T);
    
    %quiv_3d(-4e-4,-4e-4,c,d,e,f,m,n,l,ep,mu,Xtail,Ftail,NXmic,NFmic,T);
    %quiv_3d(-2e-4,-2e-4,c,d,e,f,m,n,l,ep,mu,Xtail,Ftail,NXmic,NFmic,T);
    %quiv_3d(0,0,c,d,e,f,m,n,l,ep,mu,Xtail,Ftail,NXmic,NFmic,T);
    quiv_3d(a,b,0,0,e,f,m,n,l,ep,mu,Xtail,Ftail,NXmic,NFmic,T);
    
    t = t + Dt;
    
    Xtail = childress_tail(alpha, beta, K, s, Q, t, Ltail, Nr);       %get positions for next time step
    NXmic = next_micpos_RK(Xtail, Ftail, NXmic, NFmic, ep, mu, T, Dt);
    Center = [Xtail(Nr,1), 0, 0];    %center of ellipsoid for next time step
    Nring = initial_mic(aE, bE, cE, Center, micnum, micincr);
    
    for pt = 1:size(particles, 1)
        %particles(pt,:) = particles(pt,:) + Dt*get_U(particles(pt,:), Xtail, Ftail, NXmic, NFmic, ep, mu, T);  %particles positions for next time step
        k_1 = get_U(particles(pt,:), Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        k_2 = get_U(particles(pt,:) + Dt/2*k_1, Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        k_3 = get_U(particles(pt,:) + Dt/2*k_2, Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        k_4 = get_U(particles(pt,:) + Dt*k_3, Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        particles(pt,:) = particles(pt,:) + Dt/6*(k_1 + 2*k_2 + 2*k_3 + k_4);
    end
    
    
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    fprintf(fidXtail, '%12.10f %12.10f %12.10f\n', Xtail);
    fprintf(fidNXmic1, '%12.10f', NXmic(:,:,1));
    fprintf(fidNXmic2, '%12.10f', NXmic(:,:,2));
    fprintf(fidNXmic3, '%12.10f', NXmic(:,:,3));
    fprintf(fidNring, '%12.10f %12.10f %12.10f\n', Nring);
    fprintf(fidParticles, '%12.10f %12.10f %12.10f\n', particles);
    
end
fclose(fidXtail);
fclose(fidNXmic1);
fclose(fidNXmic2);
fclose(fidNXmic3);
fclose(fidNring);
fclose(fidParticles);
