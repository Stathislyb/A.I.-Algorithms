function [] = main()
    main_crash_counter_simple=0;		% arxikopoiisi twn zitoumenwn sto 0
    main_movements_counter_simple=0;
    main_solution_found_simple=0;
    main_crash_counter_restarts=0;
    main_movements_counter_restarts=0;
    main_solution_found_restarts=0;
    main_crash_counter_stochastic=0;
    main_movements_counter_stochastic=0;
    main_solution_found_stochastic=0;
    n= input('Give the number of tokens: ');    % eisodos twn orismatwn
    x= input('Give the number of times to run: ');
    max_side_moves= input('Give the a limit side moves: ');
    restarts= input('Give the a limit restarts: ');
    max_repeats= input('Give the a limit repeats: ');
    
    for i=1:x    % ektelesi twn algorithmwn gia x fores o kathenas kai lipsi twn apotelesmatwn

        [solution_found,crash_counter_simple,movements_counter_simple] = greedy_hill_climbing_restarts (max_side_moves,n,1);
        main_crash_counter_simple=main_crash_counter_simple+crash_counter_simple;
        main_movements_counter_simple=main_movements_counter_simple+movements_counter_simple;
        main_solution_found_simple=main_solution_found_simple+solution_found;
        
        [solution_found,crash_counter_restarts,movements_counter_restarts] = greedy_hill_climbing_restarts (max_side_moves,n,restarts);
        main_crash_counter_restarts=main_crash_counter_restarts+crash_counter_restarts;
        main_movements_counter_restarts=main_movements_counter_restarts+movements_counter_restarts;
        main_solution_found_restarts=main_solution_found_restarts+solution_found;
        
        [solution_found,crash_counter_stochastic,movements_counter_stochastic] = greedy_hill_climbing_stochastic_restarts(max_repeats,restarts,n);
        main_crash_counter_stochastic=main_crash_counter_stochastic+crash_counter_stochastic;
        main_movements_counter_stochastic=main_movements_counter_stochastic+movements_counter_stochastic;
        main_solution_found_stochastic=main_solution_found_stochastic+solution_found;
        
    end
    
	% emfanisi twn apotelesmatwn
    disp(' ');
	disp('Greedy hill-climbing with sideways moves ');
    y=main_crash_counter_simple/x;
    disp('Crashes mean : ');
    disp(y);
    y=main_movements_counter_simple/x;
    disp('Movements mean : ');
    disp(y);
    y=main_solution_found_simple;
    disp('Solutions found : ');
    disp(y);
    
    disp(' ');
    disp('Greedy hill-climbing with sideways moves and restarts ');
    y=main_crash_counter_restarts/x;
    disp('Crashes mean : ');
    disp(y);
    y=main_movements_counter_restarts/x;
    disp('Movements mean : ');
    disp(y);
    y=main_solution_found_simple;
    disp('Solutions found : ');
    disp(y);
    
    disp(' ');
    disp('Hill-climbing with stochastic choices and restarts ');
    y=main_crash_counter_stochastic/x;
    disp('Crashes mean : ');
    disp(y);
    y=main_movements_counter_stochastic/x;
    disp('Movements mean : ');
    disp(y);
    y=main_solution_found_stochastic;
    disp('Solutions found : ');
    disp(y);
    



%Greedy hill-climbing with sideways moves and restarts 
function [solution_found,total_crash_counter,movements_counter] = greedy_hill_climbing_restarts (max_side_moves,n,restarts)
goal_found=false;		% arxikopoiisi metavlitwn kai zitoumenwn
i=1;
solution_found=0;
movements_counter=0;
total_crash_counter=0;
while i<=restarts 		% ektelesi tou greedy hill climbing mexri na vrei stoxo
    [crash_counter,goal_found,movements_counter] = greedy_hill_climbing(movements_counter,max_side_moves,n);
    total_crash_counter=total_crash_counter+crash_counter;
    if goal_found==true
        solution_found=solution_found+1;
    	i=restarts+1;
    else
        i=i+1;
    end
end





