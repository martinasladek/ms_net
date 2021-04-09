r_from_d <- function(d){
  
  # if n1 and n2 are not known precisely, use n1 = 2 and n2 = 2
  
  #a = ((n1 + n2)^2)/n1*n2
  
  a = 4
  
  return(
    
    d/sqrt(d^2 + a)
    
  )
  
}
