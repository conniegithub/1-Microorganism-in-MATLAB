function quiv_3d(a, b, c, d, e, f, m, n, l, ep, mu, Xtail, Ftail, NXmic, NFmic, T)
% Input values x-interval [a,b]     y-interval [c,d]
% x-increment n         y-increment m
% epsilon, mu, and N values
% xk: positions with forces
% u: velocities at those positions
% f4: the additional known force

% quiv_mod(a, b, c, d, m, n, ep, mu, N, xk, u, f4)
dx=(b-a)/(n-1);
dy=(d-c)/(m-1);
dz=(f-e)/(l-1);

X=[];
Y=[];
Z=[];
Vx = [];
Vy = [];
Vz = [];




    for i = 1:n+1
        for j = 1:m+1
            for k = 1:l+1
            x = a + dx*(i-1);
            y = c + dy*(j-1);
            z = e + dz*(k-1);
            X=[X x];
            Y=[Y y];
            Z=[Z z];
            U = get_U([x y z], Xtail, Ftail, NXmic, NFmic, ep, mu, T);
            
            Vx = [Vx U(1)]; 
            Vy = [Vy U(2)]; 
            Vz = [Vz U(3)];
    
            end
        end
    end
    
    fidField = fopen('Field.txt', 'a');
    fprintf(fidField, '%12.10f %12.10f %12.10f %12.10f %12.10f %12.10f\n', X, Y, Z, Vx, Vy, Vz);
    fclose(fidField);
    

%quiver3(X,Y, Z, Vx,Vy, Vz, 'autoscalefactor', 2, 'color', 'b'); % plot the vector field!
