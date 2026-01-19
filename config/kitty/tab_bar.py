from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, color_as_int


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

    active_fg, inactive_fg, empty_fg = (
        as_rgb(color_as_int(draw_data.inactive_fg)),
        as_rgb(color_as_int(draw_data.active_fg)),
        as_rgb(color_as_int(draw_data.active_fg)))
    active_icon, inactive_icon, empty_icon = ('●', '●', '○')

    screen.cursor.bg = 0
    for i in range(1, 9):
        title = str(i)
        if title in tab_state:
            if tab_state[title]:
                screen.cursor.fg = active_fg
                screen.draw(active_icon)
            else:
                # empty workspace
                screen.cursor.fg = inactive_fg
                screen.draw(inactive_icon)
        else:
            # empty workspace
            screen.cursor.fg = empty_fg
            screen.draw(empty_icon)
        screen.cursor.x += 1

    tab_state.clear()
    return screen.cursor.x
