#!/bin/bash

mkdir -p chrome/android/java/res_titanium_base
cp $SCRIPT_DIR/res/drawable/themed_app_icon.xml chrome/android/java/res_titanium_base/drawable/themed_app_icon.xml
for icon in $(find chrome/android/java/res_titanium_base -type f -name '*.png'); do convert $icon -fill navy -tint 36 $icon && $SCRIPT_DIR/res/icon.sh $icon; done
sed -i 's|<application |<application android:extractNativeLibs="false" |' chrome/android/java/AndroidManifest.xml
sed -i 's|<data android:mimeType="message/rfc822"/>|<data android:mimeType="message/rfc822"/><data android:mimeType="application/pdf"/>|' chrome/android/java/AndroidManifest.xml
sed -i '/com.google.ar.core.min_apk_version/d' third_party/arcore-android-sdk-client/AndroidManifest_basesplit.xml
# sed -i 's|Google LLC|jqssun, Google LLC|' chrome/browser/ui/android/strings/android_chrome_strings.grd

cp -r $SCRIPT_DIR/extensions/dist titanium/
cp $SCRIPT_DIR/extensions/stage_bundled_extensions.inc titanium/dist/
sed -i 's|"//components/privacy_sandbox/privacy_sandbox_attestations/preload:privacy_sandbox_attestations_assets",|&"//titanium/dist:extension_assets",|' chrome/android/BUILD.gn
sed -i 's|if (!base::PathService::Get(base::DIR_MODULE, \&cur)) {|if (!base::PathService::Get(chrome::DIR_USER_DATA, \&cur)) {|' chrome/common/chrome_paths.cc
sed -i 's|#include "extensions/buildflags/buildflags.h"|&\n#include "titanium/dist/stage_bundled_extensions.inc"|' chrome/browser/extensions/external_pref_loader.cc
sed -i 's|ReadStandaloneExtensionPrefFiles(prefs);|&StageBundledExtensions(base_path_id_, base_path_, prefs);|' chrome/browser/extensions/external_pref_loader.cc
sed -i 's|if (extension.location() == mojom::ManifestLocation::kCommandLine) {|if (extension.location() == mojom::ManifestLocation::kExternalPref) return false;\n&|' chrome/browser/extensions/extension_safety_check_utils.cc

