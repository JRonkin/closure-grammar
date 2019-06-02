lang="$(basename "$(pwd)")"

pushd ../..
make "$lang" || exit 1
popd
