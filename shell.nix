with import <nixpkgs> {};

mkShell {
  nativeBuildInputs = [
    stow
  ];
}
