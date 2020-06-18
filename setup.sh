CONFIG_FILE='Config.xcconfig'
VERSION=`git describe --abbrev=0 --tags --match "[0-9]*"`
BUILD=`git rev-list HEAD --count`
cp ${CONFIG_FILE}.example ${CONFIG_FILE}
sed -i '' "s/\(VERSION *= *\).*/\1$VERSION/" $CONFIG_FILE
sed -i '' "s/\(BUILD *= *\).*/\1$BUILD/" $CONFIG_FILE
