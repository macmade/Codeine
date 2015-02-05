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

#import "CESourceFile.h"

FOUNDATION_EXPORT NSString * const CEPreferencesNotificationValueChanged;

FOUNDATION_EXPORT NSString * const CEPreferencesKeyFontSize;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyFontName;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyForegoundColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyBackgroundColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeySelectionColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyCurrentLineColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyInvisibleColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyKeywordColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyCommentColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyStringColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyPredefinedColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyNumberColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyProjectColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyPreprocessorColor;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyWarningFlags;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyWarningFlagsPresetStrict;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyWarningFlagsPresetNormal;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyObjCFrameworks;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyFileTypes;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyFirstLaunch;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyTextEncoding;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyDefaultLanguage;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyDefaultLicense;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyUserName;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyUserEmail;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyLineEndings;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyShowInvisibles;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyShowSpaces;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyAutoExpandTabs;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyAutoIndent;
FOUNDATION_EXPORT NSString * const CEPreferencesKeySoftWrap;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyShowLineNumbers;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyShowPageGuide;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyShowTabStops;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyHighlightCurrentLine;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyColorThemes;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyTreatWarningsAsErrors;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyShowHiddenFiles;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyBookmarks;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyLinkerObjects;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyObjCLoadAll;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyOptimizationLevel;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyFileBrowserHidden;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyDebugAreaHidden;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyFileBrowserWidth;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyDebugAreaHeight;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyDebugAreaSelectedIndex;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyTabWidth;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyPageGuideColumn;
FOUNDATION_EXPORT NSString * const CEPreferencesKeySuggestWhileTyping;
FOUNDATION_EXPORT NSString * const CEPreferencesKeySuggestWithEscape;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyIndentSoloBrace;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyIndentSoloBracket;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyIndentSoloParenthesis;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyIndentAfterBrace;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyIndentAfterBracket;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyIndentAfterParenthesis;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyInsertClosingBrace;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyInsertClosingBracket;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyInsertClosingParenteshis;
FOUNDATION_EXPORT NSString * const CEPreferencesKeySuggestDelay;
FOUNDATION_EXPORT NSString * const CEPreferencesKeyFullScreenStyle;

typedef enum
{
    CEPreferencesFullScreenStyleNative      = 0x00,
    CEPreferencesFullScreenStyleOldStyle    = 0x01
}
CEPreferencesFullScreenStyle;

@class CEColorTheme;
@class CELinkerObject;

@interface CEPreferences: NSObject
{
@protected
    
    
    
@private
    
    RESERVED_IVARS( CEPreferences, 5 );
}

