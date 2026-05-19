# Projeto_SGLH
Projeto destinado a disciplina de Banco de Dados, onde vamos trabalhar um Sistema de Gerenciamento de uma Lan House.

## TURMA
ADS2N

## AUTORES
- Pedro Caio Francisco da Silva
- João Vitor Santos Silva
- Elton da Silva Soares de Souza

# Domínio e Contexto do Negócio

O sistema foi projetado para gerenciar as operações diárias de uma Lan House.
Este estabelecimento foca na conveniência e acessibilidade.
- O negócio sobrevive da venda de horas de internet, serviços de impressão e a organização de torneios que movimentam a comunidade.
- O contexto exige um controle rigoroso de quem está usando cada máquina, o que estão consumindo (balas, refrigerantes, salgadinhos) e quem está devidamente inscrito nos torneios da casa. 

# Descrição das Entidades
	
## Cliente
Representa os frequentadores da lan house. É uma entidade central para identificação e histórico.

## Sessão
Registra o uso do tempo em computadores.

## Computador
Representa as máquinas físicas disponíveis no estabelecimento, incluindo configurações de hardware e status:
- Livre
- Ocupado
- Manutenção

## Consumo
Entidade responsável pelo registro do que foi adquirido durante a permanência na lan house.

## Produto
Entidade responsável por itens vendidos no balcão:
- Doces
- Águas
- Refrigerantes
- Folhas de impressão e etc.

## Inscriçao
Entidade que formaliza a participação de um cliente em um torneio específico. Fundamental para organizar as chaves das competições.

## Torneio
Eventos organizados pela Lan House, como:
- Torneio de FIFA
- Counter-Strike 2
- Com premiação determinada pela Lan House.

## Audit_log
Entidade de segurança responsável pelo rastreamento de ações realizadas no sistema, Essencial para o dono da lan house evitar fraudes ou erros de caixa.

# MODELAGEM CONCEITUAL (DER)

<img width="1408" height="722" alt="MODELO_DER ATUALIZADO" src="https://github.com/user-attachments/assets/a419ca42-637e-459a-983c-ce83196d7de9" />


# SITE Produzido para auxiliar na gestão da Lan House:

https://corujao1.figma.site/

# MODELAGEM LÓGICA (TABELA)

<img width="1297" height="825" alt="Lógico_1" src="https://github.com/user-attachments/assets/0f80ffaa-fe03-40c6-99d3-666f4d439f78" />

# Normalização do Banco de Dados

O modelo lógico foi desenvolvido aplicando as três primeiras formas normais, com o objetivo de reduzir redundâncias, evitar inconsistências e melhorar a integridade dos dados.

## 1ª Forma Normal (1FN)

A Primeira Forma Normal foi aplicada garantindo que:

- Todos os atributos possuem valores atômicos;
- Não existem grupos repetitivos;
- Cada coluna possui apenas um valor por registro.

---

## 2ª Forma Normal (2FN)

A Segunda Forma Normal foi aplicada eliminando dependências parciais.

Todas as tabelas:

- Possuem chave primária definida;
- Possuem atributos dependentes totalmente da chave primária.

---

## 3ª Forma Normal (3FN)

A Terceira Forma Normal foi aplicada removendo dependências transitivas.

Dessa forma:

- Nenhum atributo não-chave depende de outro atributo não-chave;
- Os dados foram organizados em entidades independentes.

---

# Estrutura Física do Banco de Dados (DDL)

Abaixo estão os comandos SQL responsáveis pela criação das tabelas do sistema.

## Criação do Banco de Dados

```sql
CREATE DATABASE LAN_HOUSE;
USE LAN_HOUSE;
```

---

## Tabela CLIENTE

```sql
CREATE TABLE CLIENTE (
    ID_CLIENTE INT PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(100) NOT NULL,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    EMAIL VARCHAR(100) UNIQUE,
    SEXO CHAR(1) NOT NULL,

    CONSTRAINT CHK_SEXO_CLIENTE
        CHECK (SEXO IN ('M', 'F', 'O'))
);
```

---

## Tabela TELEFONE

```sql
CREATE TABLE TELEFONE (
    ID_TELEFONE INT PRIMARY KEY AUTO_INCREMENT,
    NUMERO VARCHAR(15) NOT NULL,

    ID_CLIENTE INT NOT NULL,

    FOREIGN KEY (ID_CLIENTE)
        REFERENCES CLIENTE(ID_CLIENTE)
);
```

---

## Tabela COMPUTADOR

```sql
CREATE TABLE COMPUTADOR (
    ID_COMPUTADOR INT PRIMARY KEY AUTO_INCREMENT,
    STATUS VARCHAR(20) NOT NULL,

    CONSTRAINT CHK_STATUS_COMPUTADOR
        CHECK (STATUS IN ('LIVRE', 'OCUPADO', 'MANUTENCAO'))
);
```

---

## Tabela HARDWARE

