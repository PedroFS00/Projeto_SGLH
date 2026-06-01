--PROCEDURE: ABRIR SESSÃO

DELIMITER //

CREATE PROCEDURE sp_abrir_sessao (
    IN p_id_cliente INT,
    IN p_id_computador INT
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT STATUS INTO v_status
    FROM COMPUTADOR
    WHERE ID_COMPUTADOR = p_id_computador;

    IF v_status <> 'LIVRE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Computador não está disponível.';
    END IF;

    START TRANSACTION;

    INSERT INTO SESSAO (ENTRADA, STATUS, ID_CLIENTE, ID_COMPUTADOR)
    VALUES (NOW(), 'ABERTA', p_id_cliente, p_id_computador);

    UPDATE COMPUTADOR
    SET STATUS = 'OCUPADO'
    WHERE ID_COMPUTADOR = p_id_computador;

    COMMIT;
END //

DELIMITER ;

======================================

--PROCEDURE: FECHAR SESSÃO

DELIMITER //

CREATE PROCEDURE sp_fechar_sessao (
    IN p_id_sessao INT
)
BEGIN
    DECLARE v_inicio DATETIME;
    DECLARE v_saida DATETIME;
    DECLARE v_id_computador INT;
    DECLARE v_valor_hora DECIMAL(10,2);
    DECLARE v_valor_sessao DECIMAL(10,2);
    DECLARE v_valor_consumo DECIMAL(10,2);

    SELECT ENTRADA, ID_COMPUTADOR
    INTO v_inicio, v_id_computador
    FROM SESSAO
    WHERE ID_SESSAO = p_id_sessao
      AND STATUS = 'ABERTA';

    IF v_inicio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sessão não encontrada ou já encerrada.';
    END IF;

    SET v_saida = NOW();

    SELECT VALOR_HORA INTO v_valor_hora
    FROM COMPUTADOR
    WHERE ID_COMPUTADOR = v_id_computador;

    SET v_valor_sessao = fn_calcular_valor(v_inicio, v_saida, v_valor_hora);

    SELECT COALESCE(SUM(PRECO_TOTAL), 0)
    INTO v_valor_consumo
    FROM CONSUMO
    WHERE ID_SESSAO = p_id_sessao;

    START TRANSACTION;

    UPDATE SESSAO
    SET SAIDA = v_saida,
        STATUS = 'FECHADA',
        VALOR_TOTAL = v_valor_sessao + v_valor_consumo
    WHERE ID_SESSAO = p_id_sessao;

    UPDATE COMPUTADOR
    SET STATUS = 'LIVRE'
    WHERE ID_COMPUTADOR = v_id_computador;

    COMMIT;
END //

DELIMITER ;

========================================================

--PROCEDURE: REGISTRAR CONSUMO

DELIMITER //

CREATE PROCEDURE sp_registrar_consumo (
    IN p_id_sessao INT,
    IN p_id_forma_pagamento INT
)
BEGIN
    INSERT INTO CONSUMO (ID_SESSAO, ID_FORMA_PAGAMENTO)
    VALUES (p_id_sessao, p_id_forma_pagamento);
END //

DELIMITER ;

======================================================

--PROCEDURE: ADICIONAR PRODUTO AO CONSUMO

DELIMITER //

CREATE PROCEDURE sp_add_produto_consumo (
    IN p_id_produto INT,
    IN p_id_consumo INT,
    IN p_quantidade INT
)
BEGIN
    INSERT INTO CONSUMO_PRODUTO (ID_PRODUTO, ID_CONSUMO, QUANTIDADE)
    VALUES (p_id_produto, p_id_consumo, p_quantidade);
END //

DELIMITER ;

==================================================

--PROCEDURE: FINALIZAR CONSUMO (CALCULA TOTAL)

DELIMITER //

CREATE PROCEDURE sp_finalizar_consumo (
    IN p_id_consumo INT
)
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT SUM(p.PRECO * cp.QUANTIDADE)
    INTO v_total
    FROM CONSUMO_PRODUTO cp
    JOIN PRODUTO p ON p.ID_PRODUTO = cp.ID_PRODUTO
    WHERE cp.ID_CONSUMO = p_id_consumo;

    UPDATE CONSUMO
    SET PRECO_TOTAL = v_total
    WHERE ID_CONSUMO = p_id_consumo;

END //

DELIMITER ;

==================================================

