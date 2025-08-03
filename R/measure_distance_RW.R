library(igraph)
compute_first_encounter_distance <- function(g, 
                                             df,
                                             max_steps = 1000, 
                                             n_walks_per_node = 10) {
  results <- data.frame(
    attr_name = character(),
    source_attr = numeric(),
    target_attr = numeric(),
    avg_distance = numeric(),
    stringsAsFactors = FALSE
  )
  for (i in seq_len(nrow(df))) {
    attr_name <- df$attr_name[i]
    source_attr <- df$source_attr[i]
    target_attr <- df$target_attr[i]
    
    attr_values <- vertex_attr(g, attr_name)
    source_nodes <- V(g)[attr_values == source_attr]
    
    distances <- numeric(0)
    
    for (start_node in source_nodes) {
      for (j in seq_len(n_walks_per_node)) {
        current <- start_node
        step <- 0
        
        repeat {
          neighbors <- neighbors(g, current, mode = "out")
          if (length(neighbors) == 0 || step >= max_steps) break
          
          current <- sample(neighbors, 1)
          step <- step + 1
          
          if (vertex_attr(g, attr_name, index = current) == target_attr) {
            distances <- c(distances, step)
            break
          }
        }
      }
    }
    
    avg <- if (length(distances) == 0) NA_real_ else mean(distances)
    
    results <- rbind(results, data.frame(
      attr_name = attr_name,
      source_attr = source_attr,
      target_attr = target_attr,
      avg_distance = avg,
      stringsAsFactors = FALSE
    ))
  }
  
  return(results)
}