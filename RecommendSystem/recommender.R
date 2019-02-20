# install.packages("recommederlab")
library("recommenderlab")
set.seed(1)

# 이건 코드일 뿐이고, 책에는 좀더 상세한 이론 설명이 필요하다
data_package <- data(package ="recommenderlab")
data_package$results[,"Item"]

data("MovieLense")
MovieLense

class(MovieLense)
methods(class=class(MovieLense))

### 3장 ####
# 유사도 매트릭스 계산 (Calculate  Similarity Matrix)
# 유사도 매트릭스는 cosine, pearson, jaccard 방법이 있다. need updating
similarity_users <- similarity(MovieLense[1:4,],method ="cosine",which ="users")
as.matrix(similarity_users)
image(as.matrix(similarity_users),main="User similarity")

similarity_items <- similarity(MovieLense[,1:4],method="cosine",which="items")
as.matrix(similarity_items)

# 패키지의 추천모델
recommender_models <- recommenderRegistry$get_entries(dataType="realRatingMatrix")
names(recommender_models)

# 데이터 탐구
library("ggplot2")
dim(MovieLense) # realRatingMatrix는 s4 클래스 이므로 MovieLense slot에 포함된다
slotNames(MovieLense)
class(MovieLense@data)

vector_ratings <- as.vector(MovieLense@data)
unique(vector_ratings)
table_ratings <-table(vector_ratings)
table_ratings

vector_ratings <- vector_ratings[vector_ratings !=0] # delete 0
vector_ratings<-factor(vector_ratings) # factorlize
qplot(vector_ratings)+ggtitle("Distribution of the ratings")

# 조회된 영화 탐색
view_per_movie <-colCounts(MovieLense) # 각 열에 존재하는 값의 수
view_per_movie
table_views <- data.frame(movie=names(view_per_movie),views = view_per_movie )
table_views <- table_views[order(table_views$views, decreasing = TRUE), ] # rows sort by views

ggplot(table_views[1:6,],aes(x=movie,y=views))+
  geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle=45,hjust=1))+ggtitle("Number of view of the top movies")

# 평균 평점 탐색
avg_ratings <- colMeans(MovieLense)
qplot(avg_ratings) + stat_bin(binwidth = 0.1) + ggtitle("Distribution of the average moive rating")
avg_ratings_relevant <- avg_ratings[view_per_movie > 50]  # 평가수가 50이상인 영화의 평점만 남김
qplot(avg_ratings_relevant) + stat_bin(binwidth = 0.1) + ggtitle("Distribution of the relevant avg moive rating")

# 매트릭스 시각화 
image(MovieLense[1:10,1:15],main="Heatmap of the first rows and columns") # 안본 사람이 많다 sparse matrix
min_n_movies <- quantile(rowCounts(MovieLense),0.99)
min_n_user <- quantile(colCounts(MovieLense),0.99)
image(MovieLense[rowCounts(MovieLense)>min_n_movies,colCounts(MovieLense)>min_n_user ] ,main="Heatmap of the top users")

#  3-1. 데이터 준비  ####
# 데이터를 살펴보면 시청횟수가 적은 영화는 정보부족으로 평점에 bias가 있고, 평점을 적게 매기는 사용자는 bias가 있다
# 이러한 bias data는 지식기반 추천시스템에 알맞지만 필터링엔 안좋다
# -데이터 정규화
rating_movie <-MovieLense[rowCounts(MovieLense)>50, colCounts(MovieLense)>100]
rating_movie_norm <- normalize(rating_movie)
image(rating_movie_norm)

# 데이터 이진화
# - 사용자가 영화에 평점을 매기면1, 아니면 0을 부여하는 경우 or 감정분석
rating_movie_watched <-binarize(rating_movie,minRating =3) # 평점이 1이상인 경우
min_movies_bin <-quantile(rowCounts(rating_movie),0.95) # 5%만 테스트로 뽑음
min_user_bin <-quantile(colCounts(rating_movie),0.95)
image(rating_movie_watched[rowCounts(rating_movie)>min_movies_bin,
                           colCounts(rating_movie)>min_user_bin],main="Heatmap of top by bin")


