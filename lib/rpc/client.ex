defmodule Soroban.RPC.Client do
  @moduledoc """
  Specifies the API for processing HTTP requests in the Soroban-RPC server.
  """
  alias Soroban.RPC.Client

  @behaviour Client.Spec

  @impl true
  def request(endpoint, url, headers \\ [], params \\ nil, opts \\ []),
    do: impl().request(endpoint, url, headers, params, opts)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:soroban, :http_client_impl, Client.Default)
  end
end
