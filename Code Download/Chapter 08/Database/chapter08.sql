-- Create shopping_cart table
CREATE TABLE shopping_cart
(
  cart_id     CHAR(32)  NOT NULL,
  product_id  INTEGER   NOT NULL,
  quantity    INTEGER   NOT NULL,
  buy_now     BOOLEAN   NOT NULL DEFAULT true,
  added_on    TIMESTAMP NOT NULL,
  CONSTRAINT pk_cart_id_product_id PRIMARY KEY (cart_id, product_id),
  CONSTRAINT fk_product_id         FOREIGN KEY (product_id)
             REFERENCES product (product_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Create shopping_cart_add_product function
CREATE FUNCTION shopping_cart_add_product(CHAR(32), INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCartId        ALIAS FOR $1;
    inProductId     ALIAS FOR $2;
    productQuantity INTEGER;
  BEGIN
    SELECT INTO productQuantity
                quantity
    FROM   shopping_cart
    WHERE  cart_id = inCartId AND product_id = inProductId;
    IF productQuantity IS NULL THEN
      INSERT INTO shopping_cart(cart_id, product_id, quantity, added_on)
             VALUES (inCartId, inProductId , 1, NOW());
    ELSE
      UPDATE shopping_cart
      SET    quantity = quantity + 1, buy_now = true
      WHERE  cart_id = inCartId AND product_id = inProductId;
    END IF;
  END;
$$;

-- Create shopping_cart_update function
CREATE FUNCTION shopping_cart_update(CHAR(32), INTEGER[], INTEGER[])
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCartId     ALIAS FOR $1;
    inProductIds ALIAS FOR $2;
    inQuantities ALIAS FOR $3;
  BEGIN
    FOR i IN array_lower(inQuantities, 1)..array_upper(inQuantities, 1)
    LOOP
      IF inQuantities[i] > 0 THEN
        UPDATE shopping_cart
        SET    quantity = inQuantities[i], added_on = NOW()
        WHERE  cart_id = inCartId AND product_id = inProductIds[i];
      ELSE
        PERFORM shopping_cart_remove_product(inCartId, inProductIds[i]);
      END IF;
    END LOOP;
  END;
$$;

-- Create shopping_cart_remove_product function
CREATE FUNCTION shopping_cart_remove_product(CHAR(32), INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCartId    ALIAS FOR $1;
    inProductId ALIAS FOR $2;
  BEGIN
    DELETE FROM shopping_cart
    WHERE  cart_id = inCartId AND product_id = inProductId;
  END;
$$;

-- Create cart_product type
CREATE TYPE cart_product AS
(
  product_id INTEGER,
  name       VARCHAR(50),
  price      NUMERIC(10, 2),
  quantity   INTEGER,
  subtotal   NUMERIC(10, 2)
);

-- Create shopping_cart_get_products function
CREATE FUNCTION shopping_cart_get_products(CHAR(32))
RETURNS SETOF cart_product LANGUAGE plpgsql AS $$
  DECLARE
    inCartId ALIAS FOR $1;
    outCartProductRow cart_product;
  BEGIN
    FOR outCartProductRow IN
      SELECT     p.product_id, p.name,
                 COALESCE(NULLIF(p.discounted_price, 0), p.price) AS price,
                 sc.quantity,
                 COALESCE(NULLIF(p.discounted_price, 0),
                          p.price) * sc.quantity AS subtotal
      FROM       shopping_cart sc
      INNER JOIN product p
                   ON sc.product_id = p.product_id
      WHERE      sc.cart_id = inCartId AND buy_now
    LOOP
      RETURN NEXT outCartProductRow;
    END LOOP;
  END;
$$;

-- Create cart_saved_product type
CREATE TYPE cart_saved_product AS
(
  product_id INTEGER,
  name       VARCHAR(50),
  price      NUMERIC(10, 2)
);

-- Create shopping_cart_get_saved_products function
CREATE FUNCTION shopping_cart_get_saved_products(CHAR(32))
RETURNS SETOF cart_saved_product LANGUAGE plpgsql AS $$
  DECLARE
    inCartId ALIAS FOR $1;
    outCartSavedProductRow cart_saved_product;
  BEGIN
    FOR outCartSavedProductRow IN
      SELECT     p.product_id, p.name,
                 COALESCE(NULLIF(p.discounted_price, 0), p.price) AS price
      FROM       shopping_cart sc
      INNER JOIN product p
                   ON sc.product_id = p.product_id
      WHERE      sc.cart_id = inCartId AND NOT buy_now
    LOOP
      RETURN NEXT outCartSavedProductRow;
    END LOOP;
  END;
$$;

-- Create shopping_cart_get_total_amount function
CREATE FUNCTION shopping_cart_get_total_amount(CHAR(32))
RETURNS NUMERIC(10, 2) LANGUAGE plpgsql AS $$
  DECLARE
    inCartId ALIAS FOR $1;
    outTotalAmount NUMERIC(10, 2);
  BEGIN
    SELECT     INTO outTotalAmount
               SUM(COALESCE(NULLIF(p.discounted_price, 0), p.price)
                   * sc.quantity)
    FROM       shopping_cart sc
    INNER JOIN product p
                 ON sc.product_id = p.product_id
    WHERE      sc.cart_id = inCartId AND sc.buy_now;
    RETURN outTotalAmount;
  END;
$$;

-- Create shopping_cart_save_product_for_later function
CREATE FUNCTION shopping_cart_save_product_for_later(CHAR(32), INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCartId    ALIAS FOR $1;
    inProductId ALIAS FOR $2;
  BEGIN
    UPDATE shopping_cart
    SET    buy_now = false, quantity = 1
    WHERE  cart_id = inCartId AND product_id = inProductId;
  END;
$$;

-- Create shopping_cart_move_product_to_cart function
CREATE FUNCTION shopping_cart_move_product_to_cart(CHAR(32), INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCartId    ALIAS FOR $1;
    inProductId ALIAS FOR $2;
  BEGIN
    UPDATE shopping_cart
    SET    buy_now = true, added_on = NOW()
    WHERE  cart_id = inCartId AND product_id = inProductId;
  END;
$$;

-- Updates catalog_delete_product function
CREATE OR REPLACE FUNCTION catalog_delete_product(INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
  BEGIN
    DELETE FROM product_category WHERE product_id = inProductId;
    DELETE FROM shopping_cart WHERE product_id = inProductId;
    DELETE FROM product WHERE product_id = inProductId;
  END;
$$;

-- Create shopping_cart_count_old_carts function
CREATE FUNCTION shopping_cart_count_old_carts(INTEGER)
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    inDays ALIAS FOR $1;
    outOldShoppingCartsCount INTEGER;
  BEGIN
    SELECT INTO outOldShoppingCartsCount
           COUNT(cart_id)
    FROM   (SELECT   cart_id
            FROM     shopping_cart
            GROUP BY cart_id
            HAVING   ((NOW() - ('1'||' DAYS')::INTERVAL) >= MAX(added_on)))
           AS old_carts;
    RETURN outOldShoppingCartsCount;
  END;
$$;

-- Create shopping_cart_delete_old_carts function
CREATE FUNCTION shopping_cart_delete_old_carts(INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inDays ALIAS FOR $1;
  BEGIN
    DELETE FROM shopping_cart
    WHERE cart_id IN
         (SELECT    cart_id
           FROM     shopping_cart
           GROUP BY cart_id
           HAVING   ((NOW() - (inDays||' DAYS')::INTERVAL) >= MAX(added_on)));
  END;
$$;
