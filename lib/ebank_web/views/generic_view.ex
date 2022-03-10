defmodule EbankWeb.ResetView do
  use EbankWeb, :view

  def render("generic_view.json", %{response: res}) do
    res
  end
end
