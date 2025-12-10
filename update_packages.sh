PACKAGES="curl git vim"

echo "Updating system packages..."

sudo apt update

sudo apt install --only-upgrade $PACKAGES -y
