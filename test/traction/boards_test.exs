defmodule Traction.BoardsTest do
  use Traction.DataCase

  alias Traction.Boards

  describe "boards" do
    alias Traction.Boards.Board

    import Traction.BoardsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Boards.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Boards.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Board{} = board} = Boards.create_board(valid_attrs)
      assert board.description == "some description"
      assert board.title == "some title"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Board{} = board} = Boards.update_board(board, update_attrs)
      assert board.description == "some updated description"
      assert board.title == "some updated title"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_board(board, @invalid_attrs)
      assert board == Boards.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Boards.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Boards.change_board(board)
    end
  end

  describe "lists" do
    alias Traction.Boards.List

    import Traction.BoardsFixtures

    @invalid_attrs %{position: nil, title: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Boards.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Boards.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{position: 42, title: "some title"}

      assert {:ok, %List{} = list} = Boards.create_list(valid_attrs)
      assert list.position == 42
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{position: 43, title: "some updated title"}

      assert {:ok, %List{} = list} = Boards.update_list(list, update_attrs)
      assert list.position == 43
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_list(list, @invalid_attrs)
      assert list == Boards.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Boards.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Boards.change_list(list)
    end
  end

  describe "cards" do
    alias Traction.Boards.Card

    import Traction.BoardsFixtures

    @invalid_attrs %{position: nil, description: nil, title: nil}

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Boards.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Boards.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      valid_attrs = %{position: 42, description: "some description", title: "some title"}

      assert {:ok, %Card{} = card} = Boards.create_card(valid_attrs)
      assert card.position == 42
      assert card.description == "some description"
      assert card.title == "some title"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()

      update_attrs = %{
        position: 43,
        description: "some updated description",
        title: "some updated title"
      }

      assert {:ok, %Card{} = card} = Boards.update_card(card, update_attrs)
      assert card.position == 43
      assert card.description == "some updated description"
      assert card.title == "some updated title"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_card(card, @invalid_attrs)
      assert card == Boards.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Boards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Boards.change_card(card)
    end
  end
end
