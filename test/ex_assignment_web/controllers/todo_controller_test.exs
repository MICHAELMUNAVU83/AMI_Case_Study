defmodule ExAssignmentWeb.TodoControllerTest do
  use ExAssignmentWeb.ConnCase, async: true
  alias ExAssignment.Todos
  alias ExAssignment.Todos.Todo

  describe "GET /todos" do
    test "renders the todos page", %{conn: conn} do
      conn = get(conn, "/todos")
      response = html_response(conn, 200)
      assert response =~ "Todos"
    end

    test "if there are no todos , you see the text 'Nothing to do'", %{conn: conn} do
      conn = get(conn, "/todos")

      response = html_response(conn, 200)
      assert Todos.list_todos() == []
      assert response =~ "Nothing to do"
    end

    test "if there are  todos , you see them on this page", %{conn: conn} do
      todos = create_todos()
      conn = get(conn, "/todos")

      response = html_response(conn, 200)
      assert Todos.list_todos() != []
      assert response =~ "What should I do next?"
      assert response =~ "Open"
      assert response =~ "Completed"
      assert response =~ todos.first_todo.title
      assert response =~ todos.second_todo.title
      assert response =~ todos.third_todo.title
    end

    test "Open Todos are in the Open Section", %{conn: conn} do
      # Open todos are those that are not done , they have an id that has the prefix "open-todo-"
      todos = create_todos()
      conn = get(conn, "/todos")
      response = html_response(conn, 200)

      {:ok, parsed_html} = Floki.parse_document(response)

      assert Floki.find(parsed_html, "#open-todo-#{todos.first_todo.id}") != []
      assert Floki.find(parsed_html, "#open-todo-#{todos.second_todo.id}") != []
      assert Floki.find(parsed_html, "#open-todo-#{todos.third_todo.id}") == []
    end

    test "Completed Todos are in the Completed Section", %{conn: conn} do
      # Completed todos are those that are done , they have an id that has the prefix "completed-todo-"
      todos = create_todos()
      conn = get(conn, "/todos")
      response = html_response(conn, 200)

      {:ok, parsed_html} = Floki.parse_document(response)

      assert Floki.find(parsed_html, "#completed-todo-#{todos.first_todo.id}") == []
      assert Floki.find(parsed_html, "#completed-todo-#{todos.second_todo.id}") == []
      assert Floki.find(parsed_html, "#completed-todo-#{todos.third_todo.id}") != []
    end

    test "The Recommended todo is selected randomly between the ones with the highest urgency", %{
      conn: conn
    } do
      # The recommended todo is the one with the highest urgency , this todo will have the lowest priority and has the id
      # "recommended-todo-"
      todos = create_todos()
      conn = get(conn, "/todos")
      response = html_response(conn, 200)

      {:ok, parsed_html} = Floki.parse_document(response)

      # in this case the first todo has the highest urgency

      assert Floki.find(parsed_html, "#recommended-todo-#{todos.first_todo.id}") != []
      assert Floki.find(parsed_html, "#recommended-todo-#{todos.second_todo.id}") == []
    end

    test "After We visit the todo page again , the recommended todo is persisted", %{
      conn: conn
    } do
      # The recommended todo is the one with the highest urgency , this todo will have the lowest priority and has the id
      # "recommended-todo-"
      todos = create_todos()
      conn = get(conn, "/todos")
      response = html_response(conn, 200)

      {:ok, parsed_html} = Floki.parse_document(response)

      # in this case the first todo has the highest urgency

      assert Floki.find(parsed_html, "#recommended-todo-#{todos.first_todo.id}") != []
      assert Floki.find(parsed_html, "#recommended-todo-#{todos.second_todo.id}") == []

      refreshed_conn = get(conn, "/todos")
      response = html_response(refreshed_conn, 200)

      {:ok, parsed_html} = Floki.parse_document(response)

      # in this case the first todo has the highest urgency

      assert Floki.find(parsed_html, "#recommended-todo-#{todos.first_todo.id}") != []
      assert Floki.find(parsed_html, "#recommended-todo-#{todos.second_todo.id}") == []
    end

    test "After We visit the todo page again , the recommended todo is persisted", %{
      conn: conn
    } do
      # The recommended todo is the one with the highest urgency , this todo will have the lowest priority and has the id
      # "recommended-todo-"
      todos = create_todos()
      conn = get(conn, "/todos")
      response = html_response(conn, 200)

      {:ok, parsed_html} = Floki.parse_document(response)

      # in this case the first todo has the highest urgency

      assert Floki.find(parsed_html, "#recommended-todo-#{todos.first_todo.id}") != []
      assert Floki.find(parsed_html, "#recommended-todo-#{todos.second_todo.id}") == []

      refreshed_conn = get(conn, "/todos")
      response = html_response(refreshed_conn, 200)

      {:ok, parsed_html} = Floki.parse_document(response)

      # in this case the first todo has the highest urgency

      assert Floki.find(parsed_html, "#recommended-todo-#{todos.first_todo.id}") != []
      assert Floki.find(parsed_html, "#recommended-todo-#{todos.second_todo.id}") == []
    end
  end

  defp create_todos do
    {:ok, %Todo{} = first_todo} =
      Todos.create_todo(%{done: false, priority: 1, title: "first title"})

    {:ok, %Todo{} = second_todo} =
      Todos.create_todo(%{done: false, priority: 2, title: "second title"})

    {:ok, %Todo{} = third_todo} =
      Todos.create_todo(%{done: true, priority: 3, title: "third title"})

    %{
      first_todo: first_todo,
      second_todo: second_todo,
      third_todo: third_todo
    }
  end
end
