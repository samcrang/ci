Simple Bash CI Server
=====================

A /very/ simple continuous integration server written in Bash.

Why?
----

I wanted to use a cloud-based vitual machine as a CI box for running [test-kitchen](https://github.com/opscode/test-kitchen) so I didn't have to tie up the I/O on my laptop. I tried using Jenkins but it seemed to use /a lot/ of memory, which I needed for the VMs I am spinning up and converging (~400MB). I decided to write something smaller and simpler.

It's also partially an excuse to play around with Bash scripting (as well as [Bats](https://github.com/sstephenson/bats)).

Goals
-----

- Minimal number of dependenices.
- Low memory usage.

