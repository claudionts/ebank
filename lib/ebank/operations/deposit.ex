defmodule Ebank.Operations.Deposit do
  alias Ebank.Account

  def call(%{"destination" => account_id, "amount" => amount}) do
    with %{"balance" => current_balance} <- Account.get(account_id),
         :ok <- Account.change(account_id, %{"balance" => amount + current_balance}, "balance"),
         :ok <-
           Account.change(
             account_id,
             create_transaction(account_id, amount),
             "transactions"
           ) do
        {:ok, %{"destination" => %{"balance" => amount + current_balance, "id" => account_id}}}
    else
      _ -> :account_not_found
    end
  end

  defp create_transaction(account_id, amount) do
    %{
      "transactions" => [
        %{"type" => "deposit", "destination" => account_id, "amount" => amount}
      ]
    }
  end
end
