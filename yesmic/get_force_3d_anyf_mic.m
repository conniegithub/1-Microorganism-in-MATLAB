function [Ftail]=get_force_3d_anyf_mic(ep,mu,Xtail, NXmic, Utail,NFmic)
% 
% This function returns forces for given velocities at specific points
% function [f]=get_force_2d(ep,mu,xo,u,N)
%
% M is the number of unknown force vectors
% (N is the number of known force vectors)
% fn is a matrix storing N known force vectors
% fm will be a return matrix storing M solved force vectors
% xn is a matrix storing N points with known forces
% xm is a matrix storing M points with unknown forces
% u is a matrix storing M given velocity vectors

%----------------------------------------------------------------------------
% inital data
%  ep=0.01; % sets epsilon value
%  mu=1; % sets mu value
%----------------------------------------------------------------------------
   M = size(Xtail,1);       %number of points with unknown forces
   Ns = size(NXmic, 1);    %number of segments
   Nb = size(NXmic, 2);    %number of branches
   U = [];
   Ftail = [];
   
  % to get the big B matrix with size 2*M X 2*M using xm
  for i = 1:M
      x = Xtail(i,:);
      for j = 1:M
          xk = Xtail(j,:);
          B(3*i-2:3*i, 3*j-2:3*j) = get_A_3d(x,xk,ep,mu);
      end
      % calculate sum of the known D matrices and subtract from u row by
      % row
      sum = [0;0;0];
      for k_1 = 1:Nb
        for k_2 = 1:Ns
            micx = convert_col2row(NXmic(k_2, k_1, :));
            micf = convert_col2row(NFmic(k_2, k_1, :));
            sum = sum + get_A_3d(x, micx, ep, mu)*micf';     
        end
      end
      % turning u into a 2M x 1 matrix
      U = [U;(Utail(i,:)-sum')'];
  end

% solve for matrix storing solved force vectors
Ftemp = B\U;    %gmres(B,U,10,1e-10);
    for bunch = 1:3:size(Ftemp,1)
        Ftail = [Ftail; Ftemp(bunch), Ftemp(bunch + 1), Ftemp(bunch + 2)];
    end
end
