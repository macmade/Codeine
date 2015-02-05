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

#import "CEWindowController.h"

@class CEFilesViewController;
@class CEEditorViewController;
@class CEDebugViewController;
@class CESourceFile;
@class CELanguageWindowController;
@class CEFileDetailsViewController;
@class CEDocument;

FOUNDATION_EXPORT NSString * const CEMainWindowControllerDocumentsArrayKey;

@interface CEMainWindowController: CEWindowController
{
@protected
    
    CEFilesViewController       * _fileViewController;
    CEEditorViewController      * _editorViewController;
    CEDebugViewController       * _debugViewController;
    CEFileDetailsViewController * _fileDetailsViewController;
    NSView                      * _leftView;
    NSView                      * _mainView;
    NSView                      * _bottomView;
    CELanguageWindowController  * _languageWindowController;
    NSPopUpButton               * _encodingPopUp;
    NSMutableArray              * _documents;
    CEDocument                  * _activeDocument;
    NSSplitView                 * _horizontalSplitView;
    NSSplitView                 * _verticalSplitView;
    BOOL                          _fileBrowserHidden;
    BOOL                          _debugAreaHidden;
    NSSegmentedControl          * _viewsSegmentedControl;
    BOOL                          _fullScreen;
    
@private
    
    RESERVED_IVARS( CEMainWindowController , 5 );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSView               * leftView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView               * mainView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView               * bottomView;
@property( nonatomic, readwrite, retain ) IBOutlet NSPopUpButton        * encodingPopUp;
@property( nonatomic, readonly          )          NSArray              * documents;
@property( nonatomic, readwrite, retain )          CEDocument           * activeDocument;
@property( nonatomic, readwrite, retain ) IBOutlet NSSplitView          * horizontalSplitView;
@property( nonatomic, readwrite, retain ) IBOutlet NSSplitView          * verticalSplitView;
@property( nonatomic, readwrite, retain ) IBOutlet NSSegmentedControl   * viewsSegmentedControl;
@property( nonatomic, readonly          )          BOOL                   fullScreen;

- ( IBAction )addBookmark: ( id )sender;
- ( IBAction )removeBookmark: ( id )sender;
- ( IBAction )clearConsole: ( id )sender;
- ( IBAction )openDocument: ( id )sender;
- ( IBAction )newDocument: ( id )sender;
- ( IBAction )saveDocument: ( id )sender;
- ( IBAction )toggleFileBrowser: ( id )sender;
- ( IBAction )toggleDebugArea: ( id )sender;
- ( IBAction )toggleViews: ( id )sender;
- ( IBAction )toggleLineNumbers: ( id )sender;
- ( IBAction )toggleSoftWrap: ( id )sender;
- ( IBAction )toggleInvisibleCharacters: ( id )sender;
- ( IBAction )toggleFullScreenMode: ( id )sender;
- ( IBAction )enterFullScreenMode: ( id )sender;
- ( IBAction )exitFullScreenMode: ( id )sender;

@end
