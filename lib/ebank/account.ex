defmodule Ebank.Account do
  alias Ebank.ResetFile

  @spec get(Integer.t()) :: %{
          balance: Integer.t(),
          id: Integer.t(),
          transactions: List.t()
        }
  def get(account_id) do
    %{"accounts" => accounts} = ResetFile.file_data()

    accounts
    |> Enum.filter(fn %{"id" => id} -> id == account_id end)
    |> Enum.at(0)
  end
end
