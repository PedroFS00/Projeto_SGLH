DELIMITER //

CREATE PROCEDURE sp_abrir_sessao(
    IN p_id_cliente INT,
    IN p_id_computador INT
)
BEGIN

    DECLARE v_status VARCHAR(20);

    SELECT STATUS
    INTO v_status
    FROM COMPUTADOR
    WHERE ID_COMPUTADOR = p_id_computador;

    IF v_status <> 'LIVRE' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Computador não está disponível.';

    ELSE

        START TRANSACTION;

            INSERT INTO SESSAO
            (
                ENTRADA,
                STATUS,
                ID_CLIENTE,
                ID_COMPUTADOR
            )
            VALUES
            (
                NOW(),
                'ABERTA',
                p_id_cliente,
                p_id_computador
            );

            UPDATE COMPUTADOR
            SET STATUS = 'OCUPADO'
            WHERE ID_COMPUTADOR = p_id_computador;

        COMMIT;

    END IF;

END//

DELIMITER ;

--Procedure: Fechar Sessão
DELIMITER //

CREATE PROCEDURE sp_fechar_sessao(
    IN p_id_sessao INT
)
BEGIN

    DECLARE v_entrada DATETIME;
    DECLARE v_id_computador INT;
    DECLARE v_valor_hora DECIMAL(10,2);

    DECLARE v_valor_sessao DECIMAL(10,2);
    DECLARE v_valor_consumo DECIMAL(10,2);
    DECLARE v_valor_total DECIMAL(10,2);

    SELECT
        s.ENTRADA,
        s.ID_COMPUTADOR,
        c.VALOR_HORA
    INTO
        v_entrada,
        v_id_computador,
        v_valor_hora
    FROM SESSAO s
    INNER JOIN COMPUTADOR c
        ON c.ID_COMPUTADOR = s.ID_COMPUTADOR
    WHERE s.ID_SESSAO = p_id_sessao
      AND s.STATUS = 'ABERTA';

    IF v_entrada IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Sessão não encontrada ou já encerrada.';

    END IF;

    SET v_valor_sessao =
        fn_calcular_valor(
            v_entrada,
            NOW(),
            v_valor_hora
        );

    SELECT COALESCE(SUM(PRECO),0)
    INTO v_valor_consumo
    FROM CONSUMO
    WHERE ID_SESSAO = p_id_sessao;

    SET v_valor_total =
        v_valor_sessao + v_valor_consumo;

    START TRANSACTION;

        UPDATE SESSAO
        SET
            SAIDA = NOW(),
            VALOR_TOTAL = v_valor_total,
            STATUS = 'FECHADA'
        WHERE ID_SESSAO = p_id_sessao;

        UPDATE COMPUTADOR
        SET STATUS = 'LIVRE'
        WHERE ID_COMPUTADOR = v_id_computador;

    COMMIT;

END//

DELIMITER ;

--Testes

--Abrir sessão:

CALL sp_abrir_sessao(1,8);

--Fechar sessão:

CALL sp_fechar_sessao(16);

--Consultar:

SELECT * FROM SESSAO;