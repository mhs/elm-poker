module Route exposing (Route(..), fromLocation, redirectTo, routeToString)

import Navigation exposing (Location)
import PokerApi.Scalar exposing (Id(..))
import UrlParser as Url exposing ((</>), Parser, int, oneOf, parseHash, s, string, top)


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
        , Url.map Game <| Url.map Id (s "games" </> string) -- more specific than following route
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

                Game (Id id) ->
                    [ "games", id ]
    in
    "#/" ++ String.join "/" fragments


fromLocation : Location -> Maybe Route
fromLocation location =
    parseHash route location


redirectTo : Route -> Cmd msg
redirectTo =
    -- TODO: if current user, continue, otherwise go to login
    routeToString >> Navigation.modifyUrl
