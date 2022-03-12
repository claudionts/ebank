defmodule Ebank.Account do
  alias Ebank.File

  @spec get(Integer.t()) :: map
  def get(account_id) do
    all()
    |> Enum.filter(fn %{"id" => id} -> id == account_id end)
    |> Enum.at(0)
  end

  @spec change(Integer.t(), Map.t(), String.t()) :: :ok
  def change(account_id, value, field) when field in ["transactions", "balance"] do
    accounts = all()
    current_account = get(account_id)

    unset_accounts =
      accounts
      |> Enum.filter(fn %{"id" => id} -> id != account_id end)
      |> Enum.at(0)

    account_changed = change_field(current_account, value, String.to_atom(field))
    new_account = [account_changed] ++ [unset_accounts]

    %{"accounts" => new_account}
    |> File.change_data()
  end

  @spec all() :: list(map)
  defp all do
    %{"accounts" => accounts} = File.data()
    accounts
  end

  @spec change_field(map(), map(), atom) :: map()
  defp change_field(%{"transactions" => transactions} = current_account, value, :transactions) do
    current_account
    |> Map.put("transactions", [value | transactions])
  end


  @spec change_field(Integer, map(), atom) :: map()
  defp change_field(current_account, %{"balance" => balance}, :balance) do
    current_account
    |> Map.put("balance", balance)
  end
end
