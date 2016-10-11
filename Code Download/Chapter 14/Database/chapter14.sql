-- Update orders_update_order function
CREATE OR REPLACE FUNCTION orders_update_order(INTEGER, INTEGER,
                             VARCHAR(255), VARCHAR(50), VARCHAR(50))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId    ALIAS FOR $1;
    inStatus     ALIAS FOR $2;
    inComments   ALIAS FOR $3;
    inAuthCode   ALIAS FOR $4;
    inReference  ALIAS FOR $5;
    currentDateShipped TIMESTAMP;
  BEGIN
    SELECT INTO currentDateShipped
                shipped_on
    FROM   orders
    WHERE  order_id = inOrderId;

    UPDATE orders
    SET    status = inStatus, comments = inComments,
           auth_code = inAuthCode, reference = inReference
    WHERE  order_id = inOrderId;

    IF inStatus < 7 AND currentDateShipped IS NOT NULL THEN
      UPDATE orders SET shipped_on = NULL WHERE order_id = inOrderId;
    ELSEIF inStatus > 6 AND currentDateShipped IS NULL THEN
      UPDATE orders SET shipped_on = NOW() WHERE order_id = inOrderId;
    END IF;
  END;
$$;

-- Create orders_get_audit_trail function
CREATE FUNCTION orders_get_audit_trail(INTEGER)
RETURNS SETOF audit LANGUAGE plpgsql AS $$
  DECLARE
    inOrderId ALIAS FOR $1;
    outAuditRow audit;
  BEGIN
    FOR outAuditRow IN
      SELECT audit_id, order_id, created_on, message, message_number
      FROM   audit
      WHERE  order_id = inOrderId
    LOOP
      RETURN NEXT outAuditRow;
    END LOOP;
  END;
$$;
