module EventHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger = on "keydown" (Decode.map tagger keyCode)

onDragStart : msg -> Attribute msg
onDragStart message = on "dragstart" (Decode.succeed message)

onDragEnd : msg -> Attribute msg
onDragEnd message = on "dragend" (Decode.succeed message)

onDrop : msg -> Attribute msg
onDrop message = onWithOptions "drop"
                  { preventDefault = True,
                    stopPropagation = False
                  }
                  (Decode.succeed message)

