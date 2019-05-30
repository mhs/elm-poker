module Games.List exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model.PokerGame exposing (PokerGame)
import Model.Session exposing (GamesData, GamesDataItems, Session(..))
import RemoteData exposing (RemoteData)
import Route exposing (Route(..), routeToString)
import View.Page exposing (rhref)


view : Session -> Html msg
view session =
    div []
        [ h1 [] [ text "All your games" ]
        , p [] [ text "...are belong to us" ]
        , listGames session
        ]


listGames : Session -> Html msg
listGames session =
    case session of
        NotLoggedIn ->
            p [] [ text "Log in to see your games" ]

        LoggedIn _ RemoteData.NotAsked ->
            p [] [ text "Initializing..." ]

        LoggedIn _ RemoteData.Loading ->
            p [] [ text "Loading your games..." ]

        LoggedIn _ (RemoteData.Failure err) ->
            p [ class "error" ] [ text <| Debug.toString err ]

        LoggedIn _ (RemoteData.Success games) ->
            let
                list =
                    case games of
                        [] ->
                            p [] [ text "No games yet!" ]

                        _ ->
                            ul [ class "list p10" ] (List.map gameLink games)
            in
            div [] [ list ]


gameLink : PokerGame -> Html msg
gameLink game =
    li [ class "lh-copy pv3 ba bl-0 bt-0 br-0 b--dotted b--black-30" ]
        [ a [ rhref (Route.Game game.id), class "link hover-black f6 f5-ns dib mr3 mr4-ns" ] [ text game.name ]
        , text ("( " ++ game.status ++ " )")
        ]
