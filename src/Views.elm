module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import EventHelpers exposing (..)

-- CARD VIEW

taskItemView : Int -> Task -> Html Msg
taskItemView index task =
  li [ class "task-item",
       attribute "draggable" "true",
       onDragStart <| Move task,
       attribute "ondragstart" "event.dataTransfer.setData('text/plain', '')"
     ]
     [ enrichItemContent task.name
     , button [ class "btn-delete"
              , onClick <| Delete task.name
              ][ text "+" ]
     ]

enrichItemContent : String -> Html Msg
enrichItemContent str =
  List.map
      (\word ->
        if
          String.startsWith "http" word
        then
          a [target "_blank", href word] [text word] 
        else
          text word
      )
      (String.words str)
    |> List.intersperse (text " ")
    |> Html.div []


-- COLUMN VIEW

taskColumnView : String -> List Task -> Html Msg
taskColumnView status list =
  div [ class <| "category " ++ String.toLower status,
        attribute "ondragover" "return false",
        onDrop <| DropTask status
      ] [
      h2 [] [ text status ],
      span [] [ text (toString (List.length list) ++ " item(s)") ],
      ul [] (List.indexedMap taskItemView list)
    ]