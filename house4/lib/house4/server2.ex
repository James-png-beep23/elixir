defmodule House2.Server do
  use GenServer

  alias House2.Context

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

   defp broadcast(event, state) do
    Phoenix.PubSub.broadcast(House2.PubSub, @topic, {event, state})
  end


end
