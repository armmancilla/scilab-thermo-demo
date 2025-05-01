//  ---------------------
//  | FUNCTIONS LIBRARY |
//  ---------------------
//  
//  Here are stored all the necessary functions and parameters to execute the main program.
//
//  The program execute simulations of particles of a gas under the Lennard-Jones potential and
//  particles belonging to a hard sphere gas. Both simulations rely on the Metropolis-Hastings
//  Algorithm. "Equation of State Calculations by Fast Computing Machines" (1953).
//
//  Each problem has a unique list object that stores all the parameters used for the simulation.
//
//
//  REAL GAS VARIABLES
//  ------------------
//
//
//             N   TEpp   Vpp   k   f
real_gas =    [20, 0.03, 3.0,  2.0, 1];

low_lim_rg =  [4,  0.01, 1.0,  1.0, 1];
up_lim_rg =   [200, 20.0, 10.0, 10,  10];

//  Reset variables
function [new_data] = reset_real_gas(real_gas);
    real_gas = [20, 0.03, 3.0, 2.0, 1];
    new_data = real_gas;
endfunction

//  Technical Properties
//  --------------------
//
//
tech_rg(1) = 20;            //  n: Number of data variations (Variation in thermal energy for MH), points in plot
tech_rg(2) = 64;            //  nc: Number of cycles of energy to average 
tech_rg(3) = 1.0;           //  Stepsize moved by the new position in 'propose_candidate()'
tech_rg(4) = 20;            //  ms: Number of bins of the histogram of distance between particles
tech_rg(5) = 5;             //  n_r0: Distance from the border in r0 units where the particles are not considered
                            //  in the histogram. This number is not used if periodic boundaries are actived
tech_rg(6) = 0;             //  pb: Periodic boundaries - (0): No, (1): Yes. This changes the calculation of the
                            //  Lennard-Jones Potential, as in the case without periodic boundaries the distance
                            //  between particles is taken as the difference of the position, whereas with periodic
                            //  boundaries, the minimum distance 

//                 n      nc      ss    ms   n_r0  pb
low_lim_tech_rg = [4,     16,    0.1,   2,   1,   0];
up_lim_tech_rg  = [100,  100000,  5.0,  100,  10,  1];

//  Reset technical properties
function [new_data] = reset_real_gas_tech(tech_rg)
    tech_rg = [20, 10000, 1.0, 20, 5, 0];
    new_data = tech_rg;
endfunction

//  HARD SPHERES VARIABLES
//  ----------------------
//  
//  The list of the Hard Sphere Variables is compound by 6 elements that are necessary for the
//  functionality of the simulation. The parameters control mainly the visual results we get from
//  the program, as in different cases similar dynamics can be appreciated.
//
//  hard_sphere
//    List of size = 6, containing all the editable information of the simulation. Its elements and
//    their lower and upper limits are:
//
//      * hard_sphere(1): N   - Number of particles. (Min: 4, Max: 400).
//      * hard_sphere(2): f   - Spatial Dimension. (Min: 1, Max: 5).
//      * hard_sphere(3): K   - Limit of diameters from where particles are considered for the
//                              histogram. (Min: 1.5, Max: 15).
//      * hard_sphere(4): nb  - Number of bins for the histogram. (Min: 8, Max: 80).
//      * hard_sphere(5): c   - Number of cycles to run the simulation (times all particles
//                              positions are updated). (Min: 16, Max: 64).
//      * hard_sphere(6): nu0 - Index of the case to plot. The final figure shows the histogram and
//                              the comparison between initial and final state. (Min: 1, Max: 8).
//  
//              N   f   K   nb  c   nu0
hard_sphere = [100, 2, 1.5, 64, 128,  4];

low_lim_hs =  [ 16,  1, 1.01, 8, 64,  1];
up_lim_hs =   [400, 5, 15.0,  80, 512,  8];

//  Variation of the diameters by the parameter 'nu': 'd0 = d(1-2^(nu-8))'
// nu_list = [1.38, 2.52, 3.63, 4.68, 5.61, 6.37, 6.93, 7.31]';
A_A0 = 0.02*exp(log(9.5/0.02)/7 .* linspace(0,7,8))';

function [new_data] = reset_hard_sphere(real_gas);
    hard_sphere = [100, 2, 1.5, 64, 128,  4];
    new_data = hard_sphere;
