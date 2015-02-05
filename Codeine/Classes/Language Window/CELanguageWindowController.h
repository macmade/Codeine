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
#import "CESourceFile.h"

@class CETextEncoding;
@class CEBackgroundView;
@class CELicensePopUpButton;

FOUNDATION_EXPORT NSString * const CELanguageWindowControllerTableColumnIdentifierIcon;
FOUNDATION_EXPORT NSString * const CELanguageWindowControllerTableColumnIdentifierTitle;

@interface CELanguageWindowController: CEWindowController
{
@protected
    
    CESourceFileLanguage    _language;
    CESourceFileLineEndings _lineEndings;
    CETextEncoding        * _encoding;
    NSPopUpButton         * _encodingPopUp;
    NSMatrix              * _lineEndingsMatrix;
    CEBackgroundView      * _contentView;
    NSImageView           * _iconView;
    NSTableView           * _languagesTableView;
    NSTableView           * _recentFilesTableView;
    CELicensePopUpButton  * _licensePopUp;
    
@private
    
    RESERVED_IVARS( CELanguageWindowController , 5 );
}

@property( atomic, readonly )                      CESourceFileLanguage     language;
@property( atomic, readonly )                      CESourceFileLineEndings  lineEndings;
@property( atomic, readonly )                      CETextEncoding         * encoding;
@property( nonatomic, readwrite, retain ) IBOutlet NSPopUpButton          * encodingPopUp;
@property( nonatomic, readwrite, retain ) IBOutlet NSMatrix               * lineEndingsMatrix;
@property( nonatomic, readwrite, retain ) IBOutlet CEBackgroundView       * contentView;
@property( nonatomic, readwrite, retain ) IBOutlet NSImageView            * iconView;
@property( nonatomic, readwrite, retain ) IBOutlet NSTableView            * languagesTableView;
@property( nonatomic, readwrite, retain ) IBOutlet NSTableView            * recentFilesTableView;
@property( nonatomic, readwrite, retain ) IBOutlet CELicensePopUpButton   * licensePopUp;
    
- ( IBAction )done: ( id )sender;
- ( IBAction )cancel: ( id )sender;

@end
