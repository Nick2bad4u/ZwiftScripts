import pyautogui
import time

# Move to the taskbar location (adjust coordinates as needed)
taskbar_x, taskbar_y = 100, 1079  # Example coordinates for the bottom-left corner
pyautogui.moveTo(taskbar_x, taskbar_y)

# Simulate mouse click and hold
pyautogui.mouseDown()

# Drag the taskbar to a new position (adjust coordinates as needed)
new_x, new_y = 500, 1079
pyautogui.moveTo(new_x, new_y, duration=1)  # Drag over 1 second

# Release the mouse click
pyautogui.mouseUp()
