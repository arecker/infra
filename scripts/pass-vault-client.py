#!/usr/bin/env python
import argparse
import os
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--vault-id', required=True)


def main():
    if 'VAULT_PASSWORD' in os.environ:
        print(os.environ['VAULT_PASSWORD'].strip())
    else:
        args = parser.parse_args()
        cmd = 'pass ansible/{}'.format(args.vault_id).split(' ')
        output = subprocess.check_output(cmd)
        print(output.strip())


if __name__ == '__main__':
    main()
