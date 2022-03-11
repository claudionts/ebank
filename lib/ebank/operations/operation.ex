defmodule Ebank.Operation do
  alias Ebank.Account

  def call(%{"destination" => account_id, "amount" => amount}, type)
      when type in ["deposit", "withdraw"] do
    with %{"balance" => current_balance} <- Account.get(account_id),
         true <- enough_balance(account_id, amount, type),
         :ok <-
           Account.change(
             account_id,
             %{"balance" => handle_balance(amount, current_balance, String.to_atom(type))},
             "balance"
           ),
         :ok <-
           Account.change(
             account_id,
             create_transaction(account_id, amount, type),
             "transactions"
           ) do
      {:ok,
       %{
         "destination" => %{
           "balance" => handle_balance(amount, current_balance, String.to_atom(type)),
           "id" => account_id
         }
       }}
    else
      _ -> :account_not_found
    end
  end

  defp handle_balance(amount, current_balance, :deposit), do: current_balance + amount

  defp handle_balance(amount, current_balance, :withdraw), do: current_balance - amount

  defp create_transaction(account_id, amount, type) do
    %{
      "transactions" => [
        %{"type" => type, "destination" => account_id, "amount" => amount}
      ]
    }
  end

  defp enough_balance(account_id, amount, type) do
    if type == "withdraw" do
      %{"balance" => balance} = Account.get(account_id)
      balance >= amount
    else
      true
    end
  end
end
