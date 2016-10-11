-- Delete all records from order_detail table
DELETE FROM order_detail;

-- Delete all records from orders table
DELETE FROM orders;

-- Drop customer_name field from orders table
ALTER TABLE orders DROP COLUMN customer_name;

-- Drop shipping_address field from orders table
ALTER TABLE orders DROP COLUMN shipping_address;

-- Drop customer_email field from orders table
ALTER TABLE orders DROP COLUMN customer_email;

-- Adding a new field named customer_id to orders table
ALTER TABLE orders ADD COLUMN customer_id INTEGER;

-- Adding a new field named auth_code to orders table
ALTER TABLE orders ADD COLUMN auth_code VARCHAR(50);

-- Adding a new field named reference to orders table
ALTER TABLE orders ADD COLUMN reference VARCHAR(50);

-- Adding a new foreign key constraint to orders table
ALTER TABLE orders
  ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id)
                 REFERENCES customer (customer_id)
                 ON UPDATE RESTRICT ON DELETE RESTRICT;

-- Drop shopping_cart_create_order function
DROP FUNCTION shopping_cart_create_order(CHAR(32));

-- Create shopping_cart_create_order function
CREATE FUNCTION shopping_cart_create_order(CHAR(32), INTEGER)
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    inCartId     ALIAS FOR $1;
    inCustomerId ALIAS FOR $2;
    outOrderId INTEGER;
    cartItem cart_product;
    orderTotalAmount NUMERIC(10, 2);
  BEGIN
    -- Insert a new record into orders
    INSERT INTO orders (created_on, customer_id)
           VALUES (NOW(), inCustomerId);
    -- Obtain the new Order ID
    SELECT INTO outOrderId
           currval('orders_order_id_seq');
    orderTotalAmount := 0;
    -- Insert order details in order_detail table
    FOR cartItem IN
      SELECT     p.product_id, p.name,
                 COALESCE(NULLIF(p.discounted_price, 0), p.price) AS price,
                 sc.quantity,
                 COALESCE(NULLIF(p.discounted_price, 0), p.price) * sc.quantity
                   AS subtotal
      FROM       shopping_cart sc
      INNER JOIN product p
                   ON sc.product_id = p.product_id
      WHERE      sc.cart_id = inCartId AND sc.buy_now
    LOOP
      INSERT INTO order_detail (order_id, product_id, product_name,
                                quantity, unit_cost)
             VALUES (outOrderId, cartItem.product_id, cartItem.name,
                     cartItem.quantity, cartItem.price);
      orderTotalAmount := orderTotalAmount + cartItem.subtotal;
    END LOOP;
    -- Save the order's total amount
    UPDATE orders
    SET    total_amount = orderTotalAmount
    WHERE  order_id = outOrderId;
    -- Clear the shopping cart
    PERFORM shopping_cart_empty(inCartId);
    -- Return the Order ID
    RETURN outOrderId;
  END;
$$;

-- Update orders_get_most_recent_orders function
CREATE OR REPLACE FUNCTION orders_get_most_recent_orders(INTEGER)
RETURNS SETOF order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inHowMany ALIAS FOR $1;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    FOR outOrderShortDetailsRow IN
      SELECT     o.order_id, o.total_amount, o.created_on,
                 o.shipped_on, o.status, c.name
      FROM       orders o
      INNER JOIN customer c
                   ON o.customer_id = c.customer_id
      ORDER BY   o.created_on DESC
      LIMIT      inHowMany
    LOOP
      RETURN NEXT outOrderShortDetailsRow;
    END LOOP;
  END;
$$;

-- Update orders_get_orders_between_dates function
CREATE OR REPLACE FUNCTION orders_get_orders_between_dates(TIMESTAMP, TIMESTAMP)
RETURNS SETOF order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inStartDate ALIAS FOR $1;
    inEndDate   ALIAS FOR $2;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    FOR outOrderShortDetailsRow IN
      SELECT     o.order_id, o.total_amount, o.created_on,
                 o.shipped_on, o.status, c.name
      FROM       orders o
      INNER JOIN customer c
                   ON o.customer_id = c.customer_id
      WHERE      o.created_on >= inStartDate AND o.created_on <= inEndDate
      ORDER BY   o.created_on DESC
    LOOP
      RETURN NEXT outOrderShortDetailsRow;
    END LOOP;
  END;
