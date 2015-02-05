/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina - www.xs-labs.com
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *  -   Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *  -   Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *  -   Neither the name of 'Jean-David Gadina' nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/
 
/* $Id$ */

@interface CESystemIconsHelper: NSObject
{
@protected
    
    NSBundle * _bundle;
    
@private
    
    RESERVED_IVARS( CESystemIconsHelper , 5 );
}

+ ( CESystemIconsHelper * )sharedInstance;
- ( NSImage * )iconNamed: ( NSString * )name;

@end

FOUNDATION_EXPORT NSString * const CESystemIconAccounts;
FOUNDATION_EXPORT NSString * const CESystemIconActions;
FOUNDATION_EXPORT NSString * const CESystemIconAirDrop;
FOUNDATION_EXPORT NSString * const CESystemIconAlertCautionBadgeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconAlertCautionIcon;
FOUNDATION_EXPORT NSString * const CESystemIconAlertNoteIcon;
FOUNDATION_EXPORT NSString * const CESystemIconAlertStopIcon;
FOUNDATION_EXPORT NSString * const CESystemIconAliasBadgeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconApplicationsFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconBackwardArrowIcon;
FOUNDATION_EXPORT NSString * const CESystemIconBonjour;
FOUNDATION_EXPORT NSString * const CESystemIconBookmarkIcon;
FOUNDATION_EXPORT NSString * const CESystemIconBurnableFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconBurningIcon;
FOUNDATION_EXPORT NSString * const CESystemIconCDAudioVolumeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconClippingPicture;
FOUNDATION_EXPORT NSString * const CESystemIconClippingSound;
FOUNDATION_EXPORT NSString * const CESystemIconClippingText;
FOUNDATION_EXPORT NSString * const CESystemIconClippingUnknown;
FOUNDATION_EXPORT NSString * const CESystemIconClock;
FOUNDATION_EXPORT NSString * const CESystemIconColorSyncProfileIcon;
FOUNDATION_EXPORT NSString * const CESystemIconConnectToIcon;
FOUNDATION_EXPORT NSString * const CESystemIconDeleteAliasIcon;
FOUNDATION_EXPORT NSString * const CESystemIconDesktopFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconDeveloperFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconDocumentsFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconDownloadsFolder;
FOUNDATION_EXPORT NSString * const CESystemIconDropFolderBadgeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconDropFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconEjectMediaIcon;
FOUNDATION_EXPORT NSString * const CESystemIconErasingIcon;
FOUNDATION_EXPORT NSString * const CESystemIconEveryone;
FOUNDATION_EXPORT NSString * const CESystemIconExecutableBinaryIcon;
FOUNDATION_EXPORT NSString * const CESystemIconFavoriteItemsIcon;
FOUNDATION_EXPORT NSString * const CESystemIconFileVaultIcon;
FOUNDATION_EXPORT NSString * const CESystemIconFinderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconForwardArrowIcon;
FOUNDATION_EXPORT NSString * const CESystemIconFullTrashIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGeneral;
FOUNDATION_EXPORT NSString * const CESystemIconGenericAirDiskIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericApplicationIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericDocumentIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericFileServerIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericFontIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericNetworkIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericQuestionMarkIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericSharepoint;
FOUNDATION_EXPORT NSString * const CESystemIconGenericStationeryIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericTimeMachineDiskIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericURLIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericWindowIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGridIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGroupFolder;
FOUNDATION_EXPORT NSString * const CESystemIconGroupIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGuestUserIcon;
FOUNDATION_EXPORT NSString * const CESystemIconHelpIcon;
FOUNDATION_EXPORT NSString * const CESystemIconHomeFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationAFP;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationFTP;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationFile;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationGeneric;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationHTTP;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationMAILTO;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationNEWS;
FOUNDATION_EXPORT NSString * const CESystemIconInternetLocationVNC;
FOUNDATION_EXPORT NSString * const CESystemIconKEXT;
FOUNDATION_EXPORT NSString * const CESystemIconKeepArrangedIcon;
FOUNDATION_EXPORT NSString * const CESystemIconLibraryFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconLockedBadgeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconLockedIcon;
FOUNDATION_EXPORT NSString * const CESystemIconMagnifyingGlassIcon;
FOUNDATION_EXPORT NSString * const CESystemIconMobileMe;
FOUNDATION_EXPORT NSString * const CESystemIconMovieFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconMultipleItemsIcon;
FOUNDATION_EXPORT NSString * const CESystemIconMusicFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconNetBootVolume;
FOUNDATION_EXPORT NSString * const CESystemIconNewFolderBadgeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconNoWriteIcon;
FOUNDATION_EXPORT NSString * const CESystemIconOpenFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconPicturesFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconPrivateFolderBadgeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconPrivateFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconProfileBackgroundColor;
FOUNDATION_EXPORT NSString * const CESystemIconProfileFont;
FOUNDATION_EXPORT NSString * const CESystemIconProfileFontAndColor;
FOUNDATION_EXPORT NSString * const CESystemIconPublicFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconReadOnlyFolderBadgeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconReadOnlyFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconRecentItemsIcon;
FOUNDATION_EXPORT NSString * const CESystemIconRightContainerArrowIcon;
FOUNDATION_EXPORT NSString * const CESystemIconServerApplicationsFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarAirDrop;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarAirportDisk;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarAirportExpress;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarAirportExtreme;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarAllMyFiles;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarApplicationsFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarBonjour;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarBurnFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarDesktopFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarDisplay;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarDocumentsFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarDownloadsFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarDropBoxFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarExternalDisk;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarGenericFile;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarGenericFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarHomeFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarInternalDisk;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarLaptop;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarMacMini;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarMacPro;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarMoviesFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarMusicFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarNetwork;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarOpticalDisk;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarPC;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarPicturesFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarPrefs;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarRecents;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarRemovableDisk;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarServerDrive;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarSmartFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarTimeCapsule;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarTimeMachine;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarUtilitiesFolder;
FOUNDATION_EXPORT NSString * const CESystemIconSidebarXserve;
FOUNDATION_EXPORT NSString * const CESystemIconSidebariCloud;
FOUNDATION_EXPORT NSString * const CESystemIconSidebariDisk;
FOUNDATION_EXPORT NSString * const CESystemIconSidebariMac;
FOUNDATION_EXPORT NSString * const CESystemIconSidebariPad;
FOUNDATION_EXPORT NSString * const CESystemIconSidebariPhone;
FOUNDATION_EXPORT NSString * const CESystemIconSidebariPodTouch;
FOUNDATION_EXPORT NSString * const CESystemIconSitesFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconSmartFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconStatusBarCDROMIcon;
FOUNDATION_EXPORT NSString * const CESystemIconStatusBarTrashIcon;
FOUNDATION_EXPORT NSString * const CESystemIconSync;
FOUNDATION_EXPORT NSString * const CESystemIconSystemFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarAdvanced;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarAppsFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarCustomizeIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarDeleteIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarDesktopFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarDocumentsFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarDownloadsFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarFavoritesIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarInfo;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarLabels;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarLibraryFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarMovieFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarMusicFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarPicturesFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarPublicFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarSitesFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconToolbarUtilitiesFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconTrashIcon;
FOUNDATION_EXPORT NSString * const CESystemIconUnknownFSObjectIcon;
FOUNDATION_EXPORT NSString * const CESystemIconUnlockedIcon;
FOUNDATION_EXPORT NSString * const CESystemIconUnsupported;
FOUNDATION_EXPORT NSString * const CESystemIconUserIcon;
FOUNDATION_EXPORT NSString * const CESystemIconUserUnknownIcon;
FOUNDATION_EXPORT NSString * const CESystemIconUsersFolderIcon;
FOUNDATION_EXPORT NSString * const CESystemIconUtilitiesFolder;
FOUNDATION_EXPORT NSString * const CESystemIconVCard;
FOUNDATION_EXPORT NSString * const CESystemIconAirportExpress;
FOUNDATION_EXPORT NSString * const CESystemIconAirportExtreme;
FOUNDATION_EXPORT NSString * const CESystemIconAppleTv;
FOUNDATION_EXPORT NSString * const CESystemIconCinemaDisplay;
FOUNDATION_EXPORT NSString * const CESystemIconEmac;
FOUNDATION_EXPORT NSString * const CESystemIconIbookG412;
FOUNDATION_EXPORT NSString * const CESystemIconIbookG414;
FOUNDATION_EXPORT NSString * const CESystemIconImacAluminum20;
FOUNDATION_EXPORT NSString * const CESystemIconImacAluminum24;
FOUNDATION_EXPORT NSString * const CESystemIconImacG415;
FOUNDATION_EXPORT NSString * const CESystemIconImacG417;
FOUNDATION_EXPORT NSString * const CESystemIconImacG420;
FOUNDATION_EXPORT NSString * const CESystemIconImacG517;
FOUNDATION_EXPORT NSString * const CESystemIconImacG520;
FOUNDATION_EXPORT NSString * const CESystemIconImacISight17;
FOUNDATION_EXPORT NSString * const CESystemIconImacISight20;
FOUNDATION_EXPORT NSString * const CESystemIconImacISight24;
FOUNDATION_EXPORT NSString * const CESystemIconImacUnibody21;
FOUNDATION_EXPORT NSString * const CESystemIconImacUnibody27;
FOUNDATION_EXPORT NSString * const CESystemIconIpad;
FOUNDATION_EXPORT NSString * const CESystemIconIphone3g;
FOUNDATION_EXPORT NSString * const CESystemIconIphone4Black;
FOUNDATION_EXPORT NSString * const CESystemIconIphone4White;
FOUNDATION_EXPORT NSString * const CESystemIconIphone;
FOUNDATION_EXPORT NSString * const CESystemIconIpodTouch2;
FOUNDATION_EXPORT NSString * const CESystemIconIpodTouch4Black;
FOUNDATION_EXPORT NSString * const CESystemIconIpodTouch4;
FOUNDATION_EXPORT NSString * const CESystemIconIpodTouch;
FOUNDATION_EXPORT NSString * const CESystemIconLedCinemaDisplay24;
FOUNDATION_EXPORT NSString * const CESystemIconLedCinemaDisplay27;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookBlack;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookUnibodyPlastic;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookUnibody;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookWhite;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookair11Unibody;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookair13Unibody;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookair;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookpro13Unibody;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookpro15Unibody;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookpro15;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookpro17Unibody;
FOUNDATION_EXPORT NSString * const CESystemIconMacbookpro17;
FOUNDATION_EXPORT NSString * const CESystemIconMacminiServer;
FOUNDATION_EXPORT NSString * const CESystemIconMacminiUnibodyNoOptical;
FOUNDATION_EXPORT NSString * const CESystemIconMacminiUnibody;
FOUNDATION_EXPORT NSString * const CESystemIconMacmini;
FOUNDATION_EXPORT NSString * const CESystemIconMacpro;
FOUNDATION_EXPORT NSString * const CESystemIconPowerbookG412;
FOUNDATION_EXPORT NSString * const CESystemIconPowerbookG415;
FOUNDATION_EXPORT NSString * const CESystemIconPowerbookG417;
FOUNDATION_EXPORT NSString * const CESystemIconPowerbookG4Titanium;
FOUNDATION_EXPORT NSString * const CESystemIconPowermacG4Graphite;
FOUNDATION_EXPORT NSString * const CESystemIconPowermacG4MirroredDriveDoors;
FOUNDATION_EXPORT NSString * const CESystemIconPowermacG4Quicksilver;
FOUNDATION_EXPORT NSString * const CESystemIconPowermacG5;
FOUNDATION_EXPORT NSString * const CESystemIconTimeCapsule;
FOUNDATION_EXPORT NSString * const CESystemIconXserveG4;
FOUNDATION_EXPORT NSString * const CESystemIconXserve;
FOUNDATION_EXPORT NSString * const CESystemIconIDiskGenericIcon;
FOUNDATION_EXPORT NSString * const CESystemIconIDiskUserIcon;
FOUNDATION_EXPORT NSString * const CESystemIconGenericPc;
