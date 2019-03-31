defmodule Gateway.HttpcBehaviour do
  @typep url :: String.t
  @typep http_version :: String.t
  @typep status_code :: integer
  @typep reason_phrase :: String.t
  @typep status_line :: {http_version, status_code, reason_phrase}
  @typep body :: String.t | binary()
  @typep field :: String.t
  @typep value :: String.t
  @typep header :: {field, value}
  @typep headers :: [header]
  @typep result :: {status_line, headers, body}
  @typep reason :: term
  @typep method :: term
  @typep content_type :: String.t
  
  @callback request(:get, url) :: {:ok, result} | {:error, reason}
  @callback request(method, url, headers, content_type, body) :: {:ok, result} | {:error, reason}
end
