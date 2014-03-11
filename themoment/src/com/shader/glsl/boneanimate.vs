in vec3 position;
in vec3 texcoord;

out vec2 out_texcoord;
uniform mat4x4 m;
uniform vec4 boneData[120];

void main()
{
 	vec4 a = boneData[int(texcoord.z)];
	float dSY = sin(a.z * 0.5);
	float dSP = sin(a.y * 0.5);
	float dSR = sin(a.x * 0.5);
	float dCY = cos(a.z * 0.5);
	float dCP = cos(a.y * 0.5);
	float dCR = cos(a.x * 0.5);

    vec4 quat;
	quat.x = dSR * dCP * dCY - dCR * dSP * dSY;
	quat.y = dCR * dSP * dCY + dSR * dCP * dSY;
	quat.z = dCR * dCP * dSY - dSR * dSP * dCY;
	quat.w = dCR * dCP * dCY + dSR * dSP * dSY;

	float m00 = 1.0 - 2.0 * quat.y * quat.y - 2.0 * quat.z * quat.z;
	float m01 = 2.0 * quat.x * quat.y - 2.0 * quat.w * quat.z;
	float m02 = 2.0 * quat.x * quat.z + 2.0 * quat.w * quat.y;
	float m03 = 0;
	
	float m10 = 2.0 * quat.x * quat.y + 2.0 * quat.w * quat.z;
	float m11 = 1.0 - 2.0 * quat.x * quat.x - 2.0 * quat.z * quat.z;
	float m12 = 2.0 * quat.y * quat.z - 2.0 * quat.w * quat.x;
	float m13 = 0;
	
	float m20 = 2.0 * quat.x * quat.z - 2.0 * quat.w * quat.y;
	float m21 = 2.0 * quat.y * quat.z + 2.0 * quat.w * quat.x;
	float m22 = 1.0 - 2.0 * quat.x * quat.x - 2.0 * quat.y * quat.y;
	float m23 = 0;

	vec3 result;
	result.x = position.x * m00 + position.y * m01 + position.z * m02 + m03;
	result.y = position.x * m10 + position.y * m11 + position.z * m12 + m13;
	result.z = position.x * m20 + position.y * m21 + position.z * m22 + m23;
			
 	a = boneData[int(texcoord.z+1)];
 	vec3 pos = a.xyz;
	pos.x = pos.x+result.x;
	pos.y = pos.y+result.y;
	pos.z = pos.z+result.z;
 
 	gl_Position = m * vec4(pos.xyz, 1.0);
  	out_texcoord = texcoord.xy;
}