import json
import sys

from kittens.tui.handler import kitten_ui


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    target = args[1]
    cp = main.remote_control(
        ['ls'], capture_output=True)
    if cp.returncode != 0:
        sys.stderr.buffer.write(cp.stderr)
        raise SystemExit(cp.returncode)
    output = json.loads(cp.stdout)
    # find tab which title is args[1]
    for w in output:
        for t in w["tabs"]:
            tabname = t["title"]
            if tabname == target:
                break
        else:
            continue
        break
    else:
        # if tab is not exists, create new tab
        main.remote_control(
            ['launch', '--type=tab', '--tab-title', target], check=True)

    # focus
    main.remote_control(['focus-tab', '--match', 'title:'+target], check=True)
    return ""
