defmodule House2Web.FloorLive.Index do
  use House2Web, :live_view

  alias House2.Server

  @topic "apartments_topic"

   @impl true
  def mount(_params, _session, socket) do

    apartments = Server.apartments()
    Phoenix.PubSub.subscribe(House2.PubSub, @topic)

    {:ok, assign(socket, apartments: apartments)}
  end

  @impl true
  def handle_info({:apartments_updated, apartments}, socket) do
    {:noreply, assign(socket, apartments: apartments)}
  end



end
