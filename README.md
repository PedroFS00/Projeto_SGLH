# Projeto_SGLH
Projeto destinado a disciplina de Banco de Dados, onde vamos trabalhar um Sistema de Gerenciamento de uma Lan House.

TURMA: ADS2N
AUTORES: 
PEDRO CAIO FRANCISCO DA SILVA
JOÃO VITOR SANTOS SILVA
ELTON DA SILVA SOARES DE SOUZA

Domínio e Contexto do Negócio

O sistema foi projetado para gerenciar as operações diárias de uma Lan House.
Este estabelecimento foca na conveniência e acessibilidade.
O negócio sobrevive da venda de horas de internet, serviços de impressão e a organização de torneios que movimentam a comunidade.
O contexto exige um controle rigoroso de quem está usando cada máquina, o que estão consumindo (balas, refrigerantes, salgadinhos) e quem está devidamente inscrito nos torneios da casa. 

	Descrição das Entidades
	
Cliente: Representa os frequentadores da lan house. É a entidade central para identificação e histórico.

Sessão: Registra o uso do tempo nos computadores.

Computador: Representa as máquinas físicas disponíveis no estabelecimento, quais suas configurações de hardware, e seu status, ex: "Livre", "Ocupado", ou "Manutenção".

Consumo: Entidade que detalha o registro do que foi comprado durante uma permanência na lan house.

Produto: Itens à venda no balcão: bomboniere (doces), águas, refrigerantes folhas de impressão e etc.

Inscrição: Entidade que formaliza a participação de um cliente em um torneio específico. Fundamental para organizar as chaves das competições.

Torneio: Eventos organizados pela Lan House (Ex: Torneio de Fifa ou Counter Striker 2 local) com premiação determinada pela Lan House.

Audit_log: Entidade de segurança para rastrear ações no sistema, essencial para o dono da lan house evitar fraudes ou erros de caixa.

  MODELAGEM (DER)

<img width="1408" height="722" alt="MODELO_DER ATUALIZADO" src="https://github.com/user-attachments/assets/a419ca42-637e-459a-983c-ce83196d7de9" />


SITE Produzido para auxiliar na gestão da Lan House:

https://corujao1.figma.site/