$$;

-- Update orders_get_orders_by_status function
CREATE OR REPLACE FUNCTION orders_get_orders_by_status(INTEGER)
RETURNS SETOF order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inStatus ALIAS FOR $1;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    FOR outOrderShortDetailsRow IN
      SELECT     o.order_id, o.total_amount, o.created_on,
                 o.shipped_on, o.status, c.name
      FROM       orders o
      INNER JOIN customer c
                   ON o.customer_id = c.customer_id
      WHERE      o.status = inStatus
      ORDER BY   o.created_on DESC
    LOOP
      RETURN NEXT outOrderShortDetailsRow;
    END LOOP;
  END;
$$;

-- Update orders_get_order_info function
CREATE OR REPLACE FUNCTION orders_get_order_info(INTEGER)
RETURNS orders LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
    outOrdersRow orders;
  BEGIN
    SELECT INTO outOrdersRow
                order_id, total_amount, created_on, shipped_on, status,
                comments, customer_id, auth_code, reference
    FROM   orders
    WHERE  order_id = inOrderId;
    RETURN outOrdersRow;
  END;
$$;

-- Create orders_get_by_customer_id function
CREATE FUNCTION orders_get_by_customer_id(INTEGER)
RETURNS SETOF order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inCustomerId ALIAS FOR $1;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    FOR outOrderShortDetailsRow IN
      SELECT     o.order_id, o.total_amount, o.created_on,
                 o.shipped_on, o.status, c.name
      FROM       orders o
      INNER JOIN customer c
                   ON o.customer_id = c.customer_id
      WHERE      o.customer_id = inCustomerId
      ORDER BY   o.created_on DESC
    LOOP
      RETURN NEXT outOrderShortDetailsRow;
    END LOOP;
  END;
$$;

-- Create orders_get_order_short_details function
CREATE FUNCTION orders_get_order_short_details(INTEGER)
RETURNS order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    SELECT INTO outOrderShortDetailsRow
                o.order_id, o.total_amount, o.created_on,
                o.shipped_on, o.status, c.name
    FROM        orders o
    INNER JOIN  customer c
                  ON o.customer_id = c.customer_id
    WHERE       o.order_id = inOrderId;
    RETURN outOrderShortDetailsRow;
  END;
$$;

-- Create customer_list type
CREATE TYPE customer_list AS
(
  customer_id INTEGER,
  name        VARCHAR(50)
);

-- Create customer_get_customers_list function
CREATE FUNCTION customer_get_customers_list()
RETURNS SETOF customer_list LANGUAGE plpgsql AS $$
  DECLARE
    outCustomerListRow customer_list;
  BEGIN
    FOR outCustomerListRow IN
      SELECT customer_id, name FROM customer ORDER BY name ASC
    LOOP
      RETURN NEXT outCustomerListRow;
    END LOOP;
  END;
$$;

-- Drop orders_update_order function
DROP FUNCTION orders_update_order(INTEGER, INTEGER, VARCHAR(255),
                                  VARCHAR(50), VARCHAR(255), VARCHAR(50));

-- Create orders_update_order function
CREATE FUNCTION orders_update_order(INTEGER, INTEGER, VARCHAR(255),
                                     VARCHAR(50), VARCHAR(50))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId    ALIAS FOR $1;
    inStatus     ALIAS FOR $2;
    inComments   ALIAS FOR $3;
    inAuthCode   ALIAS FOR $4;
    inReference  ALIAS FOR $5;
    currentStatus INTEGER;
  BEGIN
    SELECT INTO currentStatus
           status
    FROM   orders
    WHERE  order_id = inOrderId;
    IF  inStatus != currentStatus AND (inStatus = 0 OR inStatus = 1) THEN
      UPDATE orders SET shipped_on = NULL WHERE order_id = inOrderId;
    ELSEIF inStatus != currentStatus AND inStatus = 2 THEN
      UPDATE orders SET shipped_on = NOW() WHERE order_id = inOrderId;
    END IF;
    UPDATE orders
    SET    status = inStatus, comments = inComments,
           auth_code = inAuthCode, reference = inReference
    WHERE  order_id = inOrderId;
  END;
