function [NFmic] = mic_force(NXmic, Nring, L, k)
    
    Ns = size(NXmic, 1);    %number of segments
    Nb = size(NXmic, 2);    %number of branches
    NFmic = [];
    
    for j = 1:Nb

            
            % find force on the first x position
            NFmic(1,j,:) = 2*k*(Nring(j,:)-convert_col2row(NXmic(1,j,:))) + ...
                get_F_due2spring(k, convert_col2row(NXmic(1,j,:)), convert_col2row(NXmic(2,j,:)), L);
            
            % find force on the x's in between the two ends
            for i = 2:Ns-1
                NFmic(i,j,:) = - get_F_due2spring(k, convert_col2row(NXmic(i-1,j,:)), convert_col2row(NXmic(i,j,:)), L) + ...
                    get_F_due2spring(k, convert_col2row(NXmic(i,j,:)), convert_col2row(NXmic(i+1,j,:)), L);
            end
            
            % find force on the last x position
            NFmic(Ns,j,:) = - get_F_due2spring(k, convert_col2row(NXmic(Ns-1,j,:)), convert_col2row(NXmic(Ns,j,:)), L);

    end
    
end