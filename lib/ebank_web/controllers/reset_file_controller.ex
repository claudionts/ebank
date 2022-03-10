defmodule EbankWeb.ResetFileController do
  use EbankWeb, :controller

  alias Ebank.ResetFile

  def index(conn, _params) do
    ResetFile.reset_file()

    conn
    |> put_status(:ok)
    |> put_view(EbankWeb.ResetView)
    |> render("generic_view.json", response: "OK")
  end
end
