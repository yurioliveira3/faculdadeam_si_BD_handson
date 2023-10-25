-- CRIAÇÃO DA VIEW DE COLABORADORES
CREATE VIEW v_employees AS 
SELECT
	emp.username AS "Colaborador", 
	rl."name" AS "Cargo",
	emp.income AS "Salário",
	sp.username AS "Supervisor", 
	sp_rl."name" AS "Cargo Supervisor"	
FROM
	employees AS emp
JOIN 
	roles AS rl ON (emp.role_id = rl.id)
LEFT JOIN 
	employees AS sp ON (emp.supervisor_id = sp.id)
LEFT JOIN 
	roles AS sp_rl ON (sp.role_id = sp_rl.id)
WHERE 
	emp.deleted = FALSE 
ORDER BY 
	emp.role_id  
;

-- UTILIZAÇÃO DA VIEW

-- CRIAÇÃO DA FUNCTION QUE ALERTA SE O SALÁRIO DO COLABORADOR ESTÁ CONDIZENTE COM O CARGO DELE
DROP FUNCTION IF EXISTS fnc_employees_check_salary(employe_id int8);
CREATE FUNCTION fnc_employees_check_salary(employe_id int8) RETURNS TEXT
LANGUAGE plpgsql AS 
$function$
	DECLARE employe_username VARCHAR(255);
	DECLARE employe_salary DECIMAL(15,2);
	DECLARE employe_role VARCHAR(255);

	BEGIN 
			SELECT INTO
				employe_username, employe_salary, employe_role
					   --				-- 				-- 
				emp.username,	   emp.income,	  rl."name"
			FROM 
				employees AS emp
			JOIN 
				roles AS rl ON (emp.role_id = rl.id)
			WHERE 	
				emp.id = employe_id
			;
		
			CASE
				WHEN (employe_role = 'Estagiário' AND employe_salary < 750.00) THEN 
					RETURN 'O salário do ' || employe_username || ' para o cargo de ' || employe_role || ' não está OK, revisar!';
				WHEN (employe_role = 'Supervisor' AND employe_salary = 4000.20) THEN 
					RETURN 'O salário do ' || employe_username || ' para o cargo de ' || employe_role || ' não está OK, revisar!';
				ELSE 
					RETURN 'O salário ' || employe_salary::money || ' está OK para o cargo ' || employe_role;
			END CASE;

	END 
$function$
;

-- UTILIZAÇÃO DA FUNÇÃO 


-- CRIAÇÃO DA FUNCTION QUE REALIZA O AJUSTE DO SALÁRIO
DROP PROCEDURE IF EXISTS prc_employees_increase_salary(employe_id int8, percentage_adjustment DECIMAL(10,2));
CREATE PROCEDURE prc_employees_increase_salary(employe_id int8, percentage_adjustment DECIMAL(10,2))
LANGUAGE plpgsql AS 
$procedure$	
	BEGIN 
		
		UPDATE
			employees AS emp 
		SET 
			income = emp.income + ROUND((emp.income * (percentage_adjustment/100)),2)::decimal(10,2)
		WHERE 
			emp.id = employe_id
		;
	
		IF percentage_adjustment = 0 THEN 
			RAISE EXCEPTION 'P0001';
		END IF;
		
		-- https://www.postgresql.org/docs/current/errcodes-appendix.html
		EXCEPTION 
			WHEN SQLSTATE 'P0001' THEN 
				RAISE EXCEPTION
				'O valor de reajuste está zerado, esta transação será desfeita!';
				ROLLBACK;
			WHEN OTHERS THEN 
				RAISE EXCEPTION 
					'[Revisar] - Inconsistência na execução da procedure!';
				ROLLBACK;
	END 
$procedure$
;

-- FILTRAR OS COLABORADORES QUE ESTÃO COM O SALÁRIO INDEVIDO E AJUSTAR.
-- * DICA - CRIE UMA FUNCTION QUE REALIZA A VALIDAÇÃO, E CHAMA A PROCEDURE DE AJUSTE

-- USO DO EXPLAIN EM UMA CONSULTA
