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

#import "CEPreferencesFontsAndColorsOptionsViewController.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+Private.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+NSTableViewDelegate.h"
#import "CEPreferences.h"
#import "CEColorTheme.h"
#import "CEApplicationDelegate.h"

@implementation CEPreferencesFontsAndColorsOptionsViewController

@synthesize fontTextField               = _fontTextField;
@synthesize colorThemesPopUp            = _colorThemesPopUp;
@synthesize tableView                   = _tableView;

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
    
    RELEASE_IVAR( _fontTextField );
    RELEASE_IVAR( _colorThemesPopUp );
    RELEASE_IVAR( _tableView );
    RELEASE_IVAR( _colorChooserViews );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ self updateView ];
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( updateView ) name: CEPreferencesNotificationValueChanged object: nil ];
    [ self getColorThemes ];
    
    _tableView.delegate   = self;
    _tableView.dataSource = self;
}

- ( IBAction )chooseFont: ( id )sender
{
    NSFontManager * manager;
    NSFontPanel   * panel;
    NSFont        * font;
    
    font    = [ NSFont fontWithName: [ [ CEPreferences sharedInstance ] fontName ] size: [ [ CEPreferences sharedInstance ] fontSize ] ];
    manager = [ NSFontManager sharedFontManager ];
    panel   = [ manager fontPanel: YES ];
    
    [ manager setSelectedFont: font isMultiple: NO ];
    [ manager setDelegate: self ];
    
    [ panel makeKeyAndOrderFront: sender ];
}

- ( void )changeFont: ( id )sender
{
    NSFontManager * manager;
    NSFont        * font;
    
    if( [ sender isKindOfClass: [ NSFontManager class ] ] == NO )
    {
        return;
    }
    
    manager = ( NSFontManager * )sender;
    font    = [ manager convertFont: [ manager selectedFont ] ];
    
    [ [ CEPreferences sharedInstance ] setFontName: [ font fontName ] ];
    [ [ CEPreferences sharedInstance ] setFontSize: [ font pointSize ] ];
}

- ( IBAction )chooseColorTheme: ( id )sender
{
    CEColorTheme * theme;
    
    ( void )sender;
    
    theme = [ [ _colorThemesPopUp selectedItem ] representedObject ];
    
    if( theme == nil )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] setColorsFromColorTheme: theme ];
}

- ( IBAction )restoreDefaults: ( id )sender
{
    NSAlert * alert;
    
    ( void )sender;
    
    alert                   = [ NSAlert new ];
    alert.messageText       = L10N( "ResetThemeAlertTitle" );
    alert.informativeText   = L10N( "ResetThemeAlertText" );
    
    [ alert addButtonWithTitle: L10N( "OK" ) ];
    [ alert addButtonWithTitle: L10N( "Cancel" ) ];
    
    [ alert beginSheetModalForWindow: self.view.window completionHandler: ^( NSModalResponse response )
        {
            NSArray    * items;
            NSMenuItem * item;
            
            if( response == NSAlertFirstButtonReturn )
            {
                items = [ _colorThemesPopUp itemArray ];
                
                for( item in items )
                {
                    if( [ item.representedObject isKindOfClass: [ CEColorTheme class ] ] == YES )
                    {
                        [ _colorThemesPopUp removeItemWithTitle: item.title ];
                    }
                }
                
                [ [ CEApplicationDelegate sharedInstance ] resetColorThemes: nil ];
                [ self getColorThemes ];
                [ [ CEPreferences sharedInstance ] setColorsFromColorTheme: [ CEColorTheme defaultColorThemeWithName: @"Codeine - Dark" ] ];
            }
        }
    ];
}

- ( IBAction )saveTheme: ( id )sender
{
    ( void )sender;
}

@end
