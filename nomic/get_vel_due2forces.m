function [u] = get_vel_due2forces(x,ep,mu,xk,fk)
% function get_vel_due2forces(x,ep,mu,N,xk,fk)
% 
% get velocities due to N forces fk at N points xk
%
%  xk -- matrix with force positions on each row
%  fk -- matrix with forces on each row

if(size(xk)~= size(fk))
    disp('Error:');
    disp('The dimensions of xk and fk are not equal!');
    return;
end

N = size(xk,1);  % the number of rows of xk
                 % every row of xk represents a point
    psum = 0;
    usum = 0;
    for i = 1:N
        v = x-xk(i,:);
        r = norm(v);
        t = r^2+ep^2;
        t2 = r^2+2*ep^2;
        t3 = mu*8*pi*t^(3/2);
        f = fk(i,:); 
        dot_fv = dot(f,v);
        psum = psum + dot_fv*(2*t2+ep^2)/(8*pi*t^(5/2));
        usum = usum + f*t2/t3+dot_fv*v/t3;
    end
    p = psum;
    u = usum;

