defmodule HouseWeb.ApartmentLive.Index do
  use HouseWeb, :live_view

  alias House.Context
  alias House.Context.Apartment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :apartment_collection, Context.list_apartment())}
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
    |> assign(:page_title, "Listing Apartment")
    |> assign(:apartment, nil)
  end

  @impl true
  def handle_info({HouseWeb.ApartmentLive.FormComponent, {:saved, apartment}}, socket) do
    {:noreply, stream_insert(socket, :apartment_collection, apartment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    apartment = Context.get_apartment!(id)
    {:ok, _} = Context.delete_apartment(apartment)

    {:noreply, stream_delete(socket, :apartment_collection, apartment)}
  end
end
