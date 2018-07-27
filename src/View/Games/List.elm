module View.Games.List exposing (view)

import Html exposing (..)


view : Html msg
view =
    div []
        [ h1 [] [ text "All your games" ] ]
