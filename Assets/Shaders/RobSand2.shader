// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/RobSand2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}

		_Color ("BaseColor", Color) = (1,1,1,1)
		_NoiseColor ("NoiseColor", Color) = (1,1,1,1)
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Lum("Lum", float) = 1
		_RaySize("Ray Size", Range(0, 1)) = 0.5
		_raySmoother("Ray Smoother", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 uv_NoiseTex : TEXCOORD1;
				float4 vertex : SV_POSITION;
				float4 screenUV : TEXCOORD3;
				float3 worldpos : TEXCOORD2;
			};

			sampler2D _MainTex;
			sampler2D _NoiseTex;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _NoiseColor;
			float _Lum;
			float _RaySize;
			float _raySmoother;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldpos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.screenUV = ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col;

				fixed4 noise = tex2D(_NoiseTex, i.uv);

    			col = lerp(_Color, _NoiseColor, noise) * _Lum;



    			//TODO Unpack normal


//    			fixed4 screenSpaceLight = ComputeScreenPos(_WorldSpaceLightPos0);

    			//VertexScreenSpace
    			float2 screenUV = i.screenUV.xy / i.screenUV.w;
    			//LightScreenSpace
//    			float2 lightScreenUV = screenSpaceLight.xy / screenSpaceLight.w;


				//Distance between pixel and light source in X axis
//					float pixelDistance = screenUV.x - screenSpaceLight.x;
				float pixelDistance = abs(screenUV.x - 0.5);

				//TODO remplacer la verticalité par le ZBuffer
				float rayByVeticality = _RaySize * (-screenUV.y + 1);
//				float rayByVeticality = _RaySize * (_WorldSPaceCameraPos.z - i.screenUV.w);

				//Creation du masque
				float shouldRay = smoothstep(rayByVeticality, rayByVeticality + _raySmoother, pixelDistance);


				return col * shouldRay;
			}
			ENDCG
		}
	}
}
