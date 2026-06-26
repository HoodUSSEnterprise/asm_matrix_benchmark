#!/usr/bin/env python3
"""
Run external commands/executables multiple times and report timing statistics.
Usage example:
    python src/benchmark/bench_cross.py \
    --cmd asm=build/matrix_int.exe --cmd \
    --cmd c=D:/code/asm_matrix_benchmark/build/matrix_intc.exe \
    --cmd cpp=D:/code/asm_matrix_benchmark/build/matrix_intcpp.exe \
    --cmd py="python D:/code/asm_matrix_benchmark/src/benchmark/bench_python.py --test mul --size 200 --number 1 --repeat 1" \
    --number 1 --repeat 5

Format for --cmd: LABEL=COMMAND
The COMMAND is executed by the shell on Windows; prefer absolute paths. The script runs a warmup (single run), then repeats runs and reports per-call mean/stdev/min/max.
"""

from __future__ import annotations
import argparse
import shlex
import subprocess
import sys
import time
import statistics
from typing import List, Tuple
import json

try:
    import matplotlib.pyplot as plt
except Exception:
    plt = None


def parse_cmd(s: str) -> Tuple[str, str]:
    if "=" not in s:
        raise argparse.ArgumentTypeError("--cmd must be in LABEL=COMMAND format")
    label, cmd = s.split("=", 1)
    label = label.strip()
    cmd = cmd.strip()
    if not label or not cmd:
        raise argparse.ArgumentTypeError("--cmd must have both LABEL and COMMAND")
    return label, cmd


def run_once(cmd: str, timeout: float | None) -> float:
    t0 = time.perf_counter()
    # Use shell=True on Windows so paths with spaces are handled; on POSIX use shlex.split
    if sys.platform.startswith("win"):
        subprocess.run(cmd, shell=True, check=True, timeout=timeout)
    else:
        args = shlex.split(cmd)
        subprocess.run(args, check=True, timeout=timeout)
    t1 = time.perf_counter()
    return t1 - t0


def bench_command(
    label: str, cmd: str, number: int, repeat: int, timeout: float | None
):
    # warmup
    try:
        print(f"Warmup run for {label}: {cmd}")
        run_once(cmd, timeout)
    except subprocess.CalledProcessError as e:
        print(f"Warmup failed for {label}: {e}")
        return None
    except Exception as e:
        print(f"Warmup error for {label}: {e}")
        return None

    times = []
    for r in range(repeat):
        t0 = time.perf_counter()
        for i in range(number):
            try:
                run_once(cmd, timeout)
            except subprocess.CalledProcessError as e:
                print(f"Run failed for {label}: {e}")
                return None
        t1 = time.perf_counter()
        times.append(t1 - t0)
        print(f"{label} repeat {r + 1}/{repeat}: total {times[-1]:.6f}s")

    per_call = [t / number for t in times]
    stats = {
        "label": label,
        "cmd": cmd,
        "number": number,
        "repeat": repeat,
        "mean_s": statistics.mean(per_call),
        "stdev_s": statistics.stdev(per_call) if len(per_call) > 1 else 0.0,
        "min_s": min(per_call),
        "max_s": max(per_call),
        "per_call": per_call,
    }
    return stats


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--cmd",
        action="append",
        type=parse_cmd,
        required=True,
        help="Command to benchmark as LABEL=COMMAND (can repeat)",
    )
    parser.add_argument("--number", type=int, default=1, help="calls per repeat")
    parser.add_argument("--repeat", type=int, default=5, help="repeats")
    parser.add_argument(
        "--timeout", type=float, default=None, help="timeout per call (seconds)"
    )
    parser.add_argument(
        "--out",
        type=str,
        default=None,
        help="Optional JSON output file to save results",
    )
    parser.add_argument(
        "--plot", action="store_true", help="Generate a plot (requires matplotlib)"
    )
    parser.add_argument(
        "--plot-file",
        type=str,
        default="bench_results.png",
        help="Path to save plot PNG",
    )
    args = parser.parse_args()

    commands: List[Tuple[str, str]] = args.cmd

    results = []
    for label, cmd in commands:
        print(f"\n=== Benchmarking {label} ===")
        res = bench_command(label, cmd, args.number, args.repeat, args.timeout)
        if res is None:
            print(f"{label}: failed, skipping summary")
        else:
            results.append(res)

    print("\nSummary:")
    for r in results:
        print(
            f"{r['label']}: mean={r['mean_s']:.9f}s stdev={r['stdev_s']:.9f}s min={r['min_s']:.9f}s max={r['max_s']:.9f}s"
        )

    # Save JSON if requested
    if args.out and results:
        try:
            with open(args.out, "w", encoding="utf-8") as f:
                json.dump(results, f, indent=2)
            print(f"Saved results to {args.out}")
        except Exception as e:
            print(f"Failed to save results to {args.out}: {e}")

    # Plot if requested
    if args.plot:
        if plt is None:
            print("matplotlib not available; cannot plot")
            return
        if not results:
            print("No results to plot")
            return
        labels = [r["label"] for r in results]
        means = [r["mean_s"] for r in results]
        stdevs = [r["stdev_s"] for r in results]

        fig, ax = plt.subplots(figsize=(max(6, len(labels) * 2), 4))
        x = range(len(labels))
        ax.bar(x, means, yerr=stdevs, capsize=5)
        ax.set_xticks(x)
        ax.set_xticklabels(labels)
        ax.set_ylabel("Mean time (s)")
        ax.set_title("Cross-language benchmark")
        plt.tight_layout()
        try:
            # annotate bars with mean +/- stdev
            y_offset = (max(stdevs) * 3) if max(stdevs) > 0 else (max(means) * 0.02)
            for xi, (mu, sd) in enumerate(zip(means, stdevs)):
                label = f"{mu:.6f}s"
                if sd > 0:
                    label = f"{mu:.6f}s\n±{sd:.6f}s"
                ax.text(xi, mu + y_offset, label, ha="center", va="bottom", fontsize=8)

            plt.savefig(args.plot_file)
            print(f"Saved plot to {args.plot_file}")
        except Exception as e:
            print(f"Failed to save plot: {e}")


if __name__ == "__main__":
    main()
