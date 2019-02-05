function [Fs] = get_F_due2spring(k, x1, x2, L)
    % k: spring constant
    % L: resting distance
    % x1, x2 position vectors
    % this function will return the force due to spring
    
    dist = norm(x1-x2);
    Fs = -k*(dist-L)*(x1-x2)/dist;

end