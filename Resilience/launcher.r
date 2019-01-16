G <- your_network

# set the max value of xi at least as the double of the longest path
full_parameter_sweep <- T
if (full_parameter_sweep) {
    ## full blown
    delta <- c(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)
    xi <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
} else {
    ## simplified
    delta <- c(0.0, 1.0)
    xi <- c(0, 1)    
}

# If the original network does not has a weight attribute please create it with the value you want to study.
E(G)$weight <- E(your_network)$value

#### LAUNCHER
# this part of the code runs the simulation for every values of ξ and δ
results <- matrix(0, length(delta), length(xi))
rownames(results) <- delta
colnames(results) <- xi

start_time <- Sys.time()
for(i in 1: length(delta))
  for(j in 1:length(xi)){
    appo <- mu(G, delta[i], xi[j])
    results[i, j] <- appo
    cat("\ni = ", delta[i], " - j = ", xi[j], " - mu = ", appo)
  }
end_time <- Sys.time()
end_time - start_time

#### Plot the results
Rs <- setNames(reshape::melt(results), c("δ", "ξ", "μ"))
library(lattice)
wireframe(μ ~ δ*ξ, data = Rs, drape = T,
           scales = list(arrows = FALSE, fontfamily = "Times"),
           zlab = expression(mu),
           xlab = expression(delta),
           ylab = expression(xi),
           main = expression(mu~"for Illinois airport network"),
           #col = mycol,
           col.regions = topo.colors(100),
           screen = list(z = 45, x = -60, y = 0))
