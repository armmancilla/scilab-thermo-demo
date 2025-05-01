
function [] = main_help();
    printf("\n");
    ui_top();
    ui_line("HELP MAIN MENU: TYPE AN OPTION",'c');
    ui_section();
    ui_line(" 1  : About Program",'l');
    ui_line(" 2  : Real Gas", 'l');
    ui_line(" 3  : Hard Spheres", 'l');
    ui_line(" 4  : Functions List", 'l');
    ui_line("Else: Return",'l');
    ui_bottom();
    printf("\n");

endfunction



function [] = case_help(name);
    clc();
    printf("\n");
    ui_top();
    ui_line(convstr(name,'u')+' HELP MENU: TYPE AN OPTION','c');
    ui_section();
    ui_line(" 1  : Parameters List",'l');
    ui_line(" 2  : Theory", 'l');
    ui_line(" 3  : Algorithm", 'l');
    ui_line("Else: Return",'l');
    ui_bottom();
    printf("\n");

endfunction



function [] = program_description_display();
    printf('\n');
    program_description = part(mgetl('help/program_description.txt'),5:$);
    temp_store = line_size;
    line_size = 93;
    ui_top();
    ui_line('PROGRAM DESCRIPTION','c');
    ui_section();
    for i=5:size(program_description)(1)-1
        ui_line(program_description(i),'l');
    end
    ui_bottom();
    printf('\n')
    line_size = temp_store;
endfunction



function [] = function_files_display(name);
    function_file = part(mgetl('help/functions/'+name),5:$);
    temp_store = line_size;
    line_size = 93;
    clc();
    printf('\n');
    ui_top();
    ui_line(function_file(1),'c');
    ui_section();
    for i=3:size(function_file)(1)-1
        ui_line(function_file(i),'l');
    end
    ui_bottom();
    printf('\n');
    line_size = temp_store;
endfunction



function [] = file_reader(file_name,skip,line_length,title)
    information = part(mgetl(file_name),5:$);
    temp_store = line_size;
    line_size = line_length;
    clc();
    printf('\n');
    ui_top();
    if (exists('title','l')==1) then
        ui_line(convstr(title,'u'),'c');
        ui_section();
    end

    for i=(skip+1):size(information)(1)-1
        ui_line(information(i),'l');
    end
    ui_bottom();
    printf('\n');
    line_size = temp_store;
endfunction



function [] = case_manager(name)
    while %T
        clc();
        case_help(name);
        option = input('  Option: ');

        if (option==1) then
            file_reader('help/'+name+'/parameters_list.txt',0,93,'Parameters List');
            input('  Press any key to continue  ');

        elseif (option==2) then
            file_reader('help/'+name+'/theory.txt',0,93,'Theory');
            input('  Press any key to continue  ');

        elseif (option==3) then
            file_reader('help/'+name+'/algorithm.txt',0,93,'Algorithm');
            input('  Press any key to continue  ');

        elseif and([option<=5,option>=2,~(option==[])]) then
            break;

        else
            break;
        end

    end

endfunction



function [] = help_manager();

    while %T
        clc();
        main_help();
        option = input("  Option: ");
        if option==1 then
            file_reader('help/program_description.txt',0,93,'Program Description');
            input('  Press any key to continue  ');

        elseif (option==2) then
            clc();
            printf('\n');
            ui_top();
            ui_line('Case not available!','c')
            ui_bottom();
            printf('\n');
            exit_input = input('  Press any key to continue  ','string');
        elseif (option==3) then
            case_manager('hard spheres');

        elseif (option==4) then
            function_files = findfiles("help/functions");
            file_names = part(function_files,1:$-4);

            clc();
            printf('\n');
            ui_top();
            ui_line('FUNCTIONS LIST','c');
            ui_section();
            for i=1:size(file_names)(1)
                ui_line(file_names(i),'l');
            end
            ui_bottom();
            printf('\n');

            file_names = convstr(file_names,'l');
            function_input = convstr(input('  Write function: ','string'),'l');
            check = %F;
            for i=1:size(file_names)(1)
                if and([~(function_input==[]),function_input==file_names(i)]) then
                    function_files_display(function_files(i));
                    exit_input = input('  Press any key to continue  ','string');
                end
            end

        elseif and([option<=5,option>=2,~(option==[])]) then
            break;

        else
            break
        end

    end

endfunction