$$;

-- Create shipping table
CREATE TABLE shipping
(
  shipping_id        SERIAL         NOT NULL,
  shipping_type      VARCHAR(100)   NOT NULL,
  shipping_cost      NUMERIC(10, 2) NOT NULL,
  shipping_region_id INTEGER        NOT NULL,
  CONSTRAINT pk_shipping_id        PRIMARY KEY (shipping_id),
  CONSTRAINT fk_shipping_region_id FOREIGN KEY (shipping_region_id)
             REFERENCES shipping_region (shipping_region_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Populate shipping table
INSERT INTO shipping (shipping_id, shipping_type,
                      shipping_cost, shipping_region_id)
       VALUES(1, 'Next Day Delivery ($20)', 20.00, 2);

INSERT INTO shipping (shipping_id, shipping_type,
                      shipping_cost, shipping_region_id)
       VALUES(2, '3-4 Days ($10)', 10.00, 2);

INSERT INTO shipping (shipping_id, shipping_type,
                      shipping_cost, shipping_region_id)
       VALUES(3, '7 Days ($5)', 5.00, 2);

INSERT INTO shipping (shipping_id, shipping_type,
                      shipping_cost, shipping_region_id)
       VALUES(4, 'By air (7 days, $25)', 25.00, 3);

INSERT INTO shipping (shipping_id, shipping_type,
                      shipping_cost, shipping_region_id)
       VALUES(5, 'By sea (28 days, $10)', 10.00, 3);

INSERT INTO shipping (shipping_id, shipping_type,
                      shipping_cost, shipping_region_id)
       VALUES(6, 'By air (10 days, $35)', 35.00, 4);

INSERT INTO shipping (shipping_id, shipping_type,
                      shipping_cost, shipping_region_id)
       VALUES(7, 'By sea (28 days, $30)', 30.00, 4);

-- Update the sequence
ALTER SEQUENCE shipping_shipping_id_seq RESTART WITH 8;

-- Create tax table
CREATE TABLE tax
(
  tax_id         SERIAL         NOT NULL,
  tax_type       VARCHAR(100)   NOT NULL,
  tax_percentage NUMERIC(10, 2) NOT NULL,
  CONSTRAINT pk_tax_id PRIMARY KEY (tax_id)
);

-- Populate tax table
INSERT INTO tax (tax_id, tax_type, tax_percentage)
       VALUES(1, 'Sales Tax at 8.5%', 8.50);

INSERT INTO tax (tax_id, tax_type, tax_percentage)
       VALUES(2, 'No Tax', 0.00);

-- Update the sequence
ALTER SEQUENCE tax_tax_id_seq RESTART WITH 3;

-- Adding a new field named shipping_id to orders table
ALTER TABLE orders ADD COLUMN shipping_id INTEGER;

-- Adding a new foreign key constraint to orders table
ALTER TABLE orders
  ADD CONSTRAINT fk_shipping_id FOREIGN KEY (shipping_id)
                 REFERENCES shipping (shipping_id)
                 ON UPDATE RESTRICT ON DELETE RESTRICT;

-- Adding a new field named tax_id to orders table
ALTER TABLE orders ADD COLUMN tax_id INTEGER;

-- Adding a new foreign key constraint to orders table
ALTER TABLE orders
  ADD CONSTRAINT fk_tax_id FOREIGN KEY (tax_id)
                 REFERENCES tax (tax_id)
                 ON UPDATE RESTRICT ON DELETE RESTRICT;

-- Drop shopping_cart_create_order function
DROP FUNCTION shopping_cart_create_order(CHAR(32), INTEGER);

-- Create shopping_cart_create_order function
CREATE FUNCTION shopping_cart_create_order(CHAR(32), INTEGER,
                                           INTEGER, INTEGER)
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    inCartId     ALIAS FOR $1;
    inCustomerId ALIAS FOR $2;
    inShippingId ALIAS FOR $3;
    inTaxId      ALIAS FOR $4;
    outOrderId INTEGER;
    cartItem cart_product;
    orderTotalAmount NUMERIC(10, 2);
  BEGIN
    -- Insert a new record into orders
    INSERT INTO orders (created_on, customer_id, shipping_id, tax_id)
           VALUES (NOW(), inCustomerId, inShippingId, inTaxId);
    -- Obtain the new Order ID
    SELECT INTO outOrderId
           currval('orders_order_id_seq');
    orderTotalAmount := 0;
    -- Insert order details in order_detail table
    FOR cartItem IN
      SELECT     p.product_id, p.name,
                 COALESCE(NULLIF(p.discounted_price, 0), p.price) AS price,
                 sc.quantity,
                 COALESCE(NULLIF(p.discounted_price, 0), p.price) * sc.quantity
                   AS subtotal
      FROM       shopping_cart sc
      INNER JOIN product p
                   ON sc.product_id = p.product_id
      WHERE      sc.cart_id = inCartId AND sc.buy_now
    LOOP
      INSERT INTO order_detail (order_id, product_id, product_name,
                                quantity, unit_cost)
             VALUES (outOrderId, cartItem.product_id, cartItem.name,
                     cartItem.quantity, cartItem.price);
      orderTotalAmount := orderTotalAmount + cartItem.subtotal;
    END LOOP;
    -- Save the order's total amount
    UPDATE orders
    SET    total_amount = orderTotalAmount
    WHERE  order_id = outOrderId;
    -- Clear the shopping cart
    PERFORM shopping_cart_empty(inCartId);
    -- Return the Order ID
    RETURN outOrderId;
  END;
$$;

-- Create order_info type
CREATE TYPE order_info AS
(
  order_id       INTEGER,
  total_amount   NUMERIC(10, 2),
  created_on     TIMESTAMP,
  shipped_on     TIMESTAMP,
  status         VARCHAR(9),
  comments       VARCHAR(255),
  customer_id    INTEGER,
  auth_code      VARCHAR(50),
  reference      VARCHAR(50),
  shipping_id    INTEGER,
  shipping_type  VARCHAR(100),
  shipping_cost  NUMERIC(10, 2),
  tax_id         INTEGER,
  tax_type       VARCHAR(100),
  tax_percentage NUMERIC(10, 2)
);

-- Drop orders_get_order_info function
DROP FUNCTION orders_get_order_info(INTEGER);

-- Create orders_get_order_info function
CREATE FUNCTION orders_get_order_info(INTEGER)
RETURNS order_info LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
    outOrderInfoRow order_info;
  BEGIN
    SELECT INTO outOrderInfoRow
                o.order_id, o.total_amount, o.created_on, o.shipped_on,
                o.status, o.comments, o.customer_id, o.auth_code,
                o.reference, o.shipping_id, s.shipping_type, s.shipping_cost,
                o.tax_id, t.tax_type, t.tax_percentage
    FROM       orders o
    INNER JOIN tax t
                 ON t.tax_id = o.tax_id
    INNER JOIN shipping s
                 ON s.shipping_id = o.shipping_id
    WHERE      o.order_id = inOrderId;
    RETURN outOrderInfoRow;
  END;
$$;

-- Create orders_get_shipping_info function
CREATE FUNCTION orders_get_shipping_info(INTEGER)
RETURNS SETOF shipping LANGUAGE plpgsql AS $$
  DECLARE
    inShippingRegionId ALIAS FOR $1;
    outShippingRow shipping;
  BEGIN
    FOR outShippingRow IN
      SELECT shipping_id, shipping_type, shipping_cost, shipping_region_id
      FROM   shipping
      WHERE  shipping_region_id = inShippingRegionId
    LOOP
      RETURN NEXT outShippingRow;
    END LOOP;
  END;
$$;
