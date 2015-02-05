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

#import "CEPreferencesCompilerOptionsViewController.h"
#import "CEPreferencesCompilerOptionsViewController+NSTableViewDelegate.h"
#import "CEPreferencesCompilerOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesCompilerOptionsViewController+Private.h"
#import "CEPreferences.h"

NSString * const CEPreferencesCompilerOptionsViewControllerTableViewColumnFlagIdentifier               = @"Flag";
NSString * const CEPreferencesCompilerOptionsViewControllerTableViewColumnDescriptionIdentifier        = @"Description";

@implementation CEPreferencesCompilerOptionsViewController

@synthesize tableView               = _tableView;
@synthesize warningsPresetPopUp     = _warningsPresetPopUp;
@synthesize optimizationLevelPopUp  = _optimizationLevelPopUp;

- ( void )awakeFromNib
{
    _tableView.delegate    = self;
    _tableView.dataSource  = self;
    
    [ _optimizationLevelPopUp selectItemWithTag: [ [ CEPreferences sharedInstance ] optimizationLevel ] ];
}

- ( void )dealloc
{
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
    
    RELEASE_IVAR( _tableView );
    RELEASE_IVAR( _flags );
    RELEASE_IVAR( _warningsPresetPopUp );
    RELEASE_IVAR( _optimizationLevelPopUp );
    
    [ super dealloc ];
}

- ( IBAction )selectWarningsPreset: ( id )sender
{
    BOOL           disableAll;
    NSInteger      tag;
    NSDictionary * flags;
    NSString     * flag;
    NSNumber     * value;
    
    ( void )sender;
    
    tag = [ [ _warningsPresetPopUp selectedItem ] tag ];
    
    switch( tag )
    {
        case 1:
            
            flags       = [ [ CEPreferences sharedInstance ] warningFlagsPresetStrict ];
            disableAll  = NO;
            break;
            
        case 2:
            
            flags       = [ [ CEPreferences sharedInstance ] warningFlagsPresetNormal ];
            disableAll  = NO;
            break;
            
        case 3:
            
            flags       = [ [ CEPreferences sharedInstance ] warningFlagsPresetStrict ];
            disableAll  = YES;
            break;
            
        default:
            
            return;
    }
    
    for( flag in flags )
    {
        value = ( disableAll == YES ) ? [ NSNumber numberWithBool: NO ] : [ flags objectForKey: flag ];
        
        if( [ value boolValue ] == YES )
        {
            [ [ CEPreferences sharedInstance ] enableWarningFlag: flag ];
        }
        else
        {
            [ [ CEPreferences sharedInstance ] disableWarningFlag: flag ];
        }
    }
    
    [ self getWarningFlags ];
    [ _tableView reloadData ];
}

- ( IBAction )selectOptimizationLevel: ( id )sender
{
    CEOptimizationLevel level;
    
    ( void )sender;
    
    level = ( CEOptimizationLevel )[ _optimizationLevelPopUp selectedTag ];
    
    [ [ CEPreferences sharedInstance ] setOptimizationLevel: level ];
}

@end
