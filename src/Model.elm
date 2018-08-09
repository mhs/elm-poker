module Model exposing (Flags, Model, Page(..), initialModel)

import Model.Session exposing (Session(..))
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
    , session : Session
    }


initialModel : Flags -> Model
initialModel flags =
    { page = Blank
    , session = NotLoggedIn
    }
