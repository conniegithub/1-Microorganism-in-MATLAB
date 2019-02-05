function [pospts] = plot_particle(particles, r, ptnum)
    %plots particles around the given center points
    %size of the particle is determined by r
    %ptnum is the number of points plotted around the center point at each
    %angle
    
    incr = 2*pi/ptnum;
    for n = 1:size(particles, 1)
        x = particles(n,1);
        y = particles(n,2);
        z = particles(n,3);
        for phi = 0:2*pi;
            for theta = 0:incr:2*pi
                    X = particles(n,1) + r*sin(theta)*cos(phi);
                    Y = particles(n,2) + r*sin(theta)*sin(phi);
                    Z = particles(n,3) + r*cos(theta);
                    x = [x X];
                    y = [y Y];
                    z = [z Z];
                    plot3(x, y, z, 'r.-');
            end
        end
    end
    pospts = [x' y' z'];
end