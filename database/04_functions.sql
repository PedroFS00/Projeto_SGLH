DELIMITER $$

CREATE FUNCTION fn_duracao_minutos (
    p_inicio DATETIME,
    p_fim DATETIME
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(MINUTE, p_inicio, p_fim);
END$$

CREATE FUNCTION fn_calcular_valor (
    p_inicio DATETIME,
    p_fim DATETIME,
    p_valor_hora DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_minutos INT;
    DECLARE v_valor DECIMAL(10,2);

    SET v_minutos = TIMESTAMPDIFF(MINUTE, p_inicio, p_fim);
    SET v_valor = (v_minutos / 60.0) * p_valor_hora;

    RETURN ROUND(v_valor, 2);
END$$

DELIMITER ;