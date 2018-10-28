module StyleSheet exposing (..)
import Css exposing (..)
import Css.Global as CSSG exposing (global, everything, ul)


import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src)
import Html.Styled.Events exposing (onClick)


globalStyles : Html.Html msg
globalStyles =
  toUnstyled <|
    global
        [ everything
            [ before [ margin (px 0), padding (px 0), boxSizing borderBox]
            , after [ margin (px 0) , padding (px 0), boxSizing borderBox]
            ]
        , CSSG.class "clearfix"
            [ after
                [ display Css.table
                --, Css.content " "
                -- , clear "both"
                ]
            ]
        , CSSG.class "container" [ Css.width (px 960), margin2 (px 0) (auto) ]
        , CSSG.class "left" [ float left ]
        , CSSG.class "right" [ float right ]
        , CSSG.img
            [ border (px 0) ]
        , CSSG.typeSelector "ul"
            [ CSSG.descendants
                [ CSSG.typeSelector "li"
                    [ listStyleType none
                    , CSSG.descendants
                        [ CSSG.typeSelector "a"
                            [ textDecoration none
                            ]
                        ]
                    ]
                ]
            , position absolute
            ]
        ]
desktopStyles : Html.Html msg
desktopStyles =
  toUnstyled <|
    global
      [ CSSG.class "home"
          [ fontSize (px 14)
          , fontFamily sansSerif
          , fontFamilies ["Open Sans"]
          , CSSG.descendants
              [ CSSG.typeSelector "a"
                  [ color (rgb 51 255 255) ]
              ]
          ]
        , CSSG.class "logo"
            [ Css.width (px 467)
            , Css.height (px 77)
            , marginTop (px 33)
            , marginBottom (px 33)
            , position absolute
            , backgroundImage (url "img/nolan-logo.png")
            ]
        , CSSG.typeSelector "nav"
            [ marginTop (px 71)
            , CSSG.descendants
                [ CSSG.typeSelector "a"
                    [ fontSize (px 18)
                    , color (rgb 51 255 255)
                    ]
                , CSSG.typeSelector "ul"
                    [ CSSG.descendants
                        [ CSSG.typeSelector "li"
                            [ display inlineBlock
                            , marginRight (px 32)
                            ]
                        ]
                    ]
                ]
            , position absolute
            ]
      ]