# microg sync
sed -i 's|<application |<uses-permission android:name="android.permission.FAKE_PACKAGE_SIGNATURE" />\n    <application |' chrome/android/java/AndroidManifest.xml
sed -i '/<queries>/a\      <package android:name="app.revanced.android.gms" />\n      <package android:name="com.google.android.gms" />' chrome/android/java/AndroidManifest.xml
sed -i '/<\/application>/i\
      <meta-data android:name="app.revanced.android.gms.SPOOFED_PACKAGE_NAME"\
          android:value="com.android.chrome" />\
      <meta-data android:name="app.revanced.android.gms.SPOOFED_PACKAGE_SIGNATURE"\
          android:value="38918a453d07199354f8b19af05ec6562ced5788" />\
      <meta-data android:name="fake-signature"\
          android:value="308204433082032ba003020102020900c2e08746644a308d300d06092a864886f70d01010405003074310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e205669657731143012060355040a130b476f6f676c6520496e632e3110300e060355040b1307416e64726f69643110300e06035504031307416e64726f6964301e170d3038303832313233313333345a170d3336303130373233313333345a3074310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e205669657731143012060355040a130b476f6f676c6520496e632e3110300e060355040b1307416e64726f69643110300e06035504031307416e64726f6964820120300d06092a864886f70d01010105000382010d00308201080282010100ab562e00d83ba208ae0a966f124e29da11f2ab56d08f58e2cca91303e9b754d372f640a71b1dcb130967624e4656a7776a92193db2e5bfb724a91e77188b0e6a47a43b33d9609b77183145ccdf7b2e586674c9e1565b1f4c6a5955bff251a63dabf9c55c27222252e875e4f8154a645f897168c0b1bfc612eabf785769bb34aa7984dc7e2ea2764cae8307d8c17154d7ee5f64a51a44a602c249054157dc02cd5f5c0e55fbef8519fbe327f0b1511692c5a06f19d18385f5c4dbc2d6b93f68cc2979c70e18ab93866b3bd5db8999552a0e3b4c99df58fb918bedc182ba35e003c1b4b10dd244a8ee24fffd333872ab5221985edab0fc0d0b145b6aa192858e79020103a381d93081d6301d0603551d0e04160414c77d8cc2211756259a7fd382df6be398e4d786a53081a60603551d2304819e30819b8014c77d8cc2211756259a7fd382df6be398e4d786a5a178a4763074310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e205669657731143012060355040a130b476f6f676c6520496e632e3110300e060355040b1307416e64726f69643110300e06035504031307416e64726f6964820900c2e08746644a308d300c0603551d13040530030101ff300d06092a864886f70d010104050003820101006dd252ceef85302c360aaace939bcff2cca904bb5d7a1661f8ae46b2994204d0ff4a68c7ed1a531ec4595a623ce60763b167297a7ae35712c407f208f0cb109429124d7b106219c084ca3eb3f9ad5fb871ef92269a8be28bf16d44c8d9a08e6cb2f005bb3fe2cb96447e868e731076ad45b33f6009ea19c161e62641aa99271dfd5228c5c587875ddb7f452758d661f6cc0cccb7352e424cc4365c523532f7325137593c4ae341f4db41edda0d0b1071a7c440f0fe9ea01cb627ca674369d084bd2fd911ff06cdbf2cfa10dc0f893ae35762919048c7efc64c7144178342f70581c9de573af55b390dd7fdb9418631895d5f759f30112687ff621410c069308a" />' chrome/android/java/AndroidManifest.xml

cp $SCRIPT_DIR/microg/MicroGAccountManagerDelegate.java components/signin/public/android/java/src/org/chromium/components/signin/
sed -i 's|"java/src/org/chromium/components/signin/NullAccountManagerDelegate.java",|&\n    "java/src/org/chromium/components/signin/MicroGAccountManagerDelegate.java",|' components/signin/public/android/BUILD.gn
sed -i '/AccountManagerDelegate delegate =/{N;N;N;N;s|AccountManagerDelegate delegate =.*|AccountManagerDelegate delegate = new MicroGAccountManagerDelegate();|;}' components/signin/public/android/java/src/org/chromium/components/signin/AccountManagerFacadeProvider.java

cp $SCRIPT_DIR/microg/MicroGTrustedVaultBackend.java components/trusted_vault/android/java/src/org/chromium/components/trusted_vault/
sed -i 's|"java/src/org/chromium/components/trusted_vault/TrustedVaultClient.java",|&\n    "java/src/org/chromium/components/trusted_vault/MicroGTrustedVaultBackend.java",|' components/trusted_vault/android/BUILD.gn
sed -i '/TrustedVaultClient.Backend backend =/{N;N;N;N;s|TrustedVaultClient.Backend backend =.*|TrustedVaultClient.Backend backend = new MicroGTrustedVaultBackend();|;}' components/trusted_vault/android/java/src/org/chromium/components/trusted_vault/TrustedVaultClient.java
sed -i '/public static @UserActionableError int getSyncError(/,/^    }/ s|return .*|return UserActionableError.NONE;\n    }|' chrome/android/java/src/org/chromium/chrome/browser/sync/settings/SyncSettingsUtils.java

sed -i '/seedThenReloadAllAccountsFromSystem(accounts, primaryAccountInfo\.getId());/{n;i\
        AccountInfo matchedByEmail = AccountUtils.findAccountByEmail(accounts, primaryAccountInfo.getEmail());\
        if (matchedByEmail != null) {\
            Log.i(TAG, "Primary account Gaia ID mismatch, but email found - keeping signed in (microG workaround)");\
            List<AccountInfo> reconciled = new ArrayList<>(accounts);\
            reconciled.set(reconciled.indexOf(matchedByEmail), primaryAccountInfo);\
            seedThenReloadAllAccountsFromSystem(reconciled, CoreAccountInfo.getIdFrom(primaryAccountInfo));\
            return;\
        }
}' chrome/browser/signin/services/android/java/src/org/chromium/chrome/browser/signin/services/SigninManagerImpl.java

