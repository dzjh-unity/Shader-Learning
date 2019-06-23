// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'


Shader "Unity Shaders Custom/DiffuseFrag"
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
                fixed3 worldNormal : TEXCOORD0;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                return o;
            }

            // fixed4 frag(v2f i) : SV_Target {
            //     fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
            //     fixed3 worldNormal = normalize(i.worldNormal); // 归一化
            //     fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
            //     fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir)); // saturate防止点击结果为负值
            //     fixed3 color = ambient + diffuse;
            //     return fixed4(color, 1.0);
            // }
            
            // 半兰伯特模型
            fixed4 frag(v2f i) : SV_Target {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldNormal = normalize(i.worldNormal); // 归一化
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert; // saturate防止点击结果为负值
                fixed3 color = ambient + diffuse;
                return fixed4(color, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}