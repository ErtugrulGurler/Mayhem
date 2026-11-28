#!/usr/bin/env python3
"""Godot 4.7.2 verification runner for Linux. Uses isolated XDG save/config paths."""
import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument("--godot", default="godot")
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
evidence = root / "docs/evidence"
evidence.mkdir(exist_ok=True)
suites = [
    ("import", ["--editor", "--import", "--quit"]),
    ("startup", ["--quit-after", "180"]),
    ("session_rules", ["--script", "tests/session_rules_smoke.gd"]),
    ("systems", ["--script", "tests/p0/systems_test.gd"]),
    ("loop", ["--script", "tests/p0/loop_test.gd"]),
    ("scene", ["--script", "tests/p0/scene_test.gd"]),
    ("tutorial", ["--script", "tests/ux/tutorial_test.gd"]),
    ("layout", ["--script", "tests/ux/layout_test.gd"]),
    ("pointer", ["--script", "tests/ux/pointer_test.gd"]),
    ("menu_navigation", ["--script", "tests/menu/navigation_test.gd"]),
    ("menu_layout", ["--script", "tests/menu/layout_test.gd"]),
    ("menu_pointer", ["--script", "tests/menu/pointer_test.gd"]),
    ("pip_runs", ["--script", "tests/pip/run_comparison.gd"]),
    ("pip_animation", ["--script", "tests/pip/session_animation.gd"]),
    ("legacy_smoke", ["--script", "tests/smoke_test.gd"]),
    ("legacy_combat", ["--script", "tests/combat_test.gd"]),
]
results = []
with tempfile.TemporaryDirectory(prefix="mayhem-tests-") as temp:
    env = os.environ.copy()
    for key, folder in [("XDG_DATA_HOME", "data"), ("XDG_CONFIG_HOME", "config"), ("XDG_CACHE_HOME", "cache")]:
        env[key] = str(Path(temp) / folder)
        Path(env[key]).mkdir()
    version = subprocess.run([args.godot, "--version"], env=env, text=True, capture_output=True, check=True).stdout.strip()
    if not version.startswith("4.7.2."):
        raise SystemExit("Expected Godot 4.7.2, found: " + version)
    for name, flags in suites:
        command = [args.godot, "--headless", "--path", str(root), *flags]
        result = subprocess.run(command, cwd=root, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=120)
        log = re.sub(r"\x1b\[[0-9;]*m", "", result.stdout)
        (evidence / (name + ".txt")).write_text(log)
        passed = result.returncode == 0 and "ERROR:" not in log and "SCRIPT ERROR" not in log
        results.append({"name": name, "engine": version, "command": ["godot", "--headless", "--path", ".", *flags], "exit_code": result.returncode, "passed": passed})
        print(name, "PASS" if passed else "FAIL", "exit", result.returncode, flush=True)
        if not passed:
            print(log, flush=True)
(evidence / "commands.json").write_text(json.dumps(results, indent=2))
raise SystemExit(0 if all(item["passed"] for item in results) else 1)
