{ nixpkgs ? <nixpkgs>
# Run "nix-build --argstr date YYYY-MM-DD" to reproduce a build:
, date ? null
}:

with import nixpkgs {};

stdenv.mkDerivation rec {
  name = "anfipraesentation-${version}";
  version = if (date != null)
    then date
    else lib.fileContents
      (runCommand "anfipraesentation-date" {} "date --utc +'%F' > $out");

  src = lib.cleanSource ./.;

  nativeBuildInputs = [ #kpsewhich XYZ.sty
    (texlive.combine {
      inherit (texlive) scheme-minimal latexmk latexconfig latex latex-bin
        collection-fontsrecommended fontawesome5 dejavu
        etoolbox oberdiek graphics geometry hyperref url tools amsmath amscls beamer
        mathtools babel babel-german hyphen-german subfig caption qrcode xkeyval
        epstopdf-pkg eurosym translator l3packages xurl;
    })
  ];

  postPatch = ''
    # Set SOURCE_DATE_EPOCH to make the build reproducible:
    export SOURCE_DATE_EPOCH="$(date --date=$version +'%s')"
    # Override the LaTeX values for \today:
    sed -i \
      -e "s,\\\year=\\\year,\\\year=$(date --date=$version +'%Y')," \
      -e "s,\\\month=\\\month,\\\month=$(date --date=$version +'%m')," \
      -e "s,\\\day=\\\day,\\\day=$(date --date=$version +'%d')," \
      presentation.tex
    sed -i \
      -e "s,\\\year=\\\year,\\\year=$(date --date=$version +'%Y')," \
      -e "s,\\\month=\\\month,\\\month=$(date --date=$version +'%m')," \
      -e "s,\\\day=\\\day,\\\day=$(date --date=$version +'%d')," \
      presentation_short.tex
  '';

  buildPhase = ''
    # Build the PDFs
    make
  '';

  installPhase = ''
    mkdir $out
    cp presentation.pdf presentation_short.pdf $out/
  '';
}
