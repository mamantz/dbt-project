create or replace trigger update_final_invoice_trigger
after insert on customer.order_invoice
for each row
execute function update_final_invoice();