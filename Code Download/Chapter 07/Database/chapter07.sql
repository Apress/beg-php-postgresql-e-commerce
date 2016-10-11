-- Create catalog_get_departments function
CREATE FUNCTION catalog_get_departments()
RETURNS SETOF department LANGUAGE plpgsql AS $$
  DECLARE
    outDepartmentRow department;
  BEGIN
    FOR outDepartmentRow IN
      SELECT   department_id, name, description
      FROM     department
      ORDER BY department_id
    LOOP
      RETURN NEXT outDepartmentRow;
    END LOOP;
  END;
$$;

-- Create catalog_update_department function
CREATE FUNCTION catalog_update_department(
                  INTEGER, VARCHAR(50), VARCHAR(1000))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId ALIAS FOR $1;
    inName         ALIAS FOR $2;
    inDescription  ALIAS FOR $3;
  BEGIN
    UPDATE department
    SET    name = inName, description = inDescription
    WHERE  department_id = inDepartmentId;
  END;
$$;

-- Create catalog_delete_department function
CREATE FUNCTION catalog_delete_department(INTEGER)
RETURNS SMALLINT LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId ALIAS FOR $1;
    categoryRowsCount INTEGER;
  BEGIN
    SELECT INTO categoryRowsCount
           count(*)
    FROM   category
    WHERE  department_id = inDepartmentId;
    IF categoryRowsCount = 0 THEN
      DELETE FROM department WHERE department_id = inDepartmentId;
      RETURN 1;
    END IF;
    RETURN -1;
  END;
$$;

-- Create catalog_add_department function
CREATE FUNCTION catalog_add_department(VARCHAR(50), VARCHAR(1000))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inName        ALIAS FOR $1;
    inDescription ALIAS FOR $2;
  BEGIN
    INSERT INTO department (name, description)
           VALUES (inName, inDescription);
  END;
$$;

-- Create department_category type
CREATE TYPE department_category AS
(
  category_id INTEGER,
  name        VARCHAR(50),
  description VARCHAR(1000)
);

-- Create catalog_get_department_categories function
CREATE FUNCTION catalog_get_department_categories(INTEGER)
RETURNS SETOF department_category LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId ALIAS FOR $1;
    outDepartmentCategoryRow department_category;
  BEGIN
    FOR outDepartmentCategoryRow IN
      SELECT   category_id, name, description
      FROM     category
      WHERE    department_id = inDepartmentId
      ORDER BY category_id
    LOOP
      RETURN NEXT outDepartmentCategoryRow;
    END LOOP;
  END;
$$;

-- Create catalog_add_category function
CREATE FUNCTION catalog_add_category(
                  INTEGER, VARCHAR(50), VARCHAR(1000))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId ALIAS FOR $1;
    inName         ALIAS FOR $2;
    inDescription  ALIAS FOR $3;
  BEGIN
    INSERT INTO category (department_id, name, description)
           VALUES (inDepartmentId, inName, inDescription);
  END;
$$;

-- Create catalog_delete_category function
CREATE FUNCTION catalog_delete_category(INTEGER)
RETURNS SMALLINT LANGUAGE plpgsql AS $$
  DECLARE
    inCategoryId ALIAS FOR $1;
    productCategoryRowsCount INTEGER;
  BEGIN
    SELECT      INTO productCategoryRowsCount
                count(*)
    FROM        product p
    INNER JOIN  product_category pc
                  ON p.product_id = pc.product_id
    WHERE       pc.category_id = inCategoryId;
    IF productCategoryRowsCount = 0 THEN
      DELETE FROM category WHERE category_id = inCategoryId;
      RETURN 1;
    END IF;
    RETURN -1;
  END;
$$;

-- Create catalog_update_category function
CREATE FUNCTION catalog_update_category(
                  INTEGER, VARCHAR(50), VARCHAR(1000))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCategoryId  ALIAS FOR $1;
    inName        ALIAS FOR $2;
    inDescription ALIAS FOR $3;
  BEGIN
    UPDATE category
    SET    name = inName, description = inDescription
    WHERE  category_id = inCategoryId;
  END;
$$;

-- Create category_product type
CREATE TYPE category_product AS
(
  product_id       INTEGER,
  name             VARCHAR(50),
  description      VARCHAR(1000),
  price            NUMERIC(10, 2),
  discounted_price NUMERIC(10, 2)
);

-- Create catalog_get_category_products function
CREATE FUNCTION catalog_get_category_products(INTEGER)
RETURNS SETOF category_product LANGUAGE plpgsql AS $$
  DECLARE
    inCategoryId ALIAS FOR $1;
    outCategoryProductRow category_product;
  BEGIN
    FOR outCategoryProductRow IN
      SELECT     p.product_id, p.name, p.description, p.price,
                 p.discounted_price
      FROM       product p
      INNER JOIN product_category pc
                   ON p.product_id = pc.product_id
      WHERE      pc.category_id = inCategoryId
      ORDER BY   p.product_id
    LOOP
      RETURN NEXT outCategoryProductRow;
    END LOOP;
  END;
$$;

-- Create catalog_add_product_to_category function
CREATE FUNCTION catalog_add_product_to_category(INTEGER, VARCHAR(50),
                  VARCHAR(1000), NUMERIC(10, 2))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCategoryId  ALIAS FOR $1;
    inName        ALIAS FOR $2;
    inDescription ALIAS FOR $3;
    inPrice       ALIAS FOR $4;
    productLastInsertId INTEGER;
  BEGIN
    INSERT INTO product (name, description, price, image, thumbnail,
                         search_vector)
           VALUES (inName, inDescription, inPrice, 'generic.jpg',
                   'generic.thumb.jpg',
                   (setweight(to_tsvector(inName), 'A')
                    || to_tsvector(inDescription)));
    SELECT INTO productLastInsertId currval('product_product_id_seq');
    INSERT INTO product_category (product_id, category_id)
           VALUES (productLastInsertId, inCategoryId);
  END;
