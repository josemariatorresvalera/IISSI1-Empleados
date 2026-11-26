USE employees_db;

CALL p_populate();
SELECT f_num_subordinates(1);
CALL p_end_contract(1, '2026-12-31');
SELECT * FROM employees;
SELECT f_num_subordinates(1);
CALL p_end_contract(4, '2026-12-31');
CALL p_end_contract(99, '2026-12-31');
