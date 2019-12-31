defmodule MyshopWeb.RefundControllerTest do
  use MyshopWeb.ConnCase

  alias Myshop.Orders

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:refund) do
    {:ok, refund} = Orders.create_refund(@create_attrs)
    refund
  end

  describe "index" do
    test "lists all refunds", %{conn: conn} do
      conn = get(conn, Routes.refund_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Refunds"
    end
  end

  describe "new refund" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.refund_path(conn, :new))
      assert html_response(conn, 200) =~ "New Refund"
    end
  end

  describe "create refund" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.refund_path(conn, :create), refund: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.refund_path(conn, :show, id)

      conn = get(conn, Routes.refund_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Refund"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.refund_path(conn, :create), refund: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Refund"
    end
  end

  describe "edit refund" do
    setup [:create_refund]

    test "renders form for editing chosen refund", %{conn: conn, refund: refund} do
      conn = get(conn, Routes.refund_path(conn, :edit, refund))
      assert html_response(conn, 200) =~ "Edit Refund"
    end
  end

  describe "update refund" do
    setup [:create_refund]

    test "redirects when data is valid", %{conn: conn, refund: refund} do
      conn = put(conn, Routes.refund_path(conn, :update, refund), refund: @update_attrs)
      assert redirected_to(conn) == Routes.refund_path(conn, :show, refund)

      conn = get(conn, Routes.refund_path(conn, :show, refund))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, refund: refund} do
      conn = put(conn, Routes.refund_path(conn, :update, refund), refund: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Refund"
    end
  end

  describe "delete refund" do
    setup [:create_refund]

    test "deletes chosen refund", %{conn: conn, refund: refund} do
      conn = delete(conn, Routes.refund_path(conn, :delete, refund))
      assert redirected_to(conn) == Routes.refund_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.refund_path(conn, :show, refund))
      end
    end
  end

  defp create_refund(_) do
    refund = fixture(:refund)
    {:ok, refund: refund}
  end
end
