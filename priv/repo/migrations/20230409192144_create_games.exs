defmodule LectureBingo.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :user_id, references(:users, on_delete: :nothing)
      add :state, {:array, :map}

      timestamps()
    end

    create index(:games, [:user_id])
  end
end
