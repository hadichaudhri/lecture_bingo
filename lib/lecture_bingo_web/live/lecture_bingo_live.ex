defmodule LectureBingoWeb.LectureBingoLive do
  use LectureBingoWeb, :live_view

  alias LectureBingo.Games
  alias LectureBingo.Accounts

  def mount(_, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok, game} = Games.new_game(socket.assigns.current_user)

    socket =
      assign(
        socket,
        current_user: user,
        game: game,
        has_won: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div :if={!@has_won}>
      <div class="flex justify-between mx-6">
        <.header>
          Lecture Bingo
        </.header>
        <.button phx-click="new_game">
          New Game
        </.button>
      </div>
      <.table id="game_state" rows={@game.state} row_click={}>
        <:col :let={incident} label="Title"><%= incident.title %></:col>
        <:col :let={incident} label="Description"><%= incident.description %></:col>
        <:col :let={incident} label="Status">
          <.button
            class={if incident.occurred, do: "bg-blue-500 hover:bg-blue-500"}
            phx-click="toggle_incident"
            phx-value-id={incident.id}
          >
            <%= if incident.occurred do
              "Occurred!"
            else
              "Waiting..."
            end %>
          </.button>
        </:col>
      </.table>
    </div>
    <div
      :if={@has_won}
      class="absolute top-0 left-0 w-screen h-screen bg-contain bg-center bg-no-repeat bg-[url('/images/bingo.png')]"
    >
      <.header class="relative my-4 text-center">
        You won!
        <.button phx-click="new_game">
          New Game
        </.button>
      </.header>
    </div>
    """
  end

  def handle_event("new_game", _, socket) do
    {:ok, game} = Games.new_game(socket.assigns.current_user)
    {:noreply, assign(socket, game: game, has_won: false)}
  end

  def handle_event("toggle_incident", %{"id" => id}, socket) do
    game = Games.toggle_incident_state(socket.assigns.game, id)
    has_won = Games.determine_if_won(game)
    {:noreply, assign(socket, game: game, has_won: has_won)}
  end
end
