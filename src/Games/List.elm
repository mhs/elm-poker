module Games.List exposing (view)

import Html exposing (..)


view : Html msg
view =
    div []
        [ h1 [] [ text "All your games" ]
        , p [] [ text "...are belong to us" ]
        ]