@property( atomic, readwrite, assign ) NSString                   * fontName;
@property( atomic, readwrite, assign ) CGFloat                      fontSize;
@property( atomic, readwrite, assign ) NSColor                    * foregroundColor;
@property( atomic, readwrite, assign ) NSColor                    * backgroundColor;
@property( atomic, readwrite, assign ) NSColor                    * selectionColor;
@property( atomic, readwrite, assign ) NSColor                    * currentLineColor;
@property( atomic, readwrite, assign ) NSColor                    * invisibleColor;
@property( atomic, readwrite, assign ) NSColor                    * keywordColor;
@property( atomic, readwrite, assign ) NSColor                    * commentColor;
@property( atomic, readwrite, assign ) NSColor                    * stringColor;
@property( atomic, readwrite, assign ) NSColor                    * predefinedColor;
@property( atomic, readwrite, assign ) NSColor                    * numberColor;
@property( atomic, readwrite, assign ) NSColor                    * projectColor;
@property( atomic, readwrite, assign ) NSColor                    * preprocessorColor;
@property( atomic, readonly          ) NSDictionary               * warningFlags;
@property( atomic, readonly          ) NSDictionary               * warningFlagsPresetStrict;
@property( atomic, readonly          ) NSDictionary               * warningFlagsPresetNormal;
@property( atomic, readonly          ) NSArray                    * objCFrameworks;
@property( atomic, readonly          ) NSDictionary               * fileTypes;
@property( atomic, readwrite, assign ) BOOL                         firstLaunch;
@property( atomic, readwrite, assign ) NSStringEncoding             textEncoding;
@property( atomic, readwrite, assign ) CESourceFileLanguage         defaultLanguage;
@property( atomic, readwrite, assign ) NSString                   * defaultLicense;
@property( atomic, readwrite, assign ) NSString                   * userName;
@property( atomic, readwrite, assign ) NSString                   * userEmail;
@property( atomic, readwrite, assign ) CESourceFileLineEndings      lineEndings;
@property( atomic, readwrite, assign ) BOOL                         showInvisibles;
@property( atomic, readwrite, assign ) BOOL                         showSpaces;
@property( atomic, readwrite, assign ) BOOL                         autoExpandTabs;
@property( atomic, readwrite, assign ) BOOL                         autoIndent;
@property( atomic, readwrite, assign ) BOOL                         softWrap;
@property( atomic, readwrite, assign ) BOOL                         showLineNumbers;
@property( atomic, readwrite, assign ) BOOL                         showPageGuide;
@property( atomic, readwrite, assign ) BOOL                         showTabStops;
@property( atomic, readwrite, assign ) BOOL                         highlightCurrentLine;
@property( atomic, readonly          ) CEColorTheme               * currentColorTheme;
@property( atomic, readwrite, assign ) BOOL                         treatWarningsAsErrors;
@property( atomic, readwrite, assign ) BOOL                         showHiddenFiles;
@property( atomic, readonly          ) NSArray                    * bookmarks;
@property( atomic, readonly          ) NSArray                    * linkerObjects;
@property( atomic, readwrite, assign ) BOOL                         objCLoadAll;
@property( atomic, readwrite, assign ) CEOptimizationLevel          optimizationLevel;
@property( atomic, readwrite, assign ) BOOL                         fileBrowserHidden;
@property( atomic, readwrite, assign ) BOOL                         debugAreaHidden;
@property( atomic, readwrite, assign ) CGFloat                      fileBrowserWidth;
@property( atomic, readwrite, assign ) CGFloat                      debugAreaHeight;
@property( atomic, readwrite, assign ) NSUInteger                   debugAreaSelectedIndex;
@property( atomic, readwrite, assign ) NSUInteger                   tabWidth;
@property( atomic, readwrite, assign ) NSUInteger                   pageGuideColumn;
@property( atomic, readwrite, assign ) BOOL                         suggestWhileTyping;
@property( atomic, readwrite, assign ) BOOL                         suggestWithEscape;
@property( atomic, readwrite, assign ) BOOL                         indentSoloBrace;
@property( atomic, readwrite, assign ) BOOL                         indentSoloBracket;
@property( atomic, readwrite, assign ) BOOL                         indentSoloParenthesis;
@property( atomic, readwrite, assign ) BOOL                         indentAfterBrace;
@property( atomic, readwrite, assign ) BOOL                         indentAfterBracket;
@property( atomic, readwrite, assign ) BOOL                         indentAfterParenthesis;
@property( atomic, readwrite, assign ) BOOL                         insertClosingBrace;
@property( atomic, readwrite, assign ) BOOL                         insertClosingBracket;
@property( atomic, readwrite, assign ) BOOL                         insertClosingParenteshis;
@property( atomic, readwrite, assign ) CGFloat                      suggestDelay;
@property( atomic, readwrite, assign ) CEPreferencesFullScreenStyle fullScreenStyle;

+ ( CEPreferences * )sharedInstance;

- ( void )enableWarningFlag: ( NSString * )name;
- ( void )disableWarningFlag: ( NSString * )name;
- ( void )addObjCFramework: ( NSString * )name;
- ( void )removeObjCFramework: ( NSString * )name;
- ( void )addFileType: ( CESourceFileLanguage )type forExtension: ( NSString * )extension;
- ( void )removeFileTypeForExtension: ( NSString * )extension;
- ( void )setColorsFromColorTheme: ( CEColorTheme * )theme;
- ( void )addBookmark: ( NSString * )path;
- ( void )removeBookmark: ( NSString * )path;
- ( void )addLinkerObject: ( CELinkerObject * )object;
- ( void )removeLinkerObject: ( CELinkerObject * )object;
- ( void )setLanguage: ( CESourceFileLanguage )language ofLinkerObject: ( CELinkerObject * )object;

@end
