from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, draw_title, ColorFormatter, as_rgb, color_as_int


tab_state = {}


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:

    global tab_state
    tab_state[tab.title] = tab.is_active
    if not is_last:
        return 0

    screen.cursor.bg = 0
    for i in range(1, 9):
        screen.cursor.x = (i-1)*2
        title = str(i)
        if title in tab_state:
            if tab_state[title]:
                screen.cursor.fg = as_rgb(color_as_int(draw_data.inactive_fg))
            else:
                screen.cursor.fg = as_rgb(color_as_int(draw_data.active_fg))
            screen.draw('●')
        else:
            screen.cursor.fg = as_rgb(color_as_int(draw_data.active_fg))
            screen.draw('○')

    tab_state.clear()
    return screen.cursor.x