sed -i 's|if (trigger_ == Trigger::kForcedReconcile) {|if (trigger_ == Trigger::kForcedReconcile \|\| trigger_ == Trigger::kEnableReconcile) {|' components/signin/core/browser/account_reconcilor.cc
sed -i 's|bool accounts_matching = user_info_copy\.account_id == account_info\.account_id;|bool accounts_matching = user_info_copy.account_id == account_info.account_id || (user_info_copy.email == account_info.email \&\& !account_info.email.empty());\n  if (accounts_matching \&\& user_info_copy.account_id != account_info.account_id) { user_info_copy.account_id = account_info.account_id; }|' components/signin/internal/identity_manager/account_tracker_service.cc

sed -i '/bool AreExtensionsPermissionsEnabled(Profile\* profile) {/,/^}/ s|return profile->IsChild();|return false;|' chrome/browser/supervised_user/supervised_user_browser_utils.cc
sed -i '/void ChildAccountService::Init() {/a\  if (identity_manager_->GetPrimaryAccountInfo(signin::ConsentLevel::kSignin).IsEmpty() \&\& IsSubjectToParentalControls(user_prefs_.get())) { DisableParentalControls(user_prefs_.get()); }' components/supervised_user/core/browser/child_account_service.cc

cp $SCRIPT_DIR/microg/NativeImageDecoder.java components/image_fetcher/android/java/src/org/chromium/components/image_fetcher/
cp $SCRIPT_DIR/microg/android_native_image_decoder.* chrome/browser/image_fetcher/
sed -i 's|"android/java/src/org/chromium/components/image_fetcher/ImageFetcherBridge.java",|&\n    "android/java/src/org/chromium/components/image_fetcher/NativeImageDecoder.java",|' components/image_fetcher/BUILD.gn
sed -i 's|if (is_android) {|if (is_android) {\n    sources += [\n      "android_native_image_decoder.cc",\n      "android_native_image_decoder.h",\n    ]\n    deps += [ "//components/image_fetcher:android" ]|' chrome/browser/image_fetcher/BUILD.gn
sed -i 's|#include "chrome/browser/image_fetcher/image_decoder_impl.h"|&\n#if BUILDFLAG(IS_ANDROID)\n#include "chrome/browser/image_fetcher/android_native_image_decoder.h"\n#endif|' chrome/browser/signin/identity_manager_factory.cc
sed -i 's|params\.image_decoder = std::make_unique<ImageDecoderImpl>();|#if BUILDFLAG(IS_ANDROID)\n  params.image_decoder = std::make_unique<AndroidNativeImageDecoder>();\n#else\n  params.image_decoder = std::make_unique<ImageDecoderImpl>();\n#endif|' chrome/browser/signin/identity_manager_factory.cc


