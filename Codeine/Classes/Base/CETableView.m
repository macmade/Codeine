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

#import "CETableView.h"

@implementation CETableView

- ( void )keyDown: ( NSEvent * )e
{
    id < CETableViewDelegate > delegate;
    
    delegate = nil;
    
    if( [ self.delegate conformsToProtocol: @protocol( CETableViewDelegate ) ] )
    {
        delegate = ( id < CETableViewDelegate > )( self.delegate );
    }
    
    if( self.selectedRow != -1 )
    {
        if( [ delegate respondsToSelector: @selector( tableView:processKeyEvent:onRow:event: ) ] )
        {
            if( [ delegate tableView: self processKeyEvent: e.keyCode onRow: self.selectedRow event: e ] == YES )
            {
                return;
            }
        }
    }
    
    [ super keyDown: e ];
}

- ( void )mouseDown: ( NSEvent * )e
{
    NSPoint                     point;
    NSInteger                   row;
    NSInteger                   column;
    CGRect                      frame;
    id < CETableViewDelegate >  delegate;
    
    point       = [ self convertPoint: [ e locationInWindow ] fromView: nil ];
    row         = [ self rowAtPoint: point ];
    column      = [ self columnAtPoint: point ];
    frame       = [ self frameOfCellAtColumn: column row: row ];
    delegate    = nil;
    
    if( row == NSNotFound )
    {
        [ super mouseDown: e ];
        
        return;
    }
    
    point.x = point.x - frame.origin.x;
    point.y = point.y - frame.origin.y;
    
    if( [ self.delegate conformsToProtocol: @protocol( CETableViewDelegate ) ] )
    {
        delegate = ( id < CETableViewDelegate > )( self.delegate );
    }
    
    if( e.clickCount == 2 )
    {
        if( [ delegate respondsToSelector: @selector( tableView:shouldDoubleClickOnRow:atPoint:event: ) ] )
        {
            if( [ delegate tableView: self shouldDoubleClickOnRow: row atPoint: point event: e ] == NO )
            {
                return;
            }
        }
        
        if( [ delegate respondsToSelector: @selector( tableView:willDoubleClickOnRow:atPoint:event: ) ] )
        {
            [ delegate tableView: self willDoubleClickOnRow: row atPoint: point event: e ];
        }
        
        if( [ delegate respondsToSelector: @selector( tableView:didDoubleClickOnRow:atPoint:event: ) ] )
        {
            [ delegate tableView: self didDoubleClickOnRow: row atPoint: point event: e ];
        }
        else
        {
            [ super mouseDown: e ];
        }
    }
    else
    {
        if( [ delegate respondsToSelector: @selector( tableView:shouldClickOnRow:atPoint:event: ) ] )
        {
            if( [ delegate tableView: self shouldClickOnRow: row atPoint: point event: e ] == NO )
            {
                return;
            }
        }
        
        if( [ delegate respondsToSelector: @selector( tableView:willClickOnRow:atPoint:event: ) ] )
        {
            [ delegate tableView: self willClickOnRow: row atPoint: point event: e ];
        }
        
        if( [ delegate respondsToSelector: @selector( tableView:didClickOnRow:atPoint:event: ) ] )
        {
            [ delegate tableView: self didClickOnRow: row atPoint: point event: e ];
        }
        else
        {
            [ super mouseDown: e ];
        }
    }
}

@end
