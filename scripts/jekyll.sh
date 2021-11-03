# Based on: https://jekyllrb.com/docs/installation/macos/#local-install
# TODO make this dynamic if possible.
set -e
PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
jekyll "$@"
