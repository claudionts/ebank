defmodule EbankWeb.ResetFileController do
  use EbankWeb, :controller

  alias Ebank.File

  @spec index(%Plug.Conn{}, map()) :: map()
  def index(conn, _params) do
    File.reset()

    conn
    |> send_resp(200, ["OK"])
  end
end