endfunction

// MAIN MENU SUBROUTINE SYNTAX
// main_menu()                              Prints the main menu options available.
function [] = main_menu() // Void Function
    printf("\n");
    ui_top();
    ui_line("MAIN MENU METROPOLIS-HASTINGS: TYPE AN OPTION",'c');
    ui_section();
    ui_line(" 1  : Help",'l');
    ui_line(" 2  : Real Gas", 'l');
    ui_line(" 3  : Hard Spheres", 'l');
    ui_line("Else: Quit program",'l');
    ui_bottom();
    printf("\n");
endfunction


function [] = real_gas_menu(real_gas) // Void Function
    printf("\n");
    ui_top();
    ui_line("REAL GAS: DATA SELECTION",'c');
    ui_section();
    ui_line(" 1  : N  - Number or particles",'l');
    ui_line("      Current value: "+string(real_gas(1)),'l');
    ui_line("",'l');
    ui_line(" 2  : Ep - Thermal energy per particle (kBT)", 'l');
    ui_line("      Current value: "+string(real_gas(2))+" [meV]",'l');
    ui_line("",'l');
    ui_line(" 3  : Vp - f-Volume of the well per particle", 'l');
    ui_line("      Current value: "+string(real_gas(3))+" [nm]",'l');
    ui_line("",'l');
    ui_line(" 4  : k  - 2k-k model of the LJ potential",'l');
    ui_line("      Current value: "+string(real_gas(4)),'l');
    ui_line("",'l');
    ui_line(" 5  : f - Spatial dimension",'l');
    ui_line("      Current value: "+string(real_gas(5)),'l');
    ui_section();
    ui_line(" 6  : Reset to default",'l');
    ui_line(" 7  : Run simulation",'l');
    ui_line(" 8  : Technical Adjustments Menu","l");
    ui_line("Else: Return",'l');
    ui_bottom();
    printf("\n");
endfunction



function [] = real_gas_tech_menu(tech_rg)
    printf("\n");
    ui_top();
    ui_line("REAL GAS: TECHNICAL ADJUSTMENTS",'c');
    ui_section();
    ui_line(" 1  : n  - Number of data variations",'l');
    ui_line("      Current value: "+string(tech_rg(1)),'l');
    ui_line("",'l');
    ui_line(" 2  : ns - Number of samples to average", 'l');
    ui_line("      Current value: "+string(tech_rg(2)),'l');
    ui_line("",'l');
    ui_line(" 3  : ss - Lenght of stepsize", 'l');
    ui_line("      Current value: "+string(tech_rg(3)),'l');
    ui_line("",'l');
    ui_line(" 4  : ms - Number of points for the histogram", 'l');
    ui_line("      Current value: "+string(tech_rg(4)),'l');
    ui_line("",'l');
    ui_line(" 5  : n_r0 - Distance from the border where",'l');
    ui_line("             particles are not considered","l");
    ui_line("      Current value: "+string(tech_rg(5)),'l');
    ui_line("",'l');
    ui_line(" 6  : pb - Periodic boundaries 0: No, 1: Yes",'l');
    ui_line("      Current value: "+string(tech_rg(6)),'l');
    ui_section();
    ui_line(" 7  : Reset to default",'l');
    ui_line("Else: Return",'l');
    ui_bottom();
    printf("\n");
endfunction



