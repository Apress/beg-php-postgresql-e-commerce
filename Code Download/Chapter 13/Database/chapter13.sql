-- Create audit table
CREATE TABLE audit
(
  audit_id       SERIAL    NOT NULL,
  order_id       INTEGER   NOT NULL,
  created_on     TIMESTAMP NOT NULL,
  message        TEXT      NOT NULL,
  message_number INTEGER   NOT NULL,
  CONSTRAINT pk_audit_id PRIMARY KEY (audit_id),
  CONSTRAINT fk_order_id FOREIGN KEY (order_id)
             REFERENCES orders (order_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Create orders_create_audit function
CREATE FUNCTION orders_create_audit(INTEGER, TEXT, INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId       ALIAS FOR $1;
    inMessage       ALIAS FOR $2;
    inMessageNumber ALIAS FOR $3;
  BEGIN
    INSERT INTO audit (order_id, created_on, message, message_number)
           VALUES (inOrderId, NOW(), inMessage, inMessageNumber);
  END;
$$;

-- Create orders_update_status function
CREATE FUNCTION orders_update_status(INTEGER, INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
    inStatus  ALIAS FOR $2;
  BEGIN
    UPDATE orders SET status = inStatus WHERE order_id = inOrderId;
  END;
$$;

-- Create orders_set_auth_code function
CREATE FUNCTION orders_set_auth_code(INTEGER, VARCHAR(50), VARCHAR(50))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId   ALIAS FOR $1;
    inAuthCode  ALIAS FOR $2;
    inReference ALIAS FOR $3;
  BEGIN
    UPDATE orders
    SET    auth_code = inAuthCode, reference = inReference
    WHERE  order_id = inOrderId;
  END;
$$;

-- Create orders_set_date_shipped function
CREATE FUNCTION orders_set_date_shipped(INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
  BEGIN
    UPDATE orders SET shipped_on = NOW() WHERE order_id = inOrderId;
  END;
$$;
