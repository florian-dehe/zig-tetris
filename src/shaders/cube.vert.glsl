#version 330 core
layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec2 vTexCoord;

out vec2 fTexCoord;

uniform mat4 uMVP;

void main() {
    fTexCoord = vTexCoord;
    gl_Position = uMVP * vec4(vPosition, 1.0);
}
