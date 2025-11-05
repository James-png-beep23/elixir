defmodule House3Web.ApartmentLive.Index do
  use House3Web, :live_view

  alias House3.Context
  alias House3.Context.Apartment
  alias House3.Server  # Add this

  @topic "apartments_topic"  # Add this constant

  @impl true
  def mount(_params, _session, socket) do
    # Subscribe to GenServer updates
    Phoenix.PubSub.subscribe(House3.PubSub, @topic)

    # You can use either Context or Server to get initial data
    # Option 1: Use Context (faster, but might not have latest GenServer state)
    # {:ok, stream(socket, :apartments, Context.list_apartments())}

    # Option 2: Use Server (guaranteed to have current GenServer state)
    apartments = Server.apartments()
    {:ok, stream(socket, :apartments, apartments)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Apartment")
    |> assign(:apartment, Context.get_apartment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Apartment")
    |> assign(:apartment, %Apartment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Apartments")
    |> assign(:apartment, nil)
  end

  # Handle GenServer broadcast updates
  @impl true
  def handle_info({:apartments_updated, apartments}, socket) do
    # Replace the entire stream with the updated state from GenServer
    {:noreply, stream(socket, :apartments, apartments, reset: true)}
  end

  # Remove or comment out this handler to avoid duplicates
  # The GenServer broadcast above will handle all updates
  # @impl true
  # def handle_info({House3Web.ApartmentLive.FormComponent, {:saved, apartment}}, socket) do
  #   {:noreply, stream_insert(socket, :apartments, apartment)}
  # end

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
