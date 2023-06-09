defmodule Soroban.RPC.TopicFilter do
  @moduledoc """
  `TopicFilter` struct definition.
  """

  @type segments :: list(String.t() | struct())
  @type segments_validation :: {:ok, segments()} | {:error, atom()}
  @type request_args :: segments() | :error
  @type xdr :: String.t()
  @type t :: %__MODULE__{
          segments: segments()
        }

  defstruct [:segments]

  @spec new(args :: segments()) :: t() | {:error, atom()}
  def new(args) when is_list(args) and length(args) in 1..4 do
    with {:ok, segments} <- validate_segments(args) do
      %__MODULE__{
        segments: segments
      }
    end
  end

  def new(_args), do: {:error, :invalid_args}

  @spec to_request_args(t()) :: request_args()
  def to_request_args(%__MODULE__{segments: segments}), do: segments
  def to_request_args(_struct), do: :error

  @spec validate_segments(args :: segments(), segments :: segments()) :: segments_validation()
  defp validate_segments(_args, segments \\ [])

  defp validate_segments(["*" = val | rest], segments) do
    segments = segments ++ [val]
    validate_segments(rest, segments)
  end

  defp validate_segments([%{__struct__: struct} = val | rest], segments)
       when is_struct(val) do
    segments =
      val
      |> struct.to_sc_val()
      |> param_to_xdr()
      |> (&(segments ++ [&1])).()

    validate_segments(rest, segments)
  end

  defp validate_segments([], segments), do: {:ok, segments}

  defp validate_segments(_args, _segments), do: {:error, :invalid_segments}

  @spec param_to_xdr(param :: struct()) :: xdr()
  defp param_to_xdr(%{__struct__: struct} = param) when is_struct(param) do
    xdr = struct.to_xdr(param)
    xdr_struct = xdr.__struct__

    xdr
    |> xdr_struct.encode_xdr!()
    |> Base.encode64()
  end
end
