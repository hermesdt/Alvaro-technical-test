defmodule GatewayWeb.HttpRedirectorController do
  use GatewayWeb, :controller
  
  def redirect(conn = %{method: "GET", private: %{http: http}}, _params) do
    url = "http://#{http["host"]}#{conn.request_path}?#{conn.query_string}"
    headers = conn.req_headers

    Gateway.HttpClient.request(:get, url, headers)
    |> handle_response(conn)
  end

  def redirect(conn = %{method: "POST", private: %{http: http}}, _params) do
    url = "http://#{http["host"]}#{conn.request_path}?#{conn.query_string}"
    headers = conn.req_headers
    body = conn.body_params
    
    Gateway.HttpClient.request(:post, url, headers, headers[:"content-type"], body)
    |> handle_response(conn)
  end
  
  defp handle_response(response, conn) do
    case response do
      {:ok, {status_code, headers, body}} ->
        conn
        |> (fn(conn) ->
          headers
          |>  Enum.reduce(conn, fn({header, value}, conn) ->
            put_resp_header(conn, to_string(header), to_string(value))
          end)
        end).()
        |> send_resp(status_code, body)

      {:error, error} ->
        conn
        |> put_resp_header("content-type", "text/plain")
        |> send_resp(500, inspect(error))
    end
  end
end
