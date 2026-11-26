USE employees_db;
-- EJERCICIO 1
DELIMITER //
CREATE OR REPLACE FUNCTION f_num_subordinates(
	p_employee_id INT
)
RETURNS INT 
DETERMINISTIC 
READS SQL DATA
BEGIN
	DECLARE v_count INT DEFAULT 0;
	
	SELECT COUNT(*) INTO v_count
	FROM employees
	WHERE boss_id=p_employee_id
		AND end_date IS NULL;
	
	
	RETURN v_count;
END //


CREATE OR REPLACE PROCEDURE p_end_contract(
	IN p_employee_id INT,
	IN p_end_date DATE
 )
 BEGIN
 	DECLARE v_exists INT DEFAULT 0;
 	DECLARE v_boss_id INT;
 	DECLARE v_end_date DATE;
 	
 	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 	BEGIN
 		ROLLBACK;
 		SIGNAL SQLSTATE '45000'
 		 SET MESSAGE_TEXT='Error al dar de baja al empleado';
 	END;
 	START TRANSACTION;
 	
 	-- se comprueba si el usuario existe
 	SELECT COUNT(*) INTO v_exists
 	FROM employees
 	WHERE employee_id=p_employee_id;
 	
 	IF v_exists=0 THEN
 		SIGNAL SQLSTATE '45000'
 			SET MESSAGE_TEXT='El empleado no existe';
 	END IF;
 	
 	-- Obtener jefe actual y fecha fin
 	SELECT boss_id,end_date INTO v_boss_id, v_end_date
 	FROM employees
 	WHERE employee_id=p_employee_id;
 	
 	IF v_end_date IS NOT NULL THEN
 		SIGNAL SQLSTATE '45000'
 			SET MESSAGE_TEXT='El empleado ya tiene fecha de fin';
 	END IF;
 	-- Fecha de fin al empleado
 	UPDATE employees
 	SET end_date=p_end_date
 	WHERE employee_id=p_employee_id;
 	
 	-- Reasignar sus subordinados activos a su jefe
 	UPDATE employees
 	SET boss_id=v_boss_id
 	WHERE boss_id=p_employee_id
 	 AND end_date IS NULL;
 	COMMIT;
 	
 END//
 DELIMITER ;
 
 