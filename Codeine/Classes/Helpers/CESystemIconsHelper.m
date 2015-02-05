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

#import "CESystemIconsHelper.h"

static CESystemIconsHelper *        __sharedInstance    = nil;
static NSString            * const  __bundlePath        = @"/System/Library/CoreServices/CoreTypes.bundle";

@implementation CESystemIconsHelper

+ ( CESystemIconsHelper * )sharedInstance
{
    @synchronized( self )
    {
        if( __sharedInstance == nil )
        {
            __sharedInstance = [ [ super allocWithZone: NULL ] init ];
        }
    }
    
    return __sharedInstance;
}

+ ( id )allocWithZone:( NSZone * )zone
{
    ( void )zone;
    
    @synchronized( self )
    {
        return [ [ self sharedInstance ] retain ];
    }
}

- ( id )copyWithZone:( NSZone * )zone
{
    ( void )zone;
    
    return self;
}

- ( id )retain
{
    return self;
}

- ( NSUInteger )retainCount
{
    return UINT_MAX;
}

- ( oneway void )release
{}

- ( id )autorelease
{
    return self;
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        _bundle = [ [ NSBundle bundleWithPath: __bundlePath ] retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _bundle );
    
    [ super dealloc ];
}

- ( NSImage * )iconNamed: ( NSString * )name
{
    NSString * path;
    NSImage  * image;
    
    path  = [ _bundle pathForImageResource: name ];
    image = [ [ NSImage alloc ] initWithContentsOfFile: path ];
    
    return [ image autorelease ];
}

@end

