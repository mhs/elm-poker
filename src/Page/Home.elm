module Page.Home exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div []
        [ h1 [class "normal"] [ text "Welcome to Planning Poker!" ] ]
