library(igraph)

friend <- read.csv("friend.csv", header = TRUE) |> as.matrix()
attr <- read.csv("attr.csv", header = TRUE)

g <- graph_from_adjacency_matrix(friend)
# 确保attr和节点数对齐
stopifnot(nrow(attr) == vcount(g))

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
compute_gender_first_encounter_distance <- function(g, 
                                                    source_gender = "male", 
                                                    target_gender = "female", 
                                                    max_steps = 1000, 
                                                    n_walks_per_node = 10) {
  # 找到所有起点
  source_nodes <- V(g)[V(g)$gender == source_gender]
  
  distances <- c()  # 用于收集每次成功遇见的步数
  
  for (start_node in source_nodes) {
    for (i in 1:n_walks_per_node) {
      current <- start_node
      step <- 0
      found <- FALSE
      
      repeat {
        neighbors <- neighbors(g, current, mode = "out")
        if (length(neighbors) == 0 || step > max_steps) break
        
        current <- sample(neighbors, 1)  # 随机前进
        step <- step + 1
        
        if (V(g)[current]$gender == target_gender) {
          distances <- c(distances, step)
          found <- TRUE
          break
        }
      }
    }
  }
  
  if (length(distances) == 0) {
    warning("No successful first encounters.")
    return(NA)
  } else {
    return(mean(distances))
  }
}


set.seed(42)
V(g)$gender
# 计算从 male 到 female 的 first-encounter 平均步数
avg_distance <- compute_gender_first_encounter_distance(g, 1, 2)
print(avg_distance)

# 计算从 female 到 male 的 first-encounter 平均步数
avg_distance <- compute_gender_first_encounter_distance(g, 2, 1)
print(avg_distance)

