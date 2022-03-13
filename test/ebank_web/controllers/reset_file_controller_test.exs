defmodule EbankWeb.ResetFileControllerTest do
  use EbankWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  describe "index /reset router" do
    test "reset file data mock", %{conn: conn} do
      assert "OK" =
               conn
               |> post(Routes.reset_file_path(conn, :index))
               |> response(200)
    end
  end
end
