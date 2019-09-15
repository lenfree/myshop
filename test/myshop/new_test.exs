defmodule Myshop.NewTest do
  use Myshop.DataCase

  alias Myshop.New

  describe "lenfrees" do
    alias Myshop.New.Lenfree

    @valid_attrs %{items: %{}, name: "some name"}
    @update_attrs %{items: %{}, name: "some updated name"}
    @invalid_attrs %{items: nil, name: nil}

    def lenfree_fixture(attrs \\ %{}) do
      {:ok, lenfree} =
        attrs
        |> Enum.into(@valid_attrs)
        |> New.create_lenfree()

      lenfree
    end

    test "list_lenfrees/0 returns all lenfrees" do
      lenfree = lenfree_fixture()
      assert New.list_lenfrees() == [lenfree]
    end

    test "get_lenfree!/1 returns the lenfree with given id" do
      lenfree = lenfree_fixture()
      assert New.get_lenfree!(lenfree.id) == lenfree
    end

    test "create_lenfree/1 with valid data creates a lenfree" do
      assert {:ok, %Lenfree{} = lenfree} = New.create_lenfree(@valid_attrs)
      assert lenfree.items == %{}
      assert lenfree.name == "some name"
    end

    test "create_lenfree/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = New.create_lenfree(@invalid_attrs)
    end

    test "update_lenfree/2 with valid data updates the lenfree" do
      lenfree = lenfree_fixture()
      assert {:ok, %Lenfree{} = lenfree} = New.update_lenfree(lenfree, @update_attrs)
      assert lenfree.items == %{}
      assert lenfree.name == "some updated name"
    end

    test "update_lenfree/2 with invalid data returns error changeset" do
      lenfree = lenfree_fixture()
      assert {:error, %Ecto.Changeset{}} = New.update_lenfree(lenfree, @invalid_attrs)
      assert lenfree == New.get_lenfree!(lenfree.id)
    end

    test "delete_lenfree/1 deletes the lenfree" do
      lenfree = lenfree_fixture()
      assert {:ok, %Lenfree{}} = New.delete_lenfree(lenfree)
      assert_raise Ecto.NoResultsError, fn -> New.get_lenfree!(lenfree.id) end
    end

    test "change_lenfree/1 returns a lenfree changeset" do
      lenfree = lenfree_fixture()
      assert %Ecto.Changeset{} = New.change_lenfree(lenfree)
    end
  end
end
