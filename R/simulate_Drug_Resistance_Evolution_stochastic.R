#' Drug Resistance Evolution
#' 
#' @description An SIR-type model that includes drug treatment and resistance.
#' 
#' @details The model includes susceptible, infected untreated, treated and resistant, and recovered compartments. The processes which are modeled are infection, treatment, resistance generation and recovery.
#' 
#' This code was generated by the modelbuilder R package.  
#' The model is implemented as a set of stochastic equations using the adaptivetau package. 
 
#' The following R packages need to be loaded for the function to work: adpativetau 
#' 
#' @param S : starting value for Susceptible : numeric
#' @param Iu : starting value for Infected Untreated : numeric
#' @param It : starting value for Infected Treated : numeric
#' @param Ir : starting value for Infected Resistant : numeric
#' @param R : starting value for Recovered : numeric
#' @param bu : untreated infection rate : numeric
#' @param bt : treated infection rate : numeric
#' @param br : resistant infection rate : numeric
#' @param gu : untreated recovery rate : numeric
#' @param gt : treated recovery rate : numeric
#' @param gr : resistant recovery rate : numeric
#' @param f : fraction treated : numeric
#' @param cu : resistance emergence untreated : numeric
#' @param ct : resistance emergence treated : numeric
#' @param tfinal : Final time of simulation : numeric
#' @param rngseed : set random number seed for reproducibility : numeric
#' @return The function returns the output as a list. 
#' The time-series from the simulation is returned as a dataframe saved as list element \code{ts}. 
#' The \code{ts} dataframe has one column per compartment/variable. The first column is time.   
#' @examples  
#' # To run the simulation with default parameters:  
#' result <- simulate_Drug_Resistance_Evolution_stochastic() 
#' # To choose values other than the standard one, specify them like this:  
#' result <- simulate_Drug_Resistance_Evolution_stochastic(S = 2000,Iu = 2,It = 2,Ir = 2,R = 0) 
#' # You can display or further process the result, like this:  
#' plot(result$ts[,'time'],result$ts[,'S'],xlab='Time',ylab='Numbers',type='l') 
#' print(paste('Max number of S: ',max(result$ts[,'S']))) 
#' @section Warning: This function does not perform any error checking. So if you try to do something nonsensical (e.g. have negative values for parameters), the code will likely abort with an error message.
#' @section Model Author: Andreas Handel
#' @section Model creation date: 2020-10-05
#' @section Code Author: generated by the \code{modelbuilder} R package 
#' @section Code creation date: 2021-07-19
#' @export 
 
simulate_Drug_Resistance_Evolution_stochastic <- function(S = 1000, Iu = 1, It = 1, Ir = 1, R = 0, bu = 0.002, bt = 0.002, br = 0.002, gu = 1, gt = 1, gr = 1, f = 0, cu = 0, ct = 0, tfinal = 100, rngseed = 123) 
{ 
  #Block of ODE equations for adaptivetau 
  Drug_Resistance_Evolution_fct <- function(y, parms, t) 
  {
    with(as.list(c(y,parms)),   
     { 
       #specify each rate/transition/reaction that can happen in the system 
     rates = c(gr*Ir, gt*It, gu*Iu, S*(1-f)*bt*(1-ct)*It, S*(1-f)*bu*(1-cu)*Iu, S*br*Ir, S*bt*ct*It, S*bu*cu*Iu, S*f*bt*(1-ct)*It, S*f*bu*(1-cu)*Iu)
     return(rates) 
      }
	 	)   
  } # end function specifying rates used by adaptive tau 

   #specify for each reaction/rate/transition how the different variables change 
  #needs to be in exactly the same order as the rates listed in the rate function 
  transitions = list(c(R = +1,Ir = -1), 
 	 	 				c(R = +1,It = -1), 
 	 	 				c(R = +1,Iu = -1), 
 	 	 				c(S = -1,Iu = +1), 
 	 	 				c(S = -1,Iu = +1), 
 	 	 				c(Ir = +1,S = -1), 
 	 	 				c(Ir = +1,S = -1), 
 	 	 				c(Ir = +1,S = -1), 
 	 	 				c(It = +1,S = -1), 
 	 	 				c(It = +1,S = -1)) 
 
  ############################## 
  #Main function code block 
  ############################## 
  set.seed(rngseed) #set random number seed for reproducibility 
  #Creating named vectors 
  varvec = c(S = S, Iu = Iu, It = It, Ir = Ir, R = R) 
  parvec = c(bu = bu, bt = bt, br = br, gu = gu, gt = gt, gr = gr, f = f, cu = cu, ct = ct) 
  #Running the model 
  simout = adaptivetau::ssa.adaptivetau(init.values = varvec, transitions = transitions,
                  	 	 	 rateFunc = Drug_Resistance_Evolution_fct, params = parvec, tf = tfinal) 
  #Setting up empty list and returning result as data frame called ts 
  result <- list() 
  result$ts <- as.data.frame(simout) 
  return(result) 
 }  
 