$$;

-- Create catalog_update_product function
CREATE FUNCTION catalog_update_product(INTEGER, VARCHAR(50),
                  VARCHAR(1000), NUMERIC(10, 2), NUMERIC(10, 2))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId       ALIAS FOR $1;
    inName            ALIAS FOR $2;
    inDescription     ALIAS FOR $3;
    inPrice           ALIAS FOR $4;
    inDiscountedPrice ALIAS FOR $5;
  BEGIN
    UPDATE product
    SET    name = inName, description = inDescription, price = inPrice,
           discounted_price = inDiscountedPrice,
           search_vector = (setweight(to_tsvector(inName), 'A')
                            || to_tsvector(inDescription))
    WHERE  product_id = inProductId;
  END;
$$;

-- Create catalog_delete_product function
CREATE FUNCTION catalog_delete_product(INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
  BEGIN
    DELETE FROM product_category WHERE product_id = inProductId;
    DELETE FROM product WHERE product_id = inProductId;
  END;
$$;

-- Create catalog_remove_product_from_category function
CREATE FUNCTION catalog_remove_product_from_category(INTEGER, INTEGER)
RETURNS SMALLINT LANGUAGE plpgsql AS $$
  DECLARE
    inProductId  ALIAS FOR $1;
    inCategoryId ALIAS FOR $2;
    productCategoryRowsCount INTEGER;
  BEGIN
    SELECT INTO productCategoryRowsCount
           count(*)
    FROM   product_category
    WHERE  product_id = inProductId;
    IF productCategoryRowsCount = 1 THEN
      PERFORM catalog_delete_product(inProductId);
      RETURN 0;
    END IF;
    DELETE FROM product_category
    WHERE  category_id = inCategoryId AND product_id = inProductId;
    RETURN 1;
  END;
$$;

-- Create catalog_get_categories function
CREATE FUNCTION catalog_get_categories()
RETURNS SETOF department_category LANGUAGE plpgsql AS $$
  DECLARE
    outDepartmentCategoryRow department_category;
  BEGIN
    FOR outDepartmentCategoryRow IN
      SELECT   category_id, name, description
      FROM     category
      ORDER BY category_id
    LOOP
      RETURN NEXT outDepartmentCategoryRow;
    END LOOP;
  END;
$$;

-- Create product_info type
CREATE TYPE product_info AS
(
  name      VARCHAR(50),
  image     VARCHAR(150),
  thumbnail VARCHAR(150),
  display   SMALLINT
);

-- Create catalog_get_product_info function
CREATE FUNCTION catalog_get_product_info(INTEGER)
RETURNS product_info LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
    outProductInfoRow product_info;
  BEGIN
    SELECT INTO outProductInfoRow
           name, image, thumbnail, display
    FROM   product
    WHERE  product_id = inProductId;
    RETURN outProductInfoRow;
  END;
$$;

-- Create product_category_details type
CREATE TYPE product_category_details AS
(
  category_id   INTEGER,
  department_id INTEGER,
  name          VARCHAR(50)
);

-- Create catalog_get_categories_for_product function
CREATE FUNCTION catalog_get_categories_for_product(INTEGER)
RETURNS SETOF product_category_details LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
    outProductCategoryDetailsRow product_category_details;
  BEGIN
    FOR outProductCategoryDetailsRow IN
      SELECT   c.category_id, c.department_id, c.name
      FROM     category c
      JOIN     product_category pc
                 ON c.category_id = pc.category_id
      WHERE    pc.product_id = inProductId
      ORDER BY category_id
    LOOP
      RETURN NEXT outProductCategoryDetailsRow;
    END LOOP;
  END;
$$;

-- Create catalog_set_product_display_option function
CREATE FUNCTION catalog_set_product_display_option(INTEGER, SMALLINT)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
    inDisplay   ALIAS FOR $2;
  BEGIN
    UPDATE product SET display = inDisplay WHERE product_id = inProductId;
  END;
$$;

-- Create catalog_assign_product_to_category function
CREATE FUNCTION catalog_assign_product_to_category(INTEGER, INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId  ALIAS FOR $1;
    inCategoryId ALIAS FOR $2;
  BEGIN
    INSERT INTO product_category (product_id, category_id)
           VALUES (inProductId, inCategoryId);
  END;
$$;

-- Create catalog_move_product_to_category function
CREATE FUNCTION catalog_move_product_to_category(
                  INTEGER, INTEGER, INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId        ALIAS FOR $1;
    inSourceCategoryId ALIAS FOR $2;
    inTargetCategoryId ALIAS FOR $3;
  BEGIN
    UPDATE product_category
    SET    category_id = inTargetCategoryId
    WHERE  product_id = inProductId
           AND category_id = inSourceCategoryId;
  END;
$$;

-- Create catalog_set_image function
CREATE FUNCTION catalog_set_image(INTEGER, VARCHAR(150))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
    inImage     ALIAS FOR $2;
  BEGIN
    UPDATE product SET image = inImage WHERE product_id = inProductId;
  END;
$$;

-- Create catalog_set_thumbnail function
CREATE FUNCTION catalog_set_thumbnail(INTEGER, VARCHAR(150))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
    inThumbnail ALIAS FOR $2;
  BEGIN
    UPDATE product
    SET    thumbnail = inThumbnail
    WHERE  product_id = inProductId;
  END;
$$;
