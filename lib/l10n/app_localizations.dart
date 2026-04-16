import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Kamrai POS'**
  String get appTitle;

  /// No description provided for @appNameNav.
  ///
  /// In en, this message translates to:
  /// **'Kamrai POS'**
  String get appNameNav;

  /// No description provided for @navPrinter.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get navPrinter;

  /// No description provided for @navDrawer.
  ///
  /// In en, this message translates to:
  /// **'Drawer'**
  String get navDrawer;

  /// No description provided for @navSystemStable.
  ///
  /// In en, this message translates to:
  /// **'System Stable'**
  String get navSystemStable;

  /// No description provided for @branchSampleName.
  ///
  /// In en, this message translates to:
  /// **'Branch A'**
  String get branchSampleName;

  /// No description provided for @userRoleStoreManager.
  ///
  /// In en, this message translates to:
  /// **'Store Manager'**
  String get userRoleStoreManager;

  /// No description provided for @userCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Kamrai Headquarters'**
  String get userCompanyName;

  /// No description provided for @userInitials.
  ///
  /// In en, this message translates to:
  /// **'SM'**
  String get userInitials;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Manager'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a service to manage today'**
  String get welcomeSubtitle;

  /// No description provided for @modulePosTitle.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get modulePosTitle;

  /// No description provided for @modulePosDescription.
  ///
  /// In en, this message translates to:
  /// **'Open food sales, pick tables, and check out'**
  String get modulePosDescription;

  /// No description provided for @modulePosBadge.
  ///
  /// In en, this message translates to:
  /// **'5 Unpaid Bills'**
  String get modulePosBadge;

  /// No description provided for @moduleTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Table Management'**
  String get moduleTableTitle;

  /// No description provided for @moduleTableDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage floor plan by zone and table status'**
  String get moduleTableDescription;

  /// No description provided for @moduleTableBadge.
  ///
  /// In en, this message translates to:
  /// **'12/24 Available'**
  String get moduleTableBadge;

  /// No description provided for @moduleMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu & Buffet'**
  String get moduleMenuTitle;

  /// No description provided for @moduleMenuDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure A-La-Carte, sets, and buffet packages'**
  String get moduleMenuDescription;

  /// No description provided for @moduleMenuBadge.
  ///
  /// In en, this message translates to:
  /// **'Standard List'**
  String get moduleMenuBadge;

  /// No description provided for @moduleInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory & Stock'**
  String get moduleInventoryTitle;

  /// No description provided for @moduleInventoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Check ingredient stock, expiry, and receiving'**
  String get moduleInventoryDescription;

  /// No description provided for @moduleInventoryBadge.
  ///
  /// In en, this message translates to:
  /// **'3 Items Low Stock'**
  String get moduleInventoryBadge;

  /// No description provided for @moduleLoyaltyTitle.
  ///
  /// In en, this message translates to:
  /// **'Loyalty & CRM'**
  String get moduleLoyaltyTitle;

  /// No description provided for @moduleLoyaltyDescription.
  ///
  /// In en, this message translates to:
  /// **'Customer data and centralized points history'**
  String get moduleLoyaltyDescription;

  /// No description provided for @moduleLoyaltyBadge.
  ///
  /// In en, this message translates to:
  /// **'2,450 Members'**
  String get moduleLoyaltyBadge;

  /// No description provided for @moduleEnterpriseTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise & Branch'**
  String get moduleEnterpriseTitle;

  /// No description provided for @moduleEnterpriseDescription.
  ///
  /// In en, this message translates to:
  /// **'Company, branches, tax, and permissions'**
  String get moduleEnterpriseDescription;

  /// No description provided for @moduleEnterpriseBadge.
  ///
  /// In en, this message translates to:
  /// **'Global Settings'**
  String get moduleEnterpriseBadge;

  /// No description provided for @moduleHardwareTitle.
  ///
  /// In en, this message translates to:
  /// **'Hardware Settings'**
  String get moduleHardwareTitle;

  /// No description provided for @moduleHardwareDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect printers and cash drawer'**
  String get moduleHardwareDescription;

  /// No description provided for @moduleSalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get moduleSalesTitle;

  /// No description provided for @moduleSalesDescription.
  ///
  /// In en, this message translates to:
  /// **'Sales by channel and GP'**
  String get moduleSalesDescription;

  /// No description provided for @moduleSalesBadge.
  ///
  /// In en, this message translates to:
  /// **'+12.5% Today'**
  String get moduleSalesBadge;

  /// No description provided for @footerPremiumTag.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM EXPERIENCE'**
  String get footerPremiumTag;

  /// No description provided for @footerPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'The Ethereal Merchant POS'**
  String get footerPremiumTitle;

  /// No description provided for @footerPremiumBody.
  ///
  /// In en, this message translates to:
  /// **'Elevate store operations with the smoothest,\nmost modern POS—built for today’s business.'**
  String get footerPremiumBody;

  /// No description provided for @footerLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get footerLearnMore;

  /// No description provided for @footerSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get footerSupportTitle;

  /// No description provided for @footerSupportBody.
  ///
  /// In en, this message translates to:
  /// **'Having trouble? Reach our experts anytime.'**
  String get footerSupportBody;

  /// No description provided for @footerContactStaff.
  ///
  /// In en, this message translates to:
  /// **'Contact staff'**
  String get footerContactStaff;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @tablesFloorPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Table map'**
  String get tablesFloorPlanTitle;

  /// No description provided for @tablesStatAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get tablesStatAvailable;

  /// No description provided for @tablesStatOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get tablesStatOccupied;

  /// No description provided for @tablesStatCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get tablesStatCleaning;

  /// No description provided for @tablesAllZones.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tablesAllZones;

  /// No description provided for @tablesAddZone.
  ///
  /// In en, this message translates to:
  /// **'Add zone'**
  String get tablesAddZone;

  /// No description provided for @tablesAvailOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{avail} of {total} available'**
  String tablesAvailOfTotal(int avail, int total);

  /// No description provided for @tablesSeatsUnit.
  ///
  /// In en, this message translates to:
  /// **'seats'**
  String get tablesSeatsUnit;

  /// No description provided for @tablesGuestCount.
  ///
  /// In en, this message translates to:
  /// **'{guests}/{capacity} guests'**
  String tablesGuestCount(int guests, int capacity);

  /// No description provided for @tablesBuffetRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining {time}'**
  String tablesBuffetRemaining(String time);

  /// No description provided for @tablesTimeUp.
  ///
  /// In en, this message translates to:
  /// **'Time’s up'**
  String get tablesTimeUp;

  /// No description provided for @tablesBuffet.
  ///
  /// In en, this message translates to:
  /// **'Buffet'**
  String get tablesBuffet;

  /// No description provided for @tablesBuffetExpired.
  ///
  /// In en, this message translates to:
  /// **'Buffet — time’s up!'**
  String get tablesBuffetExpired;

  /// No description provided for @tablesAlaCarte.
  ///
  /// In en, this message translates to:
  /// **'A-La-Carte'**
  String get tablesAlaCarte;

  /// No description provided for @tablesStatusOccupiedBuffet.
  ///
  /// In en, this message translates to:
  /// **'Occupied • Buffet'**
  String get tablesStatusOccupiedBuffet;

  /// No description provided for @tablesStatusOccupiedAlaCarte.
  ///
  /// In en, this message translates to:
  /// **'Occupied • A-La-Carte'**
  String get tablesStatusOccupiedAlaCarte;

  /// No description provided for @tablesOpenBillAlaCarte.
  ///
  /// In en, this message translates to:
  /// **'Open A-La-Carte bill'**
  String get tablesOpenBillAlaCarte;

  /// No description provided for @tablesOpenBillAlaCarteSub.
  ///
  /// In en, this message translates to:
  /// **'Order à la carte'**
  String get tablesOpenBillAlaCarteSub;

  /// No description provided for @tablesOpenBillBuffet.
  ///
  /// In en, this message translates to:
  /// **'Open buffet bill'**
  String get tablesOpenBillBuffet;

  /// No description provided for @tablesOpenBillBuffetSub.
  ///
  /// In en, this message translates to:
  /// **'Choose a buffet package'**
  String get tablesOpenBillBuffetSub;

  /// No description provided for @tablesShowQrOrder.
  ///
  /// In en, this message translates to:
  /// **'Show self-order QR'**
  String get tablesShowQrOrder;

  /// No description provided for @tablesShowQrOrderSub.
  ///
  /// In en, this message translates to:
  /// **'Guests scan to order'**
  String get tablesShowQrOrderSub;

  /// No description provided for @tablesViewCurrentBill.
  ///
  /// In en, this message translates to:
  /// **'View current bill'**
  String get tablesViewCurrentBill;

  /// No description provided for @tablesViewCurrentBillSub.
  ///
  /// In en, this message translates to:
  /// **'Open order taking'**
  String get tablesViewCurrentBillSub;

  /// No description provided for @tablesMoveTable.
  ///
  /// In en, this message translates to:
  /// **'Move table'**
  String get tablesMoveTable;

  /// No description provided for @tablesMoveTableSub.
  ///
  /// In en, this message translates to:
  /// **'Move this bill to another table'**
  String get tablesMoveTableSub;

  /// No description provided for @tablesMergeTables.
  ///
  /// In en, this message translates to:
  /// **'Merge tables'**
  String get tablesMergeTables;

  /// No description provided for @tablesMergeTablesSub.
  ///
  /// In en, this message translates to:
  /// **'Combine with another bill'**
  String get tablesMergeTablesSub;

  /// No description provided for @tablesSetCleaning.
  ///
  /// In en, this message translates to:
  /// **'Start cleaning'**
  String get tablesSetCleaning;

  /// No description provided for @tablesSetCleaningSub.
  ///
  /// In en, this message translates to:
  /// **'After guests have paid'**
  String get tablesSetCleaningSub;

  /// No description provided for @tablesMarkReady.
  ///
  /// In en, this message translates to:
  /// **'Ready — mark available'**
  String get tablesMarkReady;

  /// No description provided for @tablesMarkReadySub.
  ///
  /// In en, this message translates to:
  /// **'Clean and ready for guests'**
  String get tablesMarkReadySub;

  /// No description provided for @tablesOpenBillSkipClean.
  ///
  /// In en, this message translates to:
  /// **'Open new bill now'**
  String get tablesOpenBillSkipClean;

  /// No description provided for @tablesOpenBillSkipCleanSub.
  ///
  /// In en, this message translates to:
  /// **'Skip cleaning step'**
  String get tablesOpenBillSkipCleanSub;

  /// No description provided for @deviceTypePrinter.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get deviceTypePrinter;

  /// No description provided for @deviceTypeCashDrawer.
  ///
  /// In en, this message translates to:
  /// **'Cash drawer'**
  String get deviceTypeCashDrawer;

  /// No description provided for @deviceTypePrinterWithDrawer.
  ///
  /// In en, this message translates to:
  /// **'Printer + drawer'**
  String get deviceTypePrinterWithDrawer;

  /// No description provided for @connectTypeNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get connectTypeNetwork;

  /// No description provided for @connectTypeUsb.
  ///
  /// In en, this message translates to:
  /// **'USB'**
  String get connectTypeUsb;

  /// No description provided for @connectTypeBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get connectTypeBluetooth;

  /// No description provided for @connectSublabelTcpIp.
  ///
  /// In en, this message translates to:
  /// **'TCP/IP'**
  String get connectSublabelTcpIp;

  /// No description provided for @connectSublabelDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get connectSublabelDirect;

  /// No description provided for @connectSublabelBt40.
  ///
  /// In en, this message translates to:
  /// **'BT 4.0'**
  String get connectSublabelBt40;

  /// No description provided for @deviceStatusOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get deviceStatusOnline;

  /// No description provided for @deviceStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get deviceStatusOffline;

  /// No description provided for @deviceStatusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get deviceStatusConnecting;

  /// No description provided for @paperWidth58.
  ///
  /// In en, this message translates to:
  /// **'58 mm'**
  String get paperWidth58;

  /// No description provided for @paperWidth80.
  ///
  /// In en, this message translates to:
  /// **'80 mm'**
  String get paperWidth80;

  /// No description provided for @hardwareOnlineCount.
  ///
  /// In en, this message translates to:
  /// **'{online}/{total} online'**
  String hardwareOnlineCount(int online, int total);

  /// No description provided for @hardwareAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Add device'**
  String get hardwareAddDevice;

  /// No description provided for @hardwareAllDevices.
  ///
  /// In en, this message translates to:
  /// **'All devices'**
  String get hardwareAllDevices;

  /// No description provided for @hardwareNewDevice.
  ///
  /// In en, this message translates to:
  /// **'New device'**
  String get hardwareNewDevice;

  /// No description provided for @hardwareUnnamedDevice.
  ///
  /// In en, this message translates to:
  /// **'Unnamed device'**
  String get hardwareUnnamedDevice;

  /// No description provided for @hardwareSectionNameAndType.
  ///
  /// In en, this message translates to:
  /// **'Device name & type'**
  String get hardwareSectionNameAndType;

  /// No description provided for @hardwareDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get hardwareDeviceName;

  /// No description provided for @hardwareDeviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main kitchen printer'**
  String get hardwareDeviceNameHint;

  /// No description provided for @hardwareOutputType.
  ///
  /// In en, this message translates to:
  /// **'Device type'**
  String get hardwareOutputType;

  /// No description provided for @hardwareConnectSection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get hardwareConnectSection;

  /// No description provided for @hardwarePrinterSettings.
  ///
  /// In en, this message translates to:
  /// **'Printer settings'**
  String get hardwarePrinterSettings;

  /// No description provided for @hardwarePaperSize.
  ///
  /// In en, this message translates to:
  /// **'Paper width'**
  String get hardwarePaperSize;

  /// No description provided for @hardwareEncodingCp874.
  ///
  /// In en, this message translates to:
  /// **'CP874 (Thai)'**
  String get hardwareEncodingCp874;

  /// No description provided for @hardwareAutoCutter.
  ///
  /// In en, this message translates to:
  /// **'Auto cutter'**
  String get hardwareAutoCutter;

  /// No description provided for @hardwareAutoCutterSub.
  ///
  /// In en, this message translates to:
  /// **'Cut paper automatically after printing'**
  String get hardwareAutoCutterSub;

  /// No description provided for @hardwareBuzzer.
  ///
  /// In en, this message translates to:
  /// **'Order buzzer'**
  String get hardwareBuzzer;

  /// No description provided for @hardwareBuzzerSub.
  ///
  /// In en, this message translates to:
  /// **'Beep when a new order arrives'**
  String get hardwareBuzzerSub;

  /// No description provided for @hardwarePrintRouting.
  ///
  /// In en, this message translates to:
  /// **'Print routing'**
  String get hardwarePrintRouting;

  /// No description provided for @hardwarePrintRoutingHint.
  ///
  /// In en, this message translates to:
  /// **'Choose categories to print on this device'**
  String get hardwarePrintRoutingHint;

  /// No description provided for @hardwareEnableDevice.
  ///
  /// In en, this message translates to:
  /// **'Enable device'**
  String get hardwareEnableDevice;

  /// No description provided for @hardwareEnableDeviceSub.
  ///
  /// In en, this message translates to:
  /// **'Turn off to pause print jobs temporarily'**
  String get hardwareEnableDeviceSub;

  /// No description provided for @hardwareTestPrint.
  ///
  /// In en, this message translates to:
  /// **'Test print'**
  String get hardwareTestPrint;

  /// No description provided for @hardwareDeleteDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete device'**
  String get hardwareDeleteDevice;

  /// No description provided for @hardwareDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete device'**
  String get hardwareDeleteTitle;

  /// No description provided for @hardwareDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String hardwareDeleteConfirm(String name);

  /// No description provided for @hardwareLabelIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get hardwareLabelIpAddress;

  /// No description provided for @hardwareHintIp.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.xxx'**
  String get hardwareHintIp;

  /// No description provided for @hardwareLabelPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get hardwareLabelPort;

  /// No description provided for @hardwareHintPort.
  ///
  /// In en, this message translates to:
  /// **'9100'**
  String get hardwareHintPort;

  /// No description provided for @hardwareLabelUsbPath.
  ///
  /// In en, this message translates to:
  /// **'USB device path'**
  String get hardwareLabelUsbPath;

  /// No description provided for @hardwareHintUsb.
  ///
  /// In en, this message translates to:
  /// **'/dev/usb/lp0'**
  String get hardwareHintUsb;

  /// No description provided for @hardwareScanUsb.
  ///
  /// In en, this message translates to:
  /// **'Scan USB'**
  String get hardwareScanUsb;

  /// No description provided for @hardwareLabelBtAddress.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth address'**
  String get hardwareLabelBtAddress;

  /// No description provided for @hardwareHintBt.
  ///
  /// In en, this message translates to:
  /// **'AA:BB:CC:DD:EE:FF'**
  String get hardwareHintBt;

  /// No description provided for @hardwareScanBt.
  ///
  /// In en, this message translates to:
  /// **'Scan Bluetooth'**
  String get hardwareScanBt;

  /// No description provided for @hardwareTestPrintSuccess.
  ///
  /// In en, this message translates to:
  /// **'Print job sent'**
  String get hardwareTestPrintSuccess;

  /// No description provided for @hardwareTestPrintSending.
  ///
  /// In en, this message translates to:
  /// **'Sending print job…'**
  String get hardwareTestPrintSending;

  /// No description provided for @hardwareTestPrintDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Test print'**
  String get hardwareTestPrintDialogTitle;

  /// No description provided for @hardwareTestPrintCheckPaper.
  ///
  /// In en, this message translates to:
  /// **'Check the paper from {name}'**
  String hardwareTestPrintCheckPaper(String name);

  /// No description provided for @hardwareTestPrintDeviceLine.
  ///
  /// In en, this message translates to:
  /// **'Device: {name}'**
  String hardwareTestPrintDeviceLine(String name);

  /// No description provided for @hardwarePrintTestAction.
  ///
  /// In en, this message translates to:
  /// **'Print test'**
  String get hardwarePrintTestAction;

  /// No description provided for @hardwareScanDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan for devices'**
  String get hardwareScanDialogTitle;

  /// No description provided for @hardwareScanningNetwork.
  ///
  /// In en, this message translates to:
  /// **'Scanning network…'**
  String get hardwareScanningNetwork;

  /// No description provided for @hardwareScanningUsb.
  ///
  /// In en, this message translates to:
  /// **'Scanning USB…'**
  String get hardwareScanningUsb;

  /// No description provided for @hardwareScanningBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Scanning Bluetooth…'**
  String get hardwareScanningBluetooth;

  /// No description provided for @hardwareDevicesFoundNone.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get hardwareDevicesFoundNone;

  /// No description provided for @hardwareDevicesFoundCount.
  ///
  /// In en, this message translates to:
  /// **'Found {count} devices'**
  String hardwareDevicesFoundCount(int count);

  /// No description provided for @hardwareEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No devices yet'**
  String get hardwareEmptyTitle;

  /// No description provided for @hardwareEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a printer or cash drawer to get started'**
  String get hardwareEmptySubtitle;

  /// No description provided for @hardwareEmptyAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add first device'**
  String get hardwareEmptyAddFirst;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
