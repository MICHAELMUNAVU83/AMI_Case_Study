defmodule ExAssignmentWeb.TodoController do
  use ExAssignmentWeb, :controller

  alias ExAssignment.Todos
  alias ExAssignment.Todos.Todo
  alias ExAssignment.RecommendationETS

  def index(conn, _params) do
    open_todos =
      Todos.list_todos(:open)

    done_todos = Todos.list_todos(:done)
    recommended_todo = Todos.get_recommended()

    render(conn, :index,
      open_todos: open_todos,
      done_todos: done_todos,
      recommended_todo: recommendation_in_ets(recommended_todo, open_todos)
    )
  end

  def new(conn, _params) do
    changeset = Todos.change_todo(%Todo{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"todo" => todo_params}) do
    case Todos.create_todo(todo_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: ~p"/todos")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    render(conn, :show, todo: todo)
  end

  def edit(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    changeset = Todos.change_todo(todo)
    render(conn, :edit, todo: todo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id)

    case Todos.update_todo(todo, todo_params) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo updated successfully.")
        |> redirect(to: ~p"/todos/#{todo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, todo: todo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    {:ok, _todo} = Todos.delete_todo(todo)

    conn
    |> put_flash(:info, "Todo deleted successfully.")
    |> redirect(to: ~p"/todos")
  end

  def check(conn, %{"id" => id}) do
    :ok = Todos.check(id)

    conn
    |> redirect(to: ~p"/todos")
  end

  def uncheck(conn, %{"id" => id}) do
    :ok = Todos.uncheck(id)

    conn
    |> redirect(to: ~p"/todos")
  end

  defp recommendation_in_ets(recommended_todo, open_todos) do
    # Retrieve the current recommendation from ETS
    current_recommendation = RecommendationETS.get() |> List.first()

    # Check if the current recommendation is among the open todos
    if Enum.member?(open_todos, current_recommendation) &&
         !todo_in_open_todos_of_higher_urgency(current_recommendation, open_todos) do
      # If the current recommendation is present in open_todos, do nothing
      :ok
    else
      # If not, clear the ETS table and insert the new recommendation
      RecommendationETS.clear()
      RecommendationETS.insert(recommended_todo)
    end

    # Return the updated recommendation from ETS
    RecommendationETS.get() |> List.first()
  end

  defp todo_in_open_todos_of_higher_urgency(todo, open_todos) do
    todo_priority = todo.priority

    Enum.any?(open_todos, fn open_todo ->
      open_todo.priority < todo_priority
    end)
  end
end
