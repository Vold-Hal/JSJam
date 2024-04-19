shader_type spatial;

void fragment() {
    // Get the world position of the fragment
    //vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1)).xyz;
    
    // Check if the fragment is above the center of the mesh
    if (1.0 > 0.0) {
        // Paint the upper half of the mesh in green
        ALBEDO = vec3(0.0, 1.0, 0.0); // Green color
    }
}