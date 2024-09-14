#!/bin/sh

# Define variables
export NAME="postman"
export VERSION="$(date +'%Y.%m.%d.%H%M%S')"
export REALURL="https://dl.pstmn.io/download/latest/linux_64"
export RELEASE="1"
export ARCH="x86_64"
export SOURCES_DIR="$HOME/rpmbuild/SOURCES"
export SPECS_DIR="$HOME/rpmbuild/SPECS"
export RPMS_DIR="$HOME/rpmbuild/RPMS/$ARCH"
export PACKAGE_NAME="$NAME-$VERSION-$RELEASE.$ARCH.rpm"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
for cmd in curl rpmbuild tar; do
    if ! command_exists "$cmd"; then
        echo "$cmd is not installed. Exiting."
        exit 1
    fi
done

# Initialize rpmbuild directories
echo "Initializing rpmbuild directories"
rpmdev-setuptree

# Clean up old files
echo "Cleaning up old files"
rm -rf "$SOURCES_DIR/$NAME-*.tar.gz"
rm -rf "$HOME/rpmbuild/BUILDROOT/$NAME-*"
rm -rf postman-*
rm -rf Postman.tar.gz

# Download latest Postman
if [ ! -f Postman.tar.gz ]; then
    echo "Downloading Postman"
    curl -L "$REALURL" -o Postman.tar.gz
    if [ $? -ne 0 ]; then 
        echo "Something went wrong with Postman download!"
        exit 1
    fi
fi

# Prepare package sources
echo "Preparing package sources"
tar czf "$NAME-$VERSION.tar.gz" LICENSE Postman.desktop
mv "$NAME-$VERSION.tar.gz" "$SOURCES_DIR/"

# Generate spec file
echo "Generating $NAME.spec file"
cat << EOF > "$S
