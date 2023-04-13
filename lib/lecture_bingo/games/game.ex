defmodule LectureBingo.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :user, LectureBingo.Accounts.User
    field :state, {:array, :map}

    timestamps()
  end

  def create_state(incidents) do
    Enum.map(
      incidents,
      &%{id: &1.id, title: &1.title, description: &1.description, occurred: false}
    )
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
