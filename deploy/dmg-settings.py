import os

app = os.environ["KCDBAR_APP"]
background = os.environ["KCDBAR_DMG_BACKGROUND"]

files = [app]
symlinks = {"Applications": "/Applications"}

icon_locations = {
    os.path.basename(app): (
        int(os.environ["KCDBAR_APP_X"]),
        int(os.environ["KCDBAR_APP_Y"]),
    ),
    "Applications": (
        int(os.environ["KCDBAR_DROP_X"]),
        int(os.environ["KCDBAR_DROP_Y"]),
    ),
}

window_rect = ((200, 120), (640, 420))
icon_size = 128
text_size = 12
default_view = "icon-view"
show_icon_preview = False
show_status_bar = False
show_tab_view = False
show_toolbar = False
show_pathbar = False
show_sidebar = False
arrange_by = None
grid_offset = (0, 0)
grid_spacing = 100
label_pos = "bottom"
format = "UDZO"
