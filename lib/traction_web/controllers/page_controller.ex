defmodule TractionWeb.PageController do
  use TractionWeb, :controller

  alias Traction.Boards

  def home(conn, _params) do
    boards = Boards.list_boards()
    render(conn, :home, boards: boards)
  end
end
