import WebGL exposing (..)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import Html exposing (Html, div, text, a)
import Html.Attributes exposing (height, href, style, width)
import Window exposing (Size)
import Task
import Time exposing (Time)
import AnimationFrame
import TerrianRayMarch
import WebGL.Texture as Texture exposing (Texture, Error)





-- MESH --


mesh : Mesh TerrianRayMarch.Vertex
mesh =
    WebGL.triangles
        [ ( TerrianRayMarch.Vertex (vec3 -1 1 0)
          , TerrianRayMarch.Vertex (vec3 1 1 0)
          , TerrianRayMarch.Vertex (vec3 -1 -1 0)
          )
        , ( TerrianRayMarch.Vertex (vec3 -1 -1 0)
          , TerrianRayMarch.Vertex (vec3 1 1 0)
          , TerrianRayMarch.Vertex (vec3 1 -1 0)
          )
        ]

-- MVC --
type alias Model =
  { size : Size
  , time : Float
  -- , tex : Maybe WebGL.Texture
  }

-- initModel : Model
-- initModel = Model (Size 0 0) 0

type Msg
  = Resize Size
  | Tick Time
  -- | TexLoad WebGL.Texture
  -- | TexError Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Resize s -> { model | size = s } ! []
    Tick t -> { model | time = model.time + t } ! []
    -- TexLoad tex2D -> {model |tex = Just tex2D } ! []
    -- TexError _ -> Debug.crash "error loading texture"

view : Model -> Html Msg
view {size, time} =
      div []
          [ WebGL.toHtml
            [ width size.width
            , height size.height
            , style [("display","block")]
            ]
            [ WebGL.entity
                TerrianRayMarch.vert
                TerrianRayMarch.frag
                mesh
                { iResolution = vec3 (toFloat size.width) (toFloat size.height) 0
                , iGlobalTime = time / 1000
                }
            ]
          , a [ href "https://www.shadertoy.com/view/4tBBDd"
              , style
                    [ ( "position", "absolute" )
                    , ( "top", "0" )
                    , ( "color", "#fff" )
                    , ( "font", "300 20px sans-serif" )
                    , ( "background-color", "#222" )
                    , ( "text-decoration", "none" )
                    ]
              ]
            [
                text "https://www.shadertoy.com/view/4tBBDd"
            ]
          ]


init : (Model, Cmd Msg)
init =
  {size = Size 0 0, time = 0 } ! [ Task.perform Resize Window.size
                                               -- , Texture.load "graynoise.png" |> Task.attempt (\result -> case result of
                                               --                                                              Err err -> TexError err
                                               --                                                              Ok val -> TexLoad val )
                                               ]

subs : Model -> Sub Msg
subs model =
  Sub.batch
  [ Window.resizes Resize
  , AnimationFrame.diffs Tick ]



-- MAIN --
main : Program Never Model Msg
main = Html.program {
    init = init
    , view = view
    , update = update
    , subscriptions = subs
  }
