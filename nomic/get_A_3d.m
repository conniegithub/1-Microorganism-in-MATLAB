  function [A] = get_A_3d(x,xk,ep,mu)
      % xk -- point that generates force
      % 2D
      % A -- small 3x3 matrix for fk at xk
      for i = 1:3
          v(i) = x(i)-xk(i);
      end
      r = norm(v);
      t = r^2+ep^2;
      t2 = r^2+2*ep^2;
      t3 = mu* 8*pi*t^(3/2);
      a = t2/t3;
      b = 1/t3;
      A = a*eye(3) + b*v'*v;
  end

