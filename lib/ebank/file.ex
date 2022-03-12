defmodule Ebank.File do
  @file_name "data.model.json"

  @spec reset() :: :ok
  def reset do
    data = %{
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
    File.write(@file_name, Jason.encode!(data))
  end

  @spec data() :: map
  def data do
    File.read!(@file_name)
    |> Jason.decode!()
  end

  @spec change_data(map) :: :ok
  def change_data(data) do
    File.rm(@file_name)
    File.write(@file_name, Jason.encode!(data))
  end
end