sed -i 's|if (!_omit_dex) {|if (_is_base_module \&\& !_omit_dex) {|' build/config/android/rules.gni
sed -i '/safelyRemovePreference(prefFragment/d' titanium/chromium_src/chrome/browser/language/android/java/src/org/chromium/chrome/browser/language/settings/LanguageSettingsExt.java # language
sed -i '/safelyRemovePreference($/{N;/PREF_JAVASCRIPT_OPTIMIZER/d}' titanium/chromium_src/chrome/android/java/src/org/chromium/chrome/browser/privacy/settings/PrivacySettingsExt.java # optimizer
sed -i 's|if (!Intent\.ACTION_VIEW\.equals(intent\.getAction())) {|if (!Intent.ACTION_VIEW.equals(intent.getAction()) \|\| !android.webkit.URLUtil.isNetworkUrl(IntentHandler.getUrlFromIntent(intent))) {|' titanium/chromium_src/chrome/android/java/src/org/chromium/chrome/browser/LaunchIntentDispatcherHooks.java # scheme guard
sed -i 's|if (urlFromIntent == null) {|if (!android.webkit.URLUtil.isNetworkUrl(urlFromIntent)) {|' titanium/chromium_src/chrome/android/java/src/org/chromium/chrome/browser/LaunchIntentDispatcherHooks.java # scheme guard
sed -i 's|static Intent maybeModifyCustomTabIntents(Context context, Intent intent) {|static Intent maybeModifyCustomTabIntents(Context context, Intent intent) { if (!android.webkit.URLUtil.isNetworkUrl(IntentHandler.getUrlFromIntent(intent))) { return intent; }|' titanium/chromium_src/chrome/android/java/src/org/chromium/chrome/browser/LaunchIntentDispatcherHooks.java # scheme guard
sed -i 's|readBoolean(getSettingsPreferenceKey(moduleType), true)|readBoolean(getSettingsPreferenceKey(moduleType), !HomeModulesUtils.belongsToEducationalTipModule(moduleType))|' chrome/browser/magic_stack/android/java/src/org/chromium/chrome/browser/magic_stack/HomeModulesConfigManager.java # ntp

# sed -i 's|int ExpirationMilestoneForFlag(const char\* flag) {|int ExpirationMilestoneForFlag(const char* flag) { if ((true)) return -1;|' chrome/browser/unexpire_flags.cc
for flag in "align-wakeups" "android-bottom-bar" "cct-open-in-browser-button-if-allowed-by-embedder" "darken-websites-checkbox-in-themes-setting" "enable-accessibility-sequential-focus" "enforce-incognito-isolation" "inline-pdf-v2" "jump-start-omnibox" "offline-auto-fetch" "use-fullscreen-insets-api"; do
    sed -i "/\"name\": \"$flag\"/,/}/ s/\"expiry_milestone\": [0-9]\+/\"expiry_milestone\": -1/" chrome/browser/flag-metadata.json
done
sed -i 's|newFlag(OmniboxFeatureList.OMNIBOX_SITE_SEARCH, FeatureState.ENABLED_IN_TEST);|newFlag(OmniboxFeatureList.OMNIBOX_SITE_SEARCH, FeatureState.ENABLED_IN_PROD);|' components/omnibox/common/android/java/src/org/chromium/components/omnibox/OmniboxFeatures.java # search
sed -i 's|BASE_FEATURE(kOmniboxSiteSearch, DISABLED);|BASE_FEATURE(kOmniboxSiteSearch, ENABLED);|' components/omnibox/common/omnibox_features.cc # search

sed -i '/#if BUILDFLAG(IS_DESKTOP_ANDROID)/{
a\
feature_overrides.EnableFeature(chrome::android::kSubmenusInAppMenu);\
feature_overrides.EnableFeature(features::kAndroidDevToolsFrontend);\
feature_overrides.EnableFeature(kAndroidMediaPicker);\
feature_overrides.EnableFeature(features::kUserMediaScreenCapturing);\
feature_overrides.EnableFeature(media::kAndroidEnableBackgroundMediaCapturing);\
feature_overrides.EnableFeature(media::kAutoPictureInPictureAndroid);\
feature_overrides.EnableFeature(media::kContextMenuPictureInPictureAndroid);\
feature_overrides.EnableFeature(chrome::android::kLoadAllTabsAtStartup);\
feature_overrides.EnableFeature(chrome::android::kChromeNativeUrlOverriding);\
#if 0
d}' chrome/browser/chrome_browser_field_trials.cc
sed -i '/^bool ShouldFallbackToSWIfGLES3NotSupported() {$/,/^}$/ s|^  return true;$|  return false;|' ui/gl/gl_features.cc # virt

