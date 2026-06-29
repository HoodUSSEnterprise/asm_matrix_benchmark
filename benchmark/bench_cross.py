#!/usr/bin/env python3
"""
@Author: HoodUSSEnterprise
@Date: 2026-06-29 13:48:35
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-29 13:48:56
@FilePath: \asm_matrix_benchmark\benchmark\bench_cross.py
@Description:
One-click cross-language benchmark — runs each language's example program end-to-end.

Usage:
  python benchmark/bench_cross.py                            # run all available
  python benchmark/bench_cross.py --langs python,java        # specific languages
  python benchmark/bench_cross.py --dtypes int,float         # specific data types
  python benchmark/bench_cross.py --repeat 3 --warmup 1      # custom repeat count

Output:
  - Console summary table
  - benchmark/bench_results.json
  - benchmark/bench_comparison.png  (grouped bar chart)

Extensibility: add new entries to LANGUAGES to support additional languages.
"""

import argparse
import json
import os
import shutil
import statistics
import subprocess
import sys
import time
from collections import OrderedDict
from typing import Any, Dict, List, Optional, Tuple

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
THIS_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(THIS_DIR, ".."))
BUILD_DIR = os.path.join(PROJECT_ROOT, "build")
EXAMPLE_DIR = os.path.join(PROJECT_ROOT, "example")
JAVA_SRC_DIR = os.path.join(PROJECT_ROOT, "src", "Java")
OUT_DIR = os.path.join(PROJECT_ROOT, "out")
PYTHON = sys.executable

# ---------------------------------------------------------------------------
# Language registry
# ---------------------------------------------------------------------------
# Each entry:
#   name      – display name
#   cmds      – dict[dtype] → run command (string)
#   build_cmd – optional build command (list), run once before benchmark
#
LANGUAGES: Dict[str, Dict[str, Any]] = OrderedDict(
    [
        (
            "asm",
            {
                "name": "ASM (NASM)",
                "deps": [
                    os.path.join(BUILD_DIR, "matrix_int.exe"),
                    os.path.join(BUILD_DIR, "matrix_float.exe"),
                    os.path.join(BUILD_DIR, "matrix_double.exe"),
                ],
                "cmds": {
                    "int": os.path.join(BUILD_DIR, "matrix_int.exe"),
                    "float": os.path.join(BUILD_DIR, "matrix_float.exe"),
                    "double": os.path.join(BUILD_DIR, "matrix_double.exe"),
                },
            },
        ),
        (
            "c",
            {
                "name": "C",
                "deps": [
                    os.path.join(BUILD_DIR, "matrix_intc.exe"),
                    os.path.join(BUILD_DIR, "matrix_floatc.exe"),
                    os.path.join(BUILD_DIR, "matrix_doublec.exe"),
                ],
                "cmds": {
                    "int": os.path.join(BUILD_DIR, "matrix_intc.exe"),
                    "float": os.path.join(BUILD_DIR, "matrix_floatc.exe"),
                    "double": os.path.join(BUILD_DIR, "matrix_doublec.exe"),
                },
            },
        ),
        (
            "cpp",
            {
                "name": "C++",
                "deps": [
                    os.path.join(BUILD_DIR, "matrix_intcpp.exe"),
                    os.path.join(BUILD_DIR, "matrix_floatcpp.exe"),
                    os.path.join(BUILD_DIR, "matrix_doublecpp.exe"),
                ],
                "cmds": {
                    "int": os.path.join(BUILD_DIR, "matrix_intcpp.exe"),
                    "float": os.path.join(BUILD_DIR, "matrix_floatcpp.exe"),
                    "double": os.path.join(BUILD_DIR, "matrix_doublecpp.exe"),
                },
            },
        ),
        (
            "java",
            {
                "name": "Java",
                "deps": [],  # available after compilation
                "build_cmd": None,  # lazy compilation
                "cmds": {
                    "int": "java -cp OUT_DIR;JAVA_SRC_DIR matrix_int",
                    "float": "java -cp OUT_DIR;JAVA_SRC_DIR matrix_float",
                    "double": "java -cp OUT_DIR;JAVA_SRC_DIR matrix_double",
                },
            },
        ),
        (
            "python",
            {
                "name": "Python",
                "deps": [],
                "cmds": {
                    "int": f"{PYTHON} {os.path.join(EXAMPLE_DIR, 'matrix_int.py')}",
                    "float": f"{PYTHON} {os.path.join(EXAMPLE_DIR, 'matrix_double.py')}",
                    "double": f"{PYTHON} {os.path.join(EXAMPLE_DIR, 'matrix_double.py')}",
                },
            },
        ),
    ]
)

DTYPES = ["int", "float", "double"]

# ---------------------------------------------------------------------------
# Java compilation
# ---------------------------------------------------------------------------


