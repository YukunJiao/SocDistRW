library(igraph)

matrix_first_encounter_distance <- function(g, df) {
  results <- data.frame(
    attr_name = character(),
    source_attr = numeric(),
    target_attr = numeric(),
    avg_distance = numeric(),
    stringsAsFactors = FALSE
  )
  
  # 转移矩阵P
  A <- as_adjacency_matrix(g, sparse = FALSE)
  row_sums <- rowSums(A)
  row_sums[row_sums == 0] <- 1
  P <- A / row_sums
  
  n <- vcount(g)
  
  for (i in seq_len(nrow(df))) {
    attr_name <- df$attr_name[i]
    source_attr <- df$source_attr[i]
    target_attr <- df$target_attr[i]
    
    attr_values <- vertex_attr(g, attr_name)
    
    source_nodes <- which(attr_values == source_attr)
    target_nodes <- which(attr_values == target_attr)
    
    if (length(source_nodes) == 0 || length(target_nodes) == 0) {
      warning("No valid source or target nodes.")
      results <- rbind(results, data.frame(
        attr_name = attr_name,
        source_attr = source_attr,
        target_attr = target_attr,
        avg_distance = NA_real_,
        stringsAsFactors = FALSE
      ))
      next
    }
    
    # 吸收态节点：目标节点为吸收态
    absorb <- rep(FALSE, n)
    absorb[target_nodes] <- TRUE
    
    transient_nodes <- which(!absorb)
    
    # 基本矩阵 N = (I - Q)^-1
    Q <- P[transient_nodes, transient_nodes, drop = FALSE]
    I <- diag(nrow(Q))
    N <- tryCatch(solve(I - Q), error = function(e) NULL)
    
    if (is.null(N)) {
      warning("Matrix inversion failed.")
      results <- rbind(results, data.frame(
        attr_name = attr_name,
        source_attr = source_attr,
        target_attr = target_attr,
        avg_distance = NA_real_,
        stringsAsFactors = FALSE
      ))
      next
    }
    
    expected_steps <- rowSums(N)
    
    # 只取source_nodes中属于transient的节点对应期望值
    source_in_transient <- which(transient_nodes %in% source_nodes)
    
    if (length(source_in_transient) == 0) {
      warning("All source nodes are absorbing.")
      results <- rbind(results, data.frame(
        attr_name = attr_name,
        source_attr = source_attr,
        target_attr = target_attr,
        avg_distance = NA_real_,
        stringsAsFactors = FALSE
      ))
      next
    }
    
    mean_steps <- mean(expected_steps[source_in_transient])
    
    results <- rbind(results, data.frame(
      attr_name = attr_name,
      source_attr = source_attr,
      target_attr = target_attr,
      avg_distance = mean_steps,
      stringsAsFactors = FALSE
    ))
  }
  
  return(results)
}