# 3-2. 아이템 기반 협업 필터링(collabo filltering based on item)####
# 각 아이템들에 대해, 유사한 사용자들에게 비슷한 평점을 받은 것을 바탕으로 서로 얼마나 유사한지 측정한다
# 각 아이템에 대해, 가장 유사한 k개의 아이템들을 선별한다
# 각 사용에 대해, 사용자의 구매내역과 가장 유사한 아이템을 선별한다

# - make training set, test set
which_train <-sample(x=c(TRUE,FALSE),size=nrow(rating_movie),replace = TRUE,prob = c(0.8,0.2)) # 1 validattion
recc_data_train <- rating_movie[which_train,]
recc_data_test <- rating_movie[!which_train]

which_set <- sample(x=1:5, size=nrow(rating_movie),replace = TRUE)  #  전구간을 1:5로 쪼갬 , 5 valdation
for(i in 1:5){
  which_train <- which_set == i
  recc_data_train <- rating_movie[which_train,]
  recc_data_test <- rating_movie[!which_train]
  # compose
}

# training
recc_model <- Recommender(data = recc_data_train, method = "IBCF", parameter=list(k=30))
model_details <- getModel(recc_model)
image(model_details$sim[1:20,1:20],main="Heatmap of model details")
col_sums <- colSums(model_details$sim >0)
which_max <- order(col_sums, decreasing = TRUE)[1:6]
rownames(model_details$sim)[which_max]

# testing
n_recommended <-6 # 사용자에게 추천할 아이템 수
recc_predicted <- predict(object = recc_model,newdata = recc_data_test, n= n_recommended)
recc_predicted
recc_predicted@items[[1]] # 첫번째 사용자를 위한 추천
recc_user_1 <- recc_predicted@items[[1]]
movie_user1 <- recc_predicted@itemLabels[recc_user_1]
movie_user1

recc_matrix<-sapply(recc_predicted@items, function(x){colnames(rating_movie[x])})
recc_matrix[,1:4]
number_of_items <-factor(table(recc_matrix))
chart_title <- "Distribution of the number of items for IBCF"
qplot(number_of_items)+ggtitle(chart_title) # 그림이 다르게 나옴

# 3-3. 사용자 기반 협업 필터링
# 같은 사람들이 구매한 것과 유사한 아이템 선별
# 새 사용자에게는 구매했던 것과 비슷한 아이템을 추천

recommender_models2 <- recommenderRegistry$get_entries(dataType="realRatingMatrix")
recommender_models2$UBCF_realRatingMatrix$parameters
recc_model <- Recommender(data=recc_data_train,method="UBCF")

n_recommended <-6 # 사용자에게 추천할 아이템 수
recc_predicted <- predict(object = recc_model,newdata = recc_data_test, n= n_recommended)
recc_predicted
recc_predicted@items[[1]] # 첫번째 사용자를 위한 추천
recc_user_1 <- recc_predicted@items[[1]]
movie_user1 <- recc_predicted@itemLabels[recc_user_1]
movie_user1

recc_matrix<-sapply(recc_predicted@items, function(x){colnames(rating_movie[x])})
recc_matrix[,1:4]

#  3-4. 이진 데이터에 대한 협업필터링
# 어떤 아이템을 구매했는지 알지만 평점을 알지 못하는 경우
# 각 사용자에 대해 구매한 아이템을 알 수는 없지만 좋아하는 아이템은 알고 있다.
# jaccard 지수를 사용한다.

ratings_movies_watched <- binarize(rating_movie,minRating=1)
which_train <-sample(x=c(TRUE,FALSE),size=nrow(rating_movie),replace = TRUE,prob = c(0.8,0.2)) # 1 validattion
recc_data_train <- rating_movie[which_train,]
recc_data_test <- rating_movie[!which_train]

recc_model <- Recommender(data=recc_data_train,method="IBCF",parameter=list(method = "Jaccard"))
model_details <- getModel(recc_model)
n_recommended <-6 # 사용자에게 추천할 아이템 수
recc_predicted <- predict(object = recc_model,newdata = recc_data_test, n= n_recommended)
recc_matrix<-sapply(recc_predicted@items, function(x){colnames(rating_movie[x])})
recc_matrix[,1:4]

# 협업 필터링의 한계 - 새로운 사용자에 대한 정보가 전혀 없을 경우 문제 -> 강화학습


