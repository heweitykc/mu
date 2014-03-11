in vec3 position;
in vec3 texcoord;
out vec3 out_texcoord;
uniform mat4x4 m;
void main()
{
  vec3 newpo = position * 2;

  gl_Position = m * vec4(newpo.xyz, 1.0);
  out_texcoord = texcoord;
}
