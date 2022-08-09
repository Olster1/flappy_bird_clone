cbuffer constants : register(b0)
{
    float4x4 orthoMatrix;
};

struct VS_Input {
    float3 pos : POS;
    float2 uv : TEX;
    float3 pos1 : POS_INSTANCE;
    float2 scale1 : SCALE_INSTANCE;
    float4 color1 : COLOR_INSTANCE;
    float4 uv1 : TEXCOORD_INSTANCE;
    float texture_array_index: TEX_ARRAY_INDEX;

};

struct VS_Output {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD;
    float4 color : COLOR;
    float texture_array_index: TEX_ARRAY_INDEX;
};

//Texture2D    mytexture : register(t0);
Texture2DArray mytexture : register(t0);
SamplerState mysampler : register(s0);


VS_Output vs_main(VS_Input input)
{
    VS_Output output;

    // output.pos = float4(input.pos + instance_input.pos1, 0.0f, 1.0f);
    // output.uv.x = lerp(instance_input.uv1.x, instance_input.uv1.y, input.uv.x);
    // output.uv.y = lerp(instance_input.uv1.z, instance_input.uv1.w, input.uv.y);

    float3 pos = input.pos;

    pos.x *= input.scale1.x;
    pos.y *= input.scale1.y;

    pos += input.pos1;

    output.pos = mul(orthoMatrix, float4(pos, 1.0f));

    //output.pos = float4(input.pos.x, input.pos.y, 0, 1.0f);
    output.uv = input.uv;
    output.color = input.color1;//float4(1, 0, 0, 0);
    output.texture_array_index = input.texture_array_index;
    return output;
}

float4 ps_main(VS_Output input) : SV_Target
{
    // float smoothing = 0.3f;
    float4 sample = mytexture.Sample(mysampler, float3(input.uv, input.texture_array_index)); 

    // float alpha = result.w;
    // alpha = smoothstep(0.5f, 0.5f + smoothing, alpha);

    // float4 c = result;
    // c.a = alpha;
    // if(c.a <= 0.2f) discard;

    return sample*input.color;
    
}
