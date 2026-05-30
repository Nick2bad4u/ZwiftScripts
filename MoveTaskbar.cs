using System;
using System.Runtime.InteropServices;
using System.Threading;

class Program
{
    [DllImport("user32.dll")]
    static extern void mouse_event(uint dwFlags, int dx, int dy, uint dwData, int dwExtraInfo);

    const uint MOUSEEVENTF_LEFTDOWN = 0x02;
    const uint MOUSEEVENTF_LEFTUP = 0x04;
    const uint MOUSEEVENTF_MOVE = 0x01;

    static void Main()
    {
        // Move to taskbar position (adjust coordinates as needed)
        int taskbarX = 100, taskbarY = 1079;
        SetCursorPos(taskbarX, taskbarY);

        // Simulate mouse click and hold
        mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);

        // Drag to new position (adjust coordinates as needed)
        int newX = 500, newY = 1079;
        for (int i = 0; i < 100; i++)
        {
            SetCursorPos(taskbarX + (newX - taskbarX) * i / 100, taskbarY);
            Thread.Sleep(10); // Adjust speed of drag
        }

        // Release mouse click
        mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    }

    [DllImport("user32.dll")]
    static extern bool SetCursorPos(int X, int Y);
}
