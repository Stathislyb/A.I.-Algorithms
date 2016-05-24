function [remaining_wrong_connections,moves]= Min_conflicts(C,B,D,max_repeats,moves)
    remaining_wrong_connections=0;
    repeats=0;
    finished=false;

    %Give random color values to the nodes
    [nodes] = randomcolors(C,B);

    %Give to the second row of nodes, the number of crushes for each node
    %also calculate how many wrong connections we have on the random setting
    [nodes,remaining_wrong_connections] = wrong_connections_check(nodes,D);
    
    while finished==false

        %Find the node with most crashes to alter
        [index_i] = find_node_to_alter(nodes);

        repeats=repeats+1;
        temp_nodes = nodes;  %we will work on temp_nodes to test the color changes
        
        for i=1:C(1)  % C(1+i) are the color values
           temp_nodes(:,:,i+1) = temp_nodes(:,:,1);
           temp_nodes(1,index_i,i+1) = C(1+i);
           [temp_nodes] = wrong_connections_check_for_temp(temp_nodes,D,index_i); 
        end

        %Find the best case, return the change to the original nodes matrix
        [nodes] = best_case_for_alter(temp_nodes,index_i); 

        %Recalculate the number of wrong connections
        [nodes,remaining_wrong_connections] = wrong_connections_check(nodes,D);

        %Finish the algorithm when you reach the number of repeats given or
        %when you find a solution
        if remaining_wrong_connections==0 || repeats==max_repeats
            finished=true;
        end
        
        %count the moves, the counter doesn't return to zero and has been
        %initialised outside the function to include the repeats as well.
        moves=moves+1;
        
    end
end

% Give random colors to the nodes
function [nodes] = randomcolors(C,B)
    for i=1:B(1)+1                      %for each node
        random_color=randi([2,C(1)]);   %get random pointer to C from 1 to Number of colors
        nodes(i)=C(random_color+1);     %give the random color to the node
    end
end

% Calculate the number of wrong connections (each node and total)
function [nodes,remaining_wrong_connections] = wrong_connections_check(nodes,D)
    remaining_wrong_connections=0;
    nodes(2,:)=zeros();

    for i=1:length(nodes)                            %for each node
        for j=1:2:length(D)                          %for each connection
            
            if D(j)==i-1 || D(j+1)==i-1              %if you find a connection with this node
                if nodes(1,D(j)+1) == nodes(1,D(j+1)+1)  %if the two nodes have the same color
                    %count the total wrong connections
                    remaining_wrong_connections=remaining_wrong_connections+1;
                    %count the wrong connections for this node
                    nodes(2,i)=nodes(2,i)+1;
                end
            end
            %matlab matrix starts index from 1, nodes start from 0
            %so we have i-1 in the if above and D(...)+1 in the if inside it
            
        end 
    end
end

% Find which node we should change color
function [index_i] = find_node_to_alter(nodes)
    index_i=0;
    j=0;         % index for worst_case_nodes which will probably be less or equal to i
    
    % sort nodes to have the ones with highest value in 2nd row first
    %basically, the first value(s) has the max wrong connection in the matrix
    % sort works based on columns so we reverse the nodes with ' and then
    %the result again to get the final form we need
    sorted_nodes=(sortrows(nodes',-2))'; 
    
    for i=1:length(nodes)              %for each node
        if nodes(i)==sorted_nodes(1)
            j=j+1;                     %worst_case_nodes will keep the indexes of the nodes
            worst_case_nodes(j)= i;    %with equal wrong connections which are also equal
        end                            %to the max wrong connections.
    end 
    
    i = randi(j);                       % j has the size of worst_case_nodes
    index_i = worst_case_nodes(i);      % randomly return one of those worst cases to alter
    
end

% Calculate number of wrong connections for this alteration only
function [temp_nodes] = wrong_connections_check_for_temp(temp_nodes,D,index_i)
    temp_nodes(2,index_i,end)=0;
    
    for j=1:2:length(D)                                                 %for each connection

        if D(j)==index_i-1 || D(j+1)==index_i-1                         %if you find a connection with this node
            if temp_nodes(1,D(j)+1,end) == temp_nodes(1,D(j+1)+1,end)   %if the two nodes have the same color
                %count the wrong connections for this node
                temp_nodes(2,index_i,end)=temp_nodes(2,index_i,end)+1;
            end
        end
        %matlab matrix starts index from 1, nodes start from 0
        %so we have index_i-1 in the if above and D(...)+1 in the if inside it

    end 

end


% Find and return the best change to the original nodes matrix
function [nodes] = best_case_for_alter(temp_nodes,index_i)
    temp_nodes_dimens = size(temp_nodes); % size -> [width ; length ; depth ;...]
 
    % find minimum wrong connections after the tests
    min_worst_con = temp_nodes(2,index_i,1);
    for i=2:temp_nodes_dimens(3)
        if min_worst_con > temp_nodes(2,index_i,i)
            min_worst_con = temp_nodes(2,index_i,i);
        end
    end
    
    % find which tests have the minimum wrong connections
    % similar method to find the worst case in find_node_to_alter()
    j=0;  
    for i=1:temp_nodes_dimens(3)
        if min_worst_con == temp_nodes(2,index_i,i)
            j=j+1;
            best_cases(j) = i;
        end
    end
    i = randi(j);                      
    index_z = best_cases(i);
    
    % index_z points to the z index in temp_nodes with the best color
    % change, we return this to the original matrix nodes
    nodes=temp_nodes(:,:,index_z);

end