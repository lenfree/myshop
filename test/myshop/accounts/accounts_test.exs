defmodule Myshop.AccountsTest do
  use Myshop.DataCase

  alias Myshop.Accounts
  alias Myshop.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      first_name: "eva",
      last_name: "usertest",
      credential: %{
        email: "eva@test.com",
        password: "secret"
      }
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.first_name == "eva"
      assert user.last_name == "usertest"
      assert user.credential.email == "eva@test.com"
      assert user.credential.password == "secret"
    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "enforce unique username/email" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)

      assert %{credential: %{email: ["has already been taken"]}} = errors_on(changeset)

      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept invalid email" do
      attrs = put_in(@valid_attrs, [:credential, :email], "eve.com")
      assert {:error, changeset} = Accounts.register_user(attrs)

      assert %{credential: %{email: ["has invalid format"]}} = errors_on(changeset)
    end

    test "requires password to be at least 6 chars long" do
      attrs = put_in(@valid_attrs, [:credential, :password], "12345")
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{credential: %{password: ["should be at least 6 character(s)"]}} =
               errors_on(changeset)
    end
  end

  describe "authenticate_by_email" do
    @email "user@localhost.com"
    @pass "tesmppass"

    setup do
      {:ok, user: user_fixture(email: @email, password: @pass)}
    end

    test "returns user with correct password", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authenticate_by_email_and_pass(@email, @pass)
    end

    test "returns unauthorized error with invalid password" do
      assert {:error, :unauthorized} = Accounts.authenticate_by_email_and_pass(@email, "err")
    end

    test "returns not found with no matching user email" do
      assert {:error, :not_found} =
               Accounts.authenticate_by_email_and_pass("abc@localhost", @pass)
    end
  end
end
