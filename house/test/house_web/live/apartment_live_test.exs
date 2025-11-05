defmodule HouseWeb.ApartmentLiveTest do
  use HouseWeb.ConnCase

  import Phoenix.LiveViewTest
  import House.ContextFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_apartment(_) do
    apartment = apartment_fixture()
    %{apartment: apartment}
  end

  describe "Index" do
    setup [:create_apartment]

    test "lists all apartment", %{conn: conn, apartment: apartment} do
      {:ok, _index_live, html} = live(conn, ~p"/apartment")

      assert html =~ "Listing Apartment"
      assert html =~ apartment.name
    end

    test "saves new apartment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/apartment")

      assert index_live |> element("a", "New Apartment") |> render_click() =~
               "New Apartment"

      assert_patch(index_live, ~p"/apartment/new")

      assert index_live
             |> form("#apartment-form", apartment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#apartment-form", apartment: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/apartment")

      html = render(index_live)
      assert html =~ "Apartment created successfully"
      assert html =~ "some name"
    end

    test "updates apartment in listing", %{conn: conn, apartment: apartment} do
      {:ok, index_live, _html} = live(conn, ~p"/apartment")

      assert index_live |> element("#apartment-#{apartment.id} a", "Edit") |> render_click() =~
               "Edit Apartment"

      assert_patch(index_live, ~p"/apartment/#{apartment}/edit")

      assert index_live
             |> form("#apartment-form", apartment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#apartment-form", apartment: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/apartment")

      html = render(index_live)
      assert html =~ "Apartment updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes apartment in listing", %{conn: conn, apartment: apartment} do
      {:ok, index_live, _html} = live(conn, ~p"/apartment")

      assert index_live |> element("#apartment-#{apartment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#apartment-#{apartment.id}")
    end
  end

  describe "Show" do
    setup [:create_apartment]

    test "displays apartment", %{conn: conn, apartment: apartment} do
      {:ok, _show_live, html} = live(conn, ~p"/apartment/#{apartment}")

      assert html =~ "Show Apartment"
      assert html =~ apartment.name
    end

    test "updates apartment within modal", %{conn: conn, apartment: apartment} do
      {:ok, show_live, _html} = live(conn, ~p"/apartment/#{apartment}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Apartment"

      assert_patch(show_live, ~p"/apartment/#{apartment}/show/edit")

      assert show_live
             |> form("#apartment-form", apartment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#apartment-form", apartment: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/apartment/#{apartment}")

      html = render(show_live)
      assert html =~ "Apartment updated successfully"
      assert html =~ "some updated name"
    end
  end
end
