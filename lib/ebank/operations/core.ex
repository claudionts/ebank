defmodule Ebank.Operation do
  alias Ebank.Account

  
  defp enough_balance(account_id, amount) do
    %{"balance" => balance} = Account.get(account_id)
    amount >= balance
  end
end
