module View.NotFound exposing (view)

import Html exposing (..)


view : Html msg
view =
    div []
        [ h1 [] [ text "Oops, I couldn't find that page." ] ]
