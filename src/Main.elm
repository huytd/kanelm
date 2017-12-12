port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode

import Models exposing (..)
import Views exposing (..)
import EventHelpers exposing (..)

main = Html.program {
          init = initModel,
          update = update,
          subscriptions = subscriptions,
          view = view
        }

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp -> 
      ( model, Cmd.none )

    KeyDown key ->
      if key == 13 then
         addNewTask model
      else
        ( model, Cmd.none )

    TextInput content ->
       ( { model | taskInput = content }, Cmd.none )

    Move selectedTask ->
      ( { model | movingTask = Just selectedTask }, Cmd.none )

    DropTask targetStatus ->
      let
          newTasks =
            case model.movingTask of
              Just task -> moveTaskToStatus task targetStatus model.tasks
              Nothing -> model.tasks
      in
         ( { model | 
             tasks = newTasks,
             movingTask = Nothing 
           }, Cmd.none )

view : Model -> Html Msg
view model =
  let
      todos = getToDoTasks model
      ongoing = getOnGoingTasks model
      dones = getDoneTasks model
  in
      div [ class "container" ] [
        input [ 
          type_ "text", 
          class "task-input",
          placeholder "What's on your mind right now?",
          tabindex 0,
          onKeyDown KeyDown,
          onInput TextInput,
          value model.taskInput
        ] [ ],
        div [ class "kanban-board" ] [
          taskColumnView Todo todos,
          taskColumnView OnGoing ongoing,
          taskColumnView Done dones
        ]
      ]
