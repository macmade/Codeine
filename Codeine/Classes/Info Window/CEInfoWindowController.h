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

@interface CEInfoWindowController: CEWindowController
{
@protected
    
    NSString        * _path;
    NSDictionary    * _attributes;
    BOOL              _isDirectory;
    NSOutlineView   * _outlineView;
    NSView          * _infoView;
    NSView          * _generalLabelView;
    NSView          * _iconLabelView;
    NSView          * _permissionsLabelView;
    NSView          * _generalView;
    NSView          * _iconView;
    NSView          * _permissionsView;
    NSImageView     * _smallIconView;
    NSImageView     * _largeIconView;
    NSTextField     * _infoNameTextField;
    NSTextField     * _infoSizeTextField;
    NSTextField     * _infoDateTextField;
    NSTextField     * _generalKindTextField;
    NSTextField     * _generalSizeTextField;
    NSTextField     * _generalPathTextField;
    NSTextField     * _generalCTimeTextField;
    NSTextField     * _generalMTimeTextField;
    NSTextField     * _permissionsReadableTextField;
    NSTextField     * _permissionsWriteableTextField;
    NSTextField     * _permissionsOwnerTextField;
    NSTextField     * _permissionsGroupTextField;
    NSTextField     * _permissionsOctalTextField;
    NSTextField     * _permissionsHumanTextField;
    
@private
    
    RESERVED_IVARS( CEInfoWindowController, 5 );
}

@property( atomic, readonly             )          NSString      * path;
@property( nonatomic, readwrite, retain ) IBOutlet NSOutlineView * outlineView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView        * infoView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView        * generalLabelView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView        * iconLabelView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView        * permissionsLabelView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView        * generalView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView        * iconView;
@property( nonatomic, readwrite, retain ) IBOutlet NSView        * permissionsView;
@property( nonatomic, readwrite, retain ) IBOutlet NSImageView   * smallIconView;
@property( nonatomic, readwrite, retain ) IBOutlet NSImageView   * largeIconView;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * infoNameTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * infoSizeTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * infoDateTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * generalKindTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * generalSizeTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * generalPathTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * generalCTimeTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * generalMTimeTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * permissionsReadableTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * permissionsWriteableTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * permissionsOwnerTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * permissionsGroupTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * permissionsOctalTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * permissionsHumanTextField;


- ( id )initWithPath: ( NSString * )path;

@end
