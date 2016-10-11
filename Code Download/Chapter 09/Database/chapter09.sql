-- Create orders table
CREATE TABLE orders
(
  order_id         SERIAL        NOT NULL,
  total_amount     NUMERIC(10,2) NOT NULL DEFAULT 0.00,
  created_on       TIMESTAMP     NOT NULL,
  shipped_on       TIMESTAMP,
  status           INTEGER       NOT NULL DEFAULT 0,
  comments         VARCHAR(255),
  customer_name    VARCHAR(50),
  shipping_address VARCHAR(255),
  customer_email   VARCHAR(50),
  CONSTRAINT pk_order_id PRIMARY KEY (order_id)
);

-- Create order_detail table
CREATE TABLE order_detail
(
  order_id     INTEGER        NOT NULL,
  product_id   INTEGER        NOT NULL,
  product_name VARCHAR(50)    NOT NULL,
  quantity     INTEGER        NOT NULL,
  unit_cost    NUMERIC(10, 2) NOT NULL,
  CONSTRAINT pk_order_id_product_id PRIMARY KEY (order_id, product_id),
  CONSTRAINT fk_order_id            FOREIGN KEY (order_id)
             REFERENCES orders (order_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Create shopping_cart_empty function
CREATE FUNCTION shopping_cart_empty(CHAR(32))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCartId ALIAS FOR $1;
  BEGIN
    DELETE FROM shopping_cart WHERE cart_id = inCartId;
  END;
$$;

-- Create shopping_cart_create_order function
CREATE FUNCTION shopping_cart_create_order(CHAR(32))
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    inCartId ALIAS FOR $1;
    outOrderId       INTEGER;
    cartItem         cart_product;
    orderTotalAmount NUMERIC(10, 2);
  BEGIN
    -- Insert a new record into orders
    INSERT INTO orders (created_on) VALUES (NOW());
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

-- Create order_short_details type
CREATE TYPE order_short_details AS
(
  order_id      INTEGER,
  total_amount  NUMERIC(10, 2),
  created_on    TIMESTAMP,
  shipped_on    TIMESTAMP,
  status        INTEGER,
  customer_name VARCHAR(50)
);

-- Create orders_get_most_recent_orders function
CREATE FUNCTION orders_get_most_recent_orders(INTEGER)
RETURNS SETOF order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inHowMany ALIAS FOR $1;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    FOR outOrderShortDetailsRow IN
      SELECT   order_id, total_amount, created_on,
               shipped_on, status, customer_name
      FROM     orders
      ORDER BY created_on DESC
      LIMIT    inHowMany
    LOOP
      RETURN NEXT outOrderShortDetailsRow;
    END LOOP;
  END;
$$;

-- Create orders_get_orders_between_dates function
CREATE FUNCTION orders_get_orders_between_dates(TIMESTAMP, TIMESTAMP)
RETURNS SETOF order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inStartDate ALIAS FOR $1;
    inEndDate   ALIAS FOR $2;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    FOR outOrderShortDetailsRow IN
      SELECT   order_id, total_amount, created_on,
               shipped_on, status, customer_name
      FROM     orders
      WHERE    created_on >= inStartDate AND created_on <= inEndDate
      ORDER BY created_on DESC
    LOOP
      RETURN NEXT outOrderShortDetailsRow;
    END LOOP;
  END;
$$;

-- Create orders_get_orders_by_status function
CREATE FUNCTION orders_get_orders_by_status(INTEGER)
RETURNS SETOF order_short_details LANGUAGE plpgsql AS $$
  DECLARE
    inStatus ALIAS FOR $1;
    outOrderShortDetailsRow order_short_details;
  BEGIN
    FOR outOrderShortDetailsRow IN
      SELECT   order_id, total_amount, created_on,
               shipped_on, status, customer_name
      FROM     orders
      WHERE    status = inStatus
      ORDER BY created_on DESC
    LOOP
      RETURN NEXT outOrderShortDetailsRow;
    END LOOP;
  END;
$$;

-- Create orders_get_order_info function
CREATE FUNCTION orders_get_order_info(INTEGER)
RETURNS orders LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
    outOrdersRow orders;
  BEGIN
    SELECT INTO outOrdersRow
                order_id, total_amount, created_on, shipped_on, status,
                comments, customer_name, shipping_address, customer_email
    FROM   orders
    WHERE  order_id = inOrderId;
    RETURN outOrdersRow;
  END;
$$;

-- Create order_details type
CREATE TYPE order_details AS
(
  order_id     INTEGER,
  product_id   INTEGER,
  product_name VARCHAR(50),
  quantity     INTEGER,
  unit_cost    NUMERIC(10, 2),
  subtotal     NUMERIC(10, 2)
);

-- Create orders_get_order_details function
CREATE FUNCTION orders_get_order_details(INTEGER)
RETURNS SETOF order_details LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
    outOrderDetailsRow order_details;
  BEGIN
    FOR outOrderDetailsRow IN
      SELECT order_id, product_id, product_name, quantity,
             unit_cost, (quantity * unit_cost) AS subtotal
      FROM   order_detail
      WHERE  order_id = inOrderId
    LOOP
      RETURN NEXT outOrderDetailsRow;
    END LOOP;
  END;
$$;

-- Create orders_update_order function
CREATE FUNCTION orders_update_order(INTEGER, INTEGER, VARCHAR(255),
                  VARCHAR(50), VARCHAR(255), VARCHAR(50))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId         ALIAS FOR $1;
    inStatus          ALIAS FOR $2;
    inComments        ALIAS FOR $3;
    inCustomerName    ALIAS FOR $4;
    inShippingAddress ALIAS FOR $5;
    inCustomerEmail   ALIAS FOR $6;
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
           customer_name = inCustomerName,
           shipping_address = inShippingAddress,
           customer_email = inCustomerEmail
    WHERE  order_id = inOrderId;
  END;
$$;
