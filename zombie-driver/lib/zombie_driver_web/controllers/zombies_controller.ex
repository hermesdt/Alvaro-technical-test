defmodule ZombieDriverWeb.ZombiesController do
  use ZombieDriverWeb, :controller

  def show(conn, %{"id" => driver_id}) do
    is_zombie = ZombieDriver.StatusChecker.is_zombie(driver_id)

    json(conn, %{"id" => String.to_integer(driver_id), "zombie" => is_zombie})
  end
end