defmodule Ebank.ResetFile do
  @file_name "data.model.json"

  @spec reset_file() :: atom
  def reset_file do
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

    File.rm(@file_name)
    File.write(@file_name, Jason.encode!(file_data))
  end

  @spec file_data() :: map 
  def file_data do
    File.read!(@file_name)
    |> Jason.decode!()
  end
end
