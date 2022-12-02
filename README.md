# Credit Challenge

## Introdução

A sua tarefa é desenvolver um modelo de machine learning utilizando o conjunto de dados
Credit Risk para previsão de inadimplência. O arquivo credit_risk_dataset.csv contém
informações de empréstimos bancários e o arquivo variables_def.xlsx a descrição das
variáveis. A variável alvo é a loan_status (1 significa default, 0 não default).

Você deve dividir o dataset em treino e teste, enviar suas predições para o dataset de teste
e apresentar métricas de avaliação do modelo.

A partir daqui é com você! Você escolhe a linguagem, modelo, estratégias de validação,
métricas utilizadas, etc.

Comente e explique seu código o quanto achar necessário e não se preocupe muito com o
resultado final alcançado ou em demonstrar uma grande variedade de técnicas. A principal
intenção do desafio é conseguir achar uma solução inicial e observar quais partes do
desenvolvimento você achou essencial com o tempo que tem disponível.

Como sugestão, você pode nos enviar um RMarkdown, notebook em Python do Jupyter, ou
preferencialmente, um link para o seu projeto desenvolvido no Github.

A partir do momento de envio do email contendo esse pdf, você terá um prazo de 48 horas
para desenvolver seus códigos. É fundamental que cumpra com esse prazo.
Mais uma vez obrigado pelo seu tempo, bom desafio e bom trabalho!

## Dataset
O dataset está disponível em: 

A descrição das variáveis está disponível em:

### Validação dos dados disponíveis
Foi realizada uma análise incial dos dados que resultou nos principais pontos listados abaixo.


Os outliers citados acima foram removidos da base de dados.

Para tratamento dos registros nulos, utilizou-se o método kNN para preencher as informações com base nos  `k=5` registros mais próximos.

## Modelo

A base tratada foi separada de forma aleatória em duas 

* 80% dos dados foram considerados como base de treino 
* 20% dos dados foram considerados como base de teste

O primeiro modelo testado foi uma árvore de classificação. Pelos outputs é possível notar que o modelo apresenta uma acurácia de 92.9%. Contudo ocorreu uma grande quantidade de falsos negativos (clientes que eram considerados pelo modelo como `não default`, mas são clientes que retornam `default`).

O segundo modelo foi Random Forest retornou uma melhor acurácia de 93.8%.

## Próximos Passos

Como o resultado do modelo acabaria liberando o crédito para pessoas com default seria necessário rever os parâmetros para melhorar os retonos e diminuir a incidência de falsos negativos.

Um próximo passo é analisar os retornos do Random Forest, e propor melhorias no resultado final do modelo. 
