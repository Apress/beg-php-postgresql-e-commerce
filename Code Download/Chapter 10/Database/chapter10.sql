-- Create product_recommendation type
CREATE TYPE product_recommendation AS
(
  product_id  INTEGER,
  name        VARCHAR(50),
  description VARCHAR(1000)
);

-- Create catalog_get_recommendations function
CREATE FUNCTION catalog_get_recommendations(INTEGER, INTEGER)
RETURNS SETOF product_recommendation LANGUAGE plpgsql AS $$
  DECLARE
    inProductId                     ALIAS FOR $1;
    inShortProductDescriptionLength ALIAS FOR $2;
    outProductRecommendationRow product_recommendation;
  BEGIN
    FOR outProductRecommendationRow IN
      SELECT product_id, name, description
      FROM   product
      WHERE  product_id IN
            (SELECT   od2.product_id
             FROM     order_detail od1
             JOIN     order_detail od2
                        ON od1.order_id = od2.order_id
             WHERE    od1.product_id = inProductId
                      AND od2.product_id != inProductId
             GROUP BY od2.product_id
             ORDER BY COUNT(od2.product_id) DESC
             LIMIT    5)
    LOOP
      IF char_length(outProductRecommendationRow.description) >
         inShortProductDescriptionLength THEN
        outProductRecommendationRow.description :=
          substring(outProductRecommendationRow.description, 1,
                    inShortProductDescriptionLength) || '...';
      END IF;
      RETURN NEXT outProductRecommendationRow;
    END LOOP;
  END;
$$;

-- Create shopping_cart_get_recommendations function
CREATE FUNCTION shopping_cart_get_recommendations(CHAR(32), INTEGER)
RETURNS SETOF product_recommendation LANGUAGE plpgsql AS $$
  DECLARE
    inCartId                        ALIAS FOR $1;
    inShortProductDescriptionLength ALIAS FOR $2;
    outProductRecommendationRow product_recommendation;
  BEGIN
    FOR outProductRecommendationRow IN
      -- Returns the product recommendations
      SELECT product_id, name, description
      FROM   product
      WHERE  product_id IN
            (-- Returns the products that exist in a list of orders
             SELECT   od1.product_id
             FROM     order_detail od1
             JOIN     order_detail od2
                        ON od1.order_id = od2.order_id
             JOIN     shopping_cart
                        ON od2.product_id = shopping_cart.product_id
             WHERE    shopping_cart.cart_id = inCartId
                      -- Must not include products that already exist
                      -- in the visitor's cart
                      AND od1.product_id NOT IN
                     (-- Returns the products in the specified
                      -- shopping cart
                      SELECT product_id
                      FROM   shopping_cart
                      WHERE  cart_id = inCartId)
             -- Group the product_id so we can calculate the rank
             GROUP BY od1.product_id
             -- Order descending by rank
             ORDER BY COUNT(od1.product_id) DESC
             LIMIT    5)
    LOOP
      IF char_length(outProductRecommendationRow.description) >
         inShortProductDescriptionLength THEN
        outProductRecommendationRow.description :=
          substring(outProductRecommendationRow.description, 1,
                    inShortProductDescriptionLength) || '...';
      END IF;
      RETURN NEXT outProductRecommendationRow;
    END LOOP;
  END;
$$;
