Shader "Custom/RobSand" {
	Properties {
		_Color ("BaseColor", Color) = (1,1,1,1)
		_NoiseColor ("NoiseColor", Color) = (1,1,1,1)
		_NoiseTex ("NoiseTex", 2D) = "white" {}

		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		fixed4 _NoiseColor;
		sampler2D _NoiseTex;
		sampler2D _MainTex;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
//			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
//			o.Albedo = c.rgb;

			fixed4 albedoColor = _Color.rgba;

			o.Albedo = albedoColor;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
