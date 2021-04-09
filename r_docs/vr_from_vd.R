vr_from_vd <- function(d, vd){
  
  # if n1 and n2 are not known precisely, use n1 = 2 and n2 = 2
  
#  a = (n1 + n2)^2/n1*n2
  
  a = 4
  
  return(
    
    (a^2)*vd/(d^2 + a)^3
    
  )
  
}