defmodule LectureBingo.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias LectureBingo.Repo
  alias LectureBingo.Accounts.User

  alias LectureBingo.Games.Game
  alias LectureBingo.Incidents

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Game
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def list_user_games(%User{} = user) do
    Game
    |> user_games_query(user)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  def get_user_game!(id, %User{} = user) do
    Game
    |> user_games_query(user)
    |> Repo.get!(Game, id)
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}, %User{} = user) do
    %Game{}
    |> Game.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def new_game(user) do
    state = initialize_game_state()
    create_game(%{state: state}, user)
  end

  def initialize_game_state() do
    Incidents.list_incidents()
    |> Enum.take_random(3)
    |> Game.create_state()
  end

  def toggle_incident_state(game, incident_id) do
    toggle_id = String.to_integer(incident_id)

    state =
      Enum.map(
        game.state,
        &maybe_toggle_incident(&1, toggle_id)
      )

    update_game(game, %{state: state})
  end

  def maybe_toggle_incident(%{id: id} = incident, toggled_id) when id == toggled_id do
    %{incident | occurred: !incident.occurred}
  end

  def maybe_toggle_incident(incident, _), do: incident

  def victorious?(game) do
    game.state
    |> Enum.filter(&(&1.occurred == false))
    |> Enum.empty?()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  def user_games_query(query, user) do
    from(game in query, where: game.user_id == ^user.id)
  end
end
