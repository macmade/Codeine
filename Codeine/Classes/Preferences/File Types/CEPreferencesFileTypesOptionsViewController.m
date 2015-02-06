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

#import "CEPreferencesFileTypesOptionsViewController.h"
#import "CEPreferencesFileTypesOptionsViewController+NSTableViewDelegate.h"
#import "CEPreferencesFileTypesOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesFileTypesOptionsViewController+Private.h"
#import "CEPreferencesFileTypesAddNewViewController.h"
#import "CEPreferences.h"
#import "CEMutableOrderedDictionary.h"

NSString * const CEPreferencesCompilerOptionsViewControllerColumnIconIdentifier         = @"Icon";
NSString * const CEPreferencesCompilerOptionsViewControllerColumnExtensionIdentifier    = @"Extension";
NSString * const CEPreferencesCompilerOptionsViewControllerColumnTypeIdentifier         = @"Type";

@implementation CEPreferencesFileTypesOptionsViewController

@synthesize tableView = _tableView;

- ( void )dealloc
{
    _tableView.delegate    = self;
    _tableView.dataSource  = self;
    
    RELEASE_IVAR( _tableView );
    RELEASE_IVAR( _fileTypes );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _tableView.delegate   = self;
    _tableView.dataSource = self;
}

- ( IBAction )addFileType: ( id )sender
{
    ( void )sender;
    
    if( _addNewController == nil )
    {
        _addNewController = [ CEPreferencesFileTypesAddNewViewController new ];
    }
    
    [ self.view.window beginSheet: _addNewController.window completionHandler: ^( NSModalResponse response )
        {
            if( response == NSModalResponseOK )
            {
                [ self didChooseFileType: nil ];
            }
        }
    ];
}

- ( IBAction )removeFileType: ( id )sender
{
    NSUInteger row;
    
    ( void )sender;
    
    if( [ _tableView selectedRow ] == -1 )
    {
        return;
    }
    
    row = ( NSUInteger )_tableView.selectedRow;
    
    if( row >= _fileTypes.count )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] removeFileTypeForExtension: [ _fileTypes keyAtIndex: row ] ];
    
    [ self getFileTypes ];
    [ _tableView reloadData ];
}

@end
