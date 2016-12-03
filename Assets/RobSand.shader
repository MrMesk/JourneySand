Shader "RobSand" {
    Properties {
        _Color ("BaseColor", Color) = (1,1,1,1)
		_NoiseColor ("NoiseColor", Color) = (1,1,1,1)
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Lum("Lum", float) = 1

		_BumpMap("Bump map",  2D) = "bump" {}

		_MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader {

    Tags { "RenderType" = "Opaque" }

    CGPROGRAM
    #pragma surface surf WrapLambert

    half4 LightingWrapLambert (SurfaceOutput s, half3 lightDir, half atten) {
        half NdotL = dot (s.Normal, lightDir);
        half diff = NdotL * 0.5 + 0.5;
        half4 c;
        c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
        c.a = s.Alpha;
        return c;
    }

    struct Input {
        float2 uv_MainTex;
        float2 uv_NoiseTex;
         float2 uv_BumpMap;
    };
    
    sampler2D _MainTex;
    sampler2D _NoiseTex;
    fixed4 _Color;
    fixed4 _NoiseColor;
    float _Lum;

    sampler2D _BumpMap;

    void surf (Input IN, inout SurfaceOutput o) {



    	fixed3 col = tex2D(_NoiseTex, IN.uv_NoiseTex);

    	o.Albedo = lerp(_Color, _NoiseColor, col) * _Lum;

    	o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
    }
    ENDCG
    }
    Fallback "Diffuse"
}