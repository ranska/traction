# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Traction.Repo.insert!(%Traction.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Traction.Boards

# Create a sample board
{:ok, board} =
  Boards.create_board(%{
    title: "Traction Development",
    description: "Board for tracking Traction app development progress"
  })

# Create lists
{:ok, backlog_list} =
  Boards.create_list(%{
    title: "Backlog",
    position: 1,
    board_id: board.id
  })

{:ok, in_progress_list} =
  Boards.create_list(%{
    title: "In Progress",
    position: 2,
    board_id: board.id
  })

{:ok, done_list} =
  Boards.create_list(%{
    title: "Done",
    position: 3,
    board_id: board.id
  })

# Create cards in Backlog
Boards.create_card(%{
  title: "Add user authentication",
  description: "Implement user registration, login, and session management",
  position: 1,
  list_id: backlog_list.id
})

Boards.create_card(%{
  title: "Create board show page",
  description: "Build a page to display individual boards with their lists and cards",
  position: 2,
  list_id: backlog_list.id
})

Boards.create_card(%{
  title: "Implement card drag & drop",
  description: "Add drag and drop functionality for moving cards between lists",
  position: 3,
  list_id: backlog_list.id
})

# Create cards in In Progress
Boards.create_card(%{
  title: "Add card creation form",
  description: "Create a form to add new cards to lists",
  position: 1,
  list_id: in_progress_list.id
})

# Create cards in Done
Boards.create_card(%{
  title: "Set up basic board/list/card models",
  description: "Created Ecto schemas and migrations for boards, lists, and cards",
  position: 1,
  list_id: done_list.id
})

Boards.create_card(%{
  title: "Create home page",
  description: "Built a custom home page that explains the app and lists boards",
  position: 2,
  list_id: done_list.id
})

IO.puts("Seeds completed! Created board '#{board.title}' with 3 lists and 6 cards.")
