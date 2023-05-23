function [clust] = delete_incoherente_class(clust)
    k = 1;
    for i = 1 : length(clust)
        A = find(clust == i);
        if ~isempty(A)
            clust(A(:)) = k;
            k = k+1;
        end
    end    
end

