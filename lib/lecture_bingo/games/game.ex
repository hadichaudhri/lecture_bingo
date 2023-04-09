defmodule LectureBingo.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :user, LectureBingo.Accounts.User
    field :state, {:array, :map}

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [])
    |> validate_required([])
  end
end
