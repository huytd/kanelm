port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Views exposing (..)
import EventHelpers exposing (..)


main : Program (Maybe Model) Model Msg
main = Html.programWithFlags {
          init = initModel,
          update = update,
          subscriptions = (always Sub.none),
          view = view
        }

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

    DropTask targetStatus -> moveTask model targetStatus

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
          taskColumnView "Todo" todos,
          taskColumnView "OnGoing" ongoing,
          taskColumnView "Done" dones
        ]
      ]
