#!/usr/bin/env python3
"""
Python benchmarking harness supporting int / float / double data types.

Usage examples:
  python benchmark/bench_python.py --dtype int --test mul --size 200 --number 10 --repeat 5
  python benchmark/bench_python.py --dtype float --test add --size 500 --number 5 --repeat 3
  python benchmark/bench_python.py --dtype double --test mul --size 300 --number 10 --repeat 5

Notes:
  - Python's "float" type is IEEE 754 double-precision, so --dtype float and
    --dtype double behave identically (both use Python float).
  - --dtype int uses Python int (unbounded). Large sizes may be slower.
"""

from __future__ import annotations
import argparse
import os
import sys
import statistics
from time import perf_counter
from typing import List, Union

THIS_DIR = os.path.dirname(__file__)
PROJECT_ROOT = os.path.abspath(os.path.join(THIS_DIR, ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from src.Python import base_matrix as matrix_module

Matrix = matrix_module.Matrix


def make_matrices(n: int, m: int, fill: Union[int, float] = 1):
    a: List[Union[int, float]] = [fill for _ in range(n * m)]
    b: List[Union[int, float]] = [fill + 1 for _ in range(n * m)]
    return Matrix(n, m, a), Matrix(n, m, b)


def time_callable(func, args=(), kwargs=None, number=1, repeat=3, warmup=1):
    if kwargs is None:
        kwargs = {}
    for _ in range(warmup):
        func(*args, **kwargs)
    times = []
    for _ in range(repeat):
        t0 = perf_counter()
        for _ in range(number):
            func(*args, **kwargs)
        t1 = perf_counter()
        times.append(t1 - t0)
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


def bench_add(size: int, number: int, repeat: int, fill: Union[int, float]):
    a, b = make_matrices(size, size, fill)
    def run():
        _ = a + b
    return time_callable(run, (), {}, number=number, repeat=repeat)


def bench_sub(size: int, number: int, repeat: int, fill: Union[int, float]):
    a, b = make_matrices(size, size, fill)
    def run():
        _ = a - b
    return time_callable(run, (), {}, number=number, repeat=repeat)


def bench_mul(size: int, number: int, repeat: int, fill: Union[int, float]):
    a = Matrix(size, size, [fill for _ in range(size * size)])
    b = Matrix(size, size, [fill + 1 for _ in range(size * size)])
    def run():
        _ = a * b
    return time_callable(run, (), {}, number=number, repeat=repeat)


def bench_find(size: int, number: int, repeat: int, fill: Union[int, float]):
    a = Matrix(size, size, [fill + i for i in range(size * size)])
    target = fill + (size * size - 1)
    def run():
        _ = matrix_module.find_elem(a, target)
    return time_callable(run, (), {}, number=number, repeat=repeat)


DTYPE_FILL = {
    "int": 1,
    "float": 1.0,
    "double": 1.0,
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dtype",
        choices=["int", "float", "double"],
        default="int",
        help="Data type (Python float and double are identical)",
    )
    parser.add_argument("--test", choices=["add", "sub", "mul", "find"], default="mul")
    parser.add_argument("--size", type=int, default=200, help="matrix size (n x n)")
    parser.add_argument("--number", type=int, default=1, help="calls per repeat")
    parser.add_argument("--repeat", type=int, default=5, help="repeats")
    parser.add_argument("--warmup", type=int, default=1, help="warmup runs (not timed)")
    parser.add_argument("--json", action="store_true", help="Output results as JSON")
    args = parser.parse_args()

    fill = DTYPE_FILL[args.dtype]

    if not args.json:
        print(f"dtype={args.dtype} test={args.test} size={args.size} number={args.number} repeat={args.repeat}")

    if args.test == "add":
        r = bench_add(args.size, args.number, args.repeat, fill)
    elif args.test == "sub":
        r = bench_sub(args.size, args.number, args.repeat, fill)
    elif args.test == "mul":
        r = bench_mul(args.size, args.number, args.repeat, fill)
    else:
        r = bench_find(args.size, args.number, args.repeat, fill)

    if args.json:
        import json as _json
        print(_json.dumps({
            "mean_s": r["mean_s"],
            "stdev_s": r["stdev_s"],
            "min_s": r["min_s"],
            "max_s": r["max_s"],
            "per_call": r["per_call"],
        }))
    else:
        print("results:")
        print(f"mean per call: {r['mean_s']:.9f} s")
        print(f"stdev per call: {r['stdev_s']:.9f} s")
        print(f"min per call: {r['min_s']:.9f} s")
        print(f"max per call: {r['max_s']:.9f} s")
        print(f"raw per-call times: {[f'{x:.9f}' for x in r['per_call']]}")


if __name__ == "__main__":
    main()
