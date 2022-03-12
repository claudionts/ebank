defmodule EbankWeb.ResetFileController do
  use EbankWeb, :controller

  alias Ebank.File


  @spec index(%Plug.Conn{}, map()) :: map()
  def index(conn, _params) do
    File.reset()

    conn
    |> put_status(:ok)
    |> put_view(EbankWeb.ResetView)
    |> render("generic_view.json", response: "OK")
  end
end
