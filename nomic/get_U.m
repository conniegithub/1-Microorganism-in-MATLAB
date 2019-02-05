function [U] = get_U(x, Xtail, Ftail, NXmic, NFmic, ep, mu, T)
    % finds U at any position x
    % F: force vector
    % x: position vector
    % epsilon and mu values
    %
    % this function depends on function 'get_vel_due2forces'

    U = zeros(1,3);
    Nb = size(NXmic, 2);    %number of branches
    
    %add velocity due to torque
    Ur = rotlet_Ur(x, Xtail(1,:), T, mu, ep);
    % include velocity due to tail forces
    UsTail = get_vel_due2forces(x,ep,mu,Xtail,Ftail);
    
    for i = 1:Nb

            % velocity due to each of the microvilli segments           
            xk = convert_col2row(NXmic(:,i,:));
            fk = convert_col2row(NFmic(:,i,:));
            UsMic = get_vel_due2forces(x,ep,mu,xk,fk);
                      
            U = U + UsMic;
    end
    
    U = U + UsTail + Ur;
    
end