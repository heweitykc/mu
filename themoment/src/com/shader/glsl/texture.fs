in vec2 out_texcoord;
uniform sampler2D Tex1;
void main()
{
  vec4 texColor = texture(Tex1, out_texcoord);
   gl_FragColor = texColor;
}