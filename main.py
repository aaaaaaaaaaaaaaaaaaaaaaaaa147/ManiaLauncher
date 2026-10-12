"""ManiaLauncher entry point. Run with: python main.py"""
import sys
import tkinter as tk
from tkinter import messagebox
from mania.config import Config
from mania.ui import LauncherUI


def main():
    app = tk.Tk()
    try:
        LauncherUI(app, Config())
    except Exception as error:
        messagebox.showerror('Falha ao iniciar ManiaLauncher', str(error), parent=app)
        app.destroy()
        return 1
    app.mainloop()
    return 0


if __name__ == '__main__':
    sys.exit(main())
