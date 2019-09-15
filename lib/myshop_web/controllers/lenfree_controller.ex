defmodule MyshopWeb.LenfreeController do
  use MyshopWeb, :controller

  alias Myshop.New
  alias Myshop.New.Lenfree

  def index(conn, _params) do
    lenfrees = New.list_lenfrees()
    render(conn, "index.html", lenfrees: lenfrees)
  end

  def new(conn, _params) do
    changeset = New.change_lenfree(%Lenfree{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"lenfree" => lenfree_params}) do
    case New.create_lenfree(lenfree_params) do
      {:ok, lenfree} ->
        conn
        |> put_flash(:info, "Lenfree created successfully.")
        |> redirect(to: Routes.lenfree_path(conn, :show, lenfree))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lenfree = New.get_lenfree!(id)
    render(conn, "show.html", lenfree: lenfree)
  end

  def edit(conn, %{"id" => id}) do
    lenfree = New.get_lenfree!(id)
    changeset = New.change_lenfree(lenfree)
    render(conn, "edit.html", lenfree: lenfree, changeset: changeset)
  end

  def update(conn, %{"id" => id, "lenfree" => lenfree_params}) do
    lenfree = New.get_lenfree!(id)

    case New.update_lenfree(lenfree, lenfree_params) do
      {:ok, lenfree} ->
        conn
        |> put_flash(:info, "Lenfree updated successfully.")
        |> redirect(to: Routes.lenfree_path(conn, :show, lenfree))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", lenfree: lenfree, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lenfree = New.get_lenfree!(id)
    {:ok, _lenfree} = New.delete_lenfree(lenfree)

    conn
    |> put_flash(:info, "Lenfree deleted successfully.")
    |> redirect(to: Routes.lenfree_path(conn, :index))
  end
end
