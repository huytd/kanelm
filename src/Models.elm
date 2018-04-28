port module Models exposing (..)

type Msg = NoOp | KeyDown Int | TextInput String | Move Task | DropTask String | Delete String

type alias Task = {
    name: String,
    status: String
  }

type alias Model = {
  taskInput: String,
  tasks: List Task,
  movingTask: Maybe Task
}

-- PORTS

port setStorage : Model -> Cmd msg

saveData : Model -> ( Model, Cmd Msg )
saveData model = ( model, setStorage model )

-- INITIAL FUNCTION

initModel : Maybe Model -> ( Model, Cmd msg )
initModel model = 
  case model of
    Just model -> ( model, Cmd.none )
    Nothing -> ( Model "" [] Nothing, Cmd.none )


-- ADD TASK

addNewTask : Model -> ( Model, Cmd Msg )
addNewTask model =
  let
     newModel = { model | 
                   tasks = model.tasks ++ [ Task model.taskInput "Todo" ],
                   taskInput = ""
                }
  in
     ( newModel, Cmd.batch [ setStorage newModel, Cmd.none ] )

-- CHANGE TASK STATUS

moveTaskToStatus : Task -> String -> List Task -> List Task
moveTaskToStatus taskToFind newTaskStatus tasks =
  List.map (\t -> 
    if t.name == taskToFind.name then
       { t | status = newTaskStatus }
    else
       t
     ) tasks


moveTask : Model -> String -> ( Model, Cmd Msg )
moveTask model targetStatus =
  let
      newTasks =
        case model.movingTask of
          Just task -> moveTaskToStatus task targetStatus model.tasks
          Nothing -> model.tasks

      newModel = { model | tasks = newTasks, movingTask = Nothing }
  in
      ( newModel, Cmd.batch [ setStorage newModel, Cmd.none ] )


-- DELETE TASK

deleteTask : Model -> String -> ( Model, Cmd Msg )
deleteTask model name =
    let
        newModel = { model | tasks = List.filter (\x -> x.name /= name) model.tasks }
    in
        ( newModel, Cmd.batch [ setStorage newModel, Cmd.none ] )

-- GET TASKS BY STATUS

getOnGoingTasks : Model -> List Task
getOnGoingTasks model =
  List.filter (\t -> t.status == "OnGoing") model.tasks

getToDoTasks : Model -> List Task
getToDoTasks model =
  List.filter (\t -> t.status == "Todo") model.tasks

getDoneTasks : Model -> List Task
getDoneTasks model =
  List.filter (\t -> t.status == "Done") model.tasks