def build_java() -> bool:
    """Compile all .class files needed by Java examples."""
    print("  Compiling Java ...")
    # Compile library sources
    lib_sources = [
        os.path.join(JAVA_SRC_DIR, f)
        for f in [
            "MatrixInt.java",
            "MatrixFloat.java",
            "MatrixDouble.java",
            "LUResult.java",
            "Fraction.java",
        ]
    ]
    for src in lib_sources:
        if not os.path.isfile(src):
            print(f"    MISSING: {src}")
            return False
    try:
        subprocess.run(
            ["javac", "-d", JAVA_SRC_DIR] + lib_sources,
            check=True,
            capture_output=True,
            text=True,
        )
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"    javac lib failed: {e}")
        return False

    # Compile example sources
    example_sources = [
        os.path.join(EXAMPLE_DIR, f)
        for f in ["matrix_int.java", "matrix_float.java", "matrix_double.java"]
    ]
    try:
        subprocess.run(
            ["javac", "-cp", JAVA_SRC_DIR, "-d", OUT_DIR] + example_sources,
            check=True,
            capture_output=True,
            text=True,
        )
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        stderr = getattr(e, "stderr", "")
        if stderr:
            print(f"    javac example stderr: {stderr[:500]}")
        else:
            print(f"    javac example failed: {e}")
        return False

    print("    Java compiled successfully")
    return True


# ---------------------------------------------------------------------------
# Discovery
# ---------------------------------------------------------------------------


def resolve_cmd(template: str) -> str:
    """Resolve placeholders in command template."""
    return (
        template.replace("EXAMPLE_DIR", EXAMPLE_DIR)
        .replace("JAVA_SRC_DIR", JAVA_SRC_DIR)
        .replace("OUT_DIR", OUT_DIR)
    )


def discover(lang_keys: List[str]) -> Dict:
    """Return {lang_key: {dtype: cmd, ...}} available combinations."""
    available = OrderedDict()
    for key in lang_keys:
        if key not in LANGUAGES:
            continue
        info = LANGUAGES[key]
        entry = {"name": info["name"], "cmds": OrderedDict()}

        # Check dependencies
        deps_ok = all(os.path.isfile(d) for d in info.get("deps", []))

        for dt in DTYPES:
            if dt not in info.get("cmds", {}):
                continue
            cmd_template = info["cmds"][dt]
            cmd = resolve_cmd(cmd_template)

            # Check if runnable
            ok = False
            if key == "python":
                ok = True  # Python is always available
            elif key == "java":
                # Java: check if .class exists
                class_name = cmd_template.split()[-1]
                class_path = os.path.join(OUT_DIR, f"{class_name}.class")
                ok = os.path.isfile(class_path) or build_java()
            else:
                # Compiled languages: check exe directly
                ok = deps_ok and os.path.isfile(cmd)

            if ok:
                entry["cmds"][dt] = cmd

        if entry["cmds"]:
            available[key] = entry
    return available


# ---------------------------------------------------------------------------
# Run & timing
# ---------------------------------------------------------------------------


