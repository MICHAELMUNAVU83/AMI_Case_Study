defmodule ExAssignment.RecommendationETS do
  @moduledoc """
  Provides operations for working with the recommendation ETS table.
  """

  @table_name :recommendation

  @doc """
  Initializes the recommendation ETS table.
  """
  def init do
    case :ets.info(@table_name) do
      :undefined ->
        :ets.new(@table_name, [:set, :public, :named_table])

      _ ->
        :ok
    end
  end

  @doc """
  Inserts a todo into the recommendation ETS table.
  """
  def insert(todo) do
    :ets.insert(@table_name, {:recommended_todo, todo})
  end

  @doc """
  Gets a todo from the recommendation ETS table.
  """
  def get() do
    :ets.lookup(@table_name, :recommended_todo)
    |> Enum.map(fn {_, value} -> value end)
  end

  @doc """
  Clears the recommendation ETS table.
  """
  def clear do
    :ets.delete_all_objects(@table_name)
    IO.puts("Cleared ETS table: #{@table_name}")
  end
end
