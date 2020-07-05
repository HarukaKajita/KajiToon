#ifndef KAJITOON
  #define KAJITOON
  #include "KajiToonStructures.cginc"
  #include "AutoLight.cginc"
  
  sampler2D _MainTex;
  float4 _MainTex_ST;
  sampler2D _BumpMap;
  float4 _BumpMap_ST;
  float4 _Color;
  
  fragIn vert(appdata v)
  {
    fragIn o;
    UNITY_INITIALIZE_OUTPUT(fragIn, o);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);
    o.uv1 = v.uv1;
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.tangent = UnityObjectToWorldNormal(normalize(v.tangent.xyz));
    o.binormal = normalize(cross(o.normal, o.tangent) * v.tangent.w);
    #ifdef _FORWARDBASE
      o.ambient = VertexGIForward(mul(unity_ObjectToWorld, v.vertex), o.normal);
    #endif
    UNITY_TRANSFER_FOG(o, o.vertex);
    UNITY_TRANSFER_LIGHTING(o, v.uv1);
    return o;
  }
  
  fixed4 frag(fragIn i, bool isFrontFace: SV_ISFRONTFACE): SV_Target
  {
    //normal
    float3 geomNormal = normalize(i.normal) * (isFrontFace? 1: - 1);
    float3 tangent = normalize(i.tangent);
    float3 binormal = normalize(i.binormal);
    float3x3 worldToTangent = float3x3(tangent, binormal, geomNormal);
    //pos
    float3 worldPos = i.worldPos;
    //dir
    float3 normal = mul(UnpackNormal(tex2D(_BumpMap, i.uv0)), worldToTangent);
    float3 lDir = normalize(UnityWorldSpaceLightDir(worldPos));
    float3 vDir = normalize(UnityWorldSpaceViewDir(worldPos));
    float3 rDir = normalize(reflect(-vDir, normal));
    //value    
    float NdotL = dot(normal, lDir);
    float NdotV = dot(normal, vDir);
    float RdotL = dot(rDir, lDir);

    //color
    fixed4 albedo = tex2D(_MainTex, i.uv0);
    fixed4 col = albedo;
    #ifdef _FORWARDBASE
      float3 ambient = ShadeSHPerPixel(normal, i.ambient, wPos);
    #endif
    UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
    col *= atten;
    UNITY_APPLY_FOG(i.fogCoord, col);
    return col;
  }
  
  //Shadow Pass
  fragIn_shadow vert_shadow(appdata_base v)
  {
    fragIn_shadow o;
    o.pos = UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
    o.pos = UnityApplyLinearShadowBias(o.pos);
    #ifdef _TRANSPARENT
      o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
    #endif
    return o;
  }
  
  // in
  #ifdef _TRANSPARENT
    sampler3D   _DitherMaskLOD;
  #endif
  
  float4 frag_shadow(fragIn_shadow i): SV_Target
  {
    #ifdef _TRANSPARENT
      float alpha = tex2D(_MainTex, i.uv).a * _BaseColor.a;
      half alphaRef = tex3D(_DitherMaskLOD, float3(i.pos.xy * 0.25, alpha * 0.9375)).a;
      clip(alphaRef - 0.01);
    #endif
    return 0;
  }
#endif