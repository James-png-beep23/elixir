defmodule House2Web.ApartmentLive.FormComponent do
  use House2Web, :live_component

  alias House2.Context


  @impl true
  def update(%{apartment: apartment} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Context.change_apartment(apartment))
     end)}
  end

  @impl true
  def handle_event("validate", %{"apartment" => apartment_params}, socket) do
    changeset = Context.change_apartment(socket.assigns.apartment, apartment_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"apartment" => apartment_params}, socket) do
    save_apartment(socket, socket.assigns.action, apartment_params)
  end

  defp save_apartment(socket, :edit, apartment_params) do
    case Context.update_apartment(socket.assigns.apartment, apartment_params) do
      {:ok, apartment} ->
        notify_parent({:saved, apartment})


        {:noreply,
         socket
         |> put_flash(:info, "Apartment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_apartment(socket, :new, apartment_params) do
    case Context.create_apartment(apartment_params) do
      {:ok, apartment} ->
        notify_parent({:saved, apartment})
       

        {:noreply,
         socket
         |> put_flash(:info, "Apartment created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

end
