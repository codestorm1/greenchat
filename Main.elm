import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
      (Model "" messages, WebSocket.send "ws://echo.websocket.org" input)

    NewMessage str ->
      (Model input (List.append messages [str]), Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://echo.websocket.org" NewMessage


-- VIEW
headerStyle : Attribute Msg
headerStyle =
  style
    [ ("backgroundColor", "green")
    , ("height", "20px")
    , ("width", "250px")
    ]

mainStyle : Attribute Msg
mainStyle =
  style
    [ ("margin", "5px")
    ]

-- greeting : Html Msg
-- greeting =
--   div [ myStyle ] [ text "Hello!" ]


view : Model -> Html Msg
view model =
  div [mainStyle]
    [
    div [headerStyle] [],
    div [] (List.map viewMessage model.messages)
    , input [onInput Input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
