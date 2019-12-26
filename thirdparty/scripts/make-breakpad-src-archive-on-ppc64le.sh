BREAKPAD_REPO=https://chromium.googlesource.com/breakpad/breakpad
LSS_REPO=https://chromium.googlesource.com/linux-syscall-support
LSS_REVISION=master

TOPDIR=breakpad-repos

rm -rf "$TOPDIR"
mkdir $TOPDIR
pushd $TOPDIR

BREAKPAD_DIR=breakpad.git
git clone $BREAKPAD_REPO $BREAKPAD_DIR
pushd $BREAKPAD_DIR
git fetch https://chromium.googlesource.com/breakpad/breakpad refs/changes/23/1428423/2 && git checkout FETCH_HEAD  
git fetch https://chromium.googlesource.com/breakpad/breakpad refs/changes/83/1426283/21 && git checkout FETCH_HEAD

REVISION=${1:-$(git rev-parse HEAD)}
NAME=breakpad-$REVISION

git checkout $REVISION
# Export the checked-in files, without .git metadata, into "../$NAME/".
git archive --format=tar --prefix=$NAME/ $REVISION | (cd .. && tar xf -)
popd

LSS_DIR=lss.git
git clone $LSS_REPO $LSS_DIR
pushd $LSS_DIR
git fetch https://chromium.googlesource.com/linux-syscall-support refs/changes/73/1430973/4 && git checkout FETCH_HEAD


# Export into the thirdparty directory under "../$NAME/".
git archive --format=tar --prefix=$NAME/src/third_party/lss/ FETCH_HEAD  | (cd .. && tar xf -)
popd

FILENAME="$NAME.tar.gz"
tar czvf "$FILENAME" "$NAME/"
mv "$FILENAME" ..
popd
echo "Archive created at $(pwd)/$FILENAME"

