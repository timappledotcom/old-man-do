import sys
from PIL import Image, ImageDraw

def process_icon(input_path, output_path):
    print(f"Processing {input_path}...")
    img = Image.open(input_path).convert("RGBA")
    width, height = img.size
    
    # Create a mask for the circular area
    # Assuming the "circle" the user mentions fills the image or is centered
    # But user said "remove white from outside of the circle". 
    # If the image IS the circle on a white square background, simple color replacement might be risky if there is white INSIDE.
    # Safe bet: Flood fill from (0,0) if it is white.
    
    datas = img.getdata()
    newData = []
    
    # Simple threshold strategy first?
    # Or flood fill? 
    # Let's try to detect if it's a white background.
    
    # Strategy: Create a new image with transparent background
    # Draw a circle on a mask.
    # Composite.
    
    # Actually, if the user explicitly said "remove white from OUTSIDE of the circle", 
    # it implies the shape is circular.
    # Let's just crop it to a circle. That ensures "outside" is gone.
    
    mask = Image.new('L', (width, height), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, width, height), fill=255)
    
    # Create a white image to check against? No, just apply circular mask to alpha?
    # But wait, if the source has white corners, the circular mask will cut them off.
    # What if the circle in the image is smaller than the full bounds?
    # Let's assume the icon takes up the full square and we just want to round it?
    # No, "remove the white from the outside".
    
    # Let's try flood filling from the corners with transparency.
    # This respects the actual shape of the "circle" in the image.
    
    # Image.floodfill is not directly available in basic PIL without some work or ImageDraw.floodfill (in newer versions)
    # Let's use a simple distance-based transparency for white pixels?
    # No, that makes inside white transparent too.
    
    # Let's try the ImageDraw.floodfill method on the alpha channel.
    # We will create a mask that is white everywhere, then flood fill black from corners.
    
    # 1. Create a mask initialized to White (255)
    # 2. Threshold the image to find "White" pixels.
    #    Pixels that are WHITE in the original image will be candidates for transparency.
    
    # Better approach given the tools:
    # 1. Check if corners are white.
    # 2. If so, make them transparent.
    
    from collections import deque
    
    # load pixel data
    pixels = img.load()
    
    # queue for flood fill
    q = deque()
    
    # Check corners
    starts = [(0, 0), (width-1, 0), (0, height-1), (width-1, height-1)]
    
    visited = set()
    
    # Threshold for "White"
    threshold = 240
    
    for start in starts:
        x, y = start
        r, g, b, a = pixels[x, y]
        if r > threshold and g > threshold and b > threshold:
            q.append(start)
            visited.add(start)
    
    if not q:
        print("Corners are not white. attempting circular crop instead.")
        # Fallback to circular mask
        mask = Image.new('L', (width, height), 0)
        draw = ImageDraw.Draw(mask)
        draw.ellipse((0, 0, width, height), fill=255)
        img.putalpha(mask)
    else:
        print("Flood filling white background...")
        while q:
            x, y = q.popleft()
            pixels[x, y] = (255, 255, 255, 0) # Make Transparent
            
            # Check neighbors
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                nx, ny = x + dx, y + dy
                if 0 <= nx < width and 0 <= ny < height:
                    if (nx, ny) not in visited:
                        r, g, b, a = pixels[nx, ny]
                        # If neighbor is whiteish
                        if r > threshold and g > threshold and b > threshold:
                            visited.add((nx, ny))
                            q.append((nx, ny))
                            
    img.save(output_path, "PNG")
    print(f"Saved to {output_path}")

if __name__ == "__main__":
    process_icon("old_man_do/icon.png", "old_man_do/assets/icon_transparent.png")
