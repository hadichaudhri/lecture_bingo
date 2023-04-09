defmodule LectureBingo.IncidentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LectureBingo.Incidents` context.
  """

  @doc """
  Generate a incident.
  """
  def incident_fixture(attrs \\ %{}) do
    {:ok, incident} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> LectureBingo.Incidents.create_incident()

    incident
  end
end
