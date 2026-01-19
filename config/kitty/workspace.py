import json
import sys

from kittens.tui.handler import kitten_ui


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    title = args[1]
    # get the result of running kitten @ ls
    cp = main.remote_control(
        ['ls'], capture_output=True)
    if cp.returncode != 0:
        sys.stderr.buffer.write(cp.stderr)
        raise SystemExit(cp.returncode)
    output = json.loads(cp.stdout)
    with open('/tmp/test', 'w') as f:
        f.write(json.dumps(output))
    # open a new tab with a title specified by the user
    for w in output:
        for t in w["tabs"]:
            if t["title"] == title:
                break
        else:
            continue
        break
    else:
        main.remote_control(
            ['launch', '--type=tab', '--tab-title', title], check=True)
    main.remote_control(['focus-tab', '--match', 'title:'+title], check=True)

    return ""
