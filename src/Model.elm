module Model exposing (Flags, Model, Page(..), initialModel)

import Session.Login as Login


type alias Flags =
    {}


type Page
    = Blank
    | NotFound
    | Home
    | Login Login.Model
    | GameList
    | Game


type alias Model =
    { page : Page
    }


initialModel : Flags -> Model
initialModel flags =
    { page = Blank
    }
