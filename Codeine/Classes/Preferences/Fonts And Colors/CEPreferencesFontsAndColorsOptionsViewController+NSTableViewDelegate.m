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

#import "CEPreferencesFontsAndColorsOptionsViewController+NSTableViewDelegate.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+CEColorChooserViewDelegate.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+Private.h"
#import "CEColorChooserView.h"
#import "CEPreferences.h"

@implementation CEPreferencesFontsAndColorsOptionsViewController( NSTableViewDelegate )

- ( CGFloat )tableView: ( NSTableView * )tableView heightOfRow: ( NSInteger )row
{
    NSFont * font;
    NSSize   size;
    
    ( void )tableView;
    ( void )row;
    
    font = [ NSFont fontWithName: [ [ CEPreferences sharedInstance ] fontName ] size: ( CGFloat )11 ];
    size = [ @"XXX" sizeWithAttributes: [ NSDictionary dictionaryWithObject: font forKey: NSFontAttributeName ] ];
    
    return ( size.height + 10 < ( CGFloat )27 ) ? ( CGFloat )27 : size.height + 10;
}

- ( NSView * )tableView: ( NSTableView * )tableView viewForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    CEColorChooserView * view;
    NSColor            * backgroundColor;
    NSColor            * foregroundColor;
    NSColor            * color;
    NSString           * title;
    id                   key;
    
    ( void )tableView;
    ( void )tableColumn;
    
    if( _colorChooserViews == nil )
    {
        [ self createColorChooserViews ];
    }
    
    @try
    {
        view = [ _colorChooserViews objectAtIndex: ( NSUInteger )row ];
        
        switch( row )
        {
            case 0:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] foregroundColor ];
                color           = [ [ CEPreferences sharedInstance ] backgroundColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelBackground" );
                key             = CEPreferencesKeyBackgroundColor;
                break;
                
            case 1:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] foregroundColor ];
                color           = [ [ CEPreferences sharedInstance ] foregroundColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelForeground" );
                key             = CEPreferencesKeyForegoundColor;
                break;
                
            case 2:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] foregroundColor ];
                color           = [ [ CEPreferences sharedInstance ] selectionColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] selectionColor ];
                title           = L10N( "ColorLabelSelection" );
                key             = CEPreferencesKeySelectionColor;
                break;
                
            case 3:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] foregroundColor ];
                color           = [ [ CEPreferences sharedInstance ] currentLineColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] currentLineColor ];
                title           = L10N( "ColorLabelCurrentLine" );
                key             = CEPreferencesKeyCurrentLineColor;
                break;
                
            case 4:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] invisibleColor ];
                color           = [ [ CEPreferences sharedInstance ] invisibleColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelInvisible" );
                key             = CEPreferencesKeyInvisibleColor;
                break;
                
            case 5:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] keywordColor ];
                color           = [ [ CEPreferences sharedInstance ] keywordColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelKeyword" );
                key             = CEPreferencesKeyKeywordColor;
                break;
                
            case 6:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] preprocessorColor ];
                color           = [ [ CEPreferences sharedInstance ] preprocessorColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelPreprocessor" );
                key             = CEPreferencesKeyPreprocessorColor;
                break;
                
            case 7:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] predefinedColor ];
                color           = [ [ CEPreferences sharedInstance ] predefinedColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelPredefined" );
                key             = CEPreferencesKeyPredefinedColor;
                break;
                
            case 8:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] projectColor ];
                color           = [ [ CEPreferences sharedInstance ] projectColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelProject" );
                key             = CEPreferencesKeyProjectColor;
                break;
                
            case 9:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] numberColor ];
                color           = [ [ CEPreferences sharedInstance ] numberColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelNumber" );
                key             = CEPreferencesKeyNumberColor;
                break;
                
            case 10:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] stringColor ];
                color           = [ [ CEPreferences sharedInstance ] stringColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelString" );
                key             = CEPreferencesKeyStringColor;
                break;
                
            case 11:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] commentColor ];
                color           = [ [ CEPreferences sharedInstance ] commentColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "ColorLabelComment" );
                key             = CEPreferencesKeyCommentColor;
                break;
                
            default:
                
                foregroundColor = [ [ CEPreferences sharedInstance ] foregroundColor ];
                color           = [ [ CEPreferences sharedInstance ] foregroundColor ];
                backgroundColor = [ [ CEPreferences sharedInstance ] backgroundColor ];
                title           = L10N( "N/A" );
                key             = nil;
                break;
        }
        
        view.foregroundColor    = foregroundColor;
        view.backgroundColor    = backgroundColor;
        view.color              = color;
        view.title              = title;
        view.font               = [ NSFont fontWithName: [ [ CEPreferences sharedInstance ] fontName ] size: ( CGFloat )11 ];
        view.delegate           = self;
        view.representedObject  = key;
        
        return view;
    }
    @catch ( NSException * e )
    {
        ( void )e;
    }
    
    return nil;
}

@end
