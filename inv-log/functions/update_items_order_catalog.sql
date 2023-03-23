CREATE OR REPLACE FUNCTION update_num_of_items_in_order_invoice()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM customer.order_catalog oi
    WHERE oi.customer_id = NEW.customer_id
      AND oi.item_id = NEW.item_id
      AND oi.item_desc = NEW.item_desc
      AND oi.price = NEW.price
      AND oi.purchased_on = NEW.purchased_on
      AND oi.customer_name = NEW.customer_name
      AND oi.item_name = NEW.item_name
      AND oi.order_id = NEW.order_id
  ) THEN
    WITH deleted_row AS (
      DELETE FROM customer.order_catalog
      WHERE customer_id = NEW.customer_id
        AND item_id = NEW.item_id
        AND item_desc = NEW.item_desc
        AND price = NEW.price
        AND purchased_on = NEW.purchased_on
        AND customer_name = NEW.customer_name
        AND item_name = NEW.item_name
        AND order_id = NEW.order_id
      RETURNING *
    )
    INSERT INTO customer.order_catalog (customer_id, item_id, item_desc, price, purchased_on, customer_name, item_name, order_id, num_of_items)
    SELECT customer_id, item_id, item_desc, price, purchased_on, customer_name, item_name, order_id, num_of_items+NEW.num_of_items
    FROM deleted_row;
    
    RETURN NULL;
  ELSE
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER update_num_of_items_trigger
BEFORE INSERT OR UPDATE ON customer.order_catalog
FOR EACH ROW
EXECUTE FUNCTION update_num_of_items_in_order_invoice();