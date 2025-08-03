create_networks <- function(g_base, network_name) {
  # 1. 构造文件名
  file_path <- here::here(paste0(network_name, ".csv"))
  
  # 2. 读取邻接矩阵
  adj <- read.csv(file_path, header = TRUE) |> as.matrix()
  
  # 3. 找出边的位置（邻接矩阵中值为1的位置）
  edge_list <- which(adj == 1, arr.ind = TRUE)
  edge_list <- edge_list[edge_list[, 1] < edge_list[, 2], , drop = FALSE]  # 只取上三角，避免重复边
  edges_vec <- t(edge_list) |> as.vector()
  
  # 4. 加边
  g <- igraph::add_edges(g_base, edges_vec)
  
  return(g)
}