function [] = hard_sphere_menu(hard_sphere) // Void Function

    np = hard_sphere(1);
    dimension = hard_sphere(2);
    d = 1/ceil(np**(1/dimension));

    nu_list = int(10*(8 + log(1 - (1/d)*(1./(np*(A_A0+1))).**(1/dimension))/log(2)))/10;

    printf("\n");
    ui_top();
    ui_line("HARD SPHERES: DATA SELECTION",'c');
    ui_section();
    ui_line(" 1  : N  - Number or particles",'l');
    ui_line("      Current value: "+string(hard_sphere(1)),'l');
    ui_line("",'l');
    ui_line(" 2  : f  - Spatial dimension", 'l');
    ui_line("      Current value: "+string(hard_sphere(2)),'l');
    ui_line("",'l');
    ui_line(" 3  : K  - Diameters of measurement",'l');
    ui_line("      Current value: "+string(hard_sphere(3)),'l');
    ui_line("",'l');
    ui_line(" 4  : nb - Number of bins for histogram",'l');
    ui_line("      Current value: "+string(hard_sphere(4)),'l');
    ui_line("",'l');
    ui_line(" 5  : c - Cycles of simulation",'l');
    ui_line("      Current value: "+string(hard_sphere(5)),'l');
    ui_line("",'l');
    ui_line(" 6  : nu0 - Index of nu to plot",'l');
    ui_line("      1: "+string(nu_list(1))+",  2: "+string(nu_list(2))+",  3: "+string(nu_list(3))+",  4: "+string(nu_list(4)),'l');
    ui_line("      5: "+string(nu_list(5))+",  6: "+string(nu_list(6))+",  7: "+string(nu_list(7))+",  8: "+string(nu_list(8)),'l');
    ui_line("      Current value: "+string(hard_sphere(6))+" (nu - "+string(nu_list(hard_sphere(6)))+")",'l');
    ui_section();
    ui_line(" 7  : Reset to default",'l');
    ui_line(" 8  : Run simulation",'l');
    ui_line("Else: Return",'l');
    ui_bottom();
    printf("\n");
endfunction



//  CONDITIONS CHECK
//  ----------------
//
//  Prevents the user from breaking the program when assigning a new value to a parameter. It feeds
//  on the limits list of the problem and returns the new variable inside the rigth range. If the
//  input is inside the limits, is allowed, otherwise it will return the limit quantity of the
//  parameter depending if its higher of lower.
//
//  SYNTAX
//    new_data = check_conditions(option,problem_list,lower_limit,upper_limit)
//
//  ARGUMENTS
//    new_data
//      List containing the change in the parameter
//
//    option
//      Index of the parameter to change inside the problem_list
//
//    problem_list
//      List containing all parameters to run the simulation
//
//    lower_limit
//      Corresponding list with the minimum accepted values to run the simulation
//
//    upper_limit
//      Corresponding list with the maximum accepted values to run the simulation
//
function [new_data] = check_conditions(option,real_gas,low_lim,up_lim)
    temp = input("  Write new value (between "+string(low_lim(option))+" and "+string(up_lim(option))+"): ");
    if and([temp>=low_lim(option),temp<=up_lim(option),~(temp==[])]) then
        real_gas(option) = temp;
    elseif and([temp>up_lim(option),~(temp==[])]) then
        real_gas(option) = up_lim(option);
    elseif and([temp<low_lim(option),~(temp==[])]) then
        real_gas(option) = low_lim(option);
    else
        break;
    end
    new_data = real_gas;
endfunction



//  SETTING PARAMETERS FOR THE REAL GAS
//  -----------------------------------
//
//  Stablishes the value of the default parameters used for the gas under the
//  Lennard-Jones potential simulation
//
//  SYNTAX
//    setparams()
//
function setparams()  //  Void
    global('reps', 'srep', 'r0', 'eps0');
    reps= 100;              // Number of repetitions, or sample size
    srep= 100;              // Sample size
 
    r0= 0.3;                // Interaction potential:
    eps0= 0.03;             // Vint(r)= eps0 * [ (r0/r)^(2k) - 2* (r0/r)^k ]

    h = 4.136*10^-12        // Planck constant in [meV]
endfunction



//  HAMILTONIAN OF A GAS WITH LENNARD-JONES POTENTIAL
//  -------------------------------------------------
//
//  Calculates the result of the Hamiltonian of the system
//
//  SYNTAX
//    result = Hpot_rg(X)
//
//  ARGUMENTS
//    result
//      Scalar of Energy of the current state of the system due to the Lennard-Jones Potential
//
//    X
//      Matrix of the current positions of the particles
//
function [y]= Hpot_rg(xa)
    ya = zeros(np,np);
    choice1 = zeros(np,np);
    choice2 = zeros(np,np);
    for i=1:dimension
        // Calculation of the distance with periodic boundaries
        choice1 = (side-abs(xa(:,i)*ones(xa(:,i))'-ones(xa(:,i))*xa(:,i)')).^2;
        // Calculation of the distance in a box
        choice2 = (xa(:,i)*ones(xa(:,i))'-ones(xa(:,i))*xa(:,i)').^2;

        // If there are periodic boundaries (pb)
        if (pb==1) then
            ya = ya + min(ya,ya_pb);
        else
            ya = ya + choice2;
        end
    end

    // Calculating the Lennard-Jones Potential
    mdf= abs(r0./(sqrt(ya) + r0*eye(ya))).^kpa;
    y= 0.5*eps0 * (sum( mdf.^2 - 2.0 * mdf) + np);
