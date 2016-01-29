defmodule Todos.Repo do
  use Ecto.Repo, otp_app: :todos
  @doc """
### A simple means to execute raw sql
Usage:
```
[record | _] = Todos.Repo.execute_and_load("SELECT * FROM todos WHERE id = $1", [1], User)
record
# => %Todo{...}
```
"""

  @spec execute_and_load(String.t, map(), __MODULE__) :: __MODULE__
  def execute_and_load(sql, params, model) do
    Ecto.Adapters.SQL.query!(__MODULE__, sql, params)
      |> load_into(model)
  end

  defp load_into(response, model) do
    Enum.map response.rows, fn(row) ->
      fields = Enum.reduce(Enum.zip(response.columns, row), %{}, fn({key, value}, map) ->
        Map.put(map, key, value)
      end)
      Ecto.Schema.__load__(model, nil, nil, [], fields, &__MODULE__.__adapter__.load/2)
    end
  end
end
