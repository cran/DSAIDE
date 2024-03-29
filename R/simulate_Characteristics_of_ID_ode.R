#' Characteristics of ID
#' 
#' @description A compartmental model with several different compartments: Susceptibles (S), Infected and Pre-symptomatic (P), Infected and Asymptomatic (A), Infected and Symptomatic (I), Recovered and Immune (R) and Dead (D)
#' 
#' @details The model tracks the dynamics of susceptible, presymptomatic, asymptomatic, symptomatic, recovered, and dead individuals. Susceptible (S) individuals can become infected by presymptomatic (P), asymptomatic (A), or infected (I) hosts. All infected individuals enter the presymptomatic stage first, from which they can become symptomatic or asymptomatic. Asymptomatic hosts recover within some specified duration of time, while infected hosts either recover or die, thus entering either R or D. Recovered individuals are immune to reinfection. This model is part of the DSAIDE R package, more information can be found there.
#' 
#' This code was generated by the modelbuilder R package.  
#' The model is implemented as a set of ordinary differential equations using the deSolve package. 
#' The following R packages need to be loaded for the function to work: deSolve. 
#' 
#' @param S : starting value for Susceptible : numeric
#' @param P : starting value for Presymptomatic : numeric
#' @param A : starting value for Asymptomatic : numeric
#' @param I : starting value for Symptomatic : numeric
#' @param R : starting value for Recovered : numeric
#' @param D : starting value for Dead : numeric
#' @param bP : rate of transmission from P to S : numeric
#' @param bA : rate of transmission from A to S : numeric
#' @param bI : rate of transmission from I to S : numeric
#' @param gP : rate at which a person leaves the P compartment : numeric
#' @param gA : rate at which a person leaves the A compartment : numeric
#' @param gI : rate at which a person leaves the I compartment : numeric
#' @param f : fraction of asymptomatic infections : numeric
#' @param d : fraction of symptomatic hosts that die : numeric
#' @param tstart : Start time of simulation : numeric
#' @param tfinal : Final time of simulation : numeric
#' @param dt : Time step : numeric
#' @return The function returns the output as a list. 
#' The time-series from the simulation is returned as a dataframe saved as list element \code{ts}. 
#' The \code{ts} dataframe has one column per compartment/variable. The first column is time.   
#' @examples  
#' # To run the simulation with default parameters:  
#' result <- simulate_Characteristics_of_ID_ode() 
#' # To choose values other than the standard one, specify them like this:  
#' result <- simulate_Characteristics_of_ID_ode(S = 2000,P = 2,A = 0,I = 0,R = 0,D = 0) 
#' # You can display or further process the result, like this:  
#' plot(result$ts[,'time'],result$ts[,'S'],xlab='Time',ylab='Numbers',type='l') 
#' print(paste('Max number of S: ',max(result$ts[,'S']))) 
#' @section Warning: This function does not perform any error checking. So if you try to do something nonsensical (e.g. have negative values for parameters), the code will likely abort with an error message.
#' @section Model Author: Andreas Handel, Alexis Vittengl
#' @section Model creation date: 2020-09-29
#' @section Code Author: generated by the \code{modelbuilder} R package 
#' @section Code creation date: 2021-07-19
#' @export 
 
simulate_Characteristics_of_ID_ode <- function(S = 1000, P = 1, A = 0, I = 0, R = 0, D = 0, bP = 0, bA = 0, bI = 0.001, gP = 0.1, gA = 0.1, gI = 0.1, f = 0, d = 0, tstart = 0, tfinal = 200, dt = 0.1) 
{ 
  ############################## 
  #Block of ODE equations for deSolve 
  ############################## 
  Characteristics_of_ID_ode_fct <- function(t, y, parms) 
  {
    with( as.list(c(y,parms)), { #lets us access variables and parameters stored in y and parms by name 
    #StartODES
    #Susceptible : Infection by presymptomatic : Infection by asymptomatic : Infection by symptomatic :
    dS_mb = -bP*S*P -bA*S*A -bI*S*I
    #Presymptomatic : Infection by presymptomatic : Infection by asymptomatic : Infection by symptomatic : Progression to asymtomatic stage : Progression to symptomatic stage :
    dP_mb = +bP*S*P +bA*S*A +bI*S*I -f*gP*P -(1-f)*gP*P
    #Asymptomatic : Progression to asymtomatic stage : Recovery of asymptomatic :
    dA_mb = +f*gP*P -gA*A
    #Symptomatic : Progression to symptomatic stage : Progression to death : Progression to recovery :
    dI_mb = +(1-f)*gP*P -d*gI*I -(1-d)*gI*I
    #Recovered : Recovery of asymptomatic : Recovery of symptomatic :
    dR_mb = +gA*A +(1-d)*gI*I
    #Dead : Death of Symptomatic :
    dD_mb = +d*gI*I
    #EndODES
    list(c(dS_mb,dP_mb,dA_mb,dI_mb,dR_mb,dD_mb)) 
  } ) } #close with statement, end ODE code block 
 
  ############################## 
  #Main function code block 
  ############################## 
  #Creating named vectors 
  varvec_mb = c(S = S, P = P, A = A, I = I, R = R, D = D) 
  parvec_mb = c(bP = bP, bA = bA, bI = bI, gP = gP, gA = gA, gI = gI, f = f, d = d) 
  timevec_mb = seq(tstart, tfinal,by = dt) 
  #Running the model 
  simout = deSolve::ode(y = varvec_mb, parms = parvec_mb, times = timevec_mb,  func = Characteristics_of_ID_ode_fct, rtol = 1e-12, atol = 1e-12) 
  #Setting up empty list and returning result as data frame called ts 
  result <- list() 
  result$ts <- as.data.frame(simout) 
  return(result) 
} 
