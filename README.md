# Algorithm Analysis - Assignment Two

## Pré-requisitos

- Ruby (qualquer versão recente, ex.: 3.x). Não é necessário instalar gems.

Para verificar, rode:

```bash
ruby -v
```

## Como rodar

Cada arquivo é independente e pode ser executado diretamente pela raiz do projeto:

```bash
ruby functions/dues_problem.rb
ruby functions/ferry_problem_memoization.rb
ruby functions/ferry_problem_memoization_mapping_solution.rb
```

## Arquivos

| Arquivo | O que o algoritmo faz |
| --- | --- |
| `functions/dues_problem.rb` | Agenda tarefas com prazo: ordena as tarefas pela data limite (da mais tardia para a mais cedo) e, para cada uma, tenta alocá-la no último dia livre disponível até o seu prazo. Retorna um mapa dia -> tarefa. É um algoritmo guloso. |
| `functions/ferry_problem_memoization.rb` | Problema da balsa: dado o comprimento da balsa e os tamanhos dos carros, usa programação dinâmica com memoização (recursão) para descobrir o número máximo de carros que cabem, dividindo-os entre os lados esquerdo e direito. |
| `functions/ferry_problem_memoization_mapping_solution.rb` | Mesmo problema da balsa, mas além da quantidade máxima de carros, guarda as decisões tomadas e reconstrói quais carros foram para cada lado, retornando a alocação completa. |

## Pseudocódigo dos algoritmos

### `dues_problem.rb`

```
ALGORITMO dues_problem(dues, days):
    ordene dues pela data limite em ordem decrescente
    book <- mapa vazio

    para cada dia de 1 até days:
        book[dia] <- -1   // dia livre

    para cada tarefa em dues:
        para dia de min(tarefa.prazo, days) até 1 (decrescente):
            se book[dia] == -1:
                book[dia] <- tarefa
                pare   // tarefa alocada, próxima tarefa

    retorne book
```

### `ferry_problem_memoization.rb`

```
ALGORITMO ferry_problem_memoization(ferry_length, cars):
    n <- tamanho de cars
    memo <- mapa vazio

    FUNÇÃO solve(index, esquerda, direita):
        se index == n: retorne 0

        estado <- (index, direita, esquerda)
        se estado está em memo: retorne memo[estado]

        coloca_esquerda <- -1
        coloca_direita  <- -1

        se cars[index] <= esquerda:
            coloca_esquerda <- 1 + solve(index + 1, esquerda - cars[index], direita)

        se cars[index] <= direita:
            coloca_direita <- 1 + solve(index + 1, esquerda, direita - cars[index])

        se coloca_esquerda == -1 e coloca_direita == -1:
            resultado <- 0
        senão:
            resultado <- máximo(coloca_esquerda, coloca_direita)

        memo[estado] <- resultado
        retorne resultado

    retorne solve(0, ferry_length, ferry_length)
```

### `ferry_problem_memoization_mapping_solution.rb`

```
ALGORITMO ferry_problem_memoization_mapping_solution(ferry_length, cars):
    n <- tamanho de cars
    memo <- mapa vazio
    allocations <- mapa vazio   // guarda a decisão por estado

    FUNÇÃO solve(index, esquerda, direita):
        se index == n: retorne 0

        estado <- (index, esquerda, direita)
        se estado está em memo: retorne memo[estado]

        coloca_esquerda <- -1
        coloca_direita  <- -1

        se cars[index] <= esquerda:
            coloca_esquerda <- 1 + solve(index + 1, esquerda - cars[index], direita)

        se cars[index] <= direita:
            coloca_direita <- 1 + solve(index + 1, esquerda, direita - cars[index])

        se coloca_esquerda == -1 e coloca_direita == -1:
            resultado <- 0
        senão se coloca_esquerda >= coloca_direita:
            resultado <- coloca_esquerda
            allocations[estado] <- :left
        senão:
            resultado <- coloca_direita
            allocations[estado] <- :right

        memo[estado] <- resultado
        retorne resultado

    max_cars <- solve(0, ferry_length, ferry_length)

    // reconstrói a alocação usando as decisões guardadas
    mapping <- lista vazia
    index <- 0
    esquerda <- ferry_length
    direita <- ferry_length

    enquanto index < max_cars:
        estado <- (index, esquerda, direita)
        lado <- allocations[estado]
        pare se lado não existe

        adicione { carro: index, lado: lado } a mapping

        se lado == :left: esquerda <- esquerda - cars[index]
        senão: direita <- direita - cars[index]

        index <- index + 1

    retorne { max_cars: max_cars, mapping: mapping }
```