# accessibility
sed -i 's|ChromeAccessibilityUtil.get().isAccessibilityEnabled()|org.chromium.ui.accessibility.AccessibilityState.isComplexUserInteractionServiceEnabled() \|\| org.chromium.ui.accessibility.AccessibilityState.isTouchExplorationEnabled()|' chrome/android/java/src/org/chromium/chrome/browser/tab/TabStateBrowserControlsVisibilityDelegate.java
sed -i 's|AccessibilityState.isPerformGesturesEnabled()|(AccessibilityState.isComplexUserInteractionServiceEnabled() \|\| AccessibilityState.isTouchExplorationEnabled())|' chrome/browser/ui/messages/android/java/src/org/chromium/chrome/browser/ui/messages/snackbar/SnackbarManager.java

# dev
sed -i '/BASE_FEATURE(kTaskManagerClank,/,/);/ s/base::FEATURE_DISABLED_BY_DEFAULT/base::FEATURE_ENABLED_BY_DEFAULT/' chrome/browser/task_manager/common/task_manager_features.cc
sed -i 's|!DeviceFormFactor.isNonMultiDisplayContextOnTablet(mContext)|(false \&\& &)|' chrome/android/java/src/org/chromium/chrome/browser/tabbed_mode/MoreToolsItemBuilder.java
sed -i 's|boolean shouldShowDeveloperMenu() {|boolean shouldShowDeveloperMenu() { if (true) return DevToolsWindowAndroid.isDevToolsAllowedFor(getProfile(), mItemDelegate.getWebContents());|' chrome/android/java/src/org/chromium/chrome/browser/contextmenu/ChromeContextMenuPopulator.java
sed -i 's|TabUtils.isUsingDesktopUserAgent(mItemDelegate.getWebContents())|(true \|\| TabUtils.isUsingDesktopUserAgent(mItemDelegate.getWebContents()))|' chrome/android/java/src/org/chromium/chrome/browser/contextmenu/ChromeContextMenuPopulator.java

# playback
sed -i 's|#if BUILDFLAG(IS_ANDROID)|#if 0|' content/public/renderer/render_frame_media_playback_options.cc

# viewport
sed -i 's|<meta name="color-scheme" content="light dark">|&\n<meta name="viewport" content="width=device-width">|' chrome/browser/resources/extensions/extensions.html
sed -i 's|--extensions-card-width: 400px;|--extensions-card-width: 96%;|' chrome/browser/resources/extensions/item_list.css # card width
sed -i 's|--cr-toolbar-field-width: 680px;|--cr-toolbar-field-width: 96%;|' chrome/browser/resources/extensions/shared_vars.css # page content
sed -i 's|padding: 24px 60px 64px;|padding: 24px 0 64px;|' chrome/browser/resources/extensions/item_list.css # content wrapper
sed -i 's|touch-action: none;|touch-action: pan-y;|' chrome/browser/resources/extensions/toggle_row.css # scroll

# ext: mv2
sed -i 's|uncompiled_sources_ = \[|&\n  "browser_action.json",\n  "page_action.json",|' chrome/common/extensions/api/api_sources.gni
sed -i 's/api::webstore_private::MV2DeprecationStatus::kHardDisable)));/api::webstore_private::MV2DeprecationStatus::kNone)));/' extensions/browser/api/webstore_private/webstore_private_api.cc
sed -i 's/bool g_allow_mv2_for_testing = false;/bool g_allow_mv2_for_testing = true;/' extensions/browser/manifest_v2_handler.cc

# ext: off store
sed -i '/^bool OffStoreInstallAllowedByPrefs(/a\if (const auto\& o = item.GetRequestInitiator(); o \&\& o->scheme() == "chrome-extension") return true; for (const char* d : {"addons.opera.com", "operacdn.com", "microsoftedge.microsoft.com", "edge.microsoft.com", "delivery.mp.microsoft.com"}) if (item.GetURL().DomainIs(d) || item.GetReferrerUrl().DomainIs(d)) return true;' chrome/browser/download/download_crx_util.cc
# sed -i 's/bool g_allow_offstore_install_for_testing = false;/bool g_allow_offstore_install_for_testing = true;/' chrome/browser/download/download_crx_util.cc

