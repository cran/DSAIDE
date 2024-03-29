#' Environmental Transmission model
#' 
#' @description An SIR model including environmental transmission
#' 
#' @details The model includes susceptible, infected, recovered and environmental pathogen compartments. Infection can occur through direct contact with infected or through contact with pathogen in the environment. Infected individuals shed into the environment, pathogen decays there.
#' 
#' This code was generated by the modelbuilder R package.  
#' The model is implemented as a set of ordinary differential equations using the deSolve package. 
#' The following R packages need to be loaded for the function to work: deSolve. 
#' 
#' @param S : starting value for Susceptible : numeric
#' @param I : starting value for Infected : numeric
#' @param R : starting value for Recovered : numeric
#' @param P : starting value for Pathogen in environment : numeric
#' @param bI : direct transmission rate : numeric
#' @param bP : environmental transmission rate : numeric
#' @param n : birth rate : numeric
#' @param m : natural death rate : numeric
#' @param g : recovery rate : numeric
#' @param q : rate at which infected hosts shed pathogen into the environment : numeric
#' @param c : rate at which pathogen in the environment decays : numeric
#' @param tstart : Start time of simulation : numeric
#' @param tfinal : Final time of simulation : numeric
#' @param dt : Time step : numeric
#' @return The function returns the output as a list. 
#' The time-series from the simulation is returned as a dataframe saved as list element \code{ts}. 
#' The \code{ts} dataframe has one column per compartment/variable. The first column is time.   
#' @examples  
#' # To run the simulation with default parameters:  
#' result <- simulate_Environmental_Transmission_model_ode() 
#' # To choose values other than the standard one, specify them like this:  
#' result <- simulate_Environmental_Transmission_model_ode(S = 2000,I = 2,R = 0,P = 0) 
#' # You can display or further process the result, like this:  
#' plot(result$ts[,'time'],result$ts[,'S'],xlab='Time',ylab='Numbers',type='l') 
#' print(paste('Max number of S: ',max(result$ts[,'S']))) 
#' @section Warning: This function does not perform any error checking. So if you try to do something nonsensical (e.g. have negative values for parameters), the code will likely abort with an error message.
#' @section Model Author: Andreas Handel
#' @section Model creation date: 2020-12-01
#' @section Code Author: generated by the \code{modelbuilder} R package 
#' @section Code creation date: 2021-07-19
#' @export 
 
simulate_Environmental_Transmission_model_ode <- function(S = 1000, I = 1, R = 0, P = 0, bI = 0.004, bP = 0, n = 0, m = 0, g = 2, q = 0, c = 0, tstart = 0, tfinal = 60, dt = 0.1) 
{ 
  ############################## 
  #Block of ODE equations for deSolve 
  ############################## 
  Environmental_Transmission_model_ode_fct <- function(t, y, parms) 
  {
    with( as.list(c(y,parms)), { #lets us access variables and parameters stored in y and parms by name 
    #StartODES
    #Susceptible : births : natural death : direct infection : environmental infection :
    dS_mb = +n -m*S -bI*I*S -bP*P*S
    #Infected : direct infection : environmental infection : natural death : recovery of infected :
    dI_mb = +bI*I*S +bP*P*S -m*I -g*I
    #Recovered : recovery of infected : natural death :
    dR_mb = +g*I -m*R
    #Pathogen in environment : shedding by infected : decay :
    dP_mb = +q*I -c*P
    #EndODES
    list(c(dS_mb,dI_mb,dR_mb,dP_mb)) 
  } ) } #close with statement, end ODE code block 
 
  ############################## 
  #Main function code block 
  ############################## 
  #Creating named vectors 
  varvec_mb = c(S = S, I = I, R = R, P = P) 
  parvec_mb = c(bI = bI, bP = bP, n = n, m = m, g = g, q = q, c = c) 
  timevec_mb = seq(tstart, tfinal,by = dt) 
  #Running the model 
  simout = deSolve::ode(y = varvec_mb, parms = parvec_mb, times = timevec_mb,  func = Environmental_Transmission_model_ode_fct, rtol = 1e-12, atol = 1e-12) 
  #Setting up empty list and returning result as data frame called ts 
  result <- list() 
  result$ts <- as.data.frame(simout) 
  return(result) 
} 
