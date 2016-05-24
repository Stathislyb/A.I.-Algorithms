function [remaining_wrong_connections,moves] = Tabu_search(C,B,D,max_repeats,list_size,moves)
    remaining_wrong_connections=0;
    repeats=0;
    finished=false;

    %Give random color values to the nodes and initialise randomly the tabu list
    [nodes,tabu_list] = randomcolors(C,B,list_size);
    
    %Give to the second row of nodes, the number of crushes for each node
    %also calculate how many wrong connections we have on the random setting
    [nodes,remaining_wrong_connections] = wrong_connections_check(nodes,D);

    while finished==false
        repeats=repeats+1;
        %temp_nodes will keep the best move for each node
        %inside the for loop, temp_nodes_inner will keep all the moves for
        %each node
        temp_nodes=nodes;
        
        %Check all moves to find the best
        for index_i=1:length(nodes)
            
            temp_nodes_inner = nodes;  %we will work on temp_nodes_inner to test the color changes

            for i=1:C(1)  % C(1+i) are the color values
               temp_nodes_inner(:,:,i+1) = temp_nodes_inner(:,:,1);
               temp_nodes_inner(1,index_i,i+1) = C(1+i);
               [temp_nodes_inner] = wrong_connections_check_for_temp(temp_nodes_inner,D,index_i); 
            end

            %Find the best case, return the change to the correct depth of temp_nodes matrix
            [temp_nodes(:,:,index_i),index_z] = best_case_for_alter(temp_nodes_inner,index_i,D); 

        end

        %Find the best case, return the change to pre_change_nodes matrix
        %before we give it to the original nodes, we need to confirm with
        %the Tabu list
        [pre_change_nodes,index_z] = best_case_for_alter(temp_nodes,-1,D);
        
        %Recalculate the number of wrong connections before passing it to
        %the original, depends on the Tabu list
        [pre_change_nodes,pre_change_remaining_wrong_connections] = wrong_connections_check(pre_change_nodes,D);
        
        %check with the Tabu list and the best case so far to see if we
        %keep the change. node : index_z | new color : pre_change_nodes(1,index_z)
        [keep_change,tabu_list]=check_tabu_list(tabu_list,index_z,pre_change_nodes(1,index_z),remaining_wrong_connections,pre_change_remaining_wrong_connections);
        if keep_change==1
            remaining_wrong_connections=pre_change_remaining_wrong_connections;
            nodes=pre_change_nodes;
        end
        
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

% Give random colors to the nodes and initialise randomly the tabu list
function [nodes,tabu_list] = randomcolors(C,B,list_size)
    for i=1:B(1)+1                      %for each node
        random_color=randi([2,C(1)]);   %get random pointer to C from 1 to Number of colors
        nodes(i)=C(random_color+1);     %give the random color to the node
    end
    for i=1:list_size                   %fill the tabu list            
        random_color=randi([2,C(1)]);   %get random color
        random_node=randi([1,B(1)+1]); %get random node
        tabu_list(1,i)=random_node;
        tabu_list(2,i)=random_color;
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
function [nodes,index_z] = best_case_for_alter(temp_nodes,index_i,D)
    temp_nodes_dimens = size(temp_nodes); % size -> [width ; length ; depth ;...]
    
    if index_i==-1
        % find minimum wrong connections after the tests
        for i=1:temp_nodes_dimens(3)
            [temp_nodes(:,:,i),temps_wrong_connections(i)] = wrong_connections_check(temp_nodes(:,:,i),D);
        end
        min_worst_con = temps_wrong_connections(1);
        for i=2:temp_nodes_dimens(3)
            if min_worst_con > temps_wrong_connections(i)
                min_worst_con = temps_wrong_connections(i);
            end
        end

        % find which temp have the minimum wrong connections
        % similar method to find the worst case in find_node_to_alter()
        j=0;  
        for i=1:temp_nodes_dimens(3)
            if min_worst_con == temps_wrong_connections(i)
                j=j+1;
                best_cases(j) = i;
            end
        end
    else
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
    end
    
    i = randi(j);                      
    index_z = best_cases(i);
    
    % index_z points to the z index in temp_nodes with the best color
    % change, we return this to the original matrix nodes
    nodes=temp_nodes(:,:,index_z);

end


function [keep_change,tabu_list]=check_tabu_list(tabu_list,node,color,best_so_far,this_case_value)
    keep_change=1; %assume we keep it
    
    %check and correct the assumption if needed
    if best_so_far <= this_case_value
        for i=1:length(tabu_list)
            if tabu_list(1,i)== node && tabu_list(2,i)==color
                keep_change=0;
            end
        end
    end

    %in case we keep it, inform the tabu list
    if keep_change==1
        tabu_list(:,1)=[];
        tabu_list(1,end+1)=node;
        tabu_list(2,end)=color;
    end
end