# ext: toolbar
sed -i '/<ViewStub/{N;N;N;N;N;N; /optional_button_stub/a\
        <ViewStub\
            android:id="@+id/extensions_toolbar_container_stub"\
            android:inflatedId="@+id/extensions_toolbar_container"\
            android:layout_width="wrap_content"\
            android:layout_height="?attr/toolbarButtonHeight"\
            android:layout_marginVertical="?attr/toolbarButtonMarginVertical" />
}' chrome/browser/ui/android/toolbar/java/res/layout/toolbar_phone.xml
sed -i 's|(ToolbarTablet) mToolbarLayout,|mToolbarLayout,|' chrome/android/java/src/org/chromium/chrome/browser/toolbar/ToolbarManager.java
sed -i '/\/\/ Draw the signin button if visible./i\        { View extContainer = findViewById(R.id.extensions_toolbar_container); if (extContainer != null \&\& extContainer.getVisibility() != View.GONE \&\& extContainer.getWidth() != 0) { canvas.save(); ViewUtils.translateCanvasToView(mToolbarButtonsContainer, extContainer, canvas); extContainer.draw(canvas); canvas.restore(); } }' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/top/ToolbarPhone.java

# ext: popup
sed -i '/public class RecyclerViewDelegate {$/a\public View getContainerView() { return mContainer; }' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/extensions/ExtensionActionListCoordinator.java
sed -i '/private void showPopupOnAnchor() {/,/private void closePopup() {/ s|if (buttonView == null) {|if (false) {|' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/extensions/ExtensionActionListMediator.java # scoped to showPopupOnAnchor
sed -i 's|buttonView.setIsPressed(true);|if (buttonView != null) buttonView.setIsPressed(true);|' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/extensions/ExtensionActionListMediator.java
sed -i '/[[:space:]]mWindowAndroid,/!b;n;s|[[:space:]]buttonView,|buttonView != null ? buttonView : mRecyclerViewDelegate.getContainerView(),|' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/extensions/ExtensionActionListMediator.java # set popup anchor

# ext: fullscreen
sed -i 's|#include "base/android/jni_string.h"|&\n#include "ui/base/device_form_factor.h"|' chrome/browser/ui/android/extensions/extension_action_popup_contents.cc
sed -i 's|render_frame_host->GetView()->EnableAutoResize(kMinSize, kMaxSize);|if (ui::GetDeviceFormFactor() == ui::DEVICE_FORM_FACTOR_PHONE) return;\n&|' chrome/browser/ui/android/extensions/extension_action_popup_contents.cc
sed -i '/^void ExtensionActionPopupContents::OnLoaded() {$/,/^}$/ s|^}$|if (ui::GetDeviceFormFactor() == ui::DEVICE_FORM_FACTOR_PHONE) Java_ExtensionActionPopupContents_resizeDueToAutoResize(AttachCurrentThread(), java_object_, 100000, 100000);\n}|' chrome/browser/ui/android/extensions/extension_action_popup_contents.cc
sed -i 's|mPopupWindowAndroid =$|{ View decor = activity.getWindow().getDecorView(); webContents.setSize(decor.getWidth(), decor.getHeight()); }\n&|' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/extensions/ExtensionActionPopup.java

# ext: pin
sed -i '/Pref.PIN_EXTENSIONS_MENU_BUTTON, this::updateMenuButtonPinState);$/a\if (!mPrefService.getBoolean(Pref.PIN_EXTENSIONS_MENU_BUTTON)) { mContainer.findViewById(R.id.extensions_menu_button).setVisibility(View.GONE); }' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/extensions/ExtensionsToolbarCoordinatorImpl.java
sed -i '/"ExtensionsToolbarCoordinatorImpl.requestLayoutWithViewUtils()");$/a\if (!isMenuButtonPinned()) { mContainer.findViewById(R.id.extensions_menu_button).setVisibility(View.GONE); }' chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/extensions/ExtensionsToolbarCoordinatorImpl.java

