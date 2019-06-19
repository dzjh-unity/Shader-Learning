// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'


Shader "Unity Shaders Custom/DiffuseVert"
{
    Properties {
        // 声明一个_Color类型的属性
        _Diffuse ("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Pass {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            // 在Cg代码中，需要定义一个与属性名称和类型都匹配的变量
            fixed4 _Diffuse;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));  // 归一化
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);  // 归一化
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight)); // saturate防止点击结果为负值
                o.color = ambient + diffuse;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}