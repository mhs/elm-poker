module Page.GameList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div []
        [ h1 [] [ text "All your games" ]
        , p [] [ text "...are belong to us" ]
        ]
