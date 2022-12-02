# ------------------------------------------------------------------------------
# Credit Challenge!
# ------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#--------------------------Instalação dos pacotes-------------------------------
#-------------------------------------------------------------------------------

install.packages("tidyverse")
install.packages("VIM")
install.packages("rpart")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("randomForest")

library("tidyverse")
library("VIM")
library("rpart")
library("dplyr")
library("ggplot2")
library("randomForest")

#-------------------------------------------------------------------------------
#------------------------Análise inicial dos dados------------------------------
#-------------------------------------------------------------------------------

# Importação da base de dados
credit_dataset <- read.csv("credit_risk_dataset.csv")

# Confirmando as dimensões do dataset 
#   importação esperada: 32581 linhas e 12 colunas

dim(credit_dataset)
variaveis = names(credit_dataset)
print(variaveis)

print("------- Análise das variáveis -------") 
summary(credit_dataset)


print("------- Variáveis qualitativas -------") 
credit_dataset$person_home_ownership  %>%  unique() %>% sort()
credit_dataset$loan_grade  %>%  unique() %>% sort()
credit_dataset$loan_intent  %>%  unique() %>% sort()
credit_dataset$cb_person_default_on_file  %>%  unique() %>% sort()

# Removendo outliers
filter_dataset <- credit_dataset  %>% 
                    filter(person_age < 100 & 
                           person_income < 1000000 & 
                           ( is.na(person_emp_length) | 
                              person_emp_length < person_age))


# Ajustes dos valores em branco utilizando Knn (5 observações mais próximas)

clean_dataset <- filter_dataset %>%
                 VIM::kNN(c("person_emp_length", "loan_int_rate"),k = 5) %>% 
                 select(all_of(variaveis))


print("------- Análise das variáveis sem outliers e missing values -------") 
summary(clean_dataset)


#-------------------------------------------------------------------------------
#-------------------Modelo 1 - Árvore de Classificação--------------------------
#-------------------------------------------------------------------------------

# Separando em 80% base treino e 20% para teste
set.seed(123)
is_train <- stats::runif(dim(clean_dataset)[1])>.20

train <- clean_dataset[is_train,]
test  <- clean_dataset[!is_train,]

# Gerando a árvore
m1_tree <- rpart(loan_status ~ .,
                train,
                parms = list(split = 'gini'),
                method='class')

# Visualizando a árvore gerada
palette = scales::viridis_pal(begin=.75, end=1)(20)
rpart.plot::rpart.plot(m1_tree,
                       box.palette = palette)

#----------------------------Avaliando resultados-------------------------------

# Resultados na base treino 


m1_prob_train <- predict(m1_tree, train)

# Probabilidade de default
m1_prob_default <- (m1_prob_train[,2]>.5)*1

# Gerando a matriz de confusão
m1_confusion_train <- table(m1_prob_default, train$loan_status)

# Acurácia do modelo
m1_acc_train <- (m1_confusion_train[1,1] + 
                 m1_confusion_train[2,2]) / 
                    sum(m1_confusion_train)
sprintf("Acurácia do modelo árvore na base treino: %0.1f%%", m1_acc_train*100)
print(m1_confusion_train)


# Resultados na base teste

m1_prob_test <- predict(m1_tree, test)

m1_prob_default <- (m1_prob_test[,2]>.5)*1

m1_confusion_test <- table(m1_prob_default, test$loan_status)

m1_acc_test <- (m1_confusion_test[1,1] + 
                m1_confusion_test[2,2]) / 
                  sum(m1_confusion_test)
sprintf("Acurácia do modelo árvore na base test: %0.1f%%", m1_acc_test*100)
print(m1_confusion_test)




#-------------------------------------------------------------------------------
#----------------------------Modelo 2 - Random Forest---------------------------
#-------------------------------------------------------------------------------
# Tranformando as informações para rodar o modelo de classificação
train$loan_status <- as.character(train$loan_status)
train$loan_status <- as.factor(train$loan_status)

test$loan_status <- as.character(test$loan_status)
test$loan_status <- as.factor(test$loan_status)

m2_rf <- randomForest::randomForest(loan_status ~ ., 
                                       data = train, 
                                       ntree = 50, 
                                       importance = T)

#----------------------------Avaliando resultados-------------------------------
# Resultados na base de treino

m2_prob_train <- predict(m2_rf, train)

m2_confusion_train <- table(m2_prob_train, train$loan_status)

m2_acc_train <- (m2_confusion_train[1,1] + 
                 m2_confusion_train[2,2]) / 
                    sum(m2_confusion_train)
sprintf("Acurácia do modelo árvore na base test: %0.1f%%", m2_acc_train*100)
print(m2_confusion_train)


# Resultados na base de teste
m2_prob_test <- predict(m2_rf, test)

m2_confusion_test <- table(m2_prob_test, test$loan_status)

m2_acc_test <- (m2_confusion_test[1,1] + 
                m2_confusion_test[2,2]) / 
                  sum(m2_confusion_test)
sprintf("Acurácia do modelo árvore na base test: %0.1f%%", m2_acc_test*100)
print(m2_confusion_test)

# TODO Add curva ROC

