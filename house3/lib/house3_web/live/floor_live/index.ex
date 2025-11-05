defmodule House3Web.FloorLive.Index do
  use House3Web, :live_view

  alias House3.Server

  @topic "apartments_topic"

  @impl true
  def mount(_params, _session, socket) do
    apartments = Server.apartments()
    Phoenix.PubSub.subscribe(House3.PubSub, @topic)

    {:ok,
     assign(socket,
       apartments: apartments,
       name: "",
       number_floors: ""
     )}
  end

  # PubSub update
  @impl true
  def handle_info({:apartments_updated, apartments}, socket) do
    {:noreply, assign(socket, apartments: apartments)}
  end

  # Create apartment event
  @impl true
  def handle_event("create_apartment", %{"name" => name, "number_floors" => floors}, socket) do
    case Server.create_apartment(name, String.to_integer(floors)) do
      {:ok, _apartment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Apartment created successfully")
         |> assign(name: "", number_floors: "")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to create apartment")}
    end
  end

  # Create floors for apartment
  @impl true
  def handle_event("create_floor", %{"apartment_id" => apartment_id}, socket) do
    Server.create_floor(String.to_integer(apartment_id))
    {:noreply, put_flash(socket, :info, "Floors created successfully")}
  end


  @impl true
def handle_event("delete", %{"id" => id}, socket) do
  # Use GenServer for deletion to ensure all LiveViews are updated
  case Server.delete_apartment(String.to_integer(id)) do
    :ok ->
      {:noreply, socket}  # The broadcast will update the stream

    {:error, _reason} ->
      {:noreply, put_flash(socket, :error, "Failed to delete apartment")}
  end
end
end
