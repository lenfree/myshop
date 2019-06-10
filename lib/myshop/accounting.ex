defmodule Myshop.Accounting do
  @moduledoc """
  The Accounting context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Ecto.Type
  alias Myshop.Repo

  alias Myshop.Accounting.Payment

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments(user_id) do
    Repo.all(
      from p in Payment,
        where: p.user_id == ^user_id,
        preload: [{:user, :credential}]
    )
  end

  def list_payments do
    Repo.all(
      from p in Payment,
        preload: [{:user, :credential}, :order]
    )
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id), do: Repo.get!(Payment, id)

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(attrs \\ %{}) do
    # TODO: Not sure if this is good or bad. Anyway,
    # investigate best way to handle this attribute.
    data = calculate_balance(attrs)

    %Payment{}
    |> Payment.changeset(data)
    |> Repo.insert()
  end

  def calculate_balance(attrs) do
    put_in(attrs, ["balance"], get_balance(attrs["total"], attrs["paid"]))
  end

  def convert_string_to_float(data), do: Type.cast(:float, data)

  def get_balance(balance, credit) do
    {:ok, b} = convert_string_to_float(balance)
    {:ok, c} = convert_string_to_float(credit)
    b - c
  end

  @doc """
  Updates a payment.

  ## Examples

      iex> update_payment(payment, %{field: new_value})
      {:ok, %Payment{}}

      iex> update_payment(payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Payment.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %Payment{}}

      iex> delete_payment(payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment changes.

  ## Examples

      iex> change_payment(payment)
      %Ecto.Changeset{source: %Payment{}}

  """
  def change_payment(%Payment{} = payment) do
    Payment.changeset(payment, %{})
  end
end
