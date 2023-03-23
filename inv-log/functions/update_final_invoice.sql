CREATE OR REPLACE FUNCTION update_final_invoice()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM customer.final_invoice WHERE order_id = NEW.order_id;

  INSERT INTO customer.final_invoice (customer_id, order_id, num_items_purchased, total_paid, date_purchased, item_id_list)
  SELECT 
    i.customer_id, 
    c.order_id,
    SUM(c.num_of_items), 
    SUM(c.price * c.num_of_items),
    i.purchased_on,
    string_agg(REPEAT(c.item_id || ',', c.num_of_items), '')
  FROM customer.order_catalog c
  JOIN customer.order_info i ON i.order_id = c.order_id
  WHERE c.order_id = NEW.order_id
  GROUP BY i.customer_id, c.order_id, i.purchased_on;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER update_final_invoice_trigger
AFTER INSERT OR UPDATE ON customer.order_catalog
FOR EACH ROW
EXECUTE FUNCTION update_final_invoice();