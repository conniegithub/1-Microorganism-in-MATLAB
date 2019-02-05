function [nM] = convert_col2row(M)

nM = [];
    for l = 1:3
        nM = [nM M(:,:,l)];
    end
end