endfunction



//  PROPOSING A NEW CANDIDATE FOR THE POSITION
//  ------------------------------------------
//
//  Generates a posible new position for a random particle j
//
//  SYNTAX
//    [xp,j] = propose_candidate_rg(X)
//
//  ARGUMENTS
//    xp
//      Matrix of the positions containing the new position
//
//    j
//      Random index of the particle whose position was updated
//
//    X
//      Matrix of the current positions of the particles
//
function [xp,j] = propose_candidate_rg(x);
    j= grand('uin',1,np);
    xp = x;
    xp(j,:)= xp(j,:) + stepsize*grand(1,dimension,'nor',0,1);
endfunction



//  PROPOSING A NEW CANDIDATE FOR THE POSITION
//  ------------------------------------------
//
//  Generates a matrix Nxf (particles x dimension) of the initial positions of the particles in the
//  system, equally spaced. The function locates the nearest upper limit 'm^f >= N^f' to scatter
//  the particles and arrange them in rows of 'm' until it reaches 'N'.
//
//  SYNTAX
//    [X0] = initial_state()
//
//  ARGUMENTS
//    X0
//      Resulting matrix with the initial positions
//
function x0 = initial_state();
    n1 = ceil(np**(1/dimension));

    x0 = zeros(np,dimension);

    repetition = 0;
    for i=1:dimension
        k = 1;
        for ii=1:np
            x0(ii,i) = (k-1)/n1;
            if (i==1 | modulo(ii,repetition)==0) then
                if (k==n1) then
                    k = 1;
                else
                    k = k+1;
                end
            end
        end
        repetition = n1**(i);
    end
endfunction



//  ------------------------------------
//  | HARD SPHERE METROPOLIS FUNCTIONS |
//  ------------------------------------
//
//
//  Periodic Boundaries
//  -------------------
//
//  
//
function y= mymod(x)   // For the periodic boundary conditions
    y = x - floor(x);
endfunction


//  PROPOSING A NEW CANDIDATE FOR THE POSITION
//  ------------------------------------------
//
//  Generates a posible new position for a particle j
//
//  SYNTAX
//    [xp] = propose_candidate_rg(X,j)
//
//  ARGUMENTS
//    xp
//      Matrix of the positions containing the new position
//
//    j
//      Index of the particle whose position was updated
//
//    X
//      Matrix of the current positions of the particles
//
function xp = propose_candidate_hs(x,j);
    xp = x;
    // Random step with Normal Distribution
    xp(j,:) = xp(j,:) + stepsize*grand(1,dimension,'nor',0,1);

    // Assuring the step is inside the cell
    for ii=1:dimension
        xp(j,ii) = mymod(xp(j,ii));
    end
endfunction



