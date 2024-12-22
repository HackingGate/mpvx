#!/bin/bash

# Define file paths
CONFIG_FILE="mpvx/Config.xcconfig"
PLIST_FILE="mpvx/GoogleService-Info.plist"

# Define dynamic values
VERSION=$(git describe --abbrev=0 --tags --match "[0-9]*")
BUILD=$(date -u +%Y%m%d%H%M%S)

# Environment variables for secrets (replace with your source of secrets)
API_KEY="${API_KEY}"
GOOGLE_APP_ID="${GOOGLE_APP_ID}"
GCM_SENDER_ID="${GCM_SENDER_ID}"

# Generate Config.xcconfig
echo "Generating ${CONFIG_FILE}..."
cp ${CONFIG_FILE}.example ${CONFIG_FILE}
sed -i '' "s/\(VERSION *= *\).*/\1$VERSION/" ${CONFIG_FILE}
sed -i '' "s/\(BUILD *= *\).*/\1$BUILD/" ${CONFIG_FILE}

# Update GoogleService-Info.plist
echo "Updating ${PLIST_FILE}..."
/usr/libexec/PlistBuddy -c "Set :API_KEY $API_KEY" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :GOOGLE_APP_ID $GOOGLE_APP_ID" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :GCM_SENDER_ID $GCM_SENDER_ID" "$PLIST_FILE"

# Output results
echo "Version: $VERSION"
echo "Build: $BUILD"
echo "Config and Plist updated successfully."
