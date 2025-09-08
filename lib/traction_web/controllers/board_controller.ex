defmodule TractionWeb.BoardController do
  use TractionWeb, :controller

  alias Traction.Boards
  alias Traction.Repo

  def show(conn, %{"id" => id}) do
    board = Boards.get_board!(id) |> Repo.preload(lists: [:cards])
    render(conn, :show, board: board)
  end
end
