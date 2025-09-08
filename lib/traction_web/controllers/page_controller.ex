defmodule TractionWeb.PageController do
  use TractionWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
