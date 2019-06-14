module Page exposing (Page(..), frame, rhref)

import Browser
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Route exposing (Route(..))



-- MODEL --


type Page
    = Blank
    | NotFound
    | Home
    | Login
    | GameList



-- VIEW --


rhref : Route -> Attribute msg
rhref route =
    route
        |> Route.routeToString
        |> Attr.href


frame : Page -> String -> Html msg -> Browser.Document msg
frame currentPage title content =
    { title = title
    , body =
        [ div []
            [ viewHeader currentPage
            , section [ class "pa4 black-80 avenir" ]
                [ div [ class "measure center" ]
                    [ content
                    ]
                ]
            ]
        ]
    }


viewHeader : Page -> Html msg
viewHeader currentPage =
    let
        navLinks =
            [ navbarLink currentPage Route.Home [ text "Home" ]
            , navbarLink currentPage Route.Login [ text "Login" ]
            , navbarLink currentPage Route.GameList [ text "Games" ]
            ]
    in
    header [ class "bg-white black-80 tc pv4 avenir" ]
        [ a [ class "mt2 mb0 link baskerville i fw1 f1", rhref Route.Home ] [ text "Planning Poker" ]
        , nav [ class "bt bb tc mw7 center mt4" ] navLinks
        ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink currentPage linkRoute linkContent =
    let
        active =
            case isActive currentPage linkRoute of
                True ->
                    "bg-light-green"

                False ->
                    ""
    in
    a [ rhref linkRoute, class "f6 f5-l link bg-animate black-80 hover-bg-lightest-blue dib pa3 ph3-l", class active ] linkContent


isActive : Page -> Route -> Bool
isActive currentPage linkRoute =
    case ( currentPage, linkRoute ) of
        ( Home, Route.Home ) ->
            True

        ( Login, Route.Login ) ->
            True

        ( GameList, Route.GameList ) ->
            True

        _ ->
            False
