-- Create review table
CREATE TABLE review
(
  review_id   SERIAL    NOT NULL,
  customer_id INTEGER   NOT NULL,
  product_id  INTEGER   NOT NULL,
  review      TEXT      NOT NULL,
  rating      SMALLINT  NOT NULL,
  created_on  TIMESTAMP NOT NULL,
  CONSTRAINT pk_review_id PRIMARY KEY (review_id),
  CONSTRAINT fk_customer_id FOREIGN KEY (customer_id)
             REFERENCES customer (customer_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_product_id FOREIGN KEY (product_id)
             REFERENCES product (product_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Create review_info type
CREATE TYPE review_info AS
(
  customer_name VARCHAR(50),
  review        TEXT,
  rating        SMALLINT,
  created_on    TIMESTAMP
);

-- Create catalog_get_product_reviews function
CREATE FUNCTION catalog_get_product_reviews(INTEGER)
RETURNS SETOF review_info LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
    outReviewInfoRow review_info;
  BEGIN
    FOR outReviewInfoRow IN
      SELECT     c.name, r.review, r.rating, r.created_on
      FROM       review r
      INNER JOIN customer c
                   ON c.customer_id = r.customer_id
      WHERE      r.product_id = inProductId
      ORDER BY   r.created_on DESC
    LOOP
      RETURN NEXT outReviewInfoRow;
    END LOOP;
  END;
$$;

-- Create catalog_create_product_review function
CREATE FUNCTION catalog_create_product_review(INTEGER, INTEGER, TEXT,
                                              SMALLINT)
RETURNS VOID LANGUAGE plpgsql AS $$
  DECLARE
    inCustomerId ALIAS FOR $1;
    inProductId  ALIAS FOR $2;
    inReview     ALIAS FOR $3;
    inRating     ALIAS FOR $4;
  BEGIN
    INSERT INTO review (customer_id, product_id, review, rating, created_on)
           VALUES (inCustomerId, inProductId, inReview, inRating, NOW());
  END;
$$;
