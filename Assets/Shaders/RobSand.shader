Shader "RobSand" {
    Properties {
        _Color ("BaseColor", Color) = (1,1,1,1)
		_NoiseColor ("NoiseColor", Color) = (1,1,1,1)
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Lum("Lum", float) = 1

		_BumpMap("Bump map",  2D) = "bump" {}

		_Dist("RayRange", Range(0.1, 20)) = 1

		_RaySize("Ray Size", Range(0, 1)) = 0.5
		_raySmoother("Ray Smoother", Range(0, 1)) = 0.5

		_MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader {

    Tags { "RenderType" = "Opaque" }

    CGPROGRAM
    #pragma surface surf WrapLambert vertex:vert
    #pragma multi_compile_ForwardBase
    #pragma 
    #include "UnityCG.cginc"

//    half4 LightingWrapLambert (SurfaceOutput s, half3 lightDir, half atten) {
////        half NdotL = dot (s.Normal, lightDir);
////        half diff = NdotL * 0.5 + 0.5;
////        half4 c;
////        c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
////        c.a = s.Alpha;
////        return c;
//
//
//
//		half4 c;
//		c.rgb = s.Albedo * _LightColor0.rgb + sin(_Time.y * 5);
//		return c;
//
//    }

	half4 LightingWrapLambert (SurfaceOutput s, half3 lightDir, half3 viewDir, half3 atten)//, sampler2D _NoiseTex, float2 uv_NoiseTex)
	{
        half NdotL = dot (s.Normal, lightDir);
        half diff = NdotL * 0.5 + 0.5;
        half4 c;
        c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
        c.a = s.Alpha;

//        half LdotV = dot (viewDir, lightDir);
//
//        half NL_LV = NdotL * LdotV;


//        fixed3 col = tex2D(_NoiseTex, uv_NoiseTex).rgb;
//
//        c.rgb *= col.rgb;

//		c = lerp(col, float3(0,0,0), s.Specular);

//        return c * NL_LV;// + s.Specular/2;


//		half LdotV = dot (lightDir, viewDir);
//
//		half surfProduct = NdotL * LdotV;
//
//		return lerp(half4(1,1,1,1), half4(0,0,0,1), surfProduct);


//		half4 screenSpaceLight = mul(UNITY_MATRIX_MVP, _WorldSpaceLightPos0);

//		c = (c + s.Specular) * (step(_Dist, x));

		return c;

	}



    struct Input
    {
	    float4 vertex : POSITION;
        float2 uv_MainTex;
        float2 uv_NoiseTex;
        float2 uv_BumpMap;
        float2 uv : TEXCOORD0;
        float4 screenUV : TEXCOORD2;
    };

    sampler2D _MainTex;
    sampler2D _NoiseTex;
    fixed4 _Color;
    fixed4 _NoiseColor;
    float _Lum;
    sampler2D _BumpMap;
    float _Dist;
    float4 screenUV;
	float _RaySize;
	float _raySmoother;

    Input vert (inout appdata_full v)
    {
    	Input o;
    	o.screenUV = ComputeScreenPos(v.vertex);

    	o.vertex = UnityObjectToClipPos(v.vertex);
//		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

    	return o;
    }

    void surf (Input IN, inout SurfaceOutput o)
    {

    	fixed4 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);

    	o.Albedo = lerp(_Color, _NoiseColor, noise) * _Lum;

    	o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));

		o.Specular = noise;

//		o.Emission = noise;


		fixed4 col;

//    			col = lerp(_Color, _NoiseColor, noise) * _Lum;
//
//    			//VertexScreenSpace
//    			float2 screenUV = IN.screenUV.xy / IN.screenUV.w;
//    			//LightScreenSpace
////    			float2 lightScreenUV = screenSpaceLight.xy / screenSpaceLight.w;
//
//
//				//Distance between pixel and light source in X axis
////					float pixelDistance = screenUV.x - screenSpaceLight.x;
//				float pixelDistance = abs(screenUV.x - 0.5);
//
//				//TODO remplacer la verticalité par le ZBuffer
//				float rayByVeticality = _RaySize * (-screenUV.y + 1);
////				float rayByVeticality = _RaySize * (_WorldSPaceCameraPos.z - i.screenUV.w);
//
//				//Creation du masque
//				float shouldRay = smoothstep(rayByVeticality, rayByVeticality + _raySmoother, pixelDistance);


//				o.Emission = col * shouldRay;

    }
    ENDCG
    }
    Fallback "Diffuse"
}