# ext: incognito
sed -i 's|if (!context->IsOffTheRecord()) {|if (true) {|' extensions/browser/process_manager.cc
sed -i 's|public static boolean shouldOpenIncognitoAsWindow() {|public static boolean shouldOpenIncognitoAsWindow() { if (true) return true;|' chrome/browser/incognito/android/java/src/org/chromium/chrome/browser/incognito/IncognitoUtils.java

# ext: priority
sed -i 's|host_contents_->SetColorProviderSource(NoOpColorProviderSource::Get());|&\nhost_contents_->SetPrimaryPageImportance(content::ChildProcessImportance::IMPORTANT, content::ChildProcessImportance::NORMAL);|' extensions/browser/extension_host.cc

# ext: settings
sed -i '/content::WebContents\* web_contents = show_params->GetParentWebContents();/,/DCHECK(view_android);/{/GetParentWebContents/!d}' chrome/browser/ui/android/extensions/extension_install_dialog_view_android.cc
sed -i 's|view_android->GetWindowAndroid();|show_params->GetParentWindow();|' chrome/browser/ui/android/extensions/extension_install_dialog_view_android.cc
sed -i 's|"platforms": \["win", "mac"\]|"platforms": ["win", "mac", "desktop_android"]|' chrome/common/extensions/api/_manifest_features.json

# ext: dialog
sed -i 's|.with(ModalDialogProperties.FILTER_TOUCH_FOR_SECURITY, true)|.with(ModalDialogProperties.FILTER_TOUCH_FOR_SECURITY, false)|' chrome/browser/ui/android/extensions/java/src/org/chromium/chrome/browser/ui/extensions/ExtensionInstallDialogBridge.java

# ext: locale
sed -i 's|while (!(locale_path = locales.Next()).empty()) {|&if (locale_path.IsContentUri()) { locale_path = path.Append(locales.GetInfo().GetName()); }|' extensions/common/manifest_handlers/default_locale_handler.cc
sed -i 's|while (!(locale_folder = locales.Next()).empty()) {|&if (locale_folder.IsContentUri()) { locale_folder = locale_path.Append(locales.GetInfo().GetName()); }|' extensions/common/extension_l10n_util.cc
sed -i '/extension_l10n_util::ValidateExtensionLocales($/,/error) &&$/{s|extension_l10n_util::ValidateExtensionLocales(|(extension_path_.IsVirtualDocumentPath() \|\| &|;s|error) &&|error)) \&\&|}' extensions/browser/unpacked_installer.cc

# ext: ntp
if version_lt "$VERSION" "152.0.7969.0"; then
sed -i 's|import org.chromium.chrome.browser.url_constants.UrlConstantResolverFactory;|&\nimport org.chromium.chrome.browser.url_constants.UrlOverrideUtils;|' chrome/android/java/src/org/chromium/chrome/browser/ChromeTabbedActivity.java
sed -i 's|if (isTabNtp \&\& !currentTab.isNativePage()) {|if (isTabNtp \&\& !currentTab.isNativePage() \&\& !UrlOverrideUtils.isNtpOverrideEnabled() \&\& !UrlOverrideUtils.isWebUiNtpOverrideEnabled()) {|' chrome/android/java/src/org/chromium/chrome/browser/ChromeTabbedActivity.java
else
sed -i 's|if (isTabNtp \&\& !currentTab.isNativePage() \&\& !isTabWebUiNtp) {|if (isTabNtp \&\& !currentTab.isNativePage() \&\& !isTabWebUiNtp \&\& !UrlOverrideUtils.isNtpOverrideEnabled()) {|' chrome/android/java/src/org/chromium/chrome/browser/ChromeTabbedActivity.java
fi

# desktop: omnibox
sed -i 's/is_desktop_android = !!BUILDFLAG(IS_DESKTOP_ANDROID);/is_desktop_android = false;/' components/omnibox/browser/zero_suggest_verbatim_match_provider.cc
sed -i 's/is_android_mobile = is_android_any \&\& !is_android_desktop;/is_android_mobile = is_android_any \&\& is_android_desktop;/' components/omnibox/browser/autocomplete_result.cc
# sed -i 's|OmniboxCapabilities.hasDesktopExperience(context)|true|g' chrome/browser/ui/android/omnibox/java/src/org/chromium/chrome/browser/omnibox/FuseboxSessionState.java

