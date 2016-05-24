function []=main()

    file_name = input('Give file name : ','s');
    %file_name = 'test';
    [C,B,D] = read_file(file_name);
    
    if C==-1     %file does not exist
       disp('File does not exist') 
       disp('Make sure the spelling is correct and the file is in the same path with main')
    else         %call functions
        
        disp('Min-conflicts')
        restarts= input('Give the limit restarts: ');
        repeats= input('Give the limit repeats: ');
        i=1;
        moves=0;
        while i<=restarts
           [remaining_wrong_connections_mincon,moves] = Min_conflicts(C,B,D,repeats,moves);
            if remaining_wrong_connections_mincon==0
                i=restarts+1;
            else
                i=i+1;
            end
        end
        %remaining_wrong_connections_mincon has the number of nodes
        %involved in wrong connections, * 1/2 it becomes the number of
        %wrong connections.
        if remaining_wrong_connections_mincon ~= 0
            remaining_wrong_connections_mincon=remaining_wrong_connections_mincon/2;
        end
        disp(['Number of pairs of neighboring variables which have the same value : ',num2str(remaining_wrong_connections_mincon)])
        disp(['Total moves required : ',num2str(moves)])
        disp(' ') %new line
        
        disp('Tabu search')
        repeats= input('Give the limit repeats: ');
        list_size= input('Give the size of tabu list: ');
        moves=0;
        [remaining_wrong_connections_tabu,moves] = Tabu_search(C,B,D,repeats,list_size,moves);
        %remaining_wrong_connections_tabu has the number of nodes
        %involved in wrong connections, * 1/2 it becomes the number of
        %wrong connections.
        if remaining_wrong_connections_tabu ~= 0
            remaining_wrong_connections_tabu=remaining_wrong_connections_tabu/2;
        end
        disp(['Number of pairs of neighboring variables which have the same value : ',num2str(remaining_wrong_connections_tabu)])
        disp(['Total moves required : ',num2str(moves)])
    end
end