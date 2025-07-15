float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfTriangle(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v1, s, d);
    d = seg(p, v1, v2, s, d);
    d = seg(p, v2, v0, s, d);

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    // Conditions using step
    float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x < b.x && a.y > b.y
    float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x > b.x && a.y < b.y

    // If neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}
float ease(float x) {
    return pow(1.0 - x, 3.0);
}
vec4 saturate(vec4 color, float factor) {
    float gray = dot(color, vec4(0.299, 0.587, 0.114, 0.)); // luminance
    return mix(vec4(gray), color, factor);
}

vec4 TRAIL_COLOR = iCurrentCursorColor;
const float OPACITY = 0.3;
const float DURATION = 0.3; //IN SECONDS
const float FADE_DURATION = 0.3;
const float MAX_TRAIL_LENGTH = 0.4;
const float TRAIL_HEIGHT_FACTOR = 0.4;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif
    // Normalization for fragCoord to a space of -1 to 1;
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    // Normalization for cursor position and size;
    // cursor xy has the postion in a space of -1 to 1;
    // zw has the width and height
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    // Calculate time since last cursor move for fade effect
    float timeSinceMove = iTime - iTimeCursorChange;

    // When drawing between cursors for the trail we need to determine the direction
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;
    
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    
    // Calculate the center point of the previous cursor
    vec2 prevCursorCenter = previousCursor.xy - (previousCursor.zw * offsetFactor);
    
    // Calculate direction vector from current to previous cursor
    vec2 directionVector = centerCP - centerCC;
    vec2 direction = length(directionVector) > 0.0 ? directionVector / length(directionVector) : vec2(0.0);
    float lineLength = distance(centerCC, centerCP);
    
    // Cap the line length and adjust the trail start point
    float cappedlinelength = min(lineLength, MAX_TRAIL_LENGTH);
    vec2 trailStartPoint;
    
    // If the distance exceeds MAX_TRAIL_LENGTH, use the point at MAX_TRAIL_LENGTH distance instead
    if (lineLength > MAX_TRAIL_LENGTH) {
        trailStartPoint = centerCC + direction * MAX_TRAIL_LENGTH;
    } else {
        trailStartPoint = prevCursorCenter;
    }
    
    // Calculate cursor center for thinner trail
    vec2 cursorCenter = currentCursor.xy - (currentCursor.zw * offsetFactor);
    float reducedHeight = currentCursor.w * TRAIL_HEIGHT_FACTOR;
    
    // Set vertices for a thinner trail (reduced height)
    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, cursorCenter.y - reducedHeight * 0.5);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, cursorCenter.y + reducedHeight * 0.5);
    
    // This creates the triangular shape with the point at the trail cutoff
    vec2 v2 = trailStartPoint;

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfTrail = getSdfTriangle(vu, v0, v1, v2);

    // Separate progress calculations for trail animation and fade
    float progress = clamp(timeSinceMove / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);
    
    float fadeProgress = clamp(timeSinceMove / FADE_DURATION, 0.0, 1.0);
    float easedFadeProgress = ease(fadeProgress);
    
    // Calculate fade-in opacity (starts at OPACITY, fades to 0)
    float fadeOpacity = (1.0 - easedFadeProgress) * OPACITY;

    vec4 newColor = vec4(fragColor);

    vec4 trail = TRAIL_COLOR;
    trail = saturate(trail, 2.5);
    trail.a *= fadeOpacity; // Apply fading transparency to the trail
    
    // Draw trail with fading transparency
    float trailMask = antialising(sdfTrail);
    newColor = mix(newColor, trail, trailMask * fadeOpacity);
    
    // Draw current cursor
    newColor = mix(newColor, trail, antialising(sdfCurrentCursor));
    newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));
    
    // Apply the trail effect with fading transparency
    fragColor = mix(fragColor, newColor, step(sdfCurrentCursor, easedProgress * cappedlinelength) * fadeOpacity);
}
