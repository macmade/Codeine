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

#import "CEPreferencesFileTypesOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesFileTypesOptionsViewController+Private.h"
#import "CEPreferences.h"
#import "CEMutableOrderedDictionary.h"
#import "CESourceFile.h"
#import "CESystemIconsHelper.h"

@implementation CEPreferencesFileTypesOptionsViewController( NSTableViewDataSource )

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )tableView
{
    ( void )tableView;
    
    if( _fileTypes == nil )
    {
        [ self getFileTypes ];
    }
    
    return ( NSInteger )( _fileTypes.count );
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    NSString           * extension;
    CESourceFileLanguage type;
    
    ( void )tableView;
    
    if( _fileTypes == nil )
    {
        [ self getFileTypes ];
    }
    
    extension = [ _fileTypes keyAtIndex: ( NSUInteger )row ];
    type      = ( CESourceFileLanguage )[ ( NSNumber * )[ _fileTypes objectAtIndex: ( NSUInteger )row ] unsignedIntegerValue ];
    
    if( [ [ tableColumn identifier ] isEqualToString: CEPreferencesCompilerOptionsViewControllerColumnIconIdentifier ]  )
    {
        {
            NSImage * icon;
            
            icon = [ WORKSPACE iconForFileType: extension ];
            
            if( icon != nil )
            {
                return icon;
            }
            
            return [ [ CESystemIconsHelper sharedInstance ] iconNamed: CESystemIconGenericDocumentIcon ];
        }
    }
    else if( [ [ tableColumn identifier ] isEqualToString: CEPreferencesCompilerOptionsViewControllerColumnExtensionIdentifier ] )
    {
        return [ NSString stringWithFormat: @".%@", extension ];
    }
    else if( [ [ tableColumn identifier ] isEqualToString: CEPreferencesCompilerOptionsViewControllerColumnTypeIdentifier ] )
    {
        return [ NSNumber numberWithInt: type - 1 ];
    }
    
    return nil;
}

- ( void )tableView: ( NSTableView * )tableView setObjectValue: ( id )object forTableColumn: ( NSTableColumn * )column row: ( NSInteger )row
{
    NSString           * extension;
    CESourceFileLanguage type;
    
    ( void )tableView;
    ( void )column;
    
    extension = [ _fileTypes keyAtIndex: ( NSUInteger )row ];
    type      = ( CESourceFileLanguage )( [ ( NSNumber * )object unsignedIntegerValue ] + 1 );
    
    [ [ CEPreferences sharedInstance ] addFileType: type forExtension: extension ];
    
    [ self getFileTypes ];
    [ _tableView reloadData ];
}

@end
