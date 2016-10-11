-- Alter product table adding search_vector field
ALTER TABLE product ADD COLUMN search_vector tsvector;

-- Create index for search_vector field in product table
CREATE INDEX idx_search_vector ON product USING gist(search_vector);

-- Update newly added search_vector field from product table
UPDATE product
SET    search_vector = 
         setweight(to_tsvector(name), 'A') || to_tsvector(description);

-- Create catalog_flag_stop_words function
CREATE FUNCTION catalog_flag_stop_words(TEXT[])
RETURNS SETOF SMALLINT LANGUAGE plpgsql AS $$
  DECLARE
    inWords ALIAS FOR $1;
    outFlag SMALLINT;
    query   TEXT;
  BEGIN
    FOR i IN array_lower(inWords, 1)..array_upper(inWords, 1) LOOP
      SELECT INTO query
             to_tsquery(inWords[i]);
      IF query = '' THEN
        outFlag := 1;
      ELSE
        outFlag := 0;
      END IF;
      RETURN NEXT outFlag;
    END LOOP;
  END;
$$;

-- Function returns the number of products that match a search string
CREATE FUNCTION catalog_count_search_result(TEXT[], VARCHAR(3))
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    -- inWords is an array with the words from user's search string
    inWords    ALIAS FOR $1;

    -- inAllWords is 'on' for all-words searches
    -- and 'off' for any-words searches
    inAllWords ALIAS FOR $2;

    outSearchResultCount INTEGER;
    query                TEXT;
    search_operator      VARCHAR(1);
  BEGIN
    -- Initialize query with an empty string
    query := '';
    -- Establish the operator to be used when preparing the search string
    IF inAllWords = 'on' THEN
      search_operator := '&';
    ELSE
      search_operator := '|';
    END IF;

    -- Compose the search string
    FOR i IN array_lower(inWords, 1)..array_upper(inWords, 1) LOOP
      IF i = array_upper(inWords, 1) THEN
        query := query || inWords[i];
      ELSE
        query := query || inWords[i] || search_operator;
      END IF;
    END LOOP;

    -- Return the number of matches
    SELECT INTO outSearchResultCount
           count(*)
    FROM   product,
           to_tsquery(query) AS query_string
    WHERE  search_vector @@ query_string;
    RETURN outSearchResultCount;
  END;
$$;

-- Create catalog_search function
CREATE FUNCTION catalog_search(TEXT[], VARCHAR(3), INTEGER, INTEGER, INTEGER)
RETURNS SETOF product_list LANGUAGE plpgsql AS $$
  DECLARE
    inWords                         ALIAS FOR $1;
    inAllWords                      ALIAS FOR $2;
    inShortProductDescriptionLength ALIAS FOR $3;
    inProductsPerPage               ALIAS FOR $4;
    inStartPage                     ALIAS FOR $5;
    outProductListRow product_list;
    query             TEXT;
    search_operator   VARCHAR(1);
    query_string      TSQUERY;
  BEGIN
    -- Initialize query with an empty string
    query := '';
    -- All-words or Any-words?
    IF inAllWords = 'on' THEN
      search_operator := '&';
    ELSE
      search_operator := '|';
    END IF;

    -- Compose the search string
    FOR i IN array_lower(inWords, 1)..array_upper(inWords, 1) LOOP
      IF i = array_upper(inWords, 1) THEN
        query := query||inWords[i];
      ELSE
        query := query||inWords[i]||search_operator;
      END IF;
    END LOOP;
    query_string := to_tsquery(query);

    -- Return the search results
    FOR outProductListRow IN
      SELECT   product_id, name, description, price,
               discounted_price, thumbnail
      FROM     product
      WHERE    search_vector @@ query_string
      ORDER BY rank(search_vector, query_string) DESC
      LIMIT    inProductsPerPage
      OFFSET   inStartPage
    LOOP
      IF char_length(outProductListRow.description) >
         inShortProductDescriptionLength THEN
        outProductListRow.description :=
          substring(outProductListRow.description, 1,
                    inShortProductDescriptionLength) || '...';
      END IF;
      RETURN NEXT outProductListRow;
    END LOOP;
  END;
$$;
