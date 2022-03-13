defmodule Ebank.Operation do
  alias Ebank.Account

  @spec call(
          %{
            type: String.t(),
            destination: Integer.t(),
            amount: Integer.t(),
            origin: Integer.t()
          },
          String.t()
        ) :: map() | :account_not_found
  def call(
        params,
        "transfer"
      ) do
    %{"destination" => destination_id, "amount" => amount, "origin" => origin_id} = params

    with %{"id" => _} <- Account.get(origin_id),
         {:ok, _} <- call(%{"origin" => origin_id, "amount" => amount}, "withdraw"),
         {:ok, _} <- call(%{"destination" => destination_id, "amount" => amount}, "deposit"),
         %{"id" => id_destination} = destination = show_account(destination_id),
         %{"id" => id_origin} = origin = show_account(origin_id) do
      {:ok,
       %{
         "destination" => Map.put(destination, "id", Integer.to_string(id_destination)),
         "origin" => Map.put(origin, "id", Integer.to_string(id_origin))
       }}
    else
      _ -> :account_not_found
    end
  end

  @spec call(
          %{
            type: String.t(),
            destination: Integer.t(),
            amount: Integer.t()
          },
          String.t()
        ) :: map() | :account_not_found
  def call(params, type)
      when type in ["deposit", "withdraw"] do
    %{"amount" => amount} = params

    account_id =
      if params["destination"] != nil,
        do: params["destination"],
        else: params["origin"]

    key_map =
      if type == "withdraw",
        do: "origin",
        else: "destination"

    with %{"balance" => current_balance} <- Account.get(account_id),
         true <- enough_balance(account_id, amount, type),
         :ok <-
           Account.change(
             account_id,
             %{"balance" => handle_balance(amount, current_balance, String.to_atom(type))},
             "balance"
           ) do
      {:ok,
       %{
         key_map => %{
           "id" => Integer.to_string(account_id),
           "balance" => handle_balance(amount, current_balance, String.to_atom(type))
         }
       }}
    else
      _ -> :account_not_found
    end
  end

  @spec cast(%{
          type: String.t(),
          destination: Integer.t(),
          amount: Integer.t(),
          origin: Integer.t()
        }) :: map()
  def cast(%{
        "type" => type,
        "destination" => destination,
        "amount" => amount,
        "origin" => origin
      }) do
    %{
      "type" => type,
      "destination" => to_integer(destination),
      "amount" => to_integer(amount),
      "origin" => to_integer(origin)
    }
  end

  @spec cast(%{
          type: String.t(),
          destination: Integer.t(),
          amount: Integer.t()
        }) :: map()
  def cast(%{"type" => type, "destination" => destination, "amount" => amount}) do
    %{"type" => type, "destination" => to_integer(destination), "amount" => to_integer(amount)}
  end

  @spec cast(%{
          type: String.t(),
          origin: Integer.t(),
          amount: Integer.t()
        }) :: map()
  def cast(%{"type" => type, "origin" => origin, "amount" => amount}) do
    %{"type" => type, "origin" => to_integer(origin), "amount" => to_integer(amount)}
  end

  defp show_account(account_id) do
    account =
      account_id
      |> to_integer()
      |> Account.get()

    if not is_nil(account) && Map.has_key?(account, "transactions") do
      Map.delete(account, "transactions")
    else
      nil
    end
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

  defp to_integer(value) when is_binary(value) do
    String.to_integer(value)
  end

  defp to_integer(value) when is_integer(value) do
    value
  end
end
