function [W, H, VAF, VAF_muscle] = NN_mat_fact(M, sinergies, muscles, max_iterations)
    
    % Clustering using K-Means technique
    %
    % INPUT:
    % M         = Coordinated activity matrix
    % sinergies = Number of sinergies
    % muscles   = Number of muscles
    % max_iterations = Max number of iterations
    %
    % OUTPUT:
    % W          = Sinergy vectors
    % H          = Synergy activation coefficients
    % VAF        = Variance Accounted For
    % VAF_muscle = VAF for each muscle
    
    % Eventually invert the features matrix if it doesn't correspond to
    % what we expected in terms of dimensions
    if size(M,1) > size(M,2)
        M = M';
    end
    
    % Initialize W and H matrixes with random values
    W = rand( size(M,1), sinergies);
    H = rand( sinergies, size(M,2) );
    
    % Initialize vectors
    err_tmp     = zeros( max_iterations, 1 );
    VAF_muscle  = zeros( muscles, 1 );
    
    % Initialize while counter
    count = 1;
    
    % Loop until max_iterations is reached
    while count < max_iterations

       num_H    = W' * M;
       den_H    = W' * W * H;
       H        = H .* num_H ./ den_H;
       num_W    = M * H';
       den_W    = W * ( H * H');
       W        = W .* num_W ./ den_W;

       err_tmp(count) = sqrt(sum(sum((M-W*H).^2)));

       if count > 30 && (err_tmp(count) - err_tmp(count-30) ) < 0.001
           break
       end

       count = count+1;
       VAF   = 1-(sum(sum((M-W*H).^2))/(sum(sum(M.^2))));
       REC   = W * H;

       for i = 1:muscles
           VAF_muscle(i) = 1 - sum( ( M(i,:) - REC(i,:) ).^2) ./ sum( M(i,:) .^ 2);
       end

    end

end

