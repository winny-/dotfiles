perldir="$HOME/perl5/lib/perl5"
if command -v perl &>/dev/null && [[ -d $perldir ]]; then
    eval "$(perl -I"$perldir" -Mlocal::lib)"
fi
unset perldir
