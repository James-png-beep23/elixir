defmodule House1Web.Floor.Index do
  use House1Web, :live_view

  alias House1.Context
  alias House1.Server

  @impl true
  def mount(_params, _session, socket) do
    # Load all apartments for the dropdown
    apartments = Context.list_apartments()

    {:ok,
     socket
     |> assign(:apartments, apartments)
     |> assign(:selected_apartment_id, nil)
     |> assign(:floors, [])
     |> assign(:new_floor_count, "")}
  end

  @impl true
  def handle_event("select_apartment", %{"apartment_id" => apartment_id}, socket) do
    apartment_id = String.to_integer(apartment_id)

   
    {:ok, _pid} =
      case Registry.lookup(House1.Registry, apartment_id) do
        [] -> Server.start_link(apartment_id)
        [{pid, _}] -> {:ok, pid}
      end

    floors = Context.list_floors() |> Enum.filter(&(&1.apartment_id == apartment_id))

    {:noreply,
     socket
     |> assign(:selected_apartment_id, apartment_id)
     |> assign(:floors, floors)
     |> assign(:new_floor_count, "")}
  end

  @impl true
  def handle_event("create_floors", %{"floor_count" => count}, socket) do
    number_floors = String.to_integer(count)

    {:ok, _} = Server.create_floor(number_floors, socket.assigns.selected_apartment_id)

    floors = Context.list_floors()
             |> Enum.filter(&(&1.apartment_id == socket.assigns.selected_apartment_id))

    {:noreply, assign(socket, floors: floors, new_floor_count: "")}
  end

  @impl true
  def handle_event("update_floor_count", %{"floor_count" => count}, socket) do
    {:noreply, assign(socket, new_floor_count: count)}
  end
end
