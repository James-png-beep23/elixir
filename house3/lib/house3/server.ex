defmodule House3.Server do
  use GenServer

  alias House3.Context

  @topic "apartments_topic"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def apartments() do
    GenServer.call(__MODULE__, :apartments)
  end

  def create_apartment(name, number_floors) do
    GenServer.call(__MODULE__, {:create_apartment, name, number_floors})
  end

  def create_floor(apartment_id) do
    GenServer.call(__MODULE__, {:create_floor, apartment_id})
  end

  def delete_apartment(id) do
  GenServer.call(__MODULE__, {:delete_apartment, id})
end

  def update_apartment(id, params) do
  GenServer.call(__MODULE__, {:update_apartment, id, params})
end

  @impl true
  def init(_opts) do
    apartments = Context.list_apartments_with_floors()
    {:ok, apartments}
  end

  @impl true
  def handle_call(:apartments, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:create_apartment, name, number_floors}, _from, state) do
    attrs = %{"name" => name, "number_floors" => number_floors}
    case Context.create_apartment(attrs) do
      {:ok, apartment} ->
        new_state = [apartment | state]

        broadcast(:apartments_updated, new_state)
        {:reply, {:ok, apartment}, new_state}



      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  @impl true
  def handle_call({:create_floor, apartment_id}, _from, state) do
    apartment = Context.get_apartment!(apartment_id)
    number_floors = apartment.number_floors

    results =
      for n <- 1..number_floors do
        Context.create_floor(%{
          "apartment_id" => apartment.id,
          "name" => "Floor #{n}"
        })
      end

      apartment = Context.get_apartment_with_floors!(apartment_id)

      new_state =
        state
        |> Enum.map(fn apt ->
          if apt.id == apartment.id, do: apartment, else: apt
        end)

        broadcast(:apartments_updated, new_state)



    {:reply, results, new_state}
  end

  def handle_call({:update_apartment, id, params}, _from, state) do
  apartment = Context.get_apartment!(id)

  case Context.update_apartment(apartment, params) do
    {:ok, updated_apartment} ->
      # Reload with floors for consistent state
      apartment_with_floors = Context.get_apartment_with_floors!(updated_apartment.id)

      # Update state
      new_state = Enum.map(state, fn apt ->
        if apt.id == id, do: apartment_with_floors, else: apt
      end)

      # Broadcast the update
      broadcast(:apartments_updated, new_state)
      {:reply, {:ok, apartment_with_floors}, new_state}

    {:error, changeset} ->
      {:reply, {:error, changeset}, state}
  end
end


def handle_call({:delete_apartment, id}, _from, state) do
  apartment = Context.get_apartment!(id)

  case Context.delete_apartment(apartment) do
    {:ok, _} ->
      new_state = Enum.reject(state, fn apt -> apt.id == id end)
      broadcast(:apartments_updated, new_state)
      {:reply, :ok, new_state}

    {:error, reason} ->
      {:reply, {:error, reason}, state}
  end
end

   defp broadcast(event, state) do
    Phoenix.PubSub.broadcast(House3.PubSub, @topic, {event, state})
  end


end
