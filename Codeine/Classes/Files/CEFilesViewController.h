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

#import "CEViewController.h"

@class CEFilesViewItem;
@class CEMainWindowController;

@interface CEFilesViewController: CEViewController
{
@protected
    
    NSOutlineView           * _outlineView;
    NSMutableArray          * _rootItems;
    NSMenu                  * _openDocumentMenu;
    NSMenu                  * _bookmarkMenu;
    NSMenu                  * _fsDirectoryMenu;
    NSMenu                  * _fsFileMenu;
    CEFilesViewItem         * _quickLookItem;
    CEMainWindowController  * _mainWindowController;
    CEFilesViewItem         * _openDocumentsItem;
    
@private
    
    RESERVED_IVARS( CEFilesViewController , 5 );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSOutlineView          * outlineView;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu                 * openDocumentMenu;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu                 * bookmarkMenu;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu                 * fsDirectoryMenu;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu                 * fsFileMenu;
@property( atomic,    readwrite, assign )          CEMainWindowController * mainWindowController;

- ( IBAction )addBookmark: ( id )sender;
- ( IBAction )removeBookmark: ( id )sender;
- ( IBAction )menuActionOpen: ( id )sender;
- ( IBAction )menuActionClose: ( id )sender;
- ( IBAction )menuActionShowInFinder: ( id )sender;
- ( IBAction )menuActionOpenInDefaultEditor: ( id )sender;
- ( IBAction )menuActionDelete: ( id )sender;
- ( IBAction )menuActionRemoveBookmark: ( id )sender;
- ( IBAction )menuActionGetInfo: ( id )sender;
- ( IBAction )menuActionQuickLook: ( id )sender;
- ( IBAction )menuActionSetColorLabel: ( id )sender;

@end
