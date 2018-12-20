mu <- function(G, delta, xi){
  
  ## se il grafo è pesato poni in value i valori di weight, else poni a 1
  if(!is.null(E(G)$weight))
    G <- set_edge_attr(G, "value", value = E(G)$weight) else
      G <- set_edge_attr(G, "value", value = 1)
  
  ## calcolo il diametro del grafo
  diametro <- diameter(G)
  
  ## calcolo tutti i simple path sul grafo
  all_path <- list()
  for(i in 1:length(V(G)))
    all_path <- append(all_path, all_simple_paths(G, from = i, mode = "out"))
  max_path_lenght <- max(sapply(all_path, length)) - 1
  
  ## calcolo la lunghezza del cammino più lungo
  max_path_lenght <- max(sapply(all_path, length)) - 1
  
  ## calcolo i valori del cammino, dove il primo elemento della lista è i0 e ha epsilon0 == epsilon
  xi_s <- vector(mode = 'list', length = length(all_path))
  for(i in 1:length(all_path)){
    appo <- xi
    for(j in 1:(length(all_path[[i]][]) - 1))
      appo <- c(appo, E(G, P = c(all_path[[i]][j], all_path[[i]][j + 1]))$value)
    xi_s[[i]] <- as.vector(appo)
    for(j in 2:length(xi_s[[i]][]))
      xi_s[[i]][j] <- (xi_s[[i]][j - 1] + xi_s[[i]][j]) * delta
  }
  
  # calcolo tutti i cammini per le diverse lunghezze k
  # ATTENZIONE: nella cella 1 ci sono il numero di cammini da i0 a i1
  
  cammini_totali <- matrix(0, 1, max_path_lenght)
  for(k in 1:max_path_lenght)
    cammini_totali[k] <- length(which(sapply(all_path, length) == k + 1))
  
  # controllo se tutti i cammini sono stati considerati
  if(sum(cammini_totali) != length(all_path))
    print("ERRORE")
  #primo modo di settare gamma
  ## creo i vettori per la formula di mu
  #gamma <- matrix(1, 1, max_path_lenght)
  
  #secondo modo di settare gamma  
  gamma <- matrix(1, 1, max_path_lenght)
  appo <- 2 ^ (1:ceiling(length(gamma)/2))
  gamma[(ceiling(length(gamma)/2) + 1):length(gamma)] <- appo[1:ceiling(length(gamma)/2)]
  
  #terzo modo di settare gamma
  #gamma <- matrix(1, 1, max_path_lenght)
  #appo <- 2 ^ (ceiling(length(gamma)/2):1)
  #gamma[1:(ceiling(length(gamma)/2))] <- appo[1:ceiling(length(gamma)/2)]
  
  #gamma <- 2 ^ ((max_path_lenght - 1):0) #sequenza geometrica
  
  #primo modo di settare theta
  theta <- matrix(1/max_path_lenght, 1, max_path_lenght)
  
  #secondo modo di settare theta
  #theta <- 1/(2 ^ (1:(max_path_lenght - 1)))
  #theta <- c(theta, theta[length(theta)])
  
  #terzo modo di settare theta
  #theta <- rev(theta)
  
  #calcolo il valore di mu
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
