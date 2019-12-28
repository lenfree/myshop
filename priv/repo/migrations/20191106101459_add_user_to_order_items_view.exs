defmodule Myshop.Repo.Migrations.AddUserToOrderItemsView do
  use Ecto.Migration

  def up do
    execute("""
    CREATE VIEW order_items AS
    SELECT i.*, o.id as order_id,
    o.user_id, o.paid, o.notes,
    o.inserted_at, o.updated_at,
    o.ordered_at, 
    o.state
    FROM orders AS o, jsonb_to_recordset(o.product_items)
    AS i(name text,
     quantity int,
     price float, id text)
    """)
  end

  def down do
    execute("DROP VIEW order_items")
  end
end
