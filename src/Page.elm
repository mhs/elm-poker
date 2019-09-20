module Page exposing (Page(..), frame, login, rhref, titleFromString)

import Browser
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Page.Login exposing (Model, initialModel)
import Route exposing (Route(..))
import Session exposing (Session(..))



-- MODEL --


type Page
    = Blank
    | NotFound
    | Home
    | Login Page.Login.Model
    | GameList


type Title
    = Title String


login : Page
login =
    Login Page.Login.initialModel



-- VIEW HELPERS --


frame : Page -> Session -> Title -> Html msg -> Browser.Document msg
frame currentPage session (Title title) content =
    { title = title
    , body =
        [ div []
            [ viewHeader currentPage session
            , section [ class "pa4 black-80 avenir" ]
                [ div [ class "measure center" ]
                    [ content
                    ]
                ]
            ]
        ]
    }


viewHeader : Page -> Session -> Html msg
viewHeader currentPage session =
    let
        navLinks =
            case session of
                LoggedIn _ ->
                    [ navbarLink currentPage Route.Home [ text "Home" ]
                    , navbarLink currentPage Route.GameList [ text "Games" ]
                    , navbarLink currentPage Route.Logout [ text "Logout" ]
                    ]

                NotLoggedIn ->
                    [ navbarLink currentPage Route.Home [ text "Home" ]
                    , navbarLink currentPage Route.Login [ text "Login" ]
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


rhref : Route -> Attribute msg
rhref route =
    route
        |> Route.routeToString
        |> Attr.href


isActive : Page -> Route -> Bool
isActive currentPage linkRoute =
    case ( currentPage, linkRoute ) of
        ( Home, Route.Home ) ->
            True

        ( Login _, Route.Login ) ->
            True

        ( GameList, Route.GameList ) ->
            True

        _ ->
            False


titleFromString : String -> Title
titleFromString title =
    Title title
