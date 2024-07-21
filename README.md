# Assignment - Todo Recommendations

![AMI Company Logo](.docs/images/logo.svg)

A small Elixir/Phoenix assignment for the [AMI](https://www.africanmanagers.org/) hiring process.

---

## Hello Reviewer , below is my submission for the AMI Case Study

## Description

> There were 2 tasks for the case study

1.  Improve the quality of 'What should I do next?' recommendations
2.  Persist the 'What should I do next?' recommendation

## My Approach

## Task 1 : Improve the quality of 'What should I do next?' recommendations

- Tasks have a field called priority which is used to determine the urgency of the task
- I refactored the function called `ExAssignment.Todos.get_recommended()` which returns a random urgent task from the list of tasks
- I grouped the tasks by their priority and then take a random task from the group with the highest urgency(least priority value)

## Task 2 : Persist the 'What should I do next?' recommendation

- I decided to go with Erlang Term Storage (ETS) to store the recommended task as opposed to using a database as it is a simple key-value store and is faster than a database which is ideal for this use case.
- I created a module called `ExAssignment.RecommendationETS` which is responsible for storing and retrieving the recommended task from ETS
- I created a function called `ExAssignment.RecommendationETS.init()` which initializes the ETS table and stores the recommended task , this is called when the application starts.
- I created a function called `ExAssignment.RecommendationETS.get()` which retrieves the recommended task from ETS.

## Video Demo


https://github.com/user-attachments/assets/9d208f40-b0b5-4714-8bae-cd7a545a110b




## Testing

- I added Unit Tests for the `ExAssignment.RecommendationETS` module in the `test/ex_assignment/recommendation_ets_table_test.exs` file.
  You can run the tests by running the command `mix test test/ex_assignment/recommendation_ets_table_test.exs`

- I added Unit Tests for the `ExAssignment.Todos` module in the `test/ex_assignment/todos_test.exs` file.
  You can run the tests by running the command `mix test test/ex_assignment/todos_test.exs`

- I added Integration Tests for the `ExAssignmentWeb.TodoControllers` module in the `test/ex_assignment_web/controllers/todo_controller_test.exs` file.
  You can run the tests by running the command `mix test test/ex_assignment_web/controllers/todo_controller_test.exs`

## How to run the application

- Clone the repository by running the command `git clone https://github.com/MICHAELMUNAVU83/AMI_Case_Study.git`
- Change directory to the project root by running the command `cd AMI_Case_Study`
- Install the dependencies by running the command `mix deps.get`
- Once your enviroment is prepared, run mix setup from the root directory of this repository, to compile the project and initialize the development database.
- Start the application by running the command `mix phx.server`

## Conclusion

The assignment was a great learning experience for me as I got understand how the company structures their codebase and how they approach problems.
I am Looking forward to hearing from you soon.
