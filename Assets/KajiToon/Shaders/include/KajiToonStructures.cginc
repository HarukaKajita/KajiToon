#ifndef KAJITOON_STRUCTURES
  #define KAJITOON_STRUCTURES
  #include "AutoLight.cginc"
  struct appdata
  {
    float4 vertex: POSITION;
    float2 uv0: TEXCOORD0;
    float2 uv1: TEXCOORD1;
    float3 normal: NORMAL;
    float4 tangent: TANGENT;
  };
  
  struct fragIn
  {
    float4 pos: SV_POSITION;
    float2 uv0: TEXCOORD0;
    float2 uv1: TEXCOORD1;
    float3 worldPos: WORLDPOS;
    float3 normal: NORMAL;
    float3 tangent: TANGENT;
    float3 binormal: BINORMAL;
    #ifdef FORWARDBASE
      float3 ambient: AMBIENT;
    #endif
    UNITY_FOG_COORDS(1)
    UNITY_LIGHTING_COORDS(3, 4)
  };

  struct fragIn_shadow
  {
    float4 pos: SV_POSITION;
    #ifdef _TRANSPARENT
      float2 uv: TEXCOORD0;
    #endif
  };
#endif