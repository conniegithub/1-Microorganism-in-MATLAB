function X = childress_tail(alpha, beta, K, s, Q, t, L0, Nr)
    % returns position matrix X
    X = [];
    for i = 1:Nr
        x = -alpha*(s+Q*t);
        y = beta*cos(K*(s+Q*t));
        z = beta*sin(K*(s+Q*t));
        X = [X; [x y z]];
        s = s + L0;
    end
end
