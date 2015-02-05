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

#import "CEPreferencesCompilerOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesCompilerOptionsViewController+Private.h"
#import "CEPreferences.h"
#import "CESystemIconsHelper.h"
#import "CEMutableOrderedDictionary.h"

@implementation CEPreferencesCompilerOptionsViewController( NSTableViewDataSource )

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )tableView
{
    ( void )tableView;
    
    if( _flags == nil )
    {
        [ self getWarningFlags ];
    }
    
    return ( NSInteger )( _flags.count );
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    NSString       * flag;
    NSCellStateValue state;
    
    ( void )tableView;
    
    if( _flags == nil )
    {
        [ self getWarningFlags ];
    }
    
    flag  = [ _flags keyAtIndex: ( NSUInteger )row ];
    state = ( [ ( NSNumber * )[ _flags objectAtIndex: ( NSUInteger )row ] boolValue ] == YES ) ? NSOnState : NSOffState;
    
    if( [ [ tableColumn identifier ] isEqualToString: CEPreferencesCompilerOptionsViewControllerTableViewColumnFlagIdentifier ]  )
    {
        return [ NSNumber numberWithInteger: state ];
    }
    else if( [ [ tableColumn identifier ] isEqualToString: CEPreferencesCompilerOptionsViewControllerTableViewColumnDescriptionIdentifier ] )
    {
        return L10N( [ flag cStringUsingEncoding: NSUTF8StringEncoding ] );
    }
    
    return nil;
}

- ( void )tableView: ( NSTableView * )tableView setObjectValue: ( id )object forTableColumn: ( NSTableColumn * )column row: ( NSInteger )row
{
    NSString * flag;
    
    ( void )tableView;
    ( void )column;
    
    flag = [ _flags keyAtIndex: ( NSUInteger )row ];
    
    if( [ ( NSNumber * )object boolValue ] == YES )
    {
        [ [ CEPreferences sharedInstance ] enableWarningFlag: flag ];
    }
    else
    {
        [ [ CEPreferences sharedInstance ] disableWarningFlag: flag ];
    }
    
    [ self getWarningFlags ];
    [ _tableView reloadData ];
}

@end
