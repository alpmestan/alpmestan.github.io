``` sh
$ nix-shell
$ make       # generate site files, under _out
$ make watch # generate site files with hot-reloading, and serve it on localhost:8000
```

or just `nix-shell --run 'make watch'`.