defmodule Myshop.New do
  @moduledoc """
  The New context.
  """

  import Ecto.Query, warn: false
  alias Myshop.Repo

  alias Myshop.New.Lenfree

  @doc """
  Returns the list of lenfrees.

  ## Examples

      iex> list_lenfrees()
      [%Lenfree{}, ...]

  """
  def list_lenfrees do
    Repo.all(Lenfree)
  end

  @doc """
  Gets a single lenfree.

  Raises `Ecto.NoResultsError` if the Lenfree does not exist.

  ## Examples

      iex> get_lenfree!(123)
      %Lenfree{}

      iex> get_lenfree!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lenfree!(id), do: Repo.get!(Lenfree, id)

  @doc """
  Creates a lenfree.

  ## Examples

      iex> create_lenfree(%{field: value})
      {:ok, %Lenfree{}}

      iex> create_lenfree(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lenfree(attrs \\ %{}) do
    %Lenfree{}
    |> Lenfree.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lenfree.

  ## Examples

      iex> update_lenfree(lenfree, %{field: new_value})
      {:ok, %Lenfree{}}

      iex> update_lenfree(lenfree, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lenfree(%Lenfree{} = lenfree, attrs) do
    lenfree
    |> Lenfree.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Lenfree.

  ## Examples

      iex> delete_lenfree(lenfree)
      {:ok, %Lenfree{}}

      iex> delete_lenfree(lenfree)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lenfree(%Lenfree{} = lenfree) do
    Repo.delete(lenfree)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lenfree changes.

  ## Examples

      iex> change_lenfree(lenfree)
      %Ecto.Changeset{source: %Lenfree{}}

  """
  def change_lenfree(%Lenfree{} = lenfree) do
    Lenfree.changeset(lenfree, %{})
  end
end
