#version 330 core
in vec2 fTexCoord;

out vec4 outColor;

uniform vec3 uColor = vec3(1.0, 1.0, 1.0);
uniform sampler2D uTex;

void main() {
    outColor = texture(uTex, fTexCoord) * vec4(uColor, 1.0);
}
