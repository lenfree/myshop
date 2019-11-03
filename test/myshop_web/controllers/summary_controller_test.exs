defmodule MyshopWeb.SummaryControllerTest do
  use MyshopWeb.ConnCase

  alias Myshop.Orders

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:summary) do
    {:ok, summary} = Orders.create_summary(@create_attrs)
    summary
  end

  describe "index" do
    test "lists all summaries", %{conn: conn} do
      conn = get(conn, Routes.summary_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Summaries"
    end
  end

  describe "new summary" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.summary_path(conn, :new))
      assert html_response(conn, 200) =~ "New Summary"
    end
  end

  describe "create summary" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.summary_path(conn, :create), summary: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.summary_path(conn, :show, id)

      conn = get(conn, Routes.summary_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Summary"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.summary_path(conn, :create), summary: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Summary"
    end
  end

  describe "edit summary" do
    setup [:create_summary]

    test "renders form for editing chosen summary", %{conn: conn, summary: summary} do
      conn = get(conn, Routes.summary_path(conn, :edit, summary))
      assert html_response(conn, 200) =~ "Edit Summary"
    end
  end

  describe "update summary" do
    setup [:create_summary]

    test "redirects when data is valid", %{conn: conn, summary: summary} do
      conn = put(conn, Routes.summary_path(conn, :update, summary), summary: @update_attrs)
      assert redirected_to(conn) == Routes.summary_path(conn, :show, summary)

      conn = get(conn, Routes.summary_path(conn, :show, summary))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, summary: summary} do
      conn = put(conn, Routes.summary_path(conn, :update, summary), summary: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Summary"
    end
  end

  describe "delete summary" do
    setup [:create_summary]

    test "deletes chosen summary", %{conn: conn, summary: summary} do
      conn = delete(conn, Routes.summary_path(conn, :delete, summary))
      assert redirected_to(conn) == Routes.summary_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.summary_path(conn, :show, summary))
      end
    end
  end

  defp create_summary(_) do
    summary = fixture(:summary)
    {:ok, summary: summary}
  end
end
