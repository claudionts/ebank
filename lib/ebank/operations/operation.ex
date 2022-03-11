defmodule Ebank.Operation do
  alias Ebank.Account

  def call(%{"destination" => origin_id, "amount" => amount}, type)
      when type in ["deposit", "withdraw"] do
    with %{"balance" => current_balance} <- Account.get(origin_id),
         true <- enough_balance(origin_id, amount, type),
         :ok <-
           Account.change(
             origin_id,
             %{"balance" => handle_balance(amount, current_balance, String.to_atom(type))},
             "balance"
           ) do
      {:ok,
       %{
         "destination" => %{
           "balance" => handle_balance(amount, current_balance, String.to_atom(type)),
           "id" => origin_id
         }
       }}
    else
      _ -> :account_not_found
    end
  end

  def call(
        %{"destination" => destination_id, "amount" => amount, "origin" => origin_id},
        "transfer"
      ) do
    with %{"id" => _} <- Account.get(origin_id),
         {:ok, _} <- call(%{"destination" => origin_id, "amount" => amount}, "withdraw"),
         {:ok, _} <- call(%{"destination" => destination_id, "amount" => amount}, "deposit") do
      {:ok,
       %{
         "destination" => show_account(destination_id),
         "origin" => show_account(origin_id)
       }}
    else
      _ -> :account_not_found
    end
  end

  defp show_account(account_id) do
    Account.get(account_id) |> Map.delete("transactions")
  end
  defp handle_balance(amount, current_balance, :deposit), do: current_balance + amount

  defp handle_balance(amount, current_balance, :withdraw), do: current_balance - amount

  defp enough_balance(account_id, amount, type) do
    if type == "withdraw" do
      %{"balance" => balance} = Account.get(account_id)
      balance >= amount
    else
      true
    end
  end
end