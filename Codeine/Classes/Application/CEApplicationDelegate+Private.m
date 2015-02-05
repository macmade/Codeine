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

#import "CEApplicationDelegate+Private.h"
#import "CEPreferences.h"
#import "CEColorTheme.h"
#import "CEMainWindowController.h"

@implementation CEApplicationDelegate( Private )

- ( void )installApplicationSupportFiles
{
    void ( ^ installDir )( NSString * directory );
    
    installDir = ^( NSString * directory )
    {
        NSString * path;
        NSString * bundlePath;
        NSString * dirPath;
        
        path = [ FILE_MANAGER applicationSupportDirectory ];
        
        if( path == nil )
        {
            return;
        }
        
        bundlePath = [ BUNDLE pathForResource: directory ofType: nil ];
        dirPath    = [ path stringByAppendingPathComponent: [ bundlePath lastPathComponent ] ];
        
        if( [ FILE_MANAGER fileExistsAtPath: dirPath ] == NO )
        {
            [ FILE_MANAGER copyItemAtPath: bundlePath toPath: dirPath error: NULL ];
        }
    };
    
    installDir( @"Licenses" );
    installDir( @"Templates" );
    installDir( @"Themes" );
}

- ( void )firstLaunch
{
    if( [ [ CEPreferences sharedInstance ] firstLaunch ] == NO )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] setUserName: NSFullUserName() ];
    [ [ CEPreferences sharedInstance ] setTextEncoding: NSUTF8StringEncoding ];
    
    {
        NSDictionary * warningFlags;
        NSString     * warningFlag;
        NSNumber     * warningFlagValue;
        
        warningFlags = [ [ CEPreferences sharedInstance ] warningFlags ];
        
        if( warningFlags == nil || warningFlags.count == 0 )
        {
            warningFlags = [ [ CEPreferences sharedInstance ] warningFlagsPresetNormal ];
            
            for( warningFlag in warningFlags )
            {
                warningFlagValue = ( NSNumber * )[ warningFlags objectForKey: warningFlag ];
                
                if( [ warningFlagValue boolValue ] == YES )
                {
                    [ [ CEPreferences sharedInstance ] enableWarningFlag: warningFlag ];
                }
                else
                {
                    [ [ CEPreferences sharedInstance ] disableWarningFlag: warningFlag ];
                }
            }
        }
    }
    
    {
        CEColorTheme * theme;
        
        theme = [ CEColorTheme defaultColorThemeWithName: @"Codeine - Dark" ];
        
        [ [ CEPreferences sharedInstance ] setColorsFromColorTheme: theme ];
    }
}

- ( void )windowDidClose: ( NSNotification * )notification
{
    NSWindow           * window;
    NSWindowController * controller;
    
    window      = [ notification object ];
    controller  = window.windowController;
    
    if( [ controller isKindOfClass: [ CEMainWindowController class ] ] == YES )
    {
        [ _mainWindowControllers removeObject: controller ];
        [ controller autorelease ];
    }
}

- ( void )windowDidBecomeKey: ( NSNotification * )notification
{
    NSWindow           * window;
    NSWindowController * controller;
    
    window      = [ notification object ];
    controller  = window.windowController;
    
    if( [ controller isKindOfClass: [ CEMainWindowController class ] ] == YES && controller != _activeMainWindowController )
    {
        _activeMainWindowController = [ ( CEMainWindowController * )controller retain ];
    }
}

@end
