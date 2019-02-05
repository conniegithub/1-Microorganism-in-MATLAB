function [Nring, NXmic] = initial_mic(aE, bE, cE, Center, micnum, micincr)

    %the center of the ellipse where the microvillis are attached
    xcenter = Center(1) - aE;   %center at the tip of the head
    Xmic = Center(1) + 3*aE/4;  %center of the ring of ellipse
    x = [];
    y = [];
    z = [];
    
    xcon = 1 - ((Xmic - Center(1))/aE)^2;
    
    %calculate new b^2 and c^2 values after plugging in the know Xmic value
    %for x in the ellipsoid equation
    newbsq = bE^2*xcon;
    newcsq = cE^2*xcon;
    
    X = Xmic;
    incr = 2*pi/micnum;
    
    %using the component form of the ellipse equation to locate the
    %location where the microvillis are and discretize it
    for theta = 0:incr:2*pi
            Y = sqrt(newbsq)*sin(theta);
            Z = sqrt(newcsq)*cos(theta);
            x = [x X];
            y = [y Y];
            z = [z Z];
    end
    Nring = [x' y' z'];

    %microvilli line equations
    NXmic = [];
    lam = 1:micincr:1.8;
    for i = 1:size(x, 2)
        micx = xcenter + lam*(x(i) - xcenter);
        micy = lam*y(i);
        micz = lam*z(i);
        %get position at current microvilli
        for j = 1:length(lam)   %restructure the matrix so that each of the microvillis can be plotted individually
            NXmic(j,i,:) = [micx(j),micy(j),micz(j)];
        end
    end
end