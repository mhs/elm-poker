module Page.NotFound exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div []
        [ h1 [class "normal"] [ text "Oops, I couldn't find that page." ] ]
