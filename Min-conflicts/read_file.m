function [C,B,D] = read_file(file_name)
    C=-1;
    B=0;
    D=0;
    if exist(file_name , 'file')
        fileID = fopen(file_name);
        C = fscanf(fileID,'%d %d %d %d\n',[4,1]);
        C=C'; %C(1) number of colors, C(2:4) values of colors
        B = fscanf(fileID,'%d\n%d\n',[2,1]);
        B=B'; %B(1) number of nodes, B(2) number of connections
        D = fscanf(fileID,'%d %d < >\n');
        D=D'; %D(i : i+1) (i starting from 1 with step 2) connected nodes
        fclose(fileID);
    elseif exist(strcat(file_name,'.txt') , 'file')
        fileID = fopen(strcat(file_name,'.txt'));
        C = fscanf(fileID,'%d %d %d %d\n',[4,1]);
        C=C'; %C(1) number of colors, C(2:4) values of colors
        B = fscanf(fileID,'%d\n%d\n',[2,1]);
        B=B'; %B(1) number of nodes, B(2) number of connections
        D = fscanf(fileID,'%d %d < >\n');
        D=D'; %D(i : i+1) (i starting from 1 with step 2) connected nodes
        fclose(fileID);
    end
end