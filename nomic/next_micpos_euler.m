function [newNXmic] = next_micpos_euler(NXmic, NUmic, Dt)
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
        newNXmic(j,i,:) = NXmic(j,i,:) + Dt*NUmic(j,i,:);
        end
    end
end