module Route exposing (Route(..), fromLocation, routeToString)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, int, oneOf, parseHash, s, string, top)


type alias Id =
    Int


type Route
    = Home
    | Login
    | GameList
    | Game Id



-- URL Parsing


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home top
        , Url.map Login (s "login")
        , Url.map Game (s "games" </> int) -- more specific than following route
        , Url.map GameList (s "games")
        ]


{-| Helper to generate route fragments from a given Route.

routeToString Games 42
--- "/games/42"

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

                Game id ->
                    [ "games", toString id ]
    in
    "#/" ++ String.join "/" fragments


fromLocation : Location -> Maybe Route
fromLocation location =
    parseHash route location
