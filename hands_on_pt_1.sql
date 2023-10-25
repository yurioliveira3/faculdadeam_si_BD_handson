DROP TABLE IF EXISTS roles;
CREATE TABLE IF NOT EXISTS roles
(
	id int8 NOT NULL GENERATED BY DEFAULT AS IDENTITY, -- ID
	"name" VARCHAR(255), -- Nome do cargo 
	active BOOL NULL DEFAULT TRUE, -- Deletado
	created timestamp NOT NULL, -- Dt Criação
	created_by int8 NOT NULL, -- User Criação
	modified timestamp NULL,  -- Dt Modificação
	modified_by int8 NULL, -- User Modificação
	CONSTRAINT role_pk PRIMARY KEY(id) -- PK
);

-- CRIAÇÃO DA NOSSA TABELA DE COLABORADORES
DROP TABLE IF EXISTS employees;
CREATE TABLE IF NOT EXISTS employees
(
	id INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY, -- ID
	username VARCHAR(255), -- Nome Usuário
	income DECIMAL(15,2), -- Salário
	supervisor_id INT8 NULL, -- Supervisor
	role_id INT8 NOT NULL, -- Cargo
	deleted BOOL NULL DEFAULT FALSE, -- Deletado
	created timestamp NOT NULL, -- Dt Criação
	created_by int8 NOT NULL, -- User Criação
	modified timestamp NULL,  -- Dt Modificação
	modified_by int8 NULL, -- User Modificação
	CONSTRAINT collaborator_pk PRIMARY KEY(id), -- PK
	CONSTRAINT collaborator_supervisor_fk FOREIGN KEY (supervisor_id) REFERENCES employees(id) ON DELETE RESTRICT ON UPDATE RESTRICT, -- FK
	CONSTRAINT role_fk FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT -- FK
);

-- INSERT DOS DADOS 

--INSERT INTO public.roles ("name", active, created, created_by, modified, modified_by) VALUES('CEO', true, '2023-10-25 10:00:59.756', 1, NULL, NULL);
--INSERT INTO public.roles ("name", active, created, created_by, modified, modified_by) VALUES('Gerente', true, '2023-10-25 10:00:59.755', 1, NULL, NULL);
--INSERT INTO public.roles ("name", active, created, created_by, modified, modified_by) VALUES('Supervisor', true, '2023-10-25 10:00:51.026', 1, NULL, NULL);
--INSERT INTO public.roles ("name", active, created, created_by, modified, modified_by) VALUES('Analista', true, '2023-10-25 10:00:59.751', 1, NULL, NULL);
--INSERT INTO public.roles ("name", active, created, created_by, modified, modified_by) VALUES('Estagiário', true, '2023-10-25 10:00:59.754', 1, NULL, NULL);

INSERT INTO roles 
	("name", active, created, created_by) 
VALUES 
	('CEO', true, NOW(), 1),
	('Gerente', true, NOW(), 1),
	('Supervisor', true, NOW(), 1),
	('Analista', true, NOW(), 1),
	('Estagiário', true, NOW(), 1),
	('Consultor', true, NOW(), 1)
;

--INSERT INTO public.employees (username, income, supervisor_id, role_id, deleted, created, created_by, modified, modified_by) VALUES('Joãozinho', 100000.20, NULL, 1, false, '2023-10-25 10:05:21.191', 1, NULL, NULL);
--INSERT INTO public.employees (username, income, supervisor_id, role_id, deleted, created, created_by, modified, modified_by) VALUES('Mariazinha', 7000.20, NULL, 2, false, '2023-10-25 10:05:21.198', 1, NULL, NULL);
--INSERT INTO public.employees (username, income, supervisor_id, role_id, deleted, created, created_by, modified, modified_by) VALUES('Yami Yugi ', 4000.20, NULL, 3, false, '2023-10-25 10:05:21.197', 1, NULL, NULL);
--INSERT INTO public.employees (username, income, supervisor_id, role_id, deleted, created, created_by, modified, modified_by) VALUES('Gohan', 2700.85, NULL, 4, false, '2023-10-25 10:05:21.197', 1, NULL, NULL);
--INSERT INTO public.employees (username, income, supervisor_id, role_id, deleted, created, created_by, modified, modified_by) VALUES('Naruto', 750.00, NULL, 5, false, '2023-10-25 10:05:21.199', 1, NULL, NULL);
--INSERT INTO public.employees (username, income, supervisor_id, role_id, deleted, created, created_by, modified, modified_by) VALUES('Chaves ', 500.50, NULL, 5, false, '2023-10-25 10:05:21.199', 1, NULL, NULL);

INSERT INTO employees 
	(username, income, supervisor_id, role_id, deleted, created, created_by) 
VALUES
	('Joãozinho', 100000.20, NULL, 1, false, NOW(), 1),
	('Mariazinha', 7000.20, 3, 2, false, NOW(), 1),
	('Yami Yugi ', 4000.20, 1, 3, false, NOW(), 1),
	('Gohan', 2700.85, 2, 4, false, NOW(), 1),
	('Naruto', 750.00, 4, 5, false, NOW(), 1),
	('Chaves ', 500.50, 4, 5, false, NOW(), 1)
;

-- SELECT NA TABELA DE CARGOS
SELECT * FROM roles;

-- SELECT NA TABELA DE COLABORADORES
SELECT * FROM employees;
