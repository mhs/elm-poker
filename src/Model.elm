module Model exposing (Model, Page(..), initialModel)

import Json.Decode as Decode exposing (Value)


type Page
    = Blank
    | NotFound
    | Home
    | Login
    | GameList
    | Game


type alias Model =
    { page : Page
    }


initialModel : Value -> Model
initialModel val =
    { page = Blank
    }
