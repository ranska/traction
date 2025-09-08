defmodule Traction.BoardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Traction.Boards` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Traction.Boards.create_board()

    board
  end

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    board = board_fixture()

    {:ok, list} =
      attrs
      |> Enum.into(%{
        position: 42,
        title: "some title",
        board_id: board.id
      })
      |> Traction.Boards.create_list()

    list
  end

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    list = list_fixture()

    {:ok, card} =
      attrs
      |> Enum.into(%{
        description: "some description",
        position: 42,
        title: "some title",
        list_id: list.id
      })
      |> Traction.Boards.create_card()

    card
  end
end
