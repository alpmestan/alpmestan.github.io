with (import <nixpkgs> { config.allowBroken = true; });

let tex = texlive.combined.scheme-medium;
    hs  = haskellPackages;
    py  = pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.numpy
      python-pkgs.matplotlib
    ]);
    pandocPkgs = [ pandoc
                   hs.pandoc-sidenote
                   pandoc-imagine
                   hs.pandoc-plot
                   d2
                   # hs.latex-svg-pandoc
                   # hs.pandoc-crossref hs.pandoc-logic-proof hs.pandoc-include-plus
                   # hs.pandoc-plot hs.pandoc-markdown-ghci-filter
                   # hs.pandoc-columns
                 ];
in
mkShell {
  name = "brain";
  buildInputs = [ tex py watchexec ] ++ pandocPkgs;
}
