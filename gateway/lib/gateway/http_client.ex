defmodule Gateway.HttpClient do
  use Confex, otp_app: :gateway

  require Logger

  @requests_with_body [:post, :put, :patch]
  @http_driver Application.get_env(:gateway, Gateway.HttpClient)[:http_driver]

  def request(:get, url, headers) do
    Logger.info("requesting :get, #{inspect url}, #{inspect headers}")

    url = to_charlist(url)
    headers = convert_headers(headers)
    @http_driver.request(:get, {url, headers}, [], [])
    |> handle_response()
  end

  def request(method, url, headers, content_type, body) when method in @requests_with_body do
    Logger.info("requesting #{inspect method}, #{inspect url}, #{inspect headers}")
    Logger.debug("with body: #{inspect body}")

    url = to_charlist(url)
    headers = convert_headers(headers)
    @http_driver.request(method, {url, headers, content_type, body}, [], [])
    |> handle_response()
  end

  defp handle_response({:ok, response}) do
    {{_http_version, status_code, _reason_phrase}, headers, body} = response

    {:ok, {status_code, headers, body}}
  end

  # {:error, {:headers_error, :not_strings}}
  defp handle_response({:error, error}), do: {:error, error}

  defp convert_headers(headers) do
    Enum.map(headers, fn({key, value}) ->
      {to_charlist(key), to_charlist(value)}
    end)
  end
end
