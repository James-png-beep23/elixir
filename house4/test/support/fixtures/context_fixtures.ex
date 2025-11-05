defmodule House2.ContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `House2.Context` context.
  """

  @doc """
  Generate a apartment.
  """
  def apartment_fixture(attrs \\ %{}) do
    {:ok, apartment} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number_floors: 42
      })
      |> House2.Context.create_apartment()

    apartment
  end

  @doc """
  Generate a floor.
  """
  def floor_fixture(attrs \\ %{}) do
    {:ok, floor} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> House2.Context.create_floor()

    floor
  end
end
