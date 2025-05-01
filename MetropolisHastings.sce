exec complements/FunctionsLibrary.sce; // All functions and initial values are contained in this script.
exec complements/UserInterface.sce;    // It stores the functions that compose the User Interface of the Program.
exec complements/HelpManager.sce;      // It manages the help menu and its functions.

//  -----------------------
//  | PROGRAM DESCRIPTION |
//  -----------------------
//
//  MetropolisHastings is a SciLab interactive program to illustrate the use of the Metropolis-
//  Hastings Algorithm in the finding of equations of state for a gas under the Lennard-Jones
//  potential and a gas of hard spheres.
//
//  The current program consist of an User Interface where the user has two cases to simulate.
//  For each case, the initial parameters can be modify to get different behaviours, but the
//  final results will be unique to the problem. The main goal of the program is to show variables
//  of the equation of state and how they evolve as we vary the parameters.
//

//  Main While Loop
while %T
    clc();
    main_menu();
    option = input("  Option: ");
    select option

    //  HELP
    case 1
        clc();
        help_manager();

    //  REAL GAS
    case 2
        clc();
        printf('\n');
        ui_top();
        ui_line('Case not available!','c')
        ui_bottom();
        printf('\n');
        exit_input = input('  Press any key to continue  ','string');

    //  HARD SPHERES
    case 3
        execution_time = '';
        while %T
            clc();
            hard_sphere_menu();
            if ~(execution_time=='') then
                ui_top();
                ui_line("Total time to execute: "+string(execution_time),"c");
                ui_bottom();
                printf("\n");
            end
            option = input("  Option: ");
            if and([option<=6,option>=1,~(option==[])]) then
                hard_sphere = check_conditions(option,hard_sphere,low_lim_hs,up_lim_hs);

                // This condition is essential as if the result of N**(1/f) is not an integer,
                // some values of (A/A0-1) can't never be reached and the program might fail
                // This is due to the calculus of nu from the fixed (A/A0-1) values, since for
                // small values, nu ~ log(1 - ceil(N**(1/f))/N**(1/f))
                if (option==1 | option==2) then
                    hard_sphere(1) = ceil(hard_sphere(1)**(1/hard_sphere(2)))**hard_sphere(2);
                end

            elseif (option==7) then
                hard_sphere = reset_hard_sphere(hard_sphere);

            elseif (option==8) then
                // tic();
                execution_time = hard_metropolis(hard_sphere);
                // execution_time = string(int(100*(toc()))/100.0);
            else
                break
            end
        end
    
    else
        break;
    end

end

quit 


// end