defmodule TractionWeb.BoardLive do
  use TractionWeb, :live_view

  alias Traction.Boards
  alias Traction.Repo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    board = Boards.get_board!(id) |> Repo.preload(lists: [:cards])
    {:ok, assign(socket, board: board, dragged_card: nil, dragover_list: nil)}
  end

  @impl true
  def handle_event("dragstart", %{"card_id" => card_id}, socket) do
    IO.puts("\n" <> String.duplicate("_", 50))
    IO.puts("🎯 DRAG START DETECTED!")
    IO.puts("Card ID: #{card_id}")
    IO.puts("Socket dragged_card: #{socket.assigns.dragged_card}")
    IO.puts(String.duplicate("_", 50) <> "\n")

    {:noreply, assign(socket, dragged_card: card_id)}
  end

  @impl true
  def handle_event("drop", %{"list_id" => list_id}, socket) do
    dragged_card_id = socket.assigns.dragged_card

    IO.puts("\n" <> String.duplicate("=", 50))
    IO.puts("🎯 DROP DETECTED!")
    IO.puts("Target list ID: #{list_id}")
    IO.puts("Dragged card ID: #{dragged_card_id}")
    IO.puts(String.duplicate("=", 50))

    if dragged_card_id do
      try do
        # Get the card and update its list_id
        card = Boards.get_card!(dragged_card_id)
        IO.puts("Found card: #{card.title}")

        {:ok, _updated_card} = Boards.update_card(card, %{list_id: list_id})
        IO.puts("✅ Card updated successfully!")

        # Re-fetch board data
        board = Boards.get_board!(socket.assigns.board.id) |> Repo.preload(lists: [:cards])
        IO.puts("✅ Board data refreshed")

        {:noreply, assign(socket, board: board, dragged_card: nil, dragover_list: nil)}
      rescue
        e ->
          IO.puts("❌ DROP ERROR:")
          IO.inspect(e)
          {:noreply, assign(socket, dragged_card: nil, dragover_list: nil)}
      end
    else
      IO.puts("❌ No dragged card found!")
      {:noreply, assign(socket, dragover_list: nil)}
    end

    IO.puts(String.duplicate("=", 50) <> "\n")
  end

  @impl true
  def handle_event("dragover", %{"list_id" => list_id}, socket) do
    IO.puts("\n" <> String.duplicate("-", 30))
    IO.puts("🎯 DRAG OVER: #{list_id}")
    IO.puts("Dragged card: #{socket.assigns.dragged_card}")
    IO.puts(String.duplicate("-", 30) <> "\n")

    {:noreply, assign(socket, dragover_list: list_id)}
  end

  @impl true
  def handle_event("dragleave", _params, socket) do
    IO.puts("\n" <> String.duplicate(".", 20))
    IO.puts("👋 DRAG LEAVE")
    IO.puts(String.duplicate(".", 20) <> "\n")

    {:noreply, assign(socket, dragover_list: nil)}
  end

  @impl true
  def handle_event("force_test", _params, socket) do
    IO.puts("\n" <> String.duplicate("🚀", 20))
    IO.puts("🎯 FORCE TEST EVENT RECEIVED!")
    IO.puts("LiveView is working correctly")
    IO.puts("Socket assigns: #{inspect(Map.keys(socket.assigns))}")
    IO.puts(String.duplicate("🚀", 20) <> "\n")

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <!-- Debug button -->
    <button
      phx-click="force_test"
      class="fixed top-4 right-4 z-50 bg-red-500 text-white px-4 py-2 rounded shadow-lg hover:bg-red-600"
    >
      🚀 FORCE TEST
    </button>

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
            <div class="flex-shrink-0 w-80">
              <div class={"rounded-lg p-4 transition-colors " <> if(@dragover_list == list.id, do: "bg-blue-200 border-2 border-blue-400", else: "bg-gray-200")}>
                <h3 class="text-lg font-medium text-gray-900 mb-4">
                  {list.title}
                </h3>
                <div
                  class="space-y-3 min-h-[200px]"
                  phx-drop="drop"
                  phx-value-list_id={list.id}
                  phx-dragover="dragover"
                  phx-dragleave="dragleave"
                >
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
