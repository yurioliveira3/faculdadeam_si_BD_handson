-- PT 1
-- LISTAGEM DE COLABORADORES COM NOME E CARGO, JUNTAMENTE COM O NOME E CARGO DO SEU SUPERVISOR
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

-- ATUALIZANDO O SALÁRIO DO COLABORADOR COM O MENOR SALÁRIO
UPDATE
	employees
SET 
 	income = '751.00'
WHERE
	income = (
  	SELECT
  		min(income)
  	FROM
  		employees
  )
;

-- UTILIZANDO CTE
WITH get_min(income) AS (
	SELECT
		min(mn_emp.income)
	FROM
		employees AS mn_emp
)
UPDATE
	employees AS emp
SET 
 	income = '751.00'
FROM 
	get_min AS min_inc 
WHERE 
	emp.income = min_inc.income
;

-- REMOVENDO O COLABORADOR COM CARGO DE ANALISTA - DELETED [?]
-- * DICA - QUANDO TENTAMOS DELETAR HARD UM COLABORADOR ONDE EXISTEM DEPENDENTES DO MESMO, O COMANDO DELETE NÃO IRÁ FUNCIONAR
-- REALIZAR UM SOFT DELETE (COLUNA DELETED)
UPDATE
	employees AS emp
SET 
 	deleted = TRUE 
FROM 
	roles AS rl
WHERE
	emp.role_id = rl.id 
	AND rl."name" = 'Analista'
;

-- DELETANDO O CARGO QUE NÃO TEM COLABORADORES VINCULADOS
DELETE FROM
  roles AS rl
WHERE
	NOT EXISTS (
		SELECT
			1
		FROM
			employees AS emp
		WHERE
			emp.role_id = rl.id
	)
;

-- UTILIZANDO CTE
WITH role_without_emp(id) AS (
	SELECT
		rl.id
	FROM
		roles AS rl
	LEFT JOIN 
		employees AS emp ON (rl.id = emp.role_id)
	WHERE
		emp.id IS NULL 
)
DELETE FROM
	roles AS rl
USING 
	role_without_emp AS rwe
WHERE 
	rl.id = rwe.id
;

-- PT 2
-- UTILIZAÇÃO DA VIEW 
SELECT 
  *
FROM 
  v_employees;

-- UTILIZAÇÃO DA FUNÇÃO 
SELECT 
	fnc_employees_check_salary(id)
FROM 
	employees
;

-- OU 
SELECT 
	fnc_employees_check_salary(1) -- ID DO COLABORADOR
;

-- FILTRAR OS COLABORADORES QUE ESTÃO COM O SALÁRIO INDEVIDO E AJUSTAR.
-- * DICA - CRIE UMA FUNCTION QUE REALIZA A VALIDAÇÃO, E CHAMA A PROCEDURE DE AJUSTE
DROP FUNCTION IF EXISTS fix_salary(percentage_adjustment DECIMAL(10,2));
CREATE OR REPLACE FUNCTION fix_salary(percentage_adjustment DECIMAL(10,2)) RETURNS VOID
LANGUAGE 'plpgsql' AS 
$function$

	DECLARE items RECORD;

	BEGIN	
		FOR items IN 
			SELECT id FROM employees WHERE fnc_employees_check_salary(id) ILIKE '%revisar%'
		LOOP 
			CALL prc_employees_increase_salary(items.id,percentage_adjustment);
		END LOOP;
    END;
   
$function$
;  

SELECT 
  * 
FROM 
  fix_salary(1.00::numeric)
;

-- OU 

SELECT 
	fix_salary(1.00::numeric)
;
