line_size = 47;    // This number must be odd to align 2 column messages with 1 column messages, no lower than 47

//  FUNCTIONS WITH TEXT IN ONE COLUMN
//  ---------------------------------
//  
//  A void function (does not change a variable in the program) aiming to aide in the fast production of
//  text inside the UI
//
//  SYNTAX
//    ui_line(str_var,alignment)
//
//  ARGUMENTS
//    str_var
//      A string containing the text the editor wants to print as a line inside the UI
//
//    alignment
//      A string that sets the alignment of the text. Possible values are 'l', 'c', or 'r', which stand for
//      'left', 'center' or 'rigth', respectively
//
function [] = ui_line(str_var,alignment)

    k = bool2s(strchr(str_var,'%')=='%%');
    string_print = '  █  ';
    if (alignment=='l') then
        string_print = string_print + str_var;
        for i=1:((line_size+7)-length(string_print)+k)
            string_print = string_print + ' ';
        end
    elseif (alignment == 'r') then
        for i=1:((line_size+2)-length(str_var)+k)
            string_print = string_print + ' ';
        end
        string_print = string_print + str_var;
    elseif (alignment == 'c') then
        right_space = int(((line_size+2)-length(str_var)+k)/2);
        left_space = (line_size+2)-length(str_var)+k-right_space;
        for i=1:left_space
            string_print = string_print + ' ';
        end 
        string_print = string_print + str_var;
        for i=1:right_space
            string_print = string_print + ' ';
        end
    end

    string_print = string_print + '  █\n';
    printf(string_print);

endfunction

//  FUNCTIONS WITH TEXT IN TWO COLUMNS
//  ---------------------------------
//  
//  A void function that ease the construction of two columns texts in the UI
//
//  SYNTAX
//    ui_2line(str_var_1,str_var_2,alignment,frame)
//
//  ARGUMENTS
//    str_var_1
//      A string with the first column text
//
//    str_var_2
//      A string with the second column text
//
//    alignment
//      A string that sets the alignment of both columns. Possible values are 'll', 'lc', 'lr', 'cc', and so on,
//      which stand for 'left', 'center' or 'rigth', respectively for each column
//
//    frame
//      A string that sets the display of a frame in the middle between the columns. Possible values are 'y' for 'yes',
//      to display the frame and 'n' for 'no'
//
function [] = ui_2line(str_var_1,str_var_2,alignment,frame);

    string_print = '  █';
    str_var = [str_var_1, str_var_2];
    string_temp = ['  ','  '];
    alignments = strsplit(alignment);
    // Creating both columns
    for i=1:2
        if (alignments(i)=='l') then
            string_temp(i) = string_temp(i) + str_var(i);
            for k=1:((line_size-5)/2+1-length(str_var(i)))
                string_temp(i) = string_temp(i) + ' ';
            end
        elseif (alignments(i) == 'r') then
            for k=1:((line_size-5)/2+1-length(str_var(i)))
                string_temp(i) = string_temp(i) + ' ';
            end
            string_temp(i) = string_temp(i) + str_var(i);
        elseif (alignments(i) == 'c') then
            right_space = int(((line_size-5)/2+1-length(str_var(i)))/2);
            left_space = (line_size-5)/2+1-length(str_var(i))-right_space;
            for k=1:left_space
                string_temp(i) = string_temp(i) + ' ';
            end 
            string_temp(i) = string_temp(i) + str_var(i);
            for k=1:right_space
                string_temp(i) = string_temp(i) + ' ';
            end
        end
        string_temp(i) = string_temp(i) + '  ';
    end

    // Adding both parts
    if (frame=='y') then
        string_print = string_print + string_temp(1) + '█' + string_temp(2) + '█\n';
    elseif (frame=='n') then
        string_print = string_print + string_temp(1) + ' ' + string_temp(2) + '█\n';
    end

    printf(string_print);
endfunction


//  USER INTERFACE FUNCTIONS GROUP
//  ------------------------------
//  
//  A compilation of functions created to print in the console the main parts of the user interface
//
//
//  NO TEXT FUNCTIONS
//  -----------------
//  Its only purpose is to serve as a graphic part of the UI
function [] = ui_top();
    printf("  ██▀"+strcat(emptystr(1,line_size+2)+"▀")+"▀██\n");
endfunction

function [] = ui_bottom();
    printf("  ██▄"+strcat(emptystr(1,line_size+2)+"▄")+"▄██\n");
endfunction

function [] = ui_section();
    printf("  ██▬"+strcat(emptystr(1,line_size+2)+"▬")+"▬██\n"); //▬
endfunction

function [] = ui_2section();
    printf("  ██▬"+strcat(emptystr(1,(line_size-5)/2+1)+"▬")+"▬███▬"+strcat(emptystr(1,(line_size-5)/2+1)+"▬")+"▬██\n");
endfunction
  
function [] = ui_2bottom();
    printf("  ██▄"+strcat(emptystr(1,(line_size-5)/2+1)+"▄")+"▄███▄"+strcat(emptystr(1,(line_size-5)/2+1)+"▄")+"▄██\n\n");
endfunction

function [] = loading_bar(x,n);
    percentage = string(int(100*x/n));
    number_symbol = int(42*x/n);
    symbol = '';
    for i=1:number_symbol
        symbol = symbol + '█';
    end
    str_var = symbol+' '+percentage+'%%';
    ui_top();
    ui_line("RUNNING SIMULATION...",'l');
    ui_section();
    ui_line(str_var,'l');
    ui_bottom();
endfunction