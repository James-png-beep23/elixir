defmodule House1.Server do
  use GenServer

  alias House1.Context

  def via_tuple(apartment_id) do
    {:via, Registry,{House1.Registry, apartment_id}}
  end

  def start_link(apartment_id) do
    GenServer.start_link(__MODULE__, apartment_id, name: via_tuple(apartment_id))
  end

  def create_floor(number_floors, apartment_id) do
    GenServer.call(via_tuple(apartment_id), {:create_floor, number_floors})
  end

  

  def init(apartment_id) do
    apartment = Context.get_apartment!(apartment_id)
    {:ok, apartment}
  end

  # def handle_call({:create_floor, number_floors}, _from, apartment ) do
  #   for n <- 1..number_floors do
  #     Context.create_floor(%{apartment_id: apartment.id, name: "Floor #{n}",
  #       number_units: 0})
  #   end

  #   {:reply, {:ok, number_floors}, %{apartment | number_floors: number_floors}}

  # end

    def handle_call({:create_floor, number_floors}, _from, apartment) do
      results =
        for n <- 1..number_floors do
          floor_data = %{apartment_id: apartment.id, name: "Floor #{n}", number_units: 0}
          IO.inspect(floor_data, label: "Inserting floor")
          Context.create_floor(floor_data)
        end

      IO.inspect(results, label: "Create floor results")

      {:reply, {:ok, number_floors}, %{apartment | number_floors: number_floors}}
    end



end
