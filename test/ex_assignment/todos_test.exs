defmodule ExAssignment.TodosTest do
  use ExAssignment.DataCase

  alias ExAssignment.Todos

  describe "todos" do
    alias ExAssignment.Todos.Todo

    import ExAssignment.TodosFixtures

    @invalid_attrs %{done: nil, priority: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{done: true, priority: 42, title: "some title"}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.done == true
      assert todo.priority == 42
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{done: false, priority: 43, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.done == false
      assert todo.priority == 43
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end

    test "get_recommended/1 returns a todo with the highest urgency , this todo will have the lowest priority" do
      todo = todo_fixture()

      lower_priority_todo_attrs =  %{done: false , priority: 42, title: "some title"}
      higher_priority_todo_attrs =  %{done: false , priority: 41, title: "some title"}

      {:ok, %Todo{} = lower_priority_todo} = Todos.create_todo(lower_priority_todo_attrs)
      {:ok, %Todo{} = higher_priority_todo} = Todos.create_todo(higher_priority_todo_attrs)


      assert Todos.get_recommended() == higher_priority_todo
    end
  end
end
