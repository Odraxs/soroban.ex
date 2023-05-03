defmodule Soroban.RPC.Client.Spec do
  @moduledoc """
  Specifies expected behaviour of an HTTP client.
  """

  alias Soroban.RPC.Error

  @type method :: String.t()
  @type headers :: [{binary(), binary()}, ...]
  @type options :: Keyword.t()
  @type params :: map()
  @type response :: {:ok, map()}
  @type response_error :: {:error, Error.t()}

  @callback request(
              method :: method(),
              url :: binary(),
              headers :: headers(),
              params :: params(),
              options :: options()
            ) :: response() | response_error()
end
