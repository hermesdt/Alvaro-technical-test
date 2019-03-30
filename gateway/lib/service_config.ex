defmodule Gateway.ServiceConfig do

  @spec read(String.t) :: {:ok, [map()]} | {:error, %{message: String.t}}
  def read(filename) do
    case YamlElixir.read_from_file(filename) do
      {:ok, %{"urls" => urls}} ->
        urls = urls
        |> Enum.map(&handle_url/1)

        {:ok, urls}
      error -> error
    end
  end

  defp handle_url(url) do
    url = Map.put(url, "method", String.to_atom(String.downcase(url["method"])))

    cond do
      nsq = Map.get(url, "nsq", nil) ->
        Map.put(url, "handler", %{nsq: nsq})

      http = Map.get(url, "http", nil) ->
        Map.put(url, "handler", %{http: http})

      true ->
        raise "unkown url schema: #{inspect url}"
    end
  end
end
