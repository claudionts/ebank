defmodule Ebank.Operations.Balance do
  alias Ebank.Account
  
  def account_balance(account_id) do
    case Account.get(account_id) do
      %{"balance" => balance} -> balance
      _ -> :account_not_found 
    end
  end
end
