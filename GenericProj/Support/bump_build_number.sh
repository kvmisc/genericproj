echo "Bumping build number..."
PLIST_FILE=${PROJECT_DIR}/${INFOPLIST_FILE}
OLD_BUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PLIST_FILE}")
NEW_BUILD=$(expr ${OLD_BUILD} + 1)
/usr/libexec/Plistbuddy -c "Set CFBundleVersion ${NEW_BUILD}" "${PLIST_FILE}"
