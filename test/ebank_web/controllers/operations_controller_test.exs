defmodule EbankWeb.OperationsControllerTest do
  use EbankWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  describe "/balance router" do
    test "return balance account", %{conn: conn} do
      assert 100 =
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
end
