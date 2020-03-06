function [ classes, medoids, mean_radiuses ] = k_medoids( features, clusters )
    
    % Clustering using K-Medoids technique
    %
    % INPUT:
    % features_matrix = Matrix of detected spikes and features
    % clusters        = Number of desired clusters
    %
    % OUTPUT:
    % classes       = Clusters selector
    % medoids       = Clusters medoids
    % mean_radiuses = Clusters radiuses

    % Eventually invert the features matrix if it doesn't correspond to
    % what we expected in terms of dimensions
    if size(features,1) < size(features,2)
        features = features';
    end
    
    % Rows of features matrix correspond to the number of detected spikes
    total_spikes = length( features );
    
    % Retrieve "cluster" random spikes 
    random_spikes = randperm( total_spikes, clusters );
    
    % Initialize a matrix ( ex: 3 clusters x 4 features) containing all
    % features values of random spikes. We will have 4 medoids (based on 
    % 4 features values) for each cluster
    medoids = features( random_spikes, : );
    
    % Initialize the radius matrix all spike and clusters
    radiuses = zeros(total_spikes, clusters);
    
    % Initialize the vector that assign all spikes to proper cluster
    classes = zeros( total_spikes, 1 );
    
    % Initialize medoids matrix
    new_medoids = zeros(clusters, size(features, 2) );
    
    % Initialize mean radiuses vector
    mean_radiuses = zeros( clusters );
    
    % Initialize intra-cluster distances
    % intracluster_distances = zeros( total_spikes, total_spikes );
    
    % Set stop condition for the while loop
    stop_condition = false;
    
    % Execute a while loop until we have calculated best medoids
    while stop_condition == false
        
        % Loop all spikes in the features matrix
        for i = 1:total_spikes
    
            % Loop all clusters
            for c = 1:clusters
                
                % Calculate the radius for this spike and cluster, based on all 4
                % features of the current spike with respect to the values
                % in the current cluster medoids.
                radiuses(i,c) = sqrt( sum( features(i,:) - medoids(c,:) ) .^2 );
                
            end
            
        end
        
        % Loop all spikes
        for k = 1:total_spikes
            
            % Assign this spike to the cluster with min radius
            [~, classes(k)] = min( radiuses(k,:) );
            
        end
        
        % Loop all clusters
        for r = 1:clusters
    
            % Select spikes and features in this cluster
            cluster_features = features( classes == r, :);

            % Total spikes in this cluster
            current_cluster_spikes = length( cluster_features );
            
            % Initialize the intra-cluster distances matrix
            intracluster_distances = zeros(current_cluster_spikes, current_cluster_spikes);

            % Loop all spikes in this cluster
            for i = 1:current_cluster_spikes

                % Loop again all spikes in this cluster
                for j = 1:current_cluster_spikes
                    
                    % Calculate intra-cluster distance between the i-th and
                    % j-th spikes features
                    intracluster_distances(i,j) = sqrt( sum( cluster_features(i,:) - cluster_features(j,:) ) .^2 );
           
                end
            end
           
            % Find mean distances between spikes 
            intracluster_mean_distances = mean( intracluster_distances );

            % Find min distance index
            [~, index_medoid] = min( intracluster_mean_distances );
            
            % Assign new medoids using the features associated with the
            % spike with the min intra-cluster distance
            new_medoids(r,:) = cluster_features( index_medoid, : );

        end

        % If the updated centroids (for all clusters) are identical to the 
        % previous ones then we can stop the while loop. 
        if new_medoids == medoids
            stop_condition = true;
            
        % Else we update the centroids matrix with the new values.
        else
            medoids = new_medoids;
        end
    end
    
    % Loop all clusters
    for j = 1:clusters
        
        % Calculate mean radius for this cluster
        mean_radiuses(j) = mean( radiuses(classes == j, j) );
        
    end
    
end

