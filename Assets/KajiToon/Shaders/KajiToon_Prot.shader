Shader "KajiToon/Prot"
{
  Properties
  {
    _MainTex ("Texture", 2D) = "white" { }
    _Color ("Color", color) = (1, 1, 1, 1)
    _BumpMap ("Normal Map", 2D) = "Bump" { }
  }
  SubShader
  {
    Tags { "RenderType" = "Opaque" }
    LOD 100
    
    Pass
    {
      Name"FORWARD"
      Tags { "LightMode" = "ForwardBase" }
      CGPROGRAM
      
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_fog
      #pragma multi_compile_fwdbase_fullshadows
      
      #include "UnityCG.cginc"
      #include "include/KajiToon.cginc"
      ENDCG
      
    }
    
    Pass
    {
      Name "ShadowCaster"
      Tags { "LightMode" = "ShadowCaster" }
      
      ZWrite On ZTest LEqual Cull Off
      
      CGPROGRAM
      
      #pragma vertex vert_shadow
      #pragma fragment frag_shadow
      #pragma multi_compile_shadowcaster
      #include "UnityCG.cginc"
      #include "include/KajiToon.cginc"
      ENDCG
    }
  }
}
