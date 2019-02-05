function [newNXmic] = next_micpos_RK(Xtail, Ftail, NXmic, NFmic, ep, mu, T, Dt)
    % F: force vector
    % x: position vector
    % epsilon and mu values
    % Dt: change in t
    %
    % this function returns a new x matrix with positions of the next
    % times step
    %
    % this function depends on function 'get_vel_due2forces'
    
    newNXmic = zeros(size(NXmic));
    Ns = size(NXmic, 1);    %number of segments
    Nb = size(NXmic, 2);    %number of branches
    
    for i = 1:Nb
        for j = 1:Ns
        x = convert_col2row(NXmic(j,i,:));
        k_1 = get_U(x, Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        k_2 = get_U(x + Dt/2*k_1, Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        k_3 = get_U(x + Dt/2*k_2, Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        k_4 = get_U(x + Dt*k_3, Xtail, Ftail, NXmic, NFmic, ep, mu, T);
        
        newNXmic(j,i,:) = x + Dt/6*(k_1 + 2*k_2 + 2*k_3 + k_4);
        end
    end
end