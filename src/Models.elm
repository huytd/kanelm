module Models exposing (..)

type TaskStatus = Todo | OnGoing | Done

type alias Task = {
    name: String,
    status: TaskStatus
  }

type alias Model = {
  taskInput: String,
  tasks: List Task,
  movingTask: Maybe Task
}
