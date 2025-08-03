library(igraph)
# Creating a empty graph with nodes' attributes
assign_attributes <- function(attr) {
  g_base <- make_empty_graph(n = nrow(attr), directed = FALSE)
  
  {# 添加属性
    V(g_base)$seniority <- attr[, 1]
    V(g_base)$status <- attr[, 2]             # 1=partner; 2=associate
    V(g_base)$gender <- attr[, 3]             # 1=man; 2=woman
    V(g_base)$office <- attr[, 4]             # 1=Boston; 2=Hartford; 3=Providence
    V(g_base)$years_with_firm <- attr[, 5]
    V(g_base)$age <- attr[, 6]
    V(g_base)$practice <- attr[, 7]         # 1=litigation; 2=corporate
    V(g_base)$law_school <- attr[, 8]     # 1: Harvard/Yale; 2: UConn; 3: Other
  }
  return(g_base)
}