defmodule House.Server do
  use GenServer

  alias House.Context

  def start_link(apartment_id) do
    GenServer.start_link(__MODULE__, apartment_id, name: via_tuple(apartment_id))
  end

  defp via_tuple(apartment_id), do: {:via, Registry, {House.Registry, apartment_id}}


  def create_floor(apartment_id, number_floors) do
    GenServer.call(via_tuple(apartment_id), {:create_floor, number_floors})
  end


  def create_unit(apartment_id, floor_id, number_units) do
    GenServer.call(via_tuple(apartment_id), {:create_unit, floor_id, number_units})
  end

  def init(apartment_id) do
    state = Context.get_apartment!(apartment_id)
    {:ok, state}
  end


end
