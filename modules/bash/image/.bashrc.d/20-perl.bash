perldir="$HOME/perl5/lib/perl5"
if command -v perl && [[ -d $perldir ]]; then
    eval "$(perl -I"$perldir" -Mlocal::lib)" > /dev/null
fi
unset perldir
