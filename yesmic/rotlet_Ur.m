function Ur = rotlet_Ur(x, x0, T, mu, ep)
    %calculates the velocity at x due to a torque T at position x0
    r = norm(x-x0);
    t = r^2+ep^2;
    t2 = r^2+2*ep^2;
    Ur = (2*t2 + ep^2)/(16*mu*pi*t^(5/2))*cross(T, x-x0);

end