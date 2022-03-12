defmodule EbankWeb.OperationsControllerTest do
  use EbankWeb.ConnCase

  alias Ebank.File

  setup %{conn: conn} do
    File.reset()
    {:ok, conn: conn}
  end

  describe "/balance router" do
    test "return balance account", %{conn: conn} do
      assert 10 =
               conn
               |> get(Routes.operations_path(conn, :balance, %{"id" => 100}))
               |> json_response(200)
    end

    test "account not found", %{conn: conn} do
      assert 0 =
               conn
               |> get(Routes.operations_path(conn, :balance, %{"id" => 101}))
               |> json_response(404)
    end
  end

  describe "/event routers" do
    test "deposit :201", %{conn: conn} do
      assert %{"destination" => %{"balance" => 110, "id" => 100}} =
               conn
               |> post(
                 Routes.operations_path(conn, :deposit, %{
                   "type" => "deposit",
                   "destination" => 100,
                   "amount" => 100
                 })
               )
               |> json_response(201)
    end
  end
end
