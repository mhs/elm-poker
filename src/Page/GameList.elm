module Page.GameList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div []
        [ h1 [class "normal"]
            [ text "All your games"
            , small [class "black-50"] [ text "…are belong to us"]
            ]
        ]
