#!/bin/bash

# Define file paths
CONFIG_FILE="Config.xcconfig"
PLIST_FILE="mpvx/GoogleService-Info.plist"

# Define dynamic values
VERSION=$(git describe --abbrev=0 --tags --match "[0-9]*")
BUILD=$(date -u +%Y%m%d%H%M%S)

# Generate Config.xcconfig regardless of Firebase variables
echo "Generating ${CONFIG_FILE}..."
cp "${CONFIG_FILE}.example" "mpvx/${CONFIG_FILE}"

# If no Git tag is found, warn or handle it
if [ -z "$VERSION" ]; then
  echo "Error: Unable to get VERSION from Git tags. Please ensure you have a valid tag (matching [0-9]*)."
  exit 1
fi

# Update version/build in Config.xcconfig
sed -i '' "s/\(VERSION *= *\).*/\1$VERSION/" "mpvx/${CONFIG_FILE}"
sed -i '' "s/\(BUILD *= *\).*/\1$BUILD/" "mpvx/${CONFIG_FILE}"

echo "Version: $VERSION"
echo "Build:   $BUILD"

# Check environment variables for Firebase
# (We do this AFTER generating Config.xcconfig to ensure config is always created)
if [ -z "$API_KEY" ] || [ -z "$GOOGLE_APP_ID" ] || [ -z "$GCM_SENDER_ID" ]; then
  echo "======================================================"
  echo "Firebase won't work. Missing one or more environment variables:"
  echo "  - API_KEY"
  echo "  - GOOGLE_APP_ID"
  echo "  - GCM_SENDER_ID"
  echo "Please make sure these are set in your environment."
  echo "======================================================"
  exit 1
fi

# If we made it here, all Firebase vars exist. Proceed with Plist update.
echo "Updating ${PLIST_FILE}..."
/usr/libexec/PlistBuddy -c "Set :API_KEY $API_KEY" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :GOOGLE_APP_ID $GOOGLE_APP_ID" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :GCM_SENDER_ID $GCM_SENDER_ID" "$PLIST_FILE"

echo "Config and GoogleService-Info.plist updated successfully."