//  VALIDATION OF ALL POSITIONS
//  ---------------------------
//
//  Checks if all the positions are valid (no particles are overlapped)
//
//  SYNTAX
//    check = is_valid_all(X)
//
//  ARGUMENTS
//    check
//      Boolean scalar with the result
//
//    X
//      Matrix of the current positions of the particles
//
function check = is_valid_all(x)
    temp = zeros(np,np)
    for i=1:dimension
        temp = temp + (x(:,i)*ones(1,np)-ones(np,1)*x(:,i)').^2;
    end
    check = sum(int(min(1,sqrt(temp)/d0))) == (np^2 - np);
endfunction



//  VALIDATION OF ONE POSITION
//  --------------------------
//
//  Checks if a particle is not overlapped with any other
//
//  SYNTAX
//    check = is_valid(X)
//
//  ARGUMENTS
//    check
//      Boolean scalar with the result
//
//    j
//      Index of the particle to check
//
//    X
//      Matrix of the current positions of the particles
//
function check = is_valid(xp,j)
    if (and([xp(j,1)<1,xp(j,1)>0])) then
        temp = zeros(np, 1)
        for i = 1:dimension
            temp = temp + (xp(:,i) - xp(j,i)).^2
        end
        check = (sum(int(min(1,sqrt(temp)/d0)))) == (np-1);
    else
        check = %F;
    end
endfunction



//  DISTANCE BETWEEN ALL PARTICLES
//  ------------------------------
//
//  Calculates the current minimal distance between all particles
//
//  SYNTAX
//    dis = distance(X)
//
//  ARGUMENTS
//    dis
//      NxN matrix with the minimal distance for N particles. Cells contain the distance Dij, note
//      that Distance Dij = Dji, and Dii = 0. Therefore, there are only (N^2 - N)/2 valid distances
//
//    X
//      Matrix of the current positions of the particles
//
function dis = distance(x)
    dis = zeros(np,np);
    for i=1:dimension
        choice_1 = 1 - abs(x(:,i)*ones(1,np)-ones(np,1)*x(:,i)');
        choice_2 = abs(x(:,i)*ones(1,np)-ones(np,1)*x(:,i)');
        dis = dis + min(choice_1,choice_2).^2;
    end
    dis = sqrt(dis);
endfunction



//  FITTING FUNCTIONS
//  -----------------
//
//  The Histogram data behaves as an exponential function, so we make a Fit to find the value
//  of -N(1/2). The fit uses two functions: FF(x,p), which returns the values of the theoretical
//  function, and myfunc(p,x,data,w), that returns the error between data and the theory
//
//  ARGUMENTS
//    x
//      Vector of points where the function is defined
//
//    p
//      Parameters of the exponential function: p(1)*exp(-p(2)*x)
//
//    y
//      Theoretical values of the function to fit
//
//    data
//      Experimental values
//
//    w
//      In case the function is weighted, w represents the weights at the point x
//
function y = FF(x,p)
    //  Exponential function
    y = p(1).*exp(-p(2).*x);
endfunction

function e=myfun(p,x,data,w)
    //  Error between data and fit
    e = w.*(FF(x,p) - data)
 endfunction


//  HARD SPHERES SIMULATION USING METROPOLIS-HASTINGS ALGORITHM
//  -----------------------------------------------------------
//
//  A function that runs the simulation of a hard sphere gas using the Metropolis-Hastings
//  Algorithm. It returns three plots: an evolution of (PV/NkT - 1) when varying the diameter
//  of the particles, measure with (A/A0 - 1), the histogram of a case previously selected by the
//  user (for a specific value of the diameter), and an illustration of the effect of the method in
//  the initial positions of the particles
//
//  PHYSICAL UNDERSTANDING AND JUSTIFICATION
//  ----------------------------------------
//
//  This program is based in the article by Metropolis N. et al. "Equation of State Calculations by
//  Fast Computing Machines" (1953). The Journal of Chemical Physics. Here, they show it is
//  possible to find properties of the Equation of State using computational simulations of
//  hard spheres particles in a cell employing a novel algorithm in order to reach the
//  configuration of minimal energy of the system.
//
//  The main variable that governs the behavior of the system is the diameter of the particles.
//  The particles are located inside a cell of length 1, with periodic boundaries so that one can
//  assume the particles exists in all other cells and the effects of the borders of the box are 
//  minimized. The particles positions change over time simulating real motion of particles in a
//  gas, just one by one. After each move, we measure the distances between particles within a
//  volume with radius of 1.5 diameters, the argument behind this decision is clarified in the
//  article, where they state that most of the pairs of particles at a distance lower than this
//  value will collide in the next update. Also, a larger zones may need a better resolution to
//  recognize the effects of the radial distribution function, but it would increase rapidly the
//  time to run the simulation. The radial distribution is used to calculate the value of the
//  equation of state variables in the form (PV/NkT - 1), according to the article, an average
//  value can be approximated with the expression (64[-N(1/2)]/(N^2(K^2-1))) and doing the same
//  for different values of the diameter of the particles, one can obtain results of the general
//  behavior of the system and even compared it to theoretical results given by the free volume
//  theory.
//
//  For the simulations, we fixed the size of the initial diameter (d) respect to the size of the
//  cell, according to the total number of particles we find the number 'n' of particles that can
//  stacked in one of the axis so that the initial diameter is set to 1/(n+1), leaving just enough
//  space between particles to do the simulation but assuring they will meet eventually to get a
//  better result of the radial distribution. With the initial diameter defined, we vary the
//  diameter (d0) of the current case as 'd0 = d(1-2^(nu-8))', being 'nu' a parameter of control
//  which values can be from 0 to 7, so 'd0' vary from '~d' to 'd/2'. As in the article, we choose
//  8 cases of 'nu': 2, 4, 5, 5.5, 6, 6.25, 6.5 and 7.
//
//  For the program simulation, we initially arrange N particles in a cell, equally spaced one from
//  another and let the system evolve. A particle is selected sequentially to make a random step
//  according to a unitary normal distribution, multiplied by a step-length '(d-d0)', suggested by
//  the article. If the new position of the particle does not overlap any other particle's
//  position, this new position is accepted and the radial distribution is measure. We consider a
//  cycle when N iterations have been made, whether resulting in new positions accepted or not. The
//  measurements of the radial distribution were only consider after 8 cycles, to let the system
//  evolve sufficiently from the initial setup. The radial distribution presents an oscillatory
//  behavior that can be appreciated for lower values of 'nu', however the initial decrease of the
//  functions acts as an exponential which we can fit in order to obtain the results of '-N(1/2)'.
//
//
//  COMPUTATIONAL METHODOLOGY
//  -------------------------
//  
//  We extract the parameters from the list 'hard_sphere(i)' and generate the initial positions as
//  well as variables of the 'nu' case such as the 'd0' and 'dA', the sections of equal volume
//  where we look for particles near to others, defined as 'dA = (K^2 - 1)*%pi*d0^2/n_bins'. After
//  the lists for the histogram have been created (bins and values lists), we start the simulation
//  of the Metropolis algorithm, proposing the candidate for new positions and if this is valid and
//  we are beyond 8 cycles, we generate a matrix of distances between all particles and use them to
//  find occurrences in the ranges of the bins of the histogram. We divide such occurrences by 2,
//  since the matrix is symmetrical and 'Dij = Dji'.
//  Once the simulation has ended, the fitting functions are fed with the values obtained from the
//  histogram to get the parameters to find '-N(1/2)' and with it, calculate the equation state
//  '(PV/NkT - 1)' as a function of the proportion '(A/A0)-1', where 'A0' is the minimum area (or
//  volume) in which the particles can be arrange in the cell of area 'A=1'.
//  Finally, all the results provided by the program will be shown in 3 plots. The first compares
//  the evolution of the equation state for different values of 'd0', the second shows the
//  histogram for an specific case of 'nu' with its fitting function and the last one is an
//  illustrative figure of the change in the initial and final state.
//
function [execution_time] = hard_metropolis(hard_sphere)

    tic();

    // Random Seed
    grand('setsd',round(getdate('s')));
    
    // Setting parameters
    np = hard_sphere(1);
    dimension = hard_sphere(2);
    K = hard_sphere(3);
    n_bins = hard_sphere(4);
    cycles = hard_sphere(5);
    inu_0 = hard_sphere(6);

    L = 1.0;  // Length of the box
    ns = cycles*np;
    cycles_start = 48;
    areas_bins = (1.5:1:n_bins+0.5)';  // Bins of the histogram
    p0 = [1000;0.02];  // Initial guess for fitting
    d = 1/(ceil(np^(1/dimension)));        // Initial diameter of the particles

    x0 = initial_state();

    PANkT = zeros(8,1);
    A0 = zeros(8,1);

    nu_list = (8 + log(1 - (1/d)*(1./(np*(A_A0+1))).**(1/dimension))/log(2));

    for i=1:8
        x = x0;
        nu = nu_list(i);  // Setting the nu for the case
    
        d0 = d*(1-2^(nu-8));
        stepsize = d*(2^(nu-8)); // (d - d0);
        dA = (K^2 - 1)*d0^dimension*(%pi^(dimension/2)/gamma(dimension/2 + 1))/n_bins;
    
        temp_hist = zeros(n_bins,1);
        temp_vals = ((%pi^(dimension/2)/gamma(dimension/2 + 1))*d0^dimension:dA:dA*n_bins+ ..
                    (%pi^(dimension/2)/gamma(dimension/2 + 1))*d0^dimension)';
    
    
        nval = 0;
        j = 1;
        for ii=1:ns
    
            j = int(np*rand())+1;
            xp = propose_candidate_hs(x,j);
            if is_valid(xp,j) then
                x = xp;
                nval = nval + 1;
            end
    
            if ((ii>cycles_start*np) && (modulo(ii,np) == 0)) then
                dis = (%pi^(dimension/2)/gamma(dimension/2 + 1))*distance(x).^dimension;
                [ind, occs] = dsearch(dis,temp_vals);
                temp_hist = temp_hist + occs/(cycles-cycles_start);
            end
    
            //  Increasing index of particle to move
            // j = j - np*floor(j/np) + 1;

            //  Loading Bard Section (Calling it every 1%)
            if (modulo((i-1)*ns+ii,int(ns*8/100)) == 0) then
                disp(" ");
                clc();
                printf('\n');
                loading_bar((i-1)*ns+ii,ns*8);
            end

        end
    
        // Fit
        wm = ones(temp_hist);
        [f,p,gopt] = leastsq(list(myfun,(areas_bins-0.5),np*temp_hist,wm),p0);
    
        // PANkT(i) = dimension/2 - 1 + dimension*%pi*d0^2*(p(1)*exp(-p(2)*0.5))/(dA*2*np^2);

        PANkT(i) = n_bins*(p(1)*exp(-p(2)*0.5))/np^2/(K^2-1);
        A0(i) = 1/(np*(d*(1-2**(nu-8)))**2) - 1;
    
        // Saving data to plot case
        if (i==inu_0) then
            areas_hist = np*temp_hist;
            areas_vals = temp_vals;
            xf = x;
            pf = p;
        end
    end

    Fit = pf(1)*exp(-pf(2)*(areas_bins-0.5));

    marker_size = int(50*d*(1-2^(nu_list(inu_0)-8))/0.2);

    A_A0_theorical = linspace(0.02,6,100);
    PANkT_theo = 2./A_A0_theorical;

    subplot(1,3,1);
    plot2d('ll',[20],[200]);
    PANkT_data = scatter(A_A0,PANkT,20,'.');
    PANkT_data.mark_style = 0;
    PANkT_data.mark_size = 7;
    PANkT_data.mark_foreground = color(70,85,125);

    FVGT = plot(A_A0_theorical,PANkT_theo,'k--');
    FVGT.foreground = 1;
    FVGT.line_style = 3;
    FVGT.thickness = 2;

    ylabel('$\frac{PV}{NkT}-1$','fontsize',3); xlabel('$\frac{V}{V_{0}}-1$','fontsize',3);
    ax = gca();
    ax.data_bounds = [0.01, 0.1; 10, 100];

    subplot(1,3,2);
    HIST_data = scatter(areas_bins,areas_hist,10,'fill');
    HIST_data.mark_style = 5;
    HIST_data.mark_size = 5;
    HIST_data.mark_foreground = 1;
    HIST_data.mark_background = 0;
    HIST_data.thickness = 1.5;

    FIT_plot = plot(areas_bins,Fit);
    FIT_plot.line_style = 3;
    FIT_plot.thickness = 3;
    FIT_plot.foreground = color(70,85,125);

    ylabel('$\bar{N}$','fontsize',3); xlabel('$m\Delta V^2$','fontsize',3);
    // plot2d(areas_bins,Fit1);
    ax = gca();
    // ax.data_bounds = [0, 0; n_bins, 14*10^3];

    subplot(1,3,3);

    if (dimension == 1) then
        poly0 = scatter(x0(:,1),ones(x0(:,1))-0.5);
        poly1 = scatter(xf(:,1),ones(xf(:,1))-0.5);
    else
        poly0 = scatter(x0(:,1),x0(:,2));
        poly1 = scatter(xf(:,1),xf(:,2));
    end
    poly0.mark_size_unit = 'point';
    poly0.mark_size = marker_size;
    poly0.mark_foreground = color(212,222,246);
    poly0.thickness = 1.5;

    poly1.mark_size_unit = 'point';
    poly1.mark_size = marker_size;
    poly1.mark_foreground = color(215,42,42);
    poly1.thickness = 1.5;

    ylabel('$y$','fontsize',3); xlabel('$x$','fontsize',3);
    legend(['Initial','Final']);
    // scatter([d0/2,3*d0/2,5*d0/2],[d0/2,d0/2,d0/2],marker_size,'yellow');
    ax = gca();
    ax.data_bounds = [0, 0; 1, 1];

    f=get("current_figure") //get the handle of the current figure :
                            //if none exists, create a figure and return the corresponding handle
    // f.figure_position;
    f.figure_size=[1100,490];

    execution_time = string(int(100*(toc()))/100.0);

endfunction