def run_program(cmd: str, timeout: float = 120) -> Optional[float]:
    """Run full program, return wall time (s), or None on failure."""
    try:
        t0 = time.perf_counter()
        subprocess.run(
            cmd,
            shell=True,
            check=True,
            timeout=timeout,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        t1 = time.perf_counter()
        return t1 - t0
    except (subprocess.CalledProcessError, FileNotFoundError, OSError) as e:
        print(f"      FAILED: {e}")
        return None


def bench_one(cmd: str, repeat: int, warmup: int) -> Optional[Dict]:
    """Benchmark a single command for N repetitions, return stats."""
    # warmup
    for _ in range(warmup):
        if run_program(cmd) is None:
            return None

    times = []
    for i in range(repeat):
        t = run_program(cmd)
        if t is None:
            return None
        times.append(t)
        print(f"      run {i + 1}/{repeat}: {t:.4f}s")

    return {
        "mean_s": statistics.mean(times),
        "stdev_s": statistics.stdev(times) if len(times) > 1 else 0.0,
        "min_s": min(times),
        "max_s": max(times),
        "raw": times,
    }


# ---------------------------------------------------------------------------
# Chart
# ---------------------------------------------------------------------------


def plot_bar(data: List[Dict], out_file: str):
    """
    Generate grouped bar chart:
      X axis = dtype (int / float / double)
      groups = languages
      Y axis = mean time (s)
    """
    try:
        import matplotlib.pyplot as plt
        import numpy as np
    except ImportError:
        print("  matplotlib not available, skipping chart")
        return

    # Extract dimensions and data
    dtypes = DTYPES  # int, float, double
    langs = list(OrderedDict.fromkeys(r["lang"] for r in data))
    n_langs = len(langs)
    n_dtypes = len(dtypes)

    values = np.full((n_langs, n_dtypes), np.nan)
    errors = np.full((n_langs, n_dtypes), np.nan)
    for r in data:
        li = langs.index(r["lang"])
        di = dtypes.index(r["dtype"])
        values[li, di] = r["mean_s"]
        errors[li, di] = r["stdev_s"]

    fig, ax = plt.subplots(figsize=(max(7, n_langs * 2.5), 5))
    width = 0.8 / n_langs
    x = np.arange(n_dtypes)
    colors = ["#4C72B0", "#DD8452", "#55A868", "#C44E52", "#937860", "#8172B3"]

    for i in range(n_langs):
        off = (i - n_langs / 2 + 0.5) * width
        bars = ax.bar(
            x + off,
            values[i],
            width,
            yerr=errors[i],
            capsize=3,
            label=langs[i],
            color=colors[i % len(colors)],
        )
        for bar, val in zip(bars, values[i]):
            if not np.isnan(val):
                ax.text(
                    bar.get_x() + bar.get_width() / 2,
                    bar.get_height(),
                    f"{val:.3f}",
                    ha="center",
                    va="bottom",
                    fontsize=8,
                    rotation=45,
                )

    ax.set_xticks(x)
    ax.set_xticklabels(dtypes)
    ax.set_ylabel("Time (s)")
    ax.set_title("Cross-Language Benchmark — Full Program Runtime")
    ax.legend(fontsize=9)
    ax.grid(axis="y", alpha=0.3)
    plt.tight_layout()

    try:
        plt.savefig(out_file, dpi=150)
        print(f"  Chart saved: {out_file}")
    except Exception as e:
        print(f"  Chart failed: {e}")
    plt.close(fig)


def print_table(results: List[Dict]):
    """Print summary table."""
    print(f"\n{'=' * 65}")
    print(
        f"  {'Language':<16s} {'dtype':<8s} {'mean (s)':<12s} {'stdev':<12s} {'min':<12s} {'max':<12s}"
    )
    print(f"  {'-' * 16} {'-' * 8} {'-' * 12} {'-' * 12} {'-' * 12} {'-' * 12}")
    for r in results:
        print(
            f"  {r['lang']:<16s} {r['dtype']:<8s} {r['mean_s']:<12.4f} {r['stdev_s']:<12.4f} {r['min_s']:<12.4f} {r['max_s']:<12.4f}"
        )
    print(f"{'=' * 65}")


def save_json(results: List[Dict], path: str):
    payload = {
        "meta": {"timestamp": time.strftime("%Y-%m-%dT%H:%M:%S")},
        "results": results,
    }
    try:
        with open(path, "w", encoding="utf-8") as f:
            json.dump(payload, f, indent=2, ensure_ascii=False)
        print(f"  Results: {path}")
    except Exception as e:
        print(f"  Save failed: {e}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def parse_args(argv=None):
    p = argparse.ArgumentParser(
        description="Cross-language benchmark — run full programs, compare runtime",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    p.add_argument(
        "--langs",
        type=str,
        default=",".join(LANGUAGES),
        help="comma-separated languages (default: all)",
    )
    p.add_argument(
        "--dtypes",
        type=str,
        default=",".join(DTYPES),
        help="comma-separated data types (default: all)",
    )
    p.add_argument(
        "--repeat", type=int, default=5, help="repetitions per combination (default: 5)"
    )
    p.add_argument("--warmup", type=int, default=2, help="warmup runs (default: 2)")
    p.add_argument(
        "--out",
        type=str,
        default=os.path.join(THIS_DIR, "bench_results.json"),
        help="output JSON path",
    )
    p.add_argument(
        "--plot",
        type=str,
        default=os.path.join(THIS_DIR, "bench_comparison.png"),
        help="output chart path",
    )
    return p.parse_args(argv)


def main():
    args = parse_args()
    lang_keys = [s.strip() for s in args.langs.split(",") if s.strip()]
    dtypes = [s.strip() for s in args.dtypes.split(",") if s.strip()]

    print("=" * 60)
    print("  Cross-Language Benchmark — Full Program Runtime")
    print("=" * 60)

    # Discover available combinations
    available = discover(lang_keys)

    if not available:
        print("\nNo available language / data type combinations.")
        print("Hint: compiled languages require 'cmake --build build/' first")
        print("      Java requires javac")
        sys.exit(1)

    print(f"\nAvailable combinations:")
    for key, entry in available.items():
        dts = ", ".join(entry["cmds"].keys())
        print(f"  {entry['name']:<16s} [{dts}]")
    print()

    # Run benchmarks
    results: List[Dict] = []
    total = sum(len(entry["cmds"]) for entry in available.values())
    done = 0

    for key, entry in available.items():
        for dt, cmd in entry["cmds"].items():
            done += 1
            label = f"[{done}/{total}] {entry['name']} / {dt}"
            print(f"{label}")
            print(f"  cmd: {cmd}")

            stats = bench_one(cmd, args.repeat, args.warmup)
            if stats is None:
                print("  → FAILED\n")
            else:
                print(
                    f"  → mean={stats['mean_s']:.4f}s  stdev={stats['stdev_s']:.4f}s\n"
                )
                results.append(
                    {
                        "lang": entry["name"],
                        "dtype": dt,
                        **stats,
                    }
                )

    if not results:
        print("No valid results collected.")
        sys.exit(1)

    # Output
    print("=" * 65)
    print("  SUMMARY")
    print_table(results)
    save_json(results, args.out)
    plot_bar(results, args.plot)

    print("\nDone! Chart:", args.plot)


if __name__ == "__main__":
    main()
