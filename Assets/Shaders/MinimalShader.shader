Shader "Custom/BruitClassique"
{
    Properties
    {
	    _NoiseSettings("Noise settings : scale xy, offset xy", Vector) = (1, 1, 0, 0)
    }
    
    SubShader
    {
        Tags
        { 
            "RenderType" = "Transparent" 
            "Queue" = "Transparent+0" 
        }

        Pass
        {
            Blend One OneMinusSrcAlpha
            Cull Off 
            Lighting Off 
            ZWrite On
            ZTest LEqual
        
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #include "Assets/Shaders/Include/snoise.cginc"

            uniform float4 _NoiseSettings;

            struct appdata
		    {
		        float4 vertex : POSITION;
		        float2 uv0 : TEXCOORD0; // En spécifiant TEXCOORD0 on indique a Unity qu'il s'agit du premier canal de texture.
		    };

            struct v2f
		    {
		        float4 vertex : POSITION;
		        float2 uv0 : TEXCOORD0; // On est obligé d'assigner une semantique a chacun des canaux. ici TEXCOORD0.
		    };

            v2f vert (appdata v)
		    {
		        v2f o;
		        o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
 				o.uv0 = (v.uv0 + _NoiseSettings.zw) * _NoiseSettings.xy;
		        return o;
		    }
            
            float4 frag (v2f IN) : COLOR
		    {
		        float noise = snoise(IN.uv0);
		        return float4(noise, 0, -noise, 1);
		    }
            ENDCG
        }
    }
}
