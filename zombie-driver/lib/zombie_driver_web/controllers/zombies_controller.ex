defmodule ZombieDriverWeb.ZombiesController do
  use ZombieDriverWeb, :controller

  def show(conn, %{"id" => driver_id}) do
    case ZombieDriver.StatusChecker.is_zombie(driver_id) do
      {:ok, is_zombie} ->
        conn
        |> json(%{"id" => String.to_integer(driver_id), "zombie" => is_zombie})
      {:error, error} ->
        conn
        |> put_status(500)
        |> json(%{"error" => inspect(error)})
    end
  end
end