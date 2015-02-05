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

#import "CELanguageWindowController+NSTableViewDataSource.h"
#import "CESourceFile.h"

@implementation CELanguageWindowController( NSTableViewDataSource )

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )tableView
{
    if( tableView == _languagesTableView )
    {
        return 5;
    }
    else if( tableView == _recentFilesTableView )
    {
        return 0;
    }
    
    return 0;
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    if( tableView == _languagesTableView )
    {
        if( [ tableColumn.identifier isEqualToString: CELanguageWindowControllerTableColumnIdentifierIcon ] )
        {
            switch( row )
            {
                case 0:
                    
                    return [ WORKSPACE iconForFileType: @"c" ];
                    
                case 1:
                    
                    return [ WORKSPACE iconForFileType: @"cpp" ];
                    
                case 2:
                    
                    return [ WORKSPACE iconForFileType: @"m" ];
                    
                case 3:
                    
                    return [ WORKSPACE iconForFileType: @"mm" ];
                    
                case 4:
                    
                    return [ WORKSPACE iconForFileType: @"h" ];
                    
                default:
                    
                    return nil;
            }
        }
        else if( [ tableColumn.identifier isEqualToString: CELanguageWindowControllerTableColumnIdentifierTitle ] )
        {
            switch( row )
            {
                case 0:
                    
                    return [ NSNumber numberWithInteger: CESourceFileLanguageC ];
                    
                case 1:
                    
                    return [ NSNumber numberWithInteger: CESourceFileLanguageCPP ];
                    
                case 2:
                    
                    return [ NSNumber numberWithInteger: CESourceFileLanguageObjC ];
                    
                case 3:
                    
                    return [ NSNumber numberWithInteger: CESourceFileLanguageObjCPP ];
                    
                case 4:
                    
                    return [ NSNumber numberWithInteger: CESourceFileLanguageHeader ];
                    
                default:
                    
                    return nil;
            }
        }
    }
    else if( tableView == _recentFilesTableView )
    {
        return nil;
    }
    
    return nil;
}

@end
