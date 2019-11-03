# defmodule MyshopWeb.SummaryController do
#  use MyshopWeb, :controller
#
#  alias Myshop.Orders
#    alias Myshop.Orders.Summary
#
#  def index(conn, _params) do
#    summaries = Orders.list_summaries()
#    render(conn, "index.html", summaries: summaries)
#  end
#
#  def new(conn, _params) do
#    changeset = Orders.change_summary(%Summary{})
#    render(conn, "new.html", changeset: changeset)
#  end
#
#  def create(conn, %{"summary" => summary_params}) do
#    case Orders.create_summary(summary_params) do
#      {:ok, summary} ->
#        conn
#        |> put_flash(:info, "Summary created successfully.")
#        |> redirect(to: Routes.summary_path(conn, :show, summary))
#
#      {:error, %Ecto.Changeset{} = changeset} ->
#        render(conn, "new.html", changeset: changeset)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    summary = Orders.get_summary!(id)
#    render(conn, "show.html", summary: summary)
#  end
#
#  def edit(conn, %{"id" => id}) do
#    summary = Orders.get_summary!(id)
#    changeset = Orders.change_summary(summary)
#    render(conn, "edit.html", summary: summary, changeset: changeset)
#  end
#
#  def update(conn, %{"id" => id, "summary" => summary_params}) do
#    summary = Orders.get_summary!(id)
#
#    case Orders.update_summary(summary, summary_params) do
#      {:ok, summary} ->
#        conn
#        |> put_flash(:info, "Summary updated successfully.")
#        |> redirect(to: Routes.summary_path(conn, :show, summary))
#
#      {:error, %Ecto.Changeset{} = changeset} ->
#        render(conn, "edit.html", summary: summary, changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    summary = Orders.get_summary!(id)
#    {:ok, _summary} = Orders.delete_summary(summary)
#
#    conn
#    |> put_flash(:info, "Summary deleted successfully.")
#    |> redirect(to: Routes.summary_path(conn, :index))
#  end
# end
#
