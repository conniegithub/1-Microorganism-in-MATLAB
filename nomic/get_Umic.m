function [NUmic] = get_Umic(Xtail, Ftail, NXmic, NFmic, ep, mu, T)
    % F: force vector
    % x: position vector
    % epsilon and mu values
    %
    % this function depends on function 'get_vel_due2forces'

    NUmic = zeros(size(NXmic));
    Ns = size(NXmic, 1);    %number of segments
    Nb = size(NXmic, 2);    %number of branches
  
    for i = 1:Nb
        %velocity due to each of other microvilli
        for j = 1:Ns
            x = convert_col2row(NXmic(j,i,:));
            %velocity due to each of microvilli
            u=[0 0 0];
            for i_2 = 1:Nb
            xk = convert_col2row(NXmic(:,i_2,:));
            fk = convert_col2row(NFmic(:,i_2,:));
            u = u + get_vel_due2forces(x,ep,mu,xk,fk);
            end
            % include velocity due to tail forces
            u2 = get_vel_due2forces(x,ep,mu,Xtail,Ftail);
            %adding velocity due to torque
            Ur = rotlet_Ur(x, Xtail(1,:), T, mu, ep);
            for kk = 1:3
                NUmic(j,i,kk) = NUmic(j,i,kk) + u(kk) + u2(kk) + Ur(kk);
            end
        end
    end
    
end