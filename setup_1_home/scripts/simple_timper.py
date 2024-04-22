#!/usr/bin/env python3

import time
import sys



def main():
    time_start = time.time()
    time_clean = time.gmtime(time_start)
    time_out = time.strftime("%Y-%m-%d %H:%M:%S", time_clean)
    sec = 0
    mns = 0
    hrs = 0

    print("^C to exit")
    print(f"\rstart  : {time_out}")

    while True:
        try:
            sys.stdout.write(f"\relapsed:            {hrs:02}:{mns:02}:{sec:02}")
            sys.stdout.flush()
            time.sleep(1)
            sec = int(time.time() - time_start) - mns * 60
            if 60 <= sec:
                mns += 1
                sec = 0
            if 60 <= mns:
                hrs += 1
                mns = 0
        except KeyboardInterrupt as err:
            break

if __name__ == "__main__":
    main()
