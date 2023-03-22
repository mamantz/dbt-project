CREATE OR REPLACE FUNCTION update_final_invoice()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM customer.final_invoice WHERE order_id = NEW.order_id;

  INSERT INTO customer.final_invoice (customer_id, order_id, num_items_purchased, total_paid, date_purchased, item_id_list)
  SELECT 
    NEW.customer_id, NEW.order_id, SUM(num_of_items), 
    SUM(price * num_of_items), NEW.purchased_on, string_agg(REPEAT(item_id || ',', num_of_items), '')
  FROM customer.order_invoice
  WHERE order_id = NEW.order_id
  GROUP BY NEW.customer_id, NEW.order_id, NEW.purchased_on;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;