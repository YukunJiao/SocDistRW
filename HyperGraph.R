library(HyperG)


g <- sample_gnp(10,.1)
ase(g)
g

clique_hypergraph(g)


g <- graph_from_literal(1-2-3-1,3-4-5-3)
h <- as.hypergraph(g)
ch <- clique_hypergraph(g)
g
h
ch


P <- rbind(c(.2,.05),c(.05,.1))
ns <- rep(50,2)
set.seed(451)
g <- sample_sbm(sum(ns),P,ns)
g
test <- cluster_spectral(g)
test$classification

test$BIC


h

ch
dual_hypergraph(ch)



h <- hypergraph_from_edgelist(list(1:4,2:5,4:6,c(1,3,7)))
k <- dual_hypergraph(h)
h
k

set.seed(565)
  x <- matrix(rnorm(100),ncol=2)
  x
  h <- epsilon_hypergraph(x,epsilon=.25)
  h
  plot(h)
  plot(h,layout=x)
  
  epsilons <- runif(nrow(x),0,.5)
  k <- epsilon_hypergraph(x,epsilon=epsilons)
  
  plot(k)
  plot(k,layout=x)

h
