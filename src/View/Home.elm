module View.Home exposing (view)

import Html exposing (..)


view : Html msg
view =
    div []
        [ h1 [] [ text "Welcome to Planning Poker!" ] ]
