###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-16 20:18:25
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:06:47
# @FilePath: \asm_matrix_benchmark\src\benchmark\bench_python.py
# @Description: test four language run time
###########################################################
#!/usr/bin/env python3
"""
Simple Python benchmarking harness for functions in src/Python/matrix.py
Usage examples:
  python src/benchmark/bench_python.py --test add --size 500 --number 10 --repeat 5
  python src/benchmark/bench_python.py --test mul --size 200 --number 5 --repeat 3
"""

from __future__ import annotations
import argparse
from time import perf_counter
import statistics

import os
import sys
from typing import List

# Ensure project root is on sys.path so `src` package can be imported when
# running this script directly (e.g. `python src/benchmark/bench_python.py`).
THIS_DIR = os.path.dirname(__file__)
PROJECT_ROOT = os.path.abspath(os.path.join(THIS_DIR, "..", ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from src.Python import base_matrix as matrix_module

Matrix = matrix_module.Matrix


def make_matrices(n: int, m: int, fill: int = 1):
    a: List[int | float] = [fill for _ in range(n * m)]
    b: List[int | float] = [fill + 1 for _ in range(n * m)]
    return Matrix(n, m, a), Matrix(n, m, b)


def time_callable(func, args=(), kwargs=None, number=1, repeat=3, warmup=1):
    if kwargs is None:
        kwargs = {}
    # warmup
    for _ in range(warmup):
        func(*args, **kwargs)

    times = []
    for _ in range(repeat):
        t0 = perf_counter()
        for _ in range(number):
            func(*args, **kwargs)
        t1 = perf_counter()
        times.append(t1 - t0)

    # convert to per-call seconds
    per_call = [t / number for t in times]
    return {
        "times": times,
        "per_call": per_call,
        "mean_s": statistics.mean(per_call),
        "stdev_s": statistics.stdev(per_call) if len(per_call) > 1 else 0.0,
        "min_s": min(per_call),
        "max_s": max(per_call),
        "raw_repeat": len(per_call),
        "number": number,
    }


def bench_add(size: int, number: int, repeat: int):
    a, b = make_matrices(size, size)

    def run():
        _ = a + b

    return time_callable(run, (), {}, number=number, repeat=repeat)


def bench_sub(size: int, number: int, repeat: int):
    a, b = make_matrices(size, size)

    def run():
        _ = a - b

    return time_callable(run, (), {}, number=number, repeat=repeat)


def bench_mul(size: int, number: int, repeat: int):
    # for multiplication use size x size and size x size
    a = Matrix(size, size, [1 for _ in range(size * size)])
    b = Matrix(size, size, [1 for _ in range(size * size)])

    def run():
        _ = a * b

    return time_callable(run, (), {}, number=number, repeat=repeat)


def bench_find(size: int, number: int, repeat: int):
    a = Matrix(size, size, list(range(size * size)))

    def run():
        _ = matrix_module.find_elem(a, size * size - 1)

    return time_callable(run, (), {}, number=number, repeat=repeat)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--test", choices=["add", "sub", "mul", "find"], default="mul")
    parser.add_argument("--size", type=int, default=200, help="matrix size (n x n)")
    parser.add_argument("--number", type=int, default=1, help="calls per repeat")
    parser.add_argument("--repeat", type=int, default=5, help="repeats")
    parser.add_argument("--warmup", type=int, default=1, help="warmup runs (not timed)")
    args = parser.parse_args()

    # update warmup support in time_callable if needed
    print(
        f"Benchmark test={args.test} size={args.size} number={args.number} repeat={args.repeat}"
    )

    if args.test == "add":
        r = bench_add(args.size, args.number, args.repeat)
    elif args.test == "sub":
        r = bench_sub(args.size, args.number, args.repeat)
    elif args.test == "mul":
        r = bench_mul(args.size, args.number, args.repeat)
    else:
        r = bench_find(args.size, args.number, args.repeat)

    print("results:")
    print(f"mean per call: {r['mean_s']:.9f} s")
    print(f"stdev per call: {r['stdev_s']:.9f} s")
    print(f"min per call: {r['min_s']:.9f} s")
    print(f"max per call: {r['max_s']:.9f} s")
    print(f"raw per-call times: {[f'{x:.9f}' for x in r['per_call']]} ")


if __name__ == "__main__":
    main()
