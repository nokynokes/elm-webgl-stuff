module Components.Shaders.VHS exposing (..)

import WebGL exposing (..)
import WebGL.Texture
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)

type alias Vertex =
    { position : Vec3
    }


type alias Uniforms =
  { iResolution : Vec3
   , iGlobalTime : Float
  , iChannel0 : WebGL.Texture }

type alias Varying =
  { vFragCoord : Vec2 }

vert : Shader Vertex Uniforms Varying
vert =
  [glsl|
        precision mediump float;
        attribute vec3 position;
        varying vec2 vFragCoord;
        uniform vec3 iResolution;
        void main () {
            gl_Position = vec4(position, 1.0);
            vFragCoord = position.xy;
        }
    |]

frag : Shader {} Uniforms Varying
frag =
  [glsl|
        precision mediump float;
        varying vec2 vFragCoord;
        uniform float iGlobalTime;
        uniform vec3 iResolution;
        uniform sampler2D iChannel0;




        void mainImage(out vec4 fragColor, in vec2 fragCoord){
            float amount = sin(iGlobalTime) * 0.1;

            // uv coords
            vec2 uv = fragCoord / iResolution.xy;

            amount *= 0.3;
            float split = 1. - fract(iGlobalTime / 2.);
            float scanOffset = 0.01;
            vec2 uv1 = vec2(uv.x + amount, uv.y);
            vec2 uv2 = vec2(uv.x, uv.y + amount);
            if (uv.y > split) {
                uv.x += scanOffset;
                uv1.x += scanOffset;
                uv2.x += scanOffset;
            }

            float r = texture(iChannel0, uv1).r;
            float g = texture(iChannel0, uv).g;
            float b = texture(iChannel0, uv2).b;

            fragColor = vec4(r, g, b, 1.);

            // without
            //fragColor = texture(iChannel0, uv);

            // debug variation
            //fragColor = vec4(abs(var.x)*100., abs(var.y)*100., 0., 1.);
        }

        void main(){
          mainImage(gl_FragColor, vFragCoord);
        } |]
