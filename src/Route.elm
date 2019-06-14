module Route exposing (Route(..), fromLocation, redirectTo, routeToString)

import Browser.Navigation as Navigation exposing (Key, pushUrl)
import PokerApi.Scalar exposing (Id(..))
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)


type Route
    = Home
    | Login
    | GameList



-- URL Parsing


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.Parser.map Home top
        , Url.Parser.map Login (s "login")
        , Url.Parser.map GameList (s "games")
        ]


{-| Helper to generate route fragments from a given Route.

routeToString Games 42
--- "#/games/42"

-}
routeToString : Route -> String
routeToString page =
    let
        fragments =
            case page of
                Home ->
                    []

                Login ->
                    [ "login" ]

                GameList ->
                    [ "games" ]
    in
    "/" ++ String.join "/" fragments


fromLocation : Url -> Maybe Route
fromLocation location =
    parse route location


redirectTo : Route -> Key -> Cmd msg
redirectTo routeVal key =
    -- TODO: if current user, continue, otherwise go to login
    Navigation.pushUrl key (routeToString routeVal)
