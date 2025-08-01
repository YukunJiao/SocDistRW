# 生成图g and add attributes to nodes
library(igraph)
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


create_network_with_attributes <- function(adjmat, attr_df) {
  library(igraph)
  
  g <- graph_from_adjacency_matrix(adjmat)
  attr <- 
  
  if (nrow(attr_df) != vcount(g)) {
    stop("Number of rows in attr_df does not match number of nodes in the graph.")
  }
  
  # 设置属性名称（根据你已有数据列）
  attribute_names <- c(
    "seniority", "status", "gender", "office", 
    "years_with_firm", "age", "practice", "law_school"
  )
  
  for (i in seq_along(attribute_names)) {
    V(g)[[attribute_names[i]]] <- attr_df[, i]
  }
  return(g)
}

