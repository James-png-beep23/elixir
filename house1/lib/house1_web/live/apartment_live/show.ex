defmodule House1Web.ApartmentLive.Show do
  use House1Web, :live_view

  alias House1.Context

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:apartment, Context.get_apartment!(id))}
  end

  defp page_title(:show), do: "Show Apartment"
  defp page_title(:edit), do: "Edit Apartment"
end
