defmodule EbankWeb.OperationsController do
  use EbankWeb, :controller

  alias Ebank.Operations.Balance

  def balance(conn, %{"id" => id}) do
    case response = Balance.account_balance(String.to_integer(id)) do
      :account_not_found -> render_balance(conn, 404, 0)
      _ -> render_balance(conn, :ok, response)
    end
  end

  def render_balance(conn, status, response) do
    conn
    |> put_status(status)
    |> put_view(EbankWeb.ResetView)
    |> render("generic_view.json", response: response)
  end
end
