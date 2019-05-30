module Model exposing (Flags, Model, Page(..), initialModel)

import Browser.Navigation exposing (Key)
import Games.Game as Game
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
    | Game Game.Model


type alias Model =
    { key : Key
    , page : Page
    , session : Session
    }


initialModel : Flags -> Key -> Model
initialModel flags key =
    { key = key
    , page = Blank
    , session = NotLoggedIn
    }
