defmodule GatewayWeb.HttpRedirectorController do
  use GatewayWeb, :controller
  
  def redirect(conn = %{method: "GET", private: %{http: http}}, _params) do
    url = "http://#{http["host"]}#{conn.request_path}?#{conn.query_string}"
    headers = conn.req_headers

    case Gateway.HttpClient.request(:get, url, headers) do
      {:ok, {status_code, headers, body}} ->
        conn
        |> (fn(conn) ->
          headers
          |>  Enum.reduce(conn, fn({header, value}, conn) ->
            put_req_header(conn, to_string(header), to_string(value))
          end)
        end).()
        |> send_resp(status_code, body)

      {:error, error} ->
        send_resp(conn, 500, inspect(error))

      unkown ->
        send_resp(conn, 500, "unkown response from http client: " <> inspect(unkown))
    end

    # conn
    # |> send_resp(200, {status_code, headers, body} |> inspect)
    # conn
    # |> (fn(conn) ->
    #   headers
    #   |>  Enum.reduce(conn, fn({header, value}, conn) ->
    #     put_req_header(conn, header, value)
    #   end)

    #   conn
    # end).()
    # |> put_resp_header("content-type", "application/json")
    # |> send_resp(200, body)
  end
end
