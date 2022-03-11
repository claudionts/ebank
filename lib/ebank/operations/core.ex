defmodule Ebank.Operation do
  alias Ebank.Account

  def run(%{"destination" => account_id, "amount" => amount}, :deposit) do
    with %{"balance" => current_balance} <- Account.get(account_id),
         :ok <- Account.change(account_id, %{"balance" => amount + current_balance}, "balance"),
         :ok <-
           Account.change(
             account_id,
             %{
               "transactions" => [
                 %{"type" => "deposit", "destination" => account_id, "amount" => amount}
               ]
             },
             "transactions"
           ) do
      new_transaction =
        {:ok, %{"destination" => %{"balance" => amount + current_balance, "id" => account_id}}}
    else
      _ -> :account_not_found
    end
  end

  defp enough_balance(account_id, amount) do
    %{"balance" => balance} = Account.get(account_id)
    amount >= balance
  end
end
