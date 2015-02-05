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

#import "CEInfoWindowController+NSOutlineViewDataSource.h"

@implementation CEInfoWindowController( NSOutlineViewDataSource )

- ( NSInteger )outlineView: ( NSOutlineView * )outlineView numberOfChildrenOfItem: ( id )item
{
    ( void )outlineView;
    
    if( item == nil )
    {
        return 4;
    }
    
    if( item == _generalLabelView )     { return 1; }
    if( item == _iconLabelView )        { return 1; }
    if( item == _permissionsLabelView ) { return 1; }
    
    return 0;
}

- ( BOOL )outlineView: ( NSOutlineView * )outlineView isItemExpandable: ( id )item
{
    ( void )outlineView;
    ( void )item;
    
    if( item == _generalLabelView )     { return YES; }
    if( item == _iconLabelView )        { return YES; }
    if( item == _permissionsLabelView ) { return YES; }
    
    return NO;
}

- ( id )outlineView: ( NSOutlineView * )outlineView child: ( NSInteger )index ofItem: ( id )item
{
    ( void )outlineView;
    ( void )index;
    
    if( item == nil )
    {
        switch ( index )
        {
            case 0:
                
                return _infoView;
                
            case 1:
                
                return _generalLabelView;
                
            case 2:
                
                return _iconLabelView;
                
            case 3:
                
                return _permissionsLabelView;
                
            default:
                
                return nil;
        }
    }
    
    if( item == _generalLabelView )     { return _generalView; }
    if( item == _iconLabelView )        { return _iconView; }
    if( item == _permissionsLabelView ) { return _permissionsView; }
    
    return nil;
}

- ( id )outlineView: ( NSOutlineView * )outlineView objectValueForTableColumn: ( NSTableColumn * )tableColumn byItem: ( id )item
{
    ( void )outlineView;
    ( void )tableColumn;
    ( void )item;
    
    return nil;
}

- ( id )outlineView: ( NSOutlineView * )outlineView itemForPersistentObject: ( id )object
{
    ( void )outlineView;
    
    if( [ object isKindOfClass: [ NSNumber class ] ] == NO )
    {
        return nil;
    }
    
    if( [ ( NSNumber * )object integerValue ] == 0 ) { return _generalLabelView; }
    if( [ ( NSNumber * )object integerValue ] == 1 ) { return _iconLabelView; }
    if( [ ( NSNumber * )object integerValue ] == 2 ) { return _permissionsLabelView; }
    
    return nil;
}

- ( id )outlineView: ( NSOutlineView * )outlineView persistentObjectForItem: ( id )item
{
    ( void )outlineView;
    
    if( item == _generalLabelView     ) { return [ NSNumber numberWithInteger: 0 ]; }
    if( item == _iconLabelView        ) { return [ NSNumber numberWithInteger: 1 ]; }
    if( item == _permissionsLabelView ) { return [ NSNumber numberWithInteger: 2 ]; }
    
    return nil;
}

@end
