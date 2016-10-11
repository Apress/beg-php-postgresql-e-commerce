CREATE TABLE department
(
  department_id SERIAL        NOT NULL,
  name          VARCHAR(50)   NOT NULL,
  description   VARCHAR(1000),
  CONSTRAINT pk_department_id PRIMARY KEY (department_id)
);

INSERT INTO department (department_id, name, description) VALUES(1, 'Holiday', 'Prepare for the holidays with our special collection of seasonal hats!');
INSERT INTO department (department_id, name, description) VALUES(2, 'Caps and Berets', 'The perfect hats to wear at work and costume parties!');
INSERT INTO department (department_id, name, description) VALUES(3, 'Costume Hats', 'Find the matching hat for your new costume!');

ALTER SEQUENCE department_department_id_seq RESTART WITH 4;

CREATE TYPE department_list AS
(
  department_id INTEGER,
  name          VARCHAR(50)
);

CREATE FUNCTION catalog_get_departments_list()
RETURNS SETOF department_list LANGUAGE plpgsql AS $$
  DECLARE
    outDepartmentListRow department_list;
  BEGIN
    FOR outDepartmentListRow IN
      SELECT department_id, name 
      FROM department 
      ORDER BY department_id
    LOOP
      RETURN NEXT outDepartmentListRow;
    END LOOP;
  END;
$$;