NSString * const CESystemIconAccounts                     = @"Accounts.icns";
NSString * const CESystemIconActions                      = @"Actions.icns";
NSString * const CESystemIconAirDrop                      = @"AirDrop.icns";
NSString * const CESystemIconAlertCautionBadgeIcon        = @"AlertCautionBadgeIcon.icns";
NSString * const CESystemIconAlertCautionIcon             = @"AlertCautionIcon.icns";
NSString * const CESystemIconAlertNoteIcon                = @"AlertNoteIcon.icns";
NSString * const CESystemIconAlertStopIcon                = @"AlertStopIcon.icns";
NSString * const CESystemIconAliasBadgeIcon               = @"AliasBadgeIcon.icns";
NSString * const CESystemIconApplicationsFolderIcon       = @"ApplicationsFolderIcon.icns";
NSString * const CESystemIconBackwardArrowIcon            = @"BackwardArrowIcon.icns";
NSString * const CESystemIconBonjour                      = @"Bonjour.icns";
NSString * const CESystemIconBookmarkIcon                 = @"BookmarkIcon.icns";
NSString * const CESystemIconBurnableFolderIcon           = @"BurnableFolderIcon.icns";
NSString * const CESystemIconBurningIcon                  = @"BurningIcon.icns";
NSString * const CESystemIconCDAudioVolumeIcon            = @"CDAudioVolumeIcon.icns";
NSString * const CESystemIconClippingPicture              = @"ClippingPicture.icns";
NSString * const CESystemIconClippingSound                = @"ClippingSound.icns";
NSString * const CESystemIconClippingText                 = @"ClippingText.icns";
NSString * const CESystemIconClippingUnknown              = @"ClippingUnknown.icns";
NSString * const CESystemIconClock                        = @"Clock.icns";
NSString * const CESystemIconColorSyncProfileIcon         = @"ColorSyncProfileIcon.icns";
NSString * const CESystemIconConnectToIcon                = @"ConnectToIcon.icns";
NSString * const CESystemIconDeleteAliasIcon              = @"DeleteAliasIcon.icns";
NSString * const CESystemIconDesktopFolderIcon            = @"DesktopFolderIcon.icns";
NSString * const CESystemIconDeveloperFolderIcon          = @"DeveloperFolderIcon.icns";
NSString * const CESystemIconDocumentsFolderIcon          = @"DocumentsFolderIcon.icns";
NSString * const CESystemIconDownloadsFolder              = @"DownloadsFolder.icns";
NSString * const CESystemIconDropFolderBadgeIcon          = @"DropFolderBadgeIcon.icns";
NSString * const CESystemIconDropFolderIcon               = @"DropFolderIcon.icns";
NSString * const CESystemIconEjectMediaIcon               = @"EjectMediaIcon.icns";
NSString * const CESystemIconErasingIcon                  = @"ErasingIcon.icns";
NSString * const CESystemIconEveryone                     = @"Everyone.icns";
NSString * const CESystemIconExecutableBinaryIcon         = @"ExecutableBinaryIcon.icns";
NSString * const CESystemIconFavoriteItemsIcon            = @"FavoriteItemsIcon.icns";
NSString * const CESystemIconFileVaultIcon                = @"FileVaultIcon.icns";
NSString * const CESystemIconFinderIcon                   = @"FinderIcon.icns";
NSString * const CESystemIconForwardArrowIcon             = @"ForwardArrowIcon.icns";
NSString * const CESystemIconFullTrashIcon                = @"FullTrashIcon.icns";
NSString * const CESystemIconGeneral                      = @"General.icns";
NSString * const CESystemIconGenericAirDiskIcon           = @"GenericAirDiskIcon.icns";
NSString * const CESystemIconGenericApplicationIcon       = @"GenericApplicationIcon.icns";
NSString * const CESystemIconGenericDocumentIcon          = @"GenericDocumentIcon.icns";
NSString * const CESystemIconGenericFileServerIcon        = @"GenericFileServerIcon.icns";
NSString * const CESystemIconGenericFolderIcon            = @"GenericFolderIcon.icns";
NSString * const CESystemIconGenericFontIcon              = @"GenericFontIcon.icns";
NSString * const CESystemIconGenericNetworkIcon           = @"GenericNetworkIcon.icns";
NSString * const CESystemIconGenericQuestionMarkIcon      = @"GenericQuestionMarkIcon.icns";
NSString * const CESystemIconGenericSharepoint            = @"GenericSharepoint.icns";
NSString * const CESystemIconGenericStationeryIcon        = @"GenericStationeryIcon.icns";
NSString * const CESystemIconGenericTimeMachineDiskIcon   = @"GenericTimeMachineDiskIcon.icns";
NSString * const CESystemIconGenericURLIcon               = @"GenericURLIcon.icns";
NSString * const CESystemIconGenericWindowIcon            = @"GenericWindowIcon.icns";
NSString * const CESystemIconGridIcon                     = @"GridIcon.icns";
NSString * const CESystemIconGroupFolder                  = @"GroupFolder.icns";
NSString * const CESystemIconGroupIcon                    = @"GroupIcon.icns";
NSString * const CESystemIconGuestUserIcon                = @"GuestUserIcon.icns";
NSString * const CESystemIconHelpIcon                     = @"HelpIcon.icns";
NSString * const CESystemIconHomeFolderIcon               = @"HomeFolderIcon.icns";
NSString * const CESystemIconInternetLocationAFP          = @"InternetLocationAFP.icns";
NSString * const CESystemIconInternetLocationFTP          = @"InternetLocationFTP.icns";
NSString * const CESystemIconInternetLocationFile         = @"InternetLocationFile.icns";
NSString * const CESystemIconInternetLocationGeneric      = @"InternetLocationGeneric.icns";
NSString * const CESystemIconInternetLocationHTTP         = @"InternetLocationHTTP.icns";
NSString * const CESystemIconInternetLocationMAILTO       = @"InternetLocationMAILTO.icns";
NSString * const CESystemIconInternetLocationNEWS         = @"InternetLocationNEWS.icns";
NSString * const CESystemIconInternetLocationVNC          = @"InternetLocationVNC.icns";
NSString * const CESystemIconKEXT                         = @"KEXT.icns";
NSString * const CESystemIconKeepArrangedIcon             = @"KeepArrangedIcon.icns";
NSString * const CESystemIconLibraryFolderIcon            = @"LibraryFolderIcon.icns";
NSString * const CESystemIconLockedBadgeIcon              = @"LockedBadgeIcon.icns";
NSString * const CESystemIconLockedIcon                   = @"LockedIcon.icns";
NSString * const CESystemIconMagnifyingGlassIcon          = @"MagnifyingGlassIcon.icns";
NSString * const CESystemIconMobileMe                     = @"MobileMe.icns";
NSString * const CESystemIconMovieFolderIcon              = @"MovieFolderIcon.icns";
NSString * const CESystemIconMultipleItemsIcon            = @"MultipleItemsIcon.icns";
NSString * const CESystemIconMusicFolderIcon              = @"MusicFolderIcon.icns";
NSString * const CESystemIconNetBootVolume                = @"NetBootVolume.icns";
NSString * const CESystemIconNewFolderBadgeIcon           = @"NewFolderBadgeIcon.icns";
NSString * const CESystemIconNoWriteIcon                  = @"NoWriteIcon.icns";
NSString * const CESystemIconOpenFolderIcon               = @"OpenFolderIcon.icns";
NSString * const CESystemIconPicturesFolderIcon           = @"PicturesFolderIcon.icns";
NSString * const CESystemIconPrivateFolderBadgeIcon       = @"PrivateFolderBadgeIcon.icns";
NSString * const CESystemIconPrivateFolderIcon            = @"PrivateFolderIcon.icns";
NSString * const CESystemIconProfileBackgroundColor       = @"ProfileBackgroundColor.icns";
NSString * const CESystemIconProfileFont                  = @"ProfileFont.icns";
NSString * const CESystemIconProfileFontAndColor          = @"ProfileFontAndColor.icns";
NSString * const CESystemIconPublicFolderIcon             = @"PublicFolderIcon.icns";
NSString * const CESystemIconReadOnlyFolderBadgeIcon      = @"ReadOnlyFolderBadgeIcon.icns";
NSString * const CESystemIconReadOnlyFolderIcon           = @"ReadOnlyFolderIcon.icns";
NSString * const CESystemIconRecentItemsIcon              = @"RecentItemsIcon.icns";
NSString * const CESystemIconRightContainerArrowIcon      = @"RightContainerArrowIcon.icns";
NSString * const CESystemIconServerApplicationsFolderIcon = @"ServerApplicationsFolderIcon.icns";
NSString * const CESystemIconSidebarAirDrop               = @"SidebarAirDrop.icns";
NSString * const CESystemIconSidebarAirportDisk           = @"SidebarAirportDisk.icns";
NSString * const CESystemIconSidebarAirportExpress        = @"SidebarAirportExpress.icns";
NSString * const CESystemIconSidebarAirportExtreme        = @"SidebarAirportExtreme.icns";
NSString * const CESystemIconSidebarAllMyFiles            = @"SidebarAllMyFiles.icns";
NSString * const CESystemIconSidebarApplicationsFolder    = @"SidebarApplicationsFolder.icns";
NSString * const CESystemIconSidebarBonjour               = @"SidebarBonjour.icns";
NSString * const CESystemIconSidebarBurnFolder            = @"SidebarBurnFolder.icns";
NSString * const CESystemIconSidebarDesktopFolder         = @"SidebarDesktopFolder.icns";
NSString * const CESystemIconSidebarDisplay               = @"SidebarDisplay.icns";
NSString * const CESystemIconSidebarDocumentsFolder       = @"SidebarDocumentsFolder.icns";
NSString * const CESystemIconSidebarDownloadsFolder       = @"SidebarDownloadsFolder.icns";
NSString * const CESystemIconSidebarDropBoxFolder         = @"SidebarDropBoxFolder.icns";
NSString * const CESystemIconSidebarExternalDisk          = @"SidebarExternalDisk.icns";
NSString * const CESystemIconSidebarGenericFile           = @"SidebarGenericFile.icns";
NSString * const CESystemIconSidebarGenericFolder         = @"SidebarGenericFolder.icns";
NSString * const CESystemIconSidebarHomeFolder            = @"SidebarHomeFolder.icns";
NSString * const CESystemIconSidebarInternalDisk          = @"SidebarInternalDisk.icns";
NSString * const CESystemIconSidebarLaptop                = @"SidebarLaptop.icns";
NSString * const CESystemIconSidebarMacMini               = @"SidebarMacMini.icns";
NSString * const CESystemIconSidebarMacPro                = @"SidebarMacPro.icns";
NSString * const CESystemIconSidebarMoviesFolder          = @"SidebarMoviesFolder.icns";
NSString * const CESystemIconSidebarMusicFolder           = @"SidebarMusicFolder.icns";
NSString * const CESystemIconSidebarNetwork               = @"SidebarNetwork.icns";
NSString * const CESystemIconSidebarOpticalDisk           = @"SidebarOpticalDisk.icns";
NSString * const CESystemIconSidebarPC                    = @"SidebarPC.icns";
NSString * const CESystemIconSidebarPicturesFolder        = @"SidebarPicturesFolder.icns";
NSString * const CESystemIconSidebarPrefs                 = @"SidebarPrefs.icns";
NSString * const CESystemIconSidebarRecents               = @"SidebarRecents.icns";
NSString * const CESystemIconSidebarRemovableDisk         = @"SidebarRemovableDisk.icns";
NSString * const CESystemIconSidebarServerDrive           = @"SidebarServerDrive.icns";
NSString * const CESystemIconSidebarSmartFolder           = @"SidebarSmartFolder.icns";
NSString * const CESystemIconSidebarTimeCapsule           = @"SidebarTimeCapsule.icns";
NSString * const CESystemIconSidebarTimeMachine           = @"SidebarTimeMachine.icns";
NSString * const CESystemIconSidebarUtilitiesFolder       = @"SidebarUtilitiesFolder.icns";
NSString * const CESystemIconSidebarXserve                = @"SidebarXserve.icns";
NSString * const CESystemIconSidebariCloud                = @"SidebariCloud.icns";
NSString * const CESystemIconSidebariDisk                 = @"SidebariDisk.icns";
NSString * const CESystemIconSidebariMac                  = @"SidebariMac.icns";
NSString * const CESystemIconSidebariPad                  = @"SidebariPad.icns";
NSString * const CESystemIconSidebariPhone                = @"SidebariPhone.icns";
NSString * const CESystemIconSidebariPodTouch             = @"SidebariPodTouch.icns";
NSString * const CESystemIconSitesFolderIcon              = @"SitesFolderIcon.icns";
NSString * const CESystemIconSmartFolderIcon              = @"SmartFolderIcon.icns";
NSString * const CESystemIconStatusBarCDROMIcon           = @"StatusBarCDROMIcon.icns";
NSString * const CESystemIconStatusBarTrashIcon           = @"StatusBarTrashIcon.icns";
NSString * const CESystemIconSync                         = @"Sync.icns";
NSString * const CESystemIconSystemFolderIcon             = @"SystemFolderIcon.icns";
NSString * const CESystemIconToolbarAdvanced              = @"ToolbarAdvanced.icns";
NSString * const CESystemIconToolbarAppsFolderIcon        = @"ToolbarAppsFolderIcon.icns";
NSString * const CESystemIconToolbarCustomizeIcon         = @"ToolbarCustomizeIcon.icns";
NSString * const CESystemIconToolbarDeleteIcon            = @"ToolbarDeleteIcon.icns";
NSString * const CESystemIconToolbarDesktopFolderIcon     = @"ToolbarDesktopFolderIcon.icns";
NSString * const CESystemIconToolbarDocumentsFolderIcon   = @"ToolbarDocumentsFolderIcon.icns";
NSString * const CESystemIconToolbarDownloadsFolderIcon   = @"ToolbarDownloadsFolderIcon.icns";
NSString * const CESystemIconToolbarFavoritesIcon         = @"ToolbarFavoritesIcon.icns";
NSString * const CESystemIconToolbarInfo                  = @"ToolbarInfo.icns";
NSString * const CESystemIconToolbarLabels                = @"ToolbarLabels.icns";
NSString * const CESystemIconToolbarLibraryFolderIcon     = @"ToolbarLibraryFolderIcon.icns";
NSString * const CESystemIconToolbarMovieFolderIcon       = @"ToolbarMovieFolderIcon.icns";
NSString * const CESystemIconToolbarMusicFolderIcon       = @"ToolbarMusicFolderIcon.icns";
NSString * const CESystemIconToolbarPicturesFolderIcon    = @"ToolbarPicturesFolderIcon.icns";
NSString * const CESystemIconToolbarPublicFolderIcon      = @"ToolbarPublicFolderIcon.icns";
NSString * const CESystemIconToolbarSitesFolderIcon       = @"ToolbarSitesFolderIcon.icns";
NSString * const CESystemIconToolbarUtilitiesFolderIcon   = @"ToolbarUtilitiesFolderIcon.icns";
NSString * const CESystemIconTrashIcon                    = @"TrashIcon.icns";
NSString * const CESystemIconUnknownFSObjectIcon          = @"UnknownFSObjectIcon.icns";
NSString * const CESystemIconUnlockedIcon                 = @"UnlockedIcon.icns";
NSString * const CESystemIconUnsupported                  = @"Unsupported.icns";
NSString * const CESystemIconUserIcon                     = @"UserIcon.icns";
NSString * const CESystemIconUserUnknownIcon              = @"UserUnknownIcon.icns";
NSString * const CESystemIconUsersFolderIcon              = @"UsersFolderIcon.icns";
NSString * const CESystemIconUtilitiesFolder              = @"UtilitiesFolder.icns";
NSString * const CESystemIconVCard                        = @"VCard.icns";
NSString * const CESystemIconAirportExpress               = @"com.apple.airport-express.icns";
NSString * const CESystemIconAirportExtreme               = @"com.apple.airport-extreme.icns";
NSString * const CESystemIconAppleTv                      = @"com.apple.apple-tv.icns";
NSString * const CESystemIconCinemaDisplay                = @"com.apple.cinema-display.icns";
NSString * const CESystemIconEmac                         = @"com.apple.emac.icns";
NSString * const CESystemIconIbookG412                    = @"com.apple.ibook-g4-12.icns";
NSString * const CESystemIconIbookG414                    = @"com.apple.ibook-g4-14.icns";
NSString * const CESystemIconImacAluminum20               = @"com.apple.imac-aluminum-20.icns";
NSString * const CESystemIconImacAluminum24               = @"com.apple.imac-aluminum-24.icns";
NSString * const CESystemIconImacG415                     = @"com.apple.imac-g4-15.icns";
NSString * const CESystemIconImacG417                     = @"com.apple.imac-g4-17.icns";
NSString * const CESystemIconImacG420                     = @"com.apple.imac-g4-20.icns";
NSString * const CESystemIconImacG517                     = @"com.apple.imac-g5-17.icns";
NSString * const CESystemIconImacG520                     = @"com.apple.imac-g5-20.icns";
NSString * const CESystemIconImacISight17                 = @"com.apple.imac-iSight-17.icns";
NSString * const CESystemIconImacISight20                 = @"com.apple.imac-iSight-20.icns";
NSString * const CESystemIconImacISight24                 = @"com.apple.imac-iSight-24.icns";
NSString * const CESystemIconImacUnibody21                = @"com.apple.imac-unibody-21.icns";
NSString * const CESystemIconImacUnibody27                = @"com.apple.imac-unibody-27.icns";
NSString * const CESystemIconIpad                         = @"com.apple.ipad.icns";
NSString * const CESystemIconIphone3g                     = @"com.apple.iphone-3g.icns";
NSString * const CESystemIconIphone4Black                 = @"com.apple.iphone-4-black.icns";
NSString * const CESystemIconIphone4White                 = @"com.apple.iphone-4-white.icns";
NSString * const CESystemIconIphone                       = @"com.apple.iphone.icns";
NSString * const CESystemIconIpodTouch2                   = @"com.apple.ipod-touch-2.icns";
NSString * const CESystemIconIpodTouch4Black              = @"com.apple.ipod-touch-4-black.icns";
NSString * const CESystemIconIpodTouch4                   = @"com.apple.ipod-touch-4.icns";
NSString * const CESystemIconIpodTouch                    = @"com.apple.ipod-touch.icns";
NSString * const CESystemIconLedCinemaDisplay24           = @"com.apple.led-cinema-display-24.icns";
NSString * const CESystemIconLedCinemaDisplay27           = @"com.apple.led-cinema-display-27.icns";
NSString * const CESystemIconMacbookBlack                 = @"com.apple.macbook-black.icns";
NSString * const CESystemIconMacbookUnibodyPlastic        = @"com.apple.macbook-unibody-plastic.icns";
NSString * const CESystemIconMacbookUnibody               = @"com.apple.macbook-unibody.icns";
NSString * const CESystemIconMacbookWhite                 = @"com.apple.macbook-white.icns";
NSString * const CESystemIconMacbookair11Unibody          = @"com.apple.macbookair-11-unibody.icns";
NSString * const CESystemIconMacbookair13Unibody          = @"com.apple.macbookair-13-unibody.icns";
NSString * const CESystemIconMacbookair                   = @"com.apple.macbookair.icns";
NSString * const CESystemIconMacbookpro13Unibody          = @"com.apple.macbookpro-13-unibody.icns";
NSString * const CESystemIconMacbookpro15Unibody          = @"com.apple.macbookpro-15-unibody.icns";
NSString * const CESystemIconMacbookpro15                 = @"com.apple.macbookpro-15.icns";
NSString * const CESystemIconMacbookpro17Unibody          = @"com.apple.macbookpro-17-unibody.icns";
NSString * const CESystemIconMacbookpro17                 = @"com.apple.macbookpro-17.icns";
NSString * const CESystemIconMacminiServer                = @"com.apple.macmini-server.icns";
NSString * const CESystemIconMacminiUnibodyNoOptical      = @"com.apple.macmini-unibody-no-optical.icns";
NSString * const CESystemIconMacminiUnibody               = @"com.apple.macmini-unibody.icns";
NSString * const CESystemIconMacmini                      = @"com.apple.macmini.icns";
NSString * const CESystemIconMacpro                       = @"com.apple.macpro.icns";
NSString * const CESystemIconPowerbookG412                = @"com.apple.powerbook-g4-12.icns";
NSString * const CESystemIconPowerbookG415                = @"com.apple.powerbook-g4-15.icns";
NSString * const CESystemIconPowerbookG417                = @"com.apple.powerbook-g4-17.icns";
NSString * const CESystemIconPowerbookG4Titanium          = @"com.apple.powerbook-g4-titanium.icns";
NSString * const CESystemIconPowermacG4Graphite           = @"com.apple.powermac-g4-graphite.icns";
NSString * const CESystemIconPowermacG4MirroredDriveDoors = @"com.apple.powermac-g4-mirrored-drive-doors.icns";
NSString * const CESystemIconPowermacG4Quicksilver        = @"com.apple.powermac-g4-quicksilver.icns";
NSString * const CESystemIconPowermacG5                   = @"com.apple.powermac-g5.icns";
NSString * const CESystemIconTimeCapsule                  = @"com.apple.time-capsule.icns";
NSString * const CESystemIconXserveG4                     = @"com.apple.xserve-g4.icns";
NSString * const CESystemIconXserve                       = @"com.apple.xserve.icns";
NSString * const CESystemIconIDiskGenericIcon             = @"iDiskGenericIcon.icns";
NSString * const CESystemIconIDiskUserIcon                = @"iDiskUserIcon.icns";
NSString * const CESystemIconGenericPc                    = @"public.generic-pc.icns";