```sql
CREATE TABLE HARDWARE (
    ID_HARDWARE INT PRIMARY KEY AUTO_INCREMENT,
    PLACA_MAE VARCHAR(50) NOT NULL,
    PROCESSADOR VARCHAR(50) NOT NULL,
    PLACA_VIDEO VARCHAR(50) NOT NULL,
    MEMORIA_RAM VARCHAR(30) NOT NULL,
    ARMAZENAMENTO VARCHAR(30) NOT NULL,
    FONTE VARCHAR(40) NOT NULL,

    ID_COMPUTADOR INT NOT NULL,

    FOREIGN KEY (ID_COMPUTADOR)
        REFERENCES COMPUTADOR(ID_COMPUTADOR)
);
```

---

## Tabela SESSAO

```sql
CREATE TABLE SESSAO (
    ID_SESSAO INT PRIMARY KEY AUTO_INCREMENT,
    ENTRADA DATETIME NOT NULL,
    SAIDA DATETIME,

    ID_CLIENTE INT NOT NULL,
    ID_COMPUTADOR INT NOT NULL,

    FOREIGN KEY (ID_CLIENTE)
        REFERENCES CLIENTE(ID_CLIENTE),

    FOREIGN KEY (ID_COMPUTADOR)
        REFERENCES COMPUTADOR(ID_COMPUTADOR)
);
```

---

## Tabela TORNEIO

```sql
CREATE TABLE TORNEIO (
    ID_TORNEIO INT PRIMARY KEY AUTO_INCREMENT,
    CATEGORIA VARCHAR(50) NOT NULL,
    STATUS VARCHAR(20) NOT NULL,

    CONSTRAINT CHK_STATUS_TORNEIO
        CHECK (STATUS IN ('ABERTO', 'EM_ANDAMENTO', 'FINALIZADO'))
);
```

---

## Tabela FORMA_PAGAMENTO

```sql
CREATE TABLE FORMA_PAGAMENTO (
    ID_FORMA_PAGAMENTO INT PRIMARY KEY AUTO_INCREMENT,
    TIPO_PAGAMENTO VARCHAR(20) NOT NULL,

    CONSTRAINT CHK_TIPO_PAGAMENTO
        CHECK (TIPO_PAGAMENTO IN ('PIX', 'DINHEIRO', 'CREDITO', 'DEBITO'))
);
```

---

## Tabela INSCRICAO

```sql
CREATE TABLE INSCRICAO (
    ID_INSCRICAO INT PRIMARY KEY AUTO_INCREMENT,
    VALOR DECIMAL(10,2) NOT NULL,

    CONSTRAINT CHK_VALOR_INSCRICAO
        CHECK (VALOR >= 0),

    DATA_PAGAMENTO DATE NOT NULL,

    ID_CLIENTE INT NOT NULL,
    ID_TORNEIO INT NOT NULL,
    ID_FORMA_PAGAMENTO INT NOT NULL,

    FOREIGN KEY (ID_CLIENTE)
        REFERENCES CLIENTE(ID_CLIENTE),

    FOREIGN KEY (ID_TORNEIO)
        REFERENCES TORNEIO(ID_TORNEIO),

    FOREIGN KEY (ID_FORMA_PAGAMENTO)
        REFERENCES FORMA_PAGAMENTO(ID_FORMA_PAGAMENTO)
);
```

---

## Tabela PRODUTO

```sql
CREATE TABLE PRODUTO (
    ID_PRODUTO INT PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(50) NOT NULL,
    DATA_VALIDADE DATE NOT NULL
);
```

---

## Tabela CONSUMO

```sql
CREATE TABLE CONSUMO (
    ID_CONSUMO INT PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(50) NOT NULL,
    PRECO DECIMAL(10,2) NOT NULL,

    ID_SESSAO INT NOT NULL,
    ID_FORMA_PAGAMENTO INT NOT NULL,

    CONSTRAINT CHK_PRECO_CONSUMO
        CHECK (PRECO >= 0),

    FOREIGN KEY (ID_SESSAO)
        REFERENCES SESSAO(ID_SESSAO),

    FOREIGN KEY (ID_FORMA_PAGAMENTO)
        REFERENCES FORMA_PAGAMENTO(ID_FORMA_PAGAMENTO)
);
```

---

## Tabela CONSUMO_PRODUTO

```sql
CREATE TABLE CONSUMO_PRODUTO (
    ID_PRODUTO INT NOT NULL,
    ID_CONSUMO INT NOT NULL,

    PRIMARY KEY (ID_PRODUTO, ID_CONSUMO),

    FOREIGN KEY (ID_PRODUTO)
        REFERENCES PRODUTO(ID_PRODUTO),

    FOREIGN KEY (ID_CONSUMO)
        REFERENCES CONSUMO(ID_CONSUMO)
);
```

---

## Tabela AUDIT_LOG

```sql
CREATE TABLE AUDIT_LOG (
    ID_AUDIT INT PRIMARY KEY AUTO_INCREMENT,
    DATA_HORA DATETIME NOT NULL,
    TABELA_AFETADA VARCHAR(30) NOT NULL,
    ID_REGISTRO INT NOT NULL,
    ACAO VARCHAR(10) NOT NULL,
    DESCRICAO VARCHAR(50) NOT NULL,

    ID_CLIENTE INT,

    CONSTRAINT CHK_ACAO_AUDIT
        CHECK (ACAO IN ('UPDATE', 'DELETE', 'INSERT')),

    FOREIGN KEY (ID_CLIENTE)
        REFERENCES CLIENTE(ID_CLIENTE)
);
```
