# Copyright 2026 Paras Mohandas Khanchandani Chandani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
