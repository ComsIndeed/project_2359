from PIL import Image
import os

# Paths
input_path = r"c:\Users\Truly\AAA_WORKSPACE_WINDOWS\_AAA_MAIN\project_2359\apps\project_2359_flutter\assets\app_icon.png"
output_dir = r"c:\Users\Truly\AAA_WORKSPACE_WINDOWS\_AAA_MAIN\project_2359\apps\project-2359\assets\images"

# Load the image
img = Image.open(input_path).convert("RGBA")
pixels = img.load()
width, height = img.size

# The icon has a pure black background (#000000)
# We need to make the background transparent while keeping the icon's internal colors
# Looking at the icon: it has white/gray shapes on a black background
# The black background is pure black (0,0,0), the icon's details include grays and whites

# Strategy: Replace pure black pixels at the edges/background with transparent
# We'll use flood fill from corners to detect connected black regions

from collections import deque

# Create a mask for what to make transparent
transparent_mask = Image.new("L", (width, height), 0)
mask_pixels = transparent_mask.load()

# Flood fill from corners to find the background
# Pure black threshold - background is (0,0,0)
def is_background_black(pixel):
    r, g, b, a = pixel
    # Pure black or very close to pure black
    return r <= 5 and g <= 5 and b <= 5

# BFS flood fill from edges
visited = set()
queue = deque()

# Add all edge pixels that are black
for x in range(width):
    if is_background_black(pixels[x, 0]):
        queue.append((x, 0))
    if is_background_black(pixels[x, height-1]):
        queue.append((x, height-1))
        
for y in range(height):
    if is_background_black(pixels[0, y]):
        queue.append((0, y))
    if is_background_black(pixels[width-1, y]):
        queue.append((width-1, y))

# Flood fill
while queue:
    x, y = queue.popleft()
    if (x, y) in visited:
        continue
    if x < 0 or x >= width or y < 0 or y >= height:
        continue
    
    pixel = pixels[x, y]
    if not is_background_black(pixel):
        continue
    
    visited.add((x, y))
    mask_pixels[x, y] = 255  # Mark for transparency
    
    # Add neighbors
    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        nx, ny = x + dx, y + dy
        if 0 <= nx < width and 0 <= ny < height and (nx, ny) not in visited:
            queue.append((nx, ny))

# Apply the mask - make marked pixels transparent
result = img.copy()
result_pixels = result.load()

for y in range(height):
    for x in range(width):
        if mask_pixels[x, y] == 255:
            result_pixels[x, y] = (0, 0, 0, 0)

# Save as the main icon (with transparency for adaptive icons)
icon_transparent_path = os.path.join(output_dir, "icon-foreground.png")
result.save(icon_transparent_path, "PNG")
print(f"Saved transparent icon to: {icon_transparent_path}")

# For iOS/standard icon, we need a solid background version
# Create icon with white background for better visibility
icon_white_bg = Image.new("RGBA", (width, height), (255, 255, 255, 255))
icon_white_bg.paste(result, (0, 0), result)
icon_white_path = os.path.join(output_dir, "icon.png")
icon_white_bg.save(icon_white_path, "PNG")
print(f"Saved white bg icon to: {icon_white_path}")

# Create splash icon (transparent bg)
splash_path = os.path.join(output_dir, "splash-icon.png")
result.save(splash_path, "PNG")
print(f"Saved splash icon to: {splash_path}")

# Create Android adaptive icon foreground (transparent bg)
android_fg_path = os.path.join(output_dir, "android-icon-foreground.png")
result.save(android_fg_path, "PNG")
print(f"Saved Android foreground to: {android_fg_path}")

# Create favicon (resize to 48x48)
favicon = result.resize((48, 48), Image.Resampling.LANCZOS)
favicon_path = os.path.join(output_dir, "favicon.png")
favicon.save(favicon_path, "PNG")
print(f"Saved favicon to: {favicon_path}")

# Create a simple background for Android adaptive icon (solid color)
bg_color = (30, 30, 30, 255)  # Dark gray, not pure black
android_bg = Image.new("RGBA", (width, height), bg_color)
android_bg_path = os.path.join(output_dir, "android-icon-background.png")
android_bg.save(android_bg_path, "PNG")
print(f"Saved Android background to: {android_bg_path}")

# Create monochrome version for Android 13+
# Convert to grayscale and threshold for monochrome
gray_img = result.convert("LA")
mono = Image.new("RGBA", (width, height), (0, 0, 0, 0))
mono_pixels = mono.load()
gray_pixels = gray_img.load()
result_alpha = result.split()[3]
alpha_pixels = result_alpha.load()

for y in range(height):
    for x in range(width):
        l, a = gray_pixels[x, y]
        if alpha_pixels[x, y] > 128:  # Only process non-transparent pixels
            # Use the luminance to determine if it should be visible in monochrome
            if l > 30:  # Threshold for visibility
                mono_pixels[x, y] = (255, 255, 255, 255)

mono_path = os.path.join(output_dir, "android-icon-monochrome.png")
mono.save(mono_path, "PNG")
print(f"Saved Android monochrome to: {mono_path}")

print("\nAll icons generated successfully!")
print(f"Icon dimensions: {width}x{height}")
