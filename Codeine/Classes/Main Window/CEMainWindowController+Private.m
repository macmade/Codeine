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

#import "CEMainWindowController+Private.h"
#import "CELanguageWindowController.h"
#import "CESourceFile.h"
#import "CEDocument.h"
#import "CEFilesViewController.h"
#import "CELicensePopUpButton.h"
#import "CEPreferences.h"

@implementation CEMainWindowController( Private )

- ( void )showLanguageWindow
{
    if( _languageWindowController == nil )
    {
        _languageWindowController = [ CELanguageWindowController new ];
    }
    
    [ APPLICATION beginSheet: _languageWindowController.window modalForWindow: self.window modalDelegate: self didEndSelector: @selector( didChooseLanguage: ) contextInfo: NULL ];
}

- ( void )didChooseLanguage: ( id )sender
{
    NSString         * license;
    NSString         * templates;
    NSString         * template;
    NSDateComponents * dateComponents;
    CEDocument       * document;
    NSString         * text;
    NSString         * userName;
    
    if
    (
           _languageWindowController.language    == CESourceFileLanguageNone
        || _languageWindowController.lineEndings == CESourceFileLineEndingsUnknown
        || _languageWindowController.encoding    == nil
    )
    {
        return;
    }
    
    templates = [ [ FILE_MANAGER applicationSupportDirectory ] stringByAppendingPathComponent: @"Templates" ];
    
    ( void )sender;
    
    switch( _languageWindowController.language )
    {
        case CESourceFileLanguageCPP:
            
            template = [ templates stringByAppendingPathComponent: @"C++.txt" ];
            break;
            
        case CESourceFileLanguageObjC:
            
            template = [ templates stringByAppendingPathComponent: @"Objective-C.txt" ];
            break;
            
        case CESourceFileLanguageObjCPP:
            
            template = [ templates stringByAppendingPathComponent: @"Objective-C++.txt" ];
            break;
            
        case CESourceFileLanguageHeader:
            
            template = [ templates stringByAppendingPathComponent: @"Header.txt" ];
            break;
            
        case CESourceFileLanguageC:
        case CESourceFileLanguageNone:
        default:
            
            template = [ templates stringByAppendingPathComponent: @"C.txt" ];
            break;
    }
    
    document = [ CEDocument documentWithLanguage: _languageWindowController.language ];
    text     = [ NSString stringWithContentsOfFile: template encoding: NSUTF8StringEncoding error: NULL ];
    
    if( text == nil )
    {
        text = @"";
    }
    else
    {
        license         = [ _languageWindowController.licensePopUp.licenseText stringByTrimmingCharactersInSet: [ NSCharacterSet whitespaceAndNewlineCharacterSet ] ];
        dateComponents  = [ [ NSCalendar currentCalendar ] components: NSYearCalendarUnit fromDate: [ NSDate date ] ];
        text            = [ text stringByReplacingOccurrencesOfString: @"${LICENSE}" withString: license ];
        userName        = [ [ CEPreferences sharedInstance ] userName ];
        
        if( [ [ [ CEPreferences sharedInstance ] userEmail ] length ] > 0 )
        {
            userName = [ NSString stringWithFormat: @"%@ <%@>", userName, [ [ CEPreferences sharedInstance ] userEmail ] ];
        }
        
        text = [ text stringByReplacingOccurrencesOfString: @"${USER_NAME}" withString: userName ];
        text = [ text stringByReplacingOccurrencesOfString: @"${YEAR}" withString: [ NSString stringWithFormat: @"%li", dateComponents.year ] ];
    }
    
    document.sourceFile.text = text;
    self.activeDocument      = document;
    
    RELEASE_IVAR( _languageWindowController );
}

- ( void )preferencesDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    if( [ [ CEPreferences sharedInstance ] fullScreenStyle ] == CEPreferencesFullScreenStyleNative )
    {
        self.window.collectionBehavior |= NSWindowCollectionBehaviorFullScreenPrimary;
    }
    else
    {
        self.window.collectionBehavior &= ~NSWindowCollectionBehaviorFullScreenPrimary;
    }
}

@end
