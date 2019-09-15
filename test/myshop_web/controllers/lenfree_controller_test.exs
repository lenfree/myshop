defmodule MyshopWeb.LenfreeControllerTest do
  use MyshopWeb.ConnCase

  alias Myshop.New

  @create_attrs %{items: %{}, name: "some name"}
  @update_attrs %{items: %{}, name: "some updated name"}
  @invalid_attrs %{items: nil, name: nil}

  def fixture(:lenfree) do
    {:ok, lenfree} = New.create_lenfree(@create_attrs)
    lenfree
  end

  describe "index" do
    test "lists all lenfrees", %{conn: conn} do
      conn = get(conn, Routes.lenfree_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Lenfrees"
    end
  end

  describe "new lenfree" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.lenfree_path(conn, :new))
      assert html_response(conn, 200) =~ "New Lenfree"
    end
  end

  describe "create lenfree" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.lenfree_path(conn, :create), lenfree: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.lenfree_path(conn, :show, id)

      conn = get(conn, Routes.lenfree_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Lenfree"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.lenfree_path(conn, :create), lenfree: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Lenfree"
    end
  end

  describe "edit lenfree" do
    setup [:create_lenfree]

    test "renders form for editing chosen lenfree", %{conn: conn, lenfree: lenfree} do
      conn = get(conn, Routes.lenfree_path(conn, :edit, lenfree))
      assert html_response(conn, 200) =~ "Edit Lenfree"
    end
  end

  describe "update lenfree" do
    setup [:create_lenfree]

    test "redirects when data is valid", %{conn: conn, lenfree: lenfree} do
      conn = put(conn, Routes.lenfree_path(conn, :update, lenfree), lenfree: @update_attrs)
      assert redirected_to(conn) == Routes.lenfree_path(conn, :show, lenfree)

      conn = get(conn, Routes.lenfree_path(conn, :show, lenfree))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, lenfree: lenfree} do
      conn = put(conn, Routes.lenfree_path(conn, :update, lenfree), lenfree: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Lenfree"
    end
  end

  describe "delete lenfree" do
    setup [:create_lenfree]

    test "deletes chosen lenfree", %{conn: conn, lenfree: lenfree} do
      conn = delete(conn, Routes.lenfree_path(conn, :delete, lenfree))
      assert redirected_to(conn) == Routes.lenfree_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.lenfree_path(conn, :show, lenfree))
      end
    end
  end

  defp create_lenfree(_) do
    lenfree = fixture(:lenfree)
    {:ok, lenfree: lenfree}
  end
end
