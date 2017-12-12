module Models exposing (..)

type Msg = NoOp | KeyDown Int | TextInput String | Move Task | DropTask TaskStatus

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

-- INITIAL FUNCTION

initModel : ( Model, Cmd msg )
initModel = ( Model ""
  [
    Task "Demo Task #1" OnGoing,
    Task "Demo Task #2" Todo,
    Task "Demo Task #3" Done
  ] Nothing, Cmd.none )

-- ADD TASK

addNewTask : Model -> ( Model, Cmd Msg )
addNewTask model =
  ( { model | 
      tasks = model.tasks ++ [ Task model.taskInput Todo ],
      taskInput = ""
    }
  , Cmd.none )

-- CHANGE TASK STATUS

moveTaskToStatus : Task -> TaskStatus -> List Task -> List Task
moveTaskToStatus taskToFind newTaskStatus tasks =
  List.map (\t -> 
    if t.name == taskToFind.name then
       { t | status = newTaskStatus }
    else
       t
     ) tasks

-- GET TASKS BY STATUS

getOnGoingTasks : Model -> List Task
getOnGoingTasks model =
  List.filter (\t -> t.status == OnGoing) model.tasks

getToDoTasks : Model -> List Task
getToDoTasks model =
  List.filter (\t -> t.status == Todo) model.tasks

getDoneTasks : Model -> List Task
getDoneTasks model =
  List.filter (\t -> t.status == Done) model.tasks


