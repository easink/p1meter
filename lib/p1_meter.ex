defmodule P1Meter do
  @moduledoc """
  Documentation for `IEC62056_21 mode D`.
  """

  alias P1Meter.Context
  alias P1Meter.Frame

  # @timeout 10_000

  @spec get_frame(Context.t()) :: {:ok, Frame.t()} | {:error, term}
  def get_frame(ctx) do
    Frame.get_frame(ctx)
  end

  @spec stream(Context.t()) :: Enumerable.t()
  def stream(ctx) do
    Stream.unfold(ctx, fn ctx ->
      case get_frame(ctx) do
        {:ok, frame} -> {frame, ctx}
        {:error, :timeout} -> nil
        {:error, reason} -> raise("Error getting frame: #{inspect(reason)}")
      end
    end)
  end
end
