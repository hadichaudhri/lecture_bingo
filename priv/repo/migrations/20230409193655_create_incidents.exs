defmodule LectureBingo.Repo.Migrations.CreateIncidents do
  use Ecto.Migration

  def change do
    create table(:incidents) do
      add :title, :string, null: false
      add :description, :string, null: false

      timestamps()
    end
  end
end