## 4. 추천시스템의 평가 #####
# - 모델을 평가하기 위한 데이터 준비
# - 몇몇 모델들에 대한 성능 평가
# - 가장 좋은 성능을 가지는 모델의 선택
# - 모델의 매개변수 최적화
set.seed(2)
library(recommenderlab)
library(ggplot2)
data("MovieLense")
rating_movie<- MovieLense[rowCounts(MovieLense)>50, colCounts(MovieLense)>100] # 평점50번이상의 사용자와 평점 100개이상의 영화

percentage_training <- 0.8
min(rowCounts(rating_movie)) # 모델을 테스트할 아이템이 없는 사용자가 없도록 사용자가 구매한 아이템 수의 최소값보다 적게
items_to_keep <-15
rating_threshold <-3# 좋고 나쁨(이진)으로 바꾸기 위한 평점 기준
n_eval <-1

eval_sets <- evaluationScheme(data=rating_movie,method="split",train=percentage_training,
                              given = items_to_keep,goodRating = rating_threshold , k= n_eval) 
# 부트스트랩을 위해선  split 대신 bootstrapt 사용
# k-fold를 위해서는 split 대신 cross-validation 사용
eval_sets
getData(eval_sets,"unknown")
qplot(rowCounts(getData(eval_sets,"unknown")))+geom_histogram(binwidth = 10)+ggtitle("unknown items by the user")

# 평가
eval_recom <- Recommender(data=getData(eval_sets),"train",method = "IBCF")
eval_pred <- predict(eval_recom,newdata=getData(eval_sets,"known"), n=10,type="ratings")
qplot(rowCounts(eval_pred))+geom_histogram(binwidth = 10)+ggtitle("Distribution of movies per user")
eval_acc <- calcPredictionAccuracy(eval_pred,data= getData(eval_sets,"unknown"),byUser=TRUE) # 전체 지수평가 하려면 byUser=false
head(eval_acc)

# 평가2
results<-evaluate (x=eval_sets,method = "IBCF",n=seq(10,100,10))
class(results)
head(getConfusionMatrix(results)[[1]])
# True positive : 구매 됬으며 추천된 아이템 참/참
# False Positive(!종 오류) : 구매되지 않았으나 추천된 아이템 거짓/참  # 재판 
# False Negative(2종 오류) : 구매됬으나 추천된 아이템이 아님 참/거짓  # 암검사 - 1,2종 오류는 trade-off
# True Negative : 구매x 추천x 거짓/거짓

# True Positive Rate : 구매된 아이템 중 추천 아이템의 비율   TP/(TP+FN )
# False Positive Rate : 구매되지 않은 아이템중 추천한 아이템의 비율 FP/(FP+FN)
# 위의 두개로 추천의 정확도 계산가능

plot(results,"prec/rec",annotate=TRUE,main="precision-recall" )
# precision(정확도) : TP/ (TP+FP)
# reacll(재현도) : TP/(TP+FN) - 올바른 것 중에 참인 것


# 가장 적합한 모델 식별
list(name="IBCF",param = list(k=20)) # 가장 가까운 k개의 아이템을 고려함 
models_to_evaluate <- list(
  IBCF_cos =list(name="IBCF",param =list(method="cosine")),
  IBCF_cor =list(name="IBCF",param =list(method="pearson")),
  UBCF_cos =list(name="UBCF",param =list(method="cosine")),
  UBCF_cor =list(name="UBCF",param =list(method="pearson")),
  ramdom = list(name="RANDOM",param =NULL)
  )
n_recommendataions <-c(1,5,seq(10,100,10))
list_results <- evaluate(eval_sets,models_to_evaluate,n=n_recommendataions)
avg_matrics <- lapply(list_results,avg)
plot(list_results,annotate=1,legend="topleft")
plot(list_results,"prec/rec",annotate=c(1:4),legend="bottomleft")


# 적합한 k의 수 찾기
vector_k <-c(5,10,20,30,40)
models_to_evaluate <-lapply(vector_k,function(k){
  list(name="IBCF",param=list(method="cosine",k=k))
})
names(models_to_evaluate) <- paste0("IBCF_k_",vector_k)

n_recommendataions <-c(1,5,seq(10,100,10))
list_results <- evaluate(eval_sets,method=models_to_evaluate,n=n_recommendataions)
plot(list_results,annotate=1,legend="topleft")
title("ROC curve")

