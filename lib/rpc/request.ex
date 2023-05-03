defmodule Soroban.RPC.Request do
  @moduledoc """
  A module to work with Soroban RPC requests.
  Requests are composed in a functional manner.
  The request does not happen until it is configured and passed to `perform/1`.
  """

  alias Soroban.RPC.{Client, Error, HTTPError}

  @default_url "https://rpc-futurenet.stellar.org:443/"

  @type method :: String.t()
  @type headers :: [{binary(), binary()}]
  @type params :: map() | nil
  @type opts :: Keyword.t()
  @type response :: {:ok, map()} | {:error, Error.t()} | {:error, HTTPError.t()}
  @type parsed_response :: {:ok, struct()} | {:error, Error.t()} | {:error, HTTPError.t()}
  @type url :: String.t()

  @type t :: %__MODULE__{
          method: method(),
          url: url(),
          params: params(),
          headers: headers()
        }

  defstruct [
    :method,
    :url,
    :params,
    :headers
  ]

  @spec new(method :: method(), opts :: opts()) :: t()
  def new(method, opts \\ []) do
    url = Keyword.get(opts, :url, @default_url)

    %__MODULE__{
      method: method,
      url: url,
      params: nil,
      headers: []
    }
  end

  @spec add_headers(request :: t(), headers :: headers()) :: t()
  def add_headers(%__MODULE__{} = request, headers), do: %{request | headers: headers}

  @spec add_params(request :: t(), params :: params()) :: t()
  def add_params(%__MODULE__{} = request, params),
    do: %{request | params: params}

  @spec perform(request :: t()) :: response()
  def perform(%__MODULE__{method: method, url: url, headers: headers, params: params}),
    do: Client.request(method, url, headers, params)

  @spec results(response :: response(), opts :: opts()) :: parsed_response()
  def results({:ok, results}, as: resource), do: {:ok, resource.new(results)}
  def results({:error, error}, _resource), do: {:error, error}
end
