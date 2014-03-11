in vec3 position;
in vec3 texcoord;
out vec2 out_texcoord;
uniform mat4x4 m;
void main()
{
 gl_Position = m * vec4(position.xyz, 1.0);
  out_texcoord = texcoord.xy;
}