mu <- function(G, delta, xi){
  
  ## if the network is weighted set the correct attribute, else set it at 1
  if(!is.null(E(G)$weight))
    G <- set_edge_attr(G, "value", value = E(G)$weight) else
      G <- set_edge_attr(G, "value", value = 1)
  
  ## network diameter
  diametro <- diameter(G)
  
  ## compute all the simple paths
  all_path <- list()
  for(i in 1:length(V(G)))
    all_path <- append(all_path, all_simple_paths(G, from = i, mode = "out"))
  max_path_lenght <- max(sapply(all_path, length)) - 1
  
  ## longest path
  max_path_lenght <- max(sapply(all_path, length)) - 1
  
  ## compute the values for the path from i0
  xi_s <- vector(mode = 'list', length = length(all_path))
  for(i in 1:length(all_path)){
    appo <- xi
    for(j in 1:(length(all_path[[i]][]) - 1))
      appo <- c(appo, E(G, P = c(all_path[[i]][j], all_path[[i]][j + 1]))$value)
    xi_s[[i]] <- as.vector(appo)
    for(j in 2:length(xi_s[[i]][]))
      xi_s[[i]][j] <- (xi_s[[i]][j - 1] + xi_s[[i]][j]) * delta
  }
  
  # compute all the paths of lenght k
  cammini_totali <- matrix(0, 1, max_path_lenght)
  for(k in 1:max_path_lenght)
    cammini_totali[k] <- length(which(sapply(all_path, length) == k + 1))
  
  # check if all paths were considered
  if(sum(cammini_totali) != length(all_path))
    print("ERRORE")
   
  #first setting for gamma
  gamma <- matrix(1, 1, max_path_lenght)
  
  #second setting for gamma  
  #gamma <- matrix(1, 1, max_path_lenght)
  #appo <- 2 ^ (1:ceiling(length(gamma)/2))
  #gamma[(ceiling(length(gamma)/2) + 1):length(gamma)] <- appo[1:ceiling(length(gamma)/2)]
  
  #third setting for gamma
  #gamma <- matrix(1, 1, max_path_lenght)
  #appo <- 2 ^ (ceiling(length(gamma)/2):1)
  #gamma[1:(ceiling(length(gamma)/2))] <- appo[1:ceiling(length(gamma)/2)]
  
  #gamma <- 2 ^ ((max_path_lenght - 1):0) #sequenza geometrica
  
  #first setting for theta
  theta <- matrix(1/max_path_lenght, 1, max_path_lenght)
  
  #second setting for theta
  #theta <- 1/(2 ^ (1:(max_path_lenght - 1)))
  #theta <- c(theta, theta[length(theta)])
  
  #third setting for theta
  #theta <- 1/(2 ^ (1:(max_path_lenght - 1)))
  #theta <- c(theta, theta[length(theta)])
  #theta <- rev(theta)
  
  #compute mu
  cammini_pc <- matrix(0, 1, max_path_lenght)
  for(k in 1:max_path_lenght){
    appo <- which(sapply(all_path, length) == k + 1)
    conto_cammini <- 0
    for(i in appo)
      if(all(xi_s[[i]][-1] >= gamma[1:k], TRUE))
        conto_cammini <- conto_cammini + 1
    cammini_pc[k] <- conto_cammini
  }
  
  return(sum(theta * (cammini_pc / cammini_totali)))
  
}
