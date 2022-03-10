defmodule Ebank.ResetFile do
  def reset_file do
    file_name = "data.model.json"

    file_data = %{
      "accounts" => [
        %{
          "balance" => 10,
          "id" => 100,
          "transactions" => []
        },
        %{
          "balance" => 0,
          "id" => 300,
          "transactions" => []
        }
      ]
    }

    File.rm(file_name)
    File.write(file_name, Jason.encode!(file_data))
  end
end
