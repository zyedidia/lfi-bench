#!/usr/bin/env python3
"""
LFI Benchmark Hyperfine Runner

A wrapper around hyperfine that provides a template for LFI benchmarks.
Automatically generates hyperfine commands for multiple targets.
"""

import argparse
import subprocess
import sys
import shlex


def main():
    parser = argparse.ArgumentParser(description='Run hyperfine benchmarks for LFI targets')
    
    # Required arguments
    parser.add_argument('--name', required=True, 
                       help='Benchmark name (used for CSV filename)')
    parser.add_argument('--cmd', required=True,
                       help='Command template with {BUILD_DIR} placeholder')
    
    # Optional arguments
    parser.add_argument('--runs', type=int, default=1,
                       help='Number of benchmark runs (default: 1)')
    parser.add_argument('--warmup', type=int, default=0, 
                       help='Number of warmup runs (default: 0)')
    parser.add_argument('--targets', required=True,
                       help='Target specifications: "name:runner:build_dir name:runner:build_dir ..."')
    parser.add_argument('--run-command-flags', default='',
                       help='Flags for run command (e.g. "-p")')
    parser.add_argument('--setup', default='',
                       help='Setup command to run before hyperfine')
    parser.add_argument('--csv', 
                       help='CSV output filename (default: {name}.csv)')
    
    args = parser.parse_args()
    
    # Set default CSV filename
    csv_file = args.csv if args.csv else f"{args.name}.csv"
    
    # Run setup command if provided
    if args.setup:
        print(f"Running setup: {args.setup}")
        result = subprocess.run(args.setup, shell=True)
        if result.returncode != 0:
            print(f"Setup command failed with exit code {result.returncode}", file=sys.stderr)
            sys.exit(result.returncode)
    
    # Parse target specifications
    targets = []
    for target_spec in args.targets.split():
        parts = target_spec.split(':')
        if len(parts) != 3:
            print(f"Invalid target specification: {target_spec}. Expected format: name:runner:build_dir", file=sys.stderr)
            sys.exit(1)
        
        name, runner, build_dir = parts
        cmd = args.cmd.replace('{BUILD_DIR}', build_dir)
        
        # Build full command with runner (if specified)
        if runner:
            full_cmd = f'{runner} {args.run_command_flags} -- {cmd}'.strip()
        else:
            full_cmd = cmd
            
        targets.append((name, full_cmd))
    
    # Build hyperfine command
    hyperfine_cmd = [
        'hyperfine',
        '--runs', str(args.runs),
        '--warmup', str(args.warmup), 
        '--export-csv', csv_file,
    ]
    
    # Add each target to hyperfine command
    for name, cmd in targets:
        hyperfine_cmd.extend(['-n', name, cmd])
    
    # Print the command being executed for debugging
    print(f"Executing: {' '.join(shlex.quote(arg) for arg in hyperfine_cmd)}")
    
    # Execute hyperfine and pass through exit code
    result = subprocess.run(hyperfine_cmd)
    sys.exit(result.returncode)


if __name__ == '__main__':
    main()