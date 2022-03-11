defmodule Ebank.Operations.Deposit do
  alias Ebank.Operation

  def call(params) do
    params
    |> Operation.run()
  end
end
