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

#import "CELanguageWindowController.h"
#import "CELanguageWindowController+NSTableViewDataSource.h"
#import "CELanguageWindowController+NSTableViewDelegate.h"
#import "CELanguageWindowController+Private.h"
#import "CEPreferences.h"
#import "CEBackgroundView.h"

NSString * const CELanguageWindowControllerTableColumnIdentifierIcon    = @"Icon";
NSString * const CELanguageWindowControllerTableColumnIdentifierTitle   = @"Title";

@implementation CELanguageWindowController

@synthesize language                = _language;
@synthesize lineEndings             = _lineEndings;
@synthesize encoding                = _encoding;
@synthesize encodingPopUp           = _encodingPopUp;
@synthesize lineEndingsMatrix       = _lineEndingsMatrix;
@synthesize contentView             = _contentView;
@synthesize iconView                = _iconView;
@synthesize languagesTableView      = _languagesTableView;
@synthesize recentFilesTableView    = _recentFilesTableView;
@synthesize licensePopUp            = _licensePopUp;

- ( void )dealloc
{
    _languagesTableView.dataSource      = nil;
    _languagesTableView.delegate        = nil;
    _recentFilesTableView.dataSource    = nil;
    _recentFilesTableView.delegate      = nil;
    
    RELEASE_IVAR( _encodingPopUp );
    RELEASE_IVAR( _lineEndingsMatrix );
    RELEASE_IVAR( _encoding );
    RELEASE_IVAR( _contentView );
    RELEASE_IVAR( _iconView );
    RELEASE_IVAR( _languagesTableView );
    RELEASE_IVAR( _recentFilesTableView );
    RELEASE_IVAR( _licensePopUp );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSImage            * icon;
    CGImageRef           cgImage;
    NSRect               rect;
    CESourceFileLanguage language;
    
    [ _lineEndingsMatrix selectCellWithTag: ( NSInteger )[ [ CEPreferences sharedInstance ] lineEndings ] ];
    
    icon    = [ NSImage imageNamed: @"Application" ];
    rect    = NSMakeRect( ( CGFloat )0, ( CGFloat )0, ( CGFloat )512, ( CGFloat )512 );
    cgImage = [ icon CGImageForProposedRect: &rect context: nil hints: nil ];
    icon   = [ [ NSImage alloc ] initWithCGImage: cgImage size: NSMakeSize( ( CGFloat )512, ( CGFloat )512 ) ];
    
    [ _iconView setImage: icon ];
    [ icon release ];
    
    _contentView.backgroundColor = [ NSColor colorWithDeviceWhite: ( CGFloat )1   alpha: ( CGFloat )0.5 ];
    _contentView.borderColor     = [ NSColor colorWithDeviceWhite: ( CGFloat )0.5 alpha: ( CGFloat )1 ];
    
    [ _iconView setAlphaValue: ( CGFloat )0.5 ];
    [ _iconView removeFromSuperview ];
    [ self.window.contentView addSubview: _iconView positioned: NSWindowBelow relativeTo: nil ];
    
    _languagesTableView.dataSource      = self;
    _languagesTableView.delegate        = self;
    _recentFilesTableView.dataSource    = self;
    _recentFilesTableView.delegate      = self;
    
    language = [ [ CEPreferences sharedInstance ] defaultLanguage ];
    
    switch( language )
    {
        case CESourceFileLanguageC:
            
            [ _languagesTableView selectRowIndexes: [ NSIndexSet indexSetWithIndex: 0 ] byExtendingSelection: NO ];
            
            break;
            
        case CESourceFileLanguageCPP:
            
            [ _languagesTableView selectRowIndexes: [ NSIndexSet indexSetWithIndex: 1 ] byExtendingSelection: NO ];
            
            break;
            
        case CESourceFileLanguageObjC:
            
            [ _languagesTableView selectRowIndexes: [ NSIndexSet indexSetWithIndex: 2 ] byExtendingSelection: NO ];
            
            break;
            
        case CESourceFileLanguageObjCPP:
            
            [ _languagesTableView selectRowIndexes: [ NSIndexSet indexSetWithIndex: 3 ] byExtendingSelection: NO ];
            
            break;
            
        case CESourceFileLanguageNone:
        case CESourceFileLanguageHeader:
        default:
            
            break;
    }
}

- ( IBAction )done: ( id )sender
{
    NSInteger languageRow;
    
    languageRow = [ _languagesTableView selectedRow ];
    
    if( languageRow == NSNotFound )
    {
        _language = CESourceFileLanguageC;
    }
    else
    {
        switch( languageRow )
        {
            case 0:
                
                _language = CESourceFileLanguageC;
                break;
                
            case 1:
                
                _language = CESourceFileLanguageCPP;
                break;
                
            case 2:
                
                _language = CESourceFileLanguageObjC;
                break;
                
            case 3:
                
                _language = CESourceFileLanguageObjCPP;
                break;
                
            case 4:
                
                _language = CESourceFileLanguageHeader;
                break;
                
            default:
                
                _language = CESourceFileLanguageNone;
                
                break;
        }
    }
    
    _lineEndings = ( CESourceFileLineEndings )[ [ _lineEndingsMatrix selectedCell ] tag ];
    _encoding    = [ [ [ _encodingPopUp selectedItem ] representedObject ] retain ];
    
    [ self.window orderOut: sender ];
    [ APPLICATION endSheet: self.window ];
}

- ( IBAction )cancel: ( id )sender
{
    _language    = CESourceFileLanguageNone;
    _lineEndings = CESourceFileLineEndingsUnknown;
    _encoding    = nil;
    
    [ self.window orderOut: sender ];
    [ APPLICATION endSheet: self.window ];
}

@end
