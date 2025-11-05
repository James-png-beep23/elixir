defmodule House1Web.Floor.Index1 do
  use House1Web, :live_view

  alias House1.Context
  alias House1.Server

  @impl true
  def mount(%{"apartment_id" => apartment_id}, _session, socket) do
    apartment_id = String.to_integer(apartment_id)

    # Start GenServer for this apartment if not already started
    {:ok, _pid} =
      case Registry.lookup(House1.Registry, apartment_id) do
        [] -> Server.start_link(apartment_id)
        [{pid, _}] -> {:ok, pid}
      end

    # Load existing floors
    floors = Context.list_floors() |> Enum.filter(&(&1.apartment_id == apartment_id))

    {:ok,
     socket
     |> assign(:apartment_id, apartment_id)
     |> assign(:floors, floors)
     |> assign(:new_floor_count, "")}
  end

  @impl true
  def handle_event("create_floors", %{"floor_count" => count}, socket) do
    number_floors = String.to_integer(count)
    {:ok, _} = Server.create_floor(number_floors, socket.assigns.apartment_id)

    # Reload floors from DB
    floors = Context.list_floors() |> Enum.filter(&(&1.apartment_id == socket.assigns.apartment_id))

    {:noreply, assign(socket, floors: floors, new_floor_count: "")}
  end

  @impl true
  def handle_event("update_floor_count", %{"floor_count" => count}, socket) do
    {:noreply, assign(socket, new_floor_count: count)}
  end
end
