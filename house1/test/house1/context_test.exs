defmodule House1.ContextTest do
  use House1.DataCase

  alias House1.Context

  describe "apartments" do
    alias House1.Context.Apartment

    import House1.ContextFixtures

    @invalid_attrs %{name: nil}

    test "list_apartments/0 returns all apartments" do
      apartment = apartment_fixture()
      assert Context.list_apartments() == [apartment]
    end

    test "get_apartment!/1 returns the apartment with given id" do
      apartment = apartment_fixture()
      assert Context.get_apartment!(apartment.id) == apartment
    end

    test "create_apartment/1 with valid data creates a apartment" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Apartment{} = apartment} = Context.create_apartment(valid_attrs)
      assert apartment.name == "some name"
    end

    test "create_apartment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Context.create_apartment(@invalid_attrs)
    end

    test "update_apartment/2 with valid data updates the apartment" do
      apartment = apartment_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Apartment{} = apartment} = Context.update_apartment(apartment, update_attrs)
      assert apartment.name == "some updated name"
    end

    test "update_apartment/2 with invalid data returns error changeset" do
      apartment = apartment_fixture()
      assert {:error, %Ecto.Changeset{}} = Context.update_apartment(apartment, @invalid_attrs)
      assert apartment == Context.get_apartment!(apartment.id)
    end

    test "delete_apartment/1 deletes the apartment" do
      apartment = apartment_fixture()
      assert {:ok, %Apartment{}} = Context.delete_apartment(apartment)
      assert_raise Ecto.NoResultsError, fn -> Context.get_apartment!(apartment.id) end
    end

    test "change_apartment/1 returns a apartment changeset" do
      apartment = apartment_fixture()
      assert %Ecto.Changeset{} = Context.change_apartment(apartment)
    end
  end

  describe "floors" do
    alias House1.Context.Floor

    import House1.ContextFixtures

    @invalid_attrs %{name: nil, number_units: nil}

    test "list_floors/0 returns all floors" do
      floor = floor_fixture()
      assert Context.list_floors() == [floor]
    end

    test "get_floor!/1 returns the floor with given id" do
      floor = floor_fixture()
      assert Context.get_floor!(floor.id) == floor
    end

    test "create_floor/1 with valid data creates a floor" do
      valid_attrs = %{name: "some name", number_units: 42}

      assert {:ok, %Floor{} = floor} = Context.create_floor(valid_attrs)
      assert floor.name == "some name"
      assert floor.number_units == 42
    end

    test "create_floor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Context.create_floor(@invalid_attrs)
    end

    test "update_floor/2 with valid data updates the floor" do
      floor = floor_fixture()
      update_attrs = %{name: "some updated name", number_units: 43}

      assert {:ok, %Floor{} = floor} = Context.update_floor(floor, update_attrs)
      assert floor.name == "some updated name"
      assert floor.number_units == 43
    end

    test "update_floor/2 with invalid data returns error changeset" do
      floor = floor_fixture()
      assert {:error, %Ecto.Changeset{}} = Context.update_floor(floor, @invalid_attrs)
      assert floor == Context.get_floor!(floor.id)
    end

    test "delete_floor/1 deletes the floor" do
      floor = floor_fixture()
      assert {:ok, %Floor{}} = Context.delete_floor(floor)
      assert_raise Ecto.NoResultsError, fn -> Context.get_floor!(floor.id) end
    end

    test "change_floor/1 returns a floor changeset" do
      floor = floor_fixture()
      assert %Ecto.Changeset{} = Context.change_floor(floor)
    end
  end
end
