CONFIG_FILE='Config.xcconfig'
VERSION=`git describe --abbrev=0 --tags --match "[0-9]*"`
BUILD=`date -u +%Y%m%d%H%M%S`
cp ${CONFIG_FILE}.example mpvx/${CONFIG_FILE}
sed -i '' "s/\(VERSION *= *\).*/\1$VERSION/" $CONFIG_FILE
sed -i '' "s/\(BUILD *= *\).*/\1$BUILD/" $CONFIG_FILE
echo "Version: $VERSION"
echo "Build: $BUILD"
