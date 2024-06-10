defmodule P1Meter.Transport.Behaviour do
  @moduledoc """
  Behaviour for transport
  """

  @callback read_line(context :: term, timeout :: non_neg_integer()) ::
              {:ok, String.t()} | {:error, term}
end
