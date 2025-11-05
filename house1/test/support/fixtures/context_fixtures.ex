defmodule House1.ContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `House1.Context` context.
  """

  @doc """
  Generate a apartment.
  """
  def apartment_fixture(attrs \\ %{}) do
    {:ok, apartment} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> House1.Context.create_apartment()

    apartment
  end

  @doc """
  Generate a floor.
  """
  def floor_fixture(attrs \\ %{}) do
    {:ok, floor} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number_units: 42
      })
      |> House1.Context.create_floor()

    floor
  end
end
