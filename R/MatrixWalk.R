library(igraph)

# 构图和属性处理同你的脚本

friend <- read.csv("friend.csv", header = TRUE) |> as.matrix()
advise <- read.csv("advise.csv", header = TRUE) |> as.matrix()
work <- read.csv("work.csv", header = TRUE) |> as.matrix()
attr <- read.csv("attr.csv", header = TRUE)

g <- graph_from_adjacency_matrix(friend)
# 确保attr和节点数对齐
# stopifnot(nrow(attr) == vcount(g))

{# 添加属性
  V(g)$seniority <- attr[, 1]
  V(g)$status <- attr[, 2]             # 1=partner; 2=associate
  V(g)$gender <- attr[, 3]             # 1=man; 2=woman
  V(g)$office <- attr[, 4]             # 1=Boston; 2=Hartford; 3=Providence
  V(g)$years_with_firm <- attr[, 5]
  V(g)$age <- attr[, 6]
  V(g)$practice <- attr[, 7]         # 1=litigation; 2=corporate
  V(g)$law_school <- attr[, 8]     # 1: Harvard/Yale; 2: UConn; 3: Other
}

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
    return(NA)
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
  mean_steps <- mean(expected_steps[source_in_transient])
  return(mean_steps)
}

# 从男性走到女性的 first encounter 平均步数
matrix_first_encounter_distance(g, attr_name = "gender", source_attr = 1, target_attr = 2)

# 从女性走到男性
matrix_first_encounter_distance(g, attr_name = "gender", source_attr = 2, target_attr = 1)

# 其他属性：
matrix_first_encounter_distance(g, attr_name = "status", source_attr = 1, target_attr = 2)
matrix_first_encounter_distance(g, attr_name = "status", source_attr = 2, target_attr = 1)

matrix_first_encounter_distance(g, attr_name = "law_school", source_attr = 1, target_attr = 3)

