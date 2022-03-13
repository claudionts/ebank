defmodule EbankWeb.OperationsController do
  use EbankWeb, :controller

  alias Ebank.Operations.Balance
  alias Ebank.Operation
  alias Ebank.Account

  @spec operation(%Plug.Conn{}, %{
          type: String.t(),
          destination: Integer.t(),
          amount: Integer.t()
        }) :: map()
  def operation(conn, %{"type" => type, "destination" => _, "amount" => _} = params) do
    prepared_params = Operation.cast(params)

    account_id =
      if type in ["deposit", "withdraw"],
        do: Map.get(prepared_params, "destination"),
        else: Map.get(prepared_params, "origin")

    with {:ok, response} <-
           Operation.call(prepared_params, type),
         :ok <-
           Account.change(
             account_id,
             params,
             "transactions"
           ) do
      render_balance(conn, 201, response)
    else
      _ -> render_balance(conn, 404, 0)
    end
  end

  @spec balance(%Plug.Conn{}, %{id: Integer.t()}) :: map()
  def balance(conn, %{"account_id" => id}) do
    case response = Balance.account_balance(String.to_integer(id)) do
      :account_not_found -> render_balance(conn, 404, 0)
      _ -> render_balance(conn, :ok, response)
    end
  end

  @spec render_balance(%Plug.Conn{}, Integer, Map.t()) :: any
  defp render_balance(conn, status, response) do
    conn
    |> put_status(status)
    |> put_view(EbankWeb.ResetView)
    |> render("generic_view.json", response: response)
  end
end
