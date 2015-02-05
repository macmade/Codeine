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

#import "CEDiagnosticsViewController+Private.h"
#import "CEDocument.h"
#import "CESourceFile.h"
#import "CEFixItViewController.h"

@implementation CEDiagnosticsViewController( Private )

- ( void )applicationStateDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self.view setNeedsDisplay: YES ];
}

- ( void )getDiagnostics
{
    CKDiagnostic * diagnostic;
    NSString     * text;
    NSRange        lineRange;
    
    [ _diagnostics removeAllObjects ];
    
    if( _textView != nil && _textView.selectedRange.length == 0 )
    {
        text = _textView.textStorage.string;
    }
    else
    {
        text = nil;
    }
    
    for( diagnostic in _document.sourceFile.translationUnit.diagnostics )
    {
        if( text != nil )
        {
            @try
            {
                lineRange = [ text lineRangeForRange: NSMakeRange( _textView.selectedRange.location, 0 ) ];
                
                if( diagnostic.range.location >= lineRange.location && diagnostic.range.location <= lineRange.location + lineRange.length )
                {
                    continue;
                }
            }
            @catch ( NSException * e )
            {
                ( void )e;
            }
        }
        
        [ _diagnostics addObject: diagnostic ];
    }
}

- ( void )textViewSelectionDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self getDiagnostics ];
    [ _tableView reloadData ];
}

- ( void )showPopover
{
    CKDiagnostic          * diagnostic;
    CEFixItViewController * controller;
    NSRect                  cellFrame;
    
    if( self.popover.shown == YES )
    {
        return;
    }
    
    if( _tableView.selectedRow == NSNotFound )
    {
        return;
    }
    
    @try
    {
        cellFrame           = [ _tableView frameOfCellAtColumn: 0 row: _tableView.selectedRow ];
        diagnostic          = [ _diagnostics objectAtIndex: ( NSUInteger )( _tableView.selectedRow ) ];
        controller          = [ [ CEFixItViewController alloc ] initWithDiagnostic: diagnostic ];
        controller.textView = _textView;
        
        [ controller openInPopoverRelativeToRect: cellFrame ofView: _tableView preferredEdge: NSMinYEdge ];
        [ controller autorelease ];
    }
    @catch( NSException * e )
    {
        ( void )e;
    }
}

@end
