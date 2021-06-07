# Installs Carthage dependencies.
./carthage.sh update --platform ios

# Downloads AppThinner from the ThunderCloud repository.
curl -O "https://raw.githubusercontent.com/3sidedcube/ThunderCloud/master/ThunderCloud/AppThinner"

# Makes AppThinner executable.
chmod +x AppThinner
