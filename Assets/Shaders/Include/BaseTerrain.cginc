
#ifdef WIRE_FRAME
#define CORNER_COUNT 5
#else
#define CORNER_COUNT 4
#endif

uniform uint _Width;
uniform uint _Height;
uniform float4 _BBoxMin;
uniform float4 _BBoxMax;

struct appdata
{
    float4 vertex : POSITION;
};

struct gIn // OUT vertex shader, IN geometry shader
{
    uint vertexId : VERTEXID;
    uint randomId : TEXCOORD0;
};

struct v2f
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
};

//taken from http://www.reedbeta.com/blog/2013/01/12/quick-and-easy-gpu-random-numbers-in-d3d11/
//Please see also http://www.burtleburtle.net/bob/hash/integer.html
uint wang_hash(uint seed)
{
    seed = (seed ^ 61) ^ (seed >> 16);
    seed *= 9;
    seed = seed ^ (seed >> 4);
    seed *= 0x27d4eb2d;
    seed = seed ^ (seed >> 15);
    return seed;
}

gIn vert (uint id : SV_VertexID, uint inst : SV_InstanceID)
{
    gIn o;
    o.vertexId = id;
    o.randomId = wang_hash(id);
    return o;
}

float4 GetYAndNormal(float2 posIn01, float2 dxy, float3 scale)
{
    float z = GetZ(posIn01);
    const float2 halfdxy = 0.5 * dxy;
    
    // most of the cost of the terrain comes from the evaluation of this, but this calculus is done four time for each corner.
    // it should be possible to precompute this before.
    const float z00 = GetZ(posIn01 + float2(-dxy.x, -dxy.y));
    const float z01 = GetZ(posIn01 + float2(dxy.x, -dxy.y));
    const float z10 = GetZ(posIn01 + float2(-dxy.x, dxy.y));
    const float z11 = GetZ(posIn01 + float2(dxy.x, dxy.y));
    const float dzodx = 0.5 * scale.y * (z01 + z11 - z00 - z10) / (dxy.x * scale.x);
    const float dzody = 0.5 * scale.y * (z11 + z10 - z00 - z01) / (dxy.y * scale.z);
    
    const float3 baseNormal = normalize(float3(dzodx, 1, dzody));
    return float4(z, baseNormal);
    //return float4(z, 0, 1, 0);
}

void GetVertexData(uint2 vertexPosI, float2 ooWidthHeight, float3 scale, out float4 vertex, out float3 normal, out float2 uv)
{
    const float2 inUVIn01 = float2(vertexPosI.x, vertexPosI.y) * ooWidthHeight;
    const float4 vertexYAndNormal = GetYAndNormal(inUVIn01, ooWidthHeight, scale);
    const float3 vertexPos = lerp(_BBoxMin.xyz, _BBoxMax.xyz, float3(inUVIn01.x, vertexYAndNormal.x, inUVIn01.y));
    
    vertex = mul(UNITY_MATRIX_MVP, float4(vertexPos, 1));
    normal = vertexYAndNormal.yzw;
    uv = inUVIn01;
}

[maxvertexcount(CORNER_COUNT)]
#ifdef WIRE_FRAME
void geom(point gIn vert[1], inout LineStream<v2f> outputStream)
#else
void geom(point gIn vert[1], inout TriangleStream<v2f> outputStream)
#endif
{
    v2f o;
    #ifdef WIRE_FRAME
    uint2 corner[CORNER_COUNT] = {uint2(0, 0), uint2(1, 0), uint2(1, 1), uint2(0, 1), uint2(0, 0)};
    #else
    const uint2 corner[CORNER_COUNT] = {uint2(0, 0), uint2(0, 1), uint2(1, 0), uint2(1, 1)};
    #endif
    
    const uint vertexId = vert[0].vertexId;
    const uint2 posI = uint2(vertexId % _Width, vertexId / _Width);
    const float2 ooWidthHeight = 1.0 / float2(_Width, _Height);
    
    const float3 scale = _BBoxMax.xyz - _BBoxMin.xyz;
    const bool revertedQuad = vert[0].randomId % 2;
    for (uint i =0; i < CORNER_COUNT; ++i)
    {
        
        const uint2 vertexPosI = posI + (revertedQuad ? corner[i].yx : corner[i]);
        GetVertexData(vertexPosI, ooWidthHeight, scale, o.vertex, o.normal, o.uv);
        outputStream.Append(o);
    }
}

float4 frag (v2f IN) : COLOR
{
    return float4(0.5 + 0.5 * IN.normal.xyz, 1);
}
