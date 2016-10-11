-- Create shipping_region table
CREATE TABLE shipping_region
(
  shipping_region_id SERIAL       NOT NULL,
  shipping_region    VARCHAR(100) NOT NULL,
  CONSTRAINT pk_shipping_region_id PRIMARY KEY (shipping_region_id)
);

-- Populate shipping_region table
INSERT INTO shipping_region (shipping_region_id, shipping_region)
       VALUES (1, 'Please Select');
INSERT INTO shipping_region (shipping_region_id, shipping_region)
       VALUES (2, 'US / Canada');
INSERT INTO shipping_region (shipping_region_id, shipping_region)
       VALUES (3, 'Europe');
INSERT INTO shipping_region (shipping_region_id, shipping_region)
       VALUES (4, 'Rest of World');
-- Update the sequence
ALTER SEQUENCE shipping_region_shipping_region_id_seq RESTART WITH 5;

-- Create customer table
CREATE TABLE customer
(
  customer_id        SERIAL        NOT NULL,
  name               VARCHAR(50)   NOT NULL,
  email              VARCHAR(100)  NOT NULL,
  password           VARCHAR(50)   NOT NULL,
  credit_card        TEXT,
  address_1          VARCHAR(100),
  address_2          VARCHAR(100),
  city               VARCHAR(100),
  region             VARCHAR(100),
  postal_code        VARCHAR(100),
  country            VARCHAR(100),
  shipping_region_id INTEGER       NOT NULL  DEFAULT 1,
  day_phone          VARCHAR(100),
  eve_phone          VARCHAR(100),
  mob_phone          VARCHAR(100),
  CONSTRAINT pk_customer_id        PRIMARY KEY (customer_id),
  CONSTRAINT fk_shipping_region_id FOREIGN KEY (shipping_region_id)
             REFERENCES shipping_region (shipping_region_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT uk_email              UNIQUE (email)
);

-- Create customer_login_info type
CREATE TYPE customer_login_info AS
(
  customer_id INTEGER,
  password    VARCHAR(50)
);

-- Create customer_get_login_info function
CREATE FUNCTION customer_get_login_info(VARCHAR(100))
RETURNS customer_login_info LANGUAGE plpgsql AS $$
  DECLARE
    inEmail ALIAS FOR $1;
    outCustomerLoginInfoRow customer_login_info;
  BEGIN
    SELECT INTO outCustomerLoginInfoRow
                customer_id, password
    FROM   customer
    WHERE  email = inEmail;
    RETURN outCustomerLoginInfoRow;
  END;
$$;

-- Create customer_add function
CREATE FUNCTION customer_add(
                  VARCHAR(50), VARCHAR(100), VARCHAR(50))
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    inName     ALIAS FOR $1;
    inEmail    ALIAS FOR $2;
    inPassword ALIAS FOR $3;
    outCustomerId INTEGER;
  BEGIN
    INSERT INTO customer (name, email, password)
           VALUES (inName, inEmail, inPassword);
    SELECT INTO outCustomerId
           currval('customer_customer_id_seq');
    RETURN outCustomerId;
  END;
$$;

-- Create customer_get_customer function
CREATE FUNCTION customer_get_customer(INTEGER)
RETURNS customer LANGUAGE plpgsql AS $$
  DECLARE
    inCustomerId ALIAS FOR $1;
    outCustomerRow customer;
  BEGIN
    SELECT INTO outCustomerRow
                customer_id, name, email, password, credit_card,
                address_1, address_2, city, region, postal_code, country,
                shipping_region_id, day_phone, eve_phone, mob_phone
    FROM   customer
    WHERE  customer_id = inCustomerId;
    RETURN outCustomerRow;
  END;
$$;

-- Create customer_update_account function
CREATE FUNCTION customer_update_account(INTEGER, VARCHAR(50), VARCHAR(100),
                  VARCHAR(50), VARCHAR(100), VARCHAR(100), VARCHAR(100))
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCustomerId ALIAS FOR $1;
    inName       ALIAS FOR $2;
    inEmail      ALIAS FOR $3;
    inPassword   ALIAS FOR $4;
    inDayPhone   ALIAS FOR $5;
    inEvePhone   ALIAS FOR $6;
    inMobPhone   ALIAS FOR $7;
  BEGIN
    UPDATE customer
    SET    name = inName, email = inEmail,
           password = inPassword, day_phone = inDayPhone,
           eve_phone = inEvePhone, mob_phone = inMobPhone
    WHERE  customer_id = inCustomerId;
  END;
$$;

-- Create customer_update_credit_card function
CREATE FUNCTION customer_update_credit_card(INTEGER, TEXT)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCustomerId ALIAS FOR $1;
    inCreditCard ALIAS FOR $2;
  BEGIN
    UPDATE customer
    SET    credit_card = inCreditCard
    WHERE  customer_id = inCustomerId;
  END;
$$;

-- Create customer_get_shipping_regions function
CREATE FUNCTION customer_get_shipping_regions()
RETURNS SETOF shipping_region LANGUAGE plpgsql AS $$
  DECLARE
    outShippingRegion shipping_region;
  BEGIN
    FOR outShippingRegion IN
      SELECT shipping_region_id, shipping_region
      FROM   shipping_region
    LOOP
      RETURN NEXT outShippingRegion;
    END LOOP;
    RETURN;
  END;
$$;

-- Create customer_update_address function
CREATE FUNCTION customer_update_address(INTEGER, VARCHAR(100),
                  VARCHAR(100), VARCHAR(100), VARCHAR(100),
                  VARCHAR(100), VARCHAR(100), INTEGER)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCustomerId       ALIAS FOR $1;
    inAddress1         ALIAS FOR $2;
    inAddress2         ALIAS FOR $3;
    inCity             ALIAS FOR $4;
    inRegion           ALIAS FOR $5;
    inPostalCode       ALIAS FOR $6;
    inCountry          ALIAS FOR $7;
    inShippingRegionId ALIAS FOR $8;
  BEGIN
    UPDATE customer
    SET    address_1 = inAddress1, address_2 = inAddress2, city = inCity,
           region = inRegion, postal_code = inPostalCode,
           country = inCountry, shipping_region_id = inShippingRegionId
    WHERE  customer_id = inCustomerId;
  END;
$$;