# desktop: menu
sed -i 's|if (!IncognitoUtils.shouldOpenIncognitoAsWindow() \|\| is|if (!shouldShowNewIncognitoWindow() \|\| is|' chrome/android/java/src/org/chromium/chrome/browser/tabbed_mode/TabbedAppMenuPropertiesDelegate.java
sed -i 's|if (!separateIncognitoWindow \|\| is|if (!shouldShowNewIncognitoWindow() \|\| is|' chrome/android/java/src/org/chromium/chrome/browser/tabbed_mode/TabbedAppMenuPropertiesDelegate.java

# crbug.com/406136787: load unpacked
sed -i 's|assert treeId.equals(documentId);|&\n if ("com.android.externalstorage.documents".equals(mAuthority)) { String fastId = mRelativePath.isEmpty() ? treeId : (treeId.endsWith(":") ? treeId + mRelativePath : treeId + "/" + mRelativePath); Uri fast = DocumentsContract.buildDocumentUriUsingTree(tree, fastId); return contentUriExists(fast) ? fast : null; }|' base/android/java/src/org/chromium/base/VirtualDocumentPath.java

# crbug.com/445475304: incognito back
sed -i 's|private void onTabChanged(@Nullable Tab tab) {|private void onTabChanged(@Nullable Tab tab) { if (tab != null \&\& tab.isIncognitoBranded()) { mSystemBackPressSupplier.set(true); return; }|' chrome/browser/back_press/android/java/src/org/chromium/chrome/browser/back_press/MinimizeAppAndCloseTabBackPressHandler.java

# crbug.com/431004500: incognito uaf
sed -i '/for (int i = 0; i < tab_list->GetTabCount(); ++i) {/i if (!tab_list) { continue; }' chrome/browser/extensions/api/tabs/tabs_api.cc

# crbug.com/40274462: incognito uaf
sed -i '/CONTENT_EXPORT static WebContents\* FromRenderFrameHost(RenderFrameHost\* rfh);/a\CONTENT_EXPORT static bool HasLiveWebContentsForBrowserContext(BrowserContext* browser_context);' content/public/browser/web_contents.h
sed -i '/^WebContentsImpl::WebContentsImpl(BrowserContext\* browser_context)/i\ bool WebContents::HasLiveWebContentsForBrowserContext(BrowserContext* browser_context) { for (WebContentsImpl* web_contents : WebContentsImpl::GetAllWebContents()) { if (web_contents->GetBrowserContext() == browser_context) { return true; } } return false; }' content/browser/web_contents/web_contents_impl.cc
sed -i '/#include "content\/public\/browser\/render_process_host.h"/a#include "content/public/browser/web_contents.h"' chrome/browser/profiles/profile_destroyer.cc
sed -i '/^void ProfileDestroyer::DestroyOTRProfileWhenAppropriateWithTimeout($/,/MaybeSendDestroyedNotification/{/  profile->MaybeSendDestroyedNotification();/i\
if (content::WebContents::HasLiveWebContentsForBrowserContext(profile)) { return; }
}' chrome/browser/profiles/profile_destroyer.cc

# crbug.com/444024982: api 31
sed -i 's/|| mSupportedProfileType == SupportedProfileType.REGULAR) {/|| mSupportedProfileType == SupportedProfileType.REGULAR || mSupportedProfileType == SupportedProfileType.MIXED) {/' chrome/android/java/src/org/chromium/chrome/browser/ChromeTabbedActivity.java
sed -i 's/|| mSupportedProfileType == SupportedProfileType.OFF_THE_RECORD) {/|| mSupportedProfileType == SupportedProfileType.OFF_THE_RECORD || mSupportedProfileType == SupportedProfileType.MIXED) {/' chrome/android/java/src/org/chromium/chrome/browser/ChromeTabbedActivity.java

export PATCHED=1
