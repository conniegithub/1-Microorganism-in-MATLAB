function [prescribedUtail] = get_prescribedU(alpha, beta, K, s, Q, t, L0, Nr)

    prescribedUtail = [];
    for i = 1:Nr
        Utemp(1) = alpha*Q;
        Utemp(2) = -beta*K*Q*sin(K*(s+Q*t));
        Utemp(3) = beta*K*Q*cos(K*(s+Q*t));
        prescribedUtail = [prescribedUtail; [Utemp(1), Utemp(2), Utemp(3)]];
        s = s + L0;
    end
    
end