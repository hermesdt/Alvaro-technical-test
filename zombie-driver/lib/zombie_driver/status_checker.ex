defmodule ZombieDriver.StatusChecker do
  use Confex, otp_app: :zombie_driver

  alias ZombieDriver.DriverLocationsClient

  def is_zombie(driver_id) do
    case get_locations(driver_id) do
      {:ok, locations} ->
        distance = locations
        |> convert_updated_at()
        |> sort_by_updated_at()
        |> calculate_distance()

        is_zombie = if distance < zombie_distance(), do: true, else: false
        {:ok, is_zombie}

      {:error, error} -> {:error, error}
    end    
  end

  def get_locations(driver_id) do
    DriverLocationsClient.get_locations(driver_id, units(), amount())
  end

  def convert_updated_at(locations) do
    locations
    |> Enum.map(fn(location) ->
      {:ok, updated_at, _} = DateTime.from_iso8601(location["updated_at"])
      Map.put(location, "updated_at", updated_at)
    end)
  end

  def sort_by_updated_at(locations) do
    locations
    |> Enum.sort(fn(%{"updated_at" => updated_at_a}, %{"updated_at" => updated_at_b}) ->
      DateTime.compare(updated_at_a, updated_at_b) == :gt
    end)
  end

  def calculate_distance(locations) do
    locations
    |> Enum.reduce({nil, 0}, fn(loc2, acc) ->
      case acc do
        {nil, 0} ->
          {loc2, 0}
        {loc1, distance} ->
          new_distance = distance + Distance.GreatCircle.distance(
            {loc2["longitude"], loc2["latitude"]},
            {loc1["longitude"], loc1["latitude"]})
          {loc2, new_distance}
      end
    end)
    |> Tuple.to_list()
    |> Enum.at(1)
  end

  def units, do: config()[:units]
  def amount, do: config()[:amount]
  def zombie_distance, do: config()[:zombie_distance_meters]
end
