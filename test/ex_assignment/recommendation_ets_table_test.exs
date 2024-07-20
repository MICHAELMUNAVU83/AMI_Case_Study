defmodule ExAssignment.RecommendationETSTableTest do
  use ExAssignment.DataCase

  alias ExAssignment.RecommendationETS

  describe "recommendation_ets_table" do
    test "init/0 initializes the recommendation ETS table" do
      assert RecommendationETS.init() == :ok
    end

    test "insert/1 inserts a todo into the recommendation ETS table" do
      todo = %ExAssignment.Todos.Todo{id: 1, done: false, priority: 1, title: "some title"}
      assert RecommendationETS.insert(todo) == true
    end

    test "get/1 gets todos from the recommendation ETS table" do
      todo = %ExAssignment.Todos.Todo{id: 1, done: false, priority: 1, title: "some title"}
      RecommendationETS.insert(todo)
      assert RecommendationETS.get() == [todo]
    end

    test "clear/0 clears the recommendation ETS table" do
      todo = %ExAssignment.Todos.Todo{id: 1, done: false, priority: 1, title: "some title"}
      RecommendationETS.insert(todo)
      assert RecommendationETS.get() == [todo]
      RecommendationETS.clear()
      assert RecommendationETS.get() == []
    end
  end
end
