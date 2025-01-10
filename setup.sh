#!/bin/bash

CONFIG_FILE="Config.xcconfig"
PLIST_FILE="mpvx/GoogleService-Info.plist"

VERSION=$(git describe --abbrev=0 --tags --match "v[0-9]*" --match "[0-9]*" | sed 's/^v//')
BUILD=$(date -u +%Y%m%d%H%M%S)

echo "Generating ${CONFIG_FILE}..."
cp "${CONFIG_FILE}.example" "mpvx/${CONFIG_FILE}"

if [ -z "$VERSION" ]; then
	echo "Error: Unable to get VERSION from Git tags. Please ensure you have a valid tag (matching [0-9]*)."
	exit 1
fi

sed -i '' "s/\(VERSION *= *\).*/\1$VERSION/" "mpvx/${CONFIG_FILE}"
sed -i '' "s/\(BUILD *= *\).*/\1$BUILD/" "mpvx/${CONFIG_FILE}"

echo "Version: $VERSION"
echo "Build:   $BUILD"

if [ -z "$API_KEY" ] || [ -z "$GOOGLE_APP_ID" ] || [ -z "$GCM_SENDER_ID" ]; then
	echo "====================================================="
	echo "                  ⚠️ Firebase Notice                  "
	echo "====================================================="
	echo "Firebase is not fully configured for this codebase because one or more"
	echo "environment variables are missing:"
	echo "  - API_KEY: ${API_KEY}"
	echo "  - GOOGLE_APP_ID: ${GOOGLE_APP_ID}"
	echo "  - GCM_SENDER_ID: ${GCM_SENDER_ID}"
	echo ""
	echo "This notice only affects local builds and does not impact GitHub Actions."
	echo "If you wish to enable Firebase locally, set these variables and ensure"
	echo "FirebaseApp.configure() is called in your code."
	echo "====================================================="
else
	echo "Configuring Firebase for build..."
	/usr/libexec/PlistBuddy -c "Set :API_KEY $API_KEY" "$PLIST_FILE"
	/usr/libexec/PlistBuddy -c "Set :GOOGLE_APP_ID $GOOGLE_APP_ID" "$PLIST_FILE"
	/usr/libexec/PlistBuddy -c "Set :GCM_SENDER_ID $GCM_SENDER_ID" "$PLIST_FILE"
	echo "✅ Firebase environment configured successfully with GoogleService-Info.plist."
fi
