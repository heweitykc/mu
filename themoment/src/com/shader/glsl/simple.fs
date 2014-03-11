in vec3 out_texcoord;
void main()
{
   gl_FragColor = vec4(out_texcoord.xyz,1);
}