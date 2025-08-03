library(igraph)

# 构造 transition matrix P（马尔可夫转移矩阵）
get_transition_matrix <- function(g) {
  A <- as_adjacency_matrix(g, sparse = FALSE)  # 邻接矩阵
  row_sums <- rowSums(A)
  row_sums[row_sums == 0] <- 1  # 避免除以0
  P <- A / row_sums
  return(P)
}

# 核心函数：用矩阵计算 source_attr 到 target_attr 的 expected first-encounter 步数
matrix_first_encounter_distance <- function(g, attr_name = "gender", 
                                            source_attr = 1, 
                                            target_attr = 2) {
  attr_values <- vertex_attr(g, attr_name)
  source_nodes <- which(attr_values == source_attr)
  target_nodes <- which(attr_values == target_attr)
  
  if (length(source_nodes) == 0 || length(target_nodes) == 0) {
    warning("No valid source or target nodes.")
    return(NA_real_)
  }
  
  P <- get_transition_matrix(g)
  n <- vcount(g)
  
  # 将目标节点设为吸收状态（对马尔可夫链处理）
  absorb <- rep(FALSE, n)
  absorb[target_nodes] <- TRUE
  transient_nodes <- which(!absorb)
  
  Q <- P[transient_nodes, transient_nodes]  # 转移子矩阵
  I <- diag(nrow(Q))
  N <- solve(I - Q)  # 基本矩阵
  expected_steps <- rowSums(N)
  
  # 只取来源节点（source_attr）中的 transient 节点的期望
  source_in_transient <- which(transient_nodes %in% source_nodes)
  
  if (length(source_in_transient) == 0) {
    warning("All source nodes are absorbing. No transient sources.")
    return(NA_real_)
  }
  
  mean_steps <- mean(expected_steps[source_in_transient])
  return(mean_steps)
}