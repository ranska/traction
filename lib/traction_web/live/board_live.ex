defmodule TractionWeb.BoardLive do
  use TractionWeb, :live_view

  alias Traction.Boards
  alias Traction.Repo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    board = Boards.get_board!(id) |> Repo.preload(lists: [:cards])
    {:ok, assign(socket, board: board, dragged_card: nil)}
  end

  @impl true
  def handle_event("dragstart", %{"card_id" => card_id}, socket) do
    {:noreply, assign(socket, dragged_card: card_id)}
  end

  @impl true
  def handle_event("drop", %{"list_id" => list_id}, socket) do
    dragged_card_id = socket.assigns.dragged_card

    if dragged_card_id do
      # Get the card and update its list_id
      card = Boards.get_card!(dragged_card_id)
      {:ok, _updated_card} = Boards.update_card(card, %{list_id: list_id})

      # Re-fetch board data
      board = Boards.get_board!(socket.assigns.board.id) |> Repo.preload(lists: [:cards])

      {:noreply, assign(socket, board: board, dragged_card: nil)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("dragover", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-100">
      <div class="py-6">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="md:flex md:items-center md:justify-between">
            <div class="flex-1 min-w-0">
              <h1 class="text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:truncate">
                {@board.title}
              </h1>
              <p class="mt-1 text-sm text-gray-500">
                {@board.description}
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex space-x-6 overflow-x-auto pb-4">
          <%= for list <- @board.lists do %>
            <div
              class="flex-shrink-0 w-80"
              phx-drop="drop"
              phx-value-list_id={list.id}
              phx-dragover="dragover"
            >
              <div class="bg-gray-200 rounded-lg p-4">
                <h3 class="text-lg font-medium text-gray-900 mb-4">
                  {list.title}
                </h3>
                <div class="space-y-3 min-h-[200px]">
                  <%= for card <- list.cards do %>
                    <div
                      class="bg-white rounded shadow-sm p-3 hover:shadow-md transition-shadow cursor-move"
                      draggable="true"
                      phx-dragstart="dragstart"
                      phx-value-card_id={card.id}
                    >
                      <h4 class="text-sm font-medium text-gray-900">
                        {card.title}
                      </h4>
                      <p class="mt-1 text-sm text-gray-600">
                        {card.description}
                      </p>
                    </div>
                  <% end %>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
