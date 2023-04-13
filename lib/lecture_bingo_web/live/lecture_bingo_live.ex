defmodule LectureBingoWeb.LectureBingoLive do
  use LectureBingoWeb, :live_view

  alias LectureBingo.Games
  alias LectureBingo.Accounts

  def mount(_, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    if connected?(socket), do: Games.subscribe()

    socket =
      assign(
        socket,
        current_user: user,
        game: nil,
        new_button_disabled: false,
        winner: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div :if={is_nil(@winner)}>
      <div class="flex justify-between mx-6">
        <.header>
          Lecture Bingo
        </.header>
        <.button phx-click="new_game" disabled={@new_button_disabled}>
          New Game
        </.button>
      </div>
      <.table :if={not is_nil(@game)} id="game_state" rows={@game.state} row_click={}>
        <:col :let={incident} label="Title"><%= incident.title %></:col>
        <:col :let={incident} label="Description"><%= incident.description %></:col>
        <:col :let={incident} label="Status">
          <.button
            class={if incident.occurred, do: "bg-blue-500 hover:bg-blue-500"}
            phx-click="toggle_incident"
            phx-value-id={incident.id}
            disabled={not is_nil(@winner)}
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
    <div :if={@winner} class="absolute top-0 left-0 flex flex-col w-screen h-100vh">
      <div class="relative flex flex-col flex-initial mx-auto top-10">
        <p class="my-4 text-center ">
          <%= if Games.victorious?(@game) do
            "You won!"
          else
            "Sorry! #{@winner} won! :("
          end %>
        </p>
        <.button phx-click="new_game" class="justify-center grow-0">
          New Game
        </.button>
      </div>
      <img
        :if={!Games.victorious?(@game)}
        src="/images/you_lose.png"
        class="flex-none object-contain h-[75vh]"
      />
      <img
        :if={Games.victorious?(@game)}
        src="/images/bingo.png"
        class="flex-none object-scale-down h-[75vh]"
      />
    </div>
    """
  end

  def handle_event("new_game", _, socket) do
    {:ok, game} =
      Games.new_game(socket.assigns.current_user)
      |> Games.broadcast(:new_game_started)

    {:noreply, assign(socket, game: game, winner: nil)}
  end

  def handle_event("toggle_incident", %{"id" => id}, socket) do
    {:ok, game} = Games.toggle_incident_state(socket.assigns.game, id)
    Games.maybe_broadcast({:ok, game}, :victory)
    {:noreply, assign(socket, game: game)}
  end

  def handle_info(:new_game_started, socket) do
    socket =
      case is_nil(socket.assigns.game) ||
             is_binary(socket.assigns.winner) do
        true ->
          {:ok, game} = Games.new_game(socket.assigns.current_user)
          assign(socket, game: game)

        false ->
          socket
      end

    socket =
      socket
      |> assign(:new_button_disabled, true)
      |> assign(:winner, nil)

    {:noreply, socket}
  end

  def handle_info({:victory, email}, socket) do
    {:noreply, assign(socket, winner: email, new_button_disabled: false)}
  end
end
