defmodule MyshopWeb.PageControllerTest do
  use MyshopWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Myshop!"
  end
end