% Greedy hill-climbing
function [crash_counter,goal_found,movements_counter] = greedy_hill_climbing(movements_counter,max_side_moves,n)
original_board(4,1,1)=zeros();		% arxikopoiisi tou original_board... einai o pinakas opou kratountai oi sintetagmenes twn pioniwn stis arxikes theseis
%  stin prwti grammi krateitai i syntetagmeni y kai sti deuteri i x. Stin triti exoume 0 gia aksiwmatiko, 1 gia vasilisa
[original_board] = randomboard(n);
moved_on_other=0;
board=original_board;
[crash_counter] = crash_test(board);
crashes = crash_counter;
finished=false;
sidemoves(1)=0;
sidemoves_maxed=false;
goal_found=false;

while finished==false		% o vroxos pou pragmatopoiei mia kinisi
    movements_counter=movements_counter+1;
    z_index=1;
	get_next=true;
	for i=1:n			% elegxos gia kathe pioni twn pithanwn kinisewn tou  
        if board(3,i,1)==1  %if the piece is queen, check the 
                            %horizontal and vertical movements too

            horizontal_move=true;
            modifier=1;		% einai i metatopisi... edw arxikopoieitai sto 1, pou simainei metatopisi kata mia thesi
            while horizontal_move==true		% vroxos orizontias kinisis... kathe pioni pou mporei na kanei aftin tin kinisi metakineitai orizontia pros ta deksia, mexri na vrei allo pioni i mexri na ftasei sta oria tis skakieras
											% afou oloklirwthoun oi kiniseis pros ta deksia, to pioni kanei oles tis pithanes kineiseis pros ta aristera
                board=original_board;
                board(2,i,1)=original_board(2,i,1)+modifier;
                [moved_on_other] = crash_test_on_move(board,n,i);
                
                if board(2,i,1)<9 && moved_on_other==0 && modifier>0
                    [crash_counter] = crash_test(board);
                    if crashes(1)>=crash_counter	% elegxos gia to poses sygrouseis exoume se aftin tin thesi pou tha metakinithei to pioni. oi ypopsifies nees syntetagmenes kratountai mono an oi sygrouseis einai ligoteres apo aftes pou ypirxan stin arxiki topothetisi
                        z_index=z_index+1;
                        original_board(:,:,z_index)=board(:,:,1);	% oi ypopsifiesnees nees syntetagmenes kratiountai kathe fora ston original_board, afksanontas kathe fora tin triti diastasi. stin prwti diastasi vriskontai panta oi trexouses syntetagmenes
                        crashes(z_index)=crash_counter;		% oi sygrouseis pou prokyptoun me ti nea ypopsifia topothetisi kratiountai ston pinaka crashes, epekteinontas ton
                    end		
                    modifier=modifier+1;
                end

                if board(2,i,1)>0 && moved_on_other==0 && modifier<0
                    [crash_counter] = crash_test(board);
                    if crashes(1)>=crash_counter
                        z_index=z_index+1;
                        original_board(:,:,z_index)=board(:,:,1);
                        crashes(z_index)=crash_counter;
                    end				
                    modifier=modifier-1;
                end
                
                if (moved_on_other==1 && modifier>0) || board(2,i,1)>8	% otan teliwsoun oi kiniseis pros ta deksia ksekinan oi kiniseis pros ta aristera
                    modifier=-1;
                end

                if (moved_on_other==1 && modifier<0) || board(2,i,1)<1	% otan teliwsoun oi kiniseis pros ta aristera, teliwnoun oles oi pithanes kiniseis aftou tou pioniou
                    horizontal_move=false;
                end

            end

            modifier=1;
            vertical_move=true;
            while vertical_move==true	% katheti kinisi
                board=original_board;
                board(1,i,1)=original_board(1,i,1)+modifier;
                [moved_on_other] = crash_test_on_move(board,n,i);

                if board(1,i,1)<9 && moved_on_other==0 && modifier>0
                    [crash_counter] = crash_test(board);
                    if crashes(1)>=crash_counter
                        z_index=z_index+1;
                        original_board(:,:,z_index)=board(:,:,1);
                        crashes(z_index)=crash_counter;
                    end		
                    modifier=modifier+1;
                end

                if board(1,i,1)>0 && moved_on_other==0 && modifier<0
                    [crash_counter] = crash_test(board);
                    if crashes(1)>=crash_counter
                        z_index=z_index+1;
                        original_board(:,:,z_index)=board(:,:,1);
                        crashes(z_index)=crash_counter;
                    end				
                    modifier=modifier-1;
                end
                
                if (moved_on_other==1 && modifier>0) || board(1,i,1)>8
                    modifier=-1;
                end

                if (moved_on_other==1 && modifier<0) || board(1,i,1)<1
                    vertical_move=false;
                end

            end
        end

        modifier=1;
        sideways_1_move=true;		% diagwnia kinisi
        while sideways_1_move==true
            board=original_board;
            board(1,i,1)=original_board(1,i,1)+modifier;
            board(2,i,1)=original_board(2,i,1)+modifier;
            [moved_on_other] = crash_test_on_move(board,n,i);

            if (board(1,i,1)<9 && board(2,i,1)<9) && moved_on_other==0 && modifier>0
                [crash_counter] = crash_test(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end		
                modifier=modifier+1;
            end

            if (board(1,i,1)>0 && board(2,i,1)>0) && moved_on_other==0 && modifier<0
                [crash_counter] = crash_test(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end				
                modifier=modifier-1;
            end
            
            if (moved_on_other==1 && modifier>0) || board(1,i,1)>8 || board(2,i,1)>8
                modifier=-1;
            end

            if (moved_on_other==1 && modifier<0) || board(1,i,1)<1 || board(2,i,1)<1
                sideways_1_move=false;
            end

        end

        modifier=1;
        sideways_2_move=true;
        while sideways_2_move==true
            board=original_board;
            board(1,i,1)=original_board(1,i,1)+modifier;
            board(2,i,1)=original_board(2,i,1)-modifier;
            [moved_on_other] = crash_test_on_move(board,n,i);

            if (board(1,i,1)<9 && board(2,i,1)>0) && moved_on_other==0 && modifier>0
                [crash_counter] = crash_test(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end		
                modifier=modifier+1;
            end

            if (board(1,i,1)>0 && board(2,i,1)<9) && moved_on_other==0 && modifier<0
                [crash_counter] = crash_test(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end				
                modifier=modifier-1;
            end
            
            if (moved_on_other==1 && modifier>0) || board(1,i,1)>8 || board(2,i,1)<1
                modifier=-1;
            end

            if (moved_on_other==1 && modifier<0) || board(1,i,1)<1 || board(2,i,1)>8
                sideways_2_move=false;
            end

        end
    end
	
    z_index_best_case=1;
	[z_index_best_case] = find_best_case(crashes,z_index);		% klisi tis find_best_case gia na metakinithoume stin kaliteri dinati kinisi
	crash_counter = crashes(z_index_best_case);		% oi sygrouseis se aftin tin kaliteri kinisi apothikevontai ston crash_counter
	if crash_counter == 0 || sidemoves_maxed==true		% teliwnoume otan oi sygrouseis einai 0 i otan eksantlisoume ta sidemoves
		finished=true;
        board(:,:,1)=original_board(:,:,z_index_best_case);
        original_board=[];
        original_board(:,:,1)=board(:,:,1);
        if crash_counter == 0
            goal_found=true;
        end
	else
	% elegxos gia to an eimaste sto orio twn plagiwn kinisewn. xrisimopoieitai o voithitikos pinakas sidemoves, stou opoiou tin prwti thesi bainei o arithmos
	% twn sygrousewn tis proigoumenis topothetisis. An i epomeni topothetisi exei ton idio arithmo sigrousewn, o pinakas afksanetai kata ena keli. An alaksei o arithmos 
	% twn sygrousewn, o pinakas adeiazei kai i prwti tou thesi pairnei timi apo tis trexouses sygrouseis
	% an to megethos tou pinaka ftasei to max_side_moves pou exoume orisei, tote simainei oti exoume ypervei to orio twn plagiwn kinisewn
		if sidemoves(1) == crashes(z_index_best_case)
			if max_side_moves == length(sidemoves)		
				sidemoves_maxed=true;
			else
				sidemoves(end+1) = crashes(z_index_best_case);
				get_next=true;
			end
		else
			sidemoves=[];
			sidemoves(1) = crashes(z_index_best_case);
			get_next=true;
		end
		if get_next==true
			board(:,:,1)=original_board(:,:,z_index_best_case);
			original_board=[];
			original_board(:,:,1)=board(:,:,1);
			temp_crashes=crashes(z_index_best_case);
			crashes=[];
			crashes(1)=temp_crashes;
		end
    end
end

    
    
%Function that displays the board    
% function [] = show_boards(board)
%    display_board(8,8)=zeros();
%    for i=1:8
%        a=board(1,i,1);
%        b=board(2,i,1);
%      if board(3,i,1)==1
%         display_board(a,b) =  2;
%      else
%          display_board(a,b) =  1;
%      end
%    end
%     
% f = figure('Position', [500 500 275 200]);
% t = uitable('Parent', f, 'Position', [0 0 700 200],'ColumnWidth',{25});
% set(t, 'Data', display_board);


%Function that returns a random initial board state
function[board] = randomboard(n)

check=true;
% random initial state
board(1,:)=randperm(8,n);
board(2,:)=randperm(8,n);
while check==true
    chek_counter=0;
    for i=1:n
        for j=1:n
            if board(1,i) == board(1,j) && i~=j
                if board(2,i) == board(2,j)
                    board(1,:)=randperm(8,n);
                    board(2,:)=randperm(8,n);
                else
                    chek_counter = chek_counter+1;
                end
            else
                chek_counter = chek_counter+1;
            end
        end
    end
    
    if chek_counter == n^2
        check=false;
    end
end

for i=1:n
    if i<= n/2
       board(3,i,1) = 1; 
    else
       board(3,i,1) = 0; 
    end
end


%Function to return the number of crashes on an instance
function [crash_counter] = crash_test(board)
n=8;
crash_counter=0;
for i=1:n
    crushed_horizontal=true;
    crushed_vertical=true;
    crushed_sideways_down=true;
    crushed_sideways_up=true;
%     disp('examining : ');
%     board(1,i)
%     board(2,i)
    
    j=1;
    while crushed_horizontal==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_horizontal=false;
        else
            %crush vertical 
            if board(2,i,1)==board(2,j,1)
                if board(3,i,1)==1 || board(3,j,1)==1
                    crushed_horizontal=false;
                    crash_counter=crash_counter+1;
%                     disp('vertical crushed on : ');
%                     board(1,j)
%                     board(2,j)
                end
            end
        end
        j=j+1;
    end

    j=1;
    while crushed_vertical==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_vertical=false;
        else
            %crush horizontal 
            if board(1,i,1)==board(1,j,1)
                if board(3,i,1)==1 || board(3,j,1)==1
                    crushed_vertical=false;
                    crash_counter=crash_counter+1;
%                     disp('horizontal crushed on : ');
%                     board(1,j)
%                     board(2,j)
                end
            end
        end
        j=j+1;
    end
    
    j=1;
    while crushed_sideways_down==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_sideways_down=false;
        else
            %crush sideways down
            y=board(1,i,1);
            x=board(2,i,1);
            sideways_loop_down=true;
            while sideways_loop_down==true
                if y>n || x>n
                    sideways_loop_down=false;
                else
                    if board(1,j,1)==y && board(2,j,1)==x
                        sideways_loop_down=false;
                        crushed_sideways_down=false;
                        crash_counter=crash_counter+1;
%                         disp('sideways down crushed on : ');
%                         board(1,j)
%                         board(2,j)
                    end
                    y=y+1;
                    x=x+1;
                end
            end
        end
        j=j+1;
    end
    
    j=1;
    while crushed_sideways_up==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_sideways_up=false;
        else
            %crush sideways up
            y=board(1,i,1);
            x=board(2,i,1);
            sideways_loop_up=true;
            while sideways_loop_up==true
                if y<0 || x>n
                    sideways_loop_up=false;
                else
                    if board(1,j,1)==y && board(2,j,1)==x
                        sideways_loop_up=false;
                        crushed_sideways_up=false;
                        crash_counter=crash_counter+1;
%                         disp('sideways up crushed on : ');
%                         board(1,j)
%                         board(2,j)
                    end
                    y=y-1;
                    x=x+1;
                end
            end
        end
        j=j+1;
    end
end


% function to test for crash on move
function [moved_on_other] = crash_test_on_move(board,n,i)
moved_on_other=0;
loop=true;  
j=1;
while loop==true
	if i ~= j
		if j>n
			loop=false;
		else
			if board(2,i,1)==board(2,j,1) && board(1,i,1)==board(1,j,1)
				loop=false;
				moved_on_other=1;
			end
		end
	end
	j=j+1;
end


%function to find the best subcase
function [z_index_best_case] = find_best_case(crashes,z_index)
j=0;
crashes_temp=crashes;
crashes_temp=sort(crashes_temp);

for i=1:z_index		% xrisimopoieitai o pinakas best_crashes gia na kratithoun oi theseis tou crashes me ton mikrotero arithmo. An yparxoun isovathmies epilegetai mia tyxaia thesi apo ton best_crashes
	if crashes(i)==crashes_temp(1);
		j=j+1;
        best_crashes(j)=i;	
        crashes(i);
	end
end
i=randperm(j,1);
z_index_best_case=best_crashes(i);


%Greedy hill climbing with stochastic choices and restarts
function [solution_found,total_crash_counter,total_movements_counter] = greedy_hill_climbing_stochastic_restarts(max_repeats,restarts,n)
goal_found=false;
i=1;
solution_found=0;
total_movements_counter=0;
total_crash_counter=0;
while i<=restarts
    [crash_counter,goal_found,total_movements_counter] = greedy_hill_climbing_stochastic(total_movements_counter,max_repeats,n);
    total_crash_counter=total_crash_counter+crash_counter;
    if goal_found==true
        solution_found=solution_found+1;
    	i=restarts+1;
    else
        i=i+1;
    end
end





% Greedy hill-climbing
function [crash_counter,goal_found,movements_counter] = greedy_hill_climbing_stochastic(movements_counter,max_repeats,n)

% original_board=[6,2,5,8,6,1,2,4;
%                 1,3,3,3,6,7,7,7;
%                 0,1,1,1,1,0,0,0]
[original_board] = randomboard(n);
original_board(4,:,:)=zeros();

moved_on_other=0;
board=original_board;
goal_found=false;

[crash_counter,board] = crash_test_stochastic(board);
crashes = crash_counter;
finished=false;
repeats=0;

[index_i] = find_token_to_move(board,n);
board(index_i);
while finished==false
    movements_counter=movements_counter+1;
    repeats=repeats+1;
    [index_i] = find_token_to_move(original_board,n);
    z_index=1;
    i=index_i;			
    if board(3,i,1)==1  %if the piece is queen, check the 
                        %horizontal and vertical movements too

        horizontal_move=true;
        modifier=1;
        while horizontal_move==true
            board=original_board;
            board(2,i,1)=original_board(2,i,1)+modifier;
            [moved_on_other] = crash_test_on_move_stochastic(board,n,i);

            if board(2,i,1)<9 && moved_on_other==0 && modifier>0
                [crash_counter,board] = crash_test_stochastic(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end		
                modifier=modifier+1;
            end

            if board(2,i,1)>0 && moved_on_other==0 && modifier<0
                [crash_counter,board] = crash_test_stochastic(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end				
                modifier=modifier-1;
            end

            if (moved_on_other==1 && modifier>0) || board(2,i,1)>8
                modifier=-1;
            end

            if (moved_on_other==1 && modifier<0) || board(2,i,1)<1
                horizontal_move=false;
            end

        end

        modifier=1;
        vertical_move=true;
        while vertical_move==true
            board=original_board;
            board(1,i,1)=original_board(1,i,1)+modifier;
            [moved_on_other] = crash_test_on_move_stochastic(board,n,i);

            if board(1,i,1)<9 && moved_on_other==0 && modifier>0
                [crash_counter,board] = crash_test_stochastic(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end		
                modifier=modifier+1;
            end

            if board(1,i,1)>0 && moved_on_other==0 && modifier<0
                [crash_counter,board] = crash_test_stochastic(board);
                if crashes(1)>=crash_counter
                    z_index=z_index+1;
                    original_board(:,:,z_index)=board(:,:,1);
                    crashes(z_index)=crash_counter;
                end				
                modifier=modifier-1;
            end

            if (moved_on_other==1 && modifier>0) || board(1,i,1)>8
                modifier=-1;
            end

            if (moved_on_other==1 && modifier<0) || board(1,i,1)<1
                vertical_move=false;
            end

        end
    end

    modifier=1;
    sideways_1_move=true;
    while sideways_1_move==true
        board=original_board;
        board(1,i,1)=original_board(1,i,1)+modifier;
        board(2,i,1)=original_board(2,i,1)+modifier;
        [moved_on_other] = crash_test_on_move_stochastic(board,n,i);

        if (board(1,i,1)<9 && board(2,i,1)<9) && moved_on_other==0 && modifier>0
            [crash_counter,board] = crash_test_stochastic(board);
            if crashes(1)>=crash_counter
                z_index=z_index+1;
                original_board(:,:,z_index)=board(:,:,1);
                crashes(z_index)=crash_counter;
            end		
            modifier=modifier+1;
        end

        if (board(1,i,1)>0 && board(2,i,1)>0) && moved_on_other==0 && modifier<0
            [crash_counter,board] = crash_test_stochastic(board);
            if crashes(1)>=crash_counter
                z_index=z_index+1;
                original_board(:,:,z_index)=board(:,:,1);
                crashes(z_index)=crash_counter;
            end				
            modifier=modifier-1;
        end

        if (moved_on_other==1 && modifier>0) || board(1,i,1)>8 || board(2,i,1)>8
            modifier=-1;
        end

        if (moved_on_other==1 && modifier<0) || board(1,i,1)<1 || board(2,i,1)<1
            sideways_1_move=false;
        end

    end

    modifier=1;
    sideways_2_move=true;
    while sideways_2_move==true
        board=original_board;
        board(1,i,1)=original_board(1,i,1)+modifier;
        board(2,i,1)=original_board(2,i,1)-modifier;
        [moved_on_other] = crash_test_on_move_stochastic(board,n,i);

        if (board(1,i,1)<9 && board(2,i,1)>0) && moved_on_other==0 && modifier>0
            [crash_counter,board] = crash_test_stochastic(board);
            if crashes(1)>=crash_counter
                z_index=z_index+1;
                original_board(:,:,z_index)=board(:,:,1);
                crashes(z_index)=crash_counter;
            end		
            modifier=modifier+1;
        end

        if (board(1,i,1)>0 && board(2,i,1)<9) && moved_on_other==0 && modifier<0
            [crash_counter,board] = crash_test_stochastic(board);
            if crashes(1)>=crash_counter
                z_index=z_index+1;
                original_board(:,:,z_index)=board(:,:,1);
                crashes(z_index)=crash_counter;
            end				
            modifier=modifier-1;
        end

        if (moved_on_other==1 && modifier>0) || board(1,i,1)>8 || board(2,i,1)<1
            modifier=-1;
        end

        if (moved_on_other==1 && modifier<0) || board(1,i,1)<1 || board(2,i,1)>8
            sideways_2_move=false;
        end

    end

	
    z_index_best_case=1;
	[z_index_best_case] = find_best_case(crashes,z_index);
	crash_counter = crashes(z_index_best_case);
    board(:,:,1)=original_board(:,:,z_index_best_case);
    original_board=[];
    original_board(:,:,1)=board(:,:,1);
    
	if crash_counter == 0 || repeats==max_repeats
		finished=true;
        if crash_counter == 0
            goal_found=true;
        end
    else
        temp_crashes=crashes(z_index_best_case);
        crashes=[];
        crashes(1)=temp_crashes;
    end
end


%Function to return the number of crashes on an instance
function [crash_counter,board] = crash_test_stochastic(board)
n=8;
crash_counter=0;
for i=1:n
    crash_counter_tokens=0;
    crushed_horizontal=true;
    crushed_vertical=true;
    crushed_sideways_down=true;
    crushed_sideways_up=true;
%     disp('examining : ');
%     board(1,i)
%     board(2,i)
    
    j=1;
    while crushed_horizontal==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_horizontal=false;
        else
            %crush vertical 
            if board(2,i,1)==board(2,j,1)
                if board(3,i,1)==1 || board(3,j,1)==1
                    crushed_horizontal=false;
                    crash_counter=crash_counter+1;
                    crash_counter_tokens=crash_counter_tokens+1;
%                     disp('vertical crushed on : ');
%                     board(1,j)
%                     board(2,j)
                end
            end
        end
        j=j+1;
    end

    j=1;
    while crushed_vertical==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_vertical=false;
        else
            %crush horizontal 
            if board(1,i,1)==board(1,j,1)
                if board(3,i,1)==1 || board(3,j,1)==1
                    crushed_vertical=false;
                    crash_counter=crash_counter+1;
                    crash_counter_tokens=crash_counter_tokens+1;
%                     disp('horizontal crushed on : ');
%                     board(1,j)
%                     board(2,j)
                end
            end
        end
        j=j+1;
    end
    
    j=1;
    while crushed_sideways_down==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_sideways_down=false;
        else
            %crush sideways down
            y=board(1,i,1);
            x=board(2,i,1);
            sideways_loop_down=true;
            while sideways_loop_down==true
                if y>n || x>n
                    sideways_loop_down=false;
                else
                    if board(1,j,1)==y && board(2,j,1)==x
                        sideways_loop_down=false;
                        crushed_sideways_down=false;
                        crash_counter=crash_counter+1;
                        crash_counter_tokens=crash_counter_tokens+1;
%                         disp('sideways down crushed on : ');
%                         board(1,j)
%                         board(2,j)
                    end
                    y=y+1;
                    x=x+1;
                end
            end
        end
        j=j+1;
    end
    
    j=1;
    while crushed_sideways_up==true
        if j==i
            j=j+1;
        end
        if j>n
            crushed_sideways_up=false;
        else
            %crush sideways up
            y=board(1,i,1);
            x=board(2,i,1);
            sideways_loop_up=true;
            while sideways_loop_up==true
                if y<0 || x>n
                    sideways_loop_up=false;
                else
                    if board(1,j,1)==y && board(2,j,1)==x
                        sideways_loop_up=false;
                        crushed_sideways_up=false;
                        crash_counter=crash_counter+1;
                        crash_counter_tokens=crash_counter_tokens+1;
%                         disp('sideways up crushed on : ');
%                         board(1,j)
%                         board(2,j)
                    end
                    y=y-1;
                    x=x+1;
                end
            end
        end
        j=j+1;
    end
    board(4,i,1)=crash_counter_tokens;
end


% function to test for crash on move
function [moved_on_other] = crash_test_on_move_stochastic(board,n,i)
moved_on_other=0;
loop=true;  
j=1;
while loop==true
	if i ~= j
		if j>n
			loop=false;
		else
			if board(2,i,1)==board(2,j,1) && board(1,i,1)==board(1,j,1)
				loop=false;
				moved_on_other=1;
			end
		end
	end
	j=j+1;
end


%function to find which token to move
function [index_i] = find_token_to_move(board,n)
j=0;
for i=1:n
	if board(4,i,1)>0;
		j=j+1;
        tokens(j)=i;	
    elseif i==n && j==0
        j=n;
        for i=1:n
            tokens(i)=i;
        end
	end
end
i=randperm(j,1);
index_i=tokens(i);



