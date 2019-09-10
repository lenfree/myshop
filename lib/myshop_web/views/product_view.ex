defmodule MyshopWeb.ProductView do
  use MyshopWeb, :view
  alias Myshop.Products

  def category_select_options(categories) do
    for category <- categories, do: {category.name, category.id}
  end

  def to_price(attr) when is_atom(attr) do
    attr
  end

  def to_price(value) do
    Decimal.mult(Decimal.new(value), Decimal.new(100))
  end
end
