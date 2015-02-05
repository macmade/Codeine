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

#import "CEPreferences.h"
#import "CEPreferences+Private.h"
#import "CEColorTheme.h"
#import "CELinkerObject.h"

#define __PREFERENCES_CHANGE_NOTIFY( __key__ )  [ ( NSNotificationCenter * )[ NSNotificationCenter defaultCenter ] postNotificationName: CEPreferencesNotificationValueChanged object: __key__ ]

static CEPreferences * __sharedInstance = nil;

NSString * const CEPreferencesNotificationValueChanged      = @"CEPreferencesNotificationValueChanged";

NSString * const CEPreferencesKeyFontName                   = @"FontName";
NSString * const CEPreferencesKeyFontSize                   = @"FontSize";
NSString * const CEPreferencesKeyForegoundColor             = @"ForegroundColor";
NSString * const CEPreferencesKeyBackgroundColor            = @"BackgroundColor";
NSString * const CEPreferencesKeySelectionColor             = @"SelectionColor";
NSString * const CEPreferencesKeyCurrentLineColor           = @"CurrentLineColor";
NSString * const CEPreferencesKeyInvisibleColor             = @"InvisibleColor";
NSString * const CEPreferencesKeyKeywordColor               = @"KeywordColor";
NSString * const CEPreferencesKeyCommentColor               = @"CommentColor";
NSString * const CEPreferencesKeyStringColor                = @"StringColor";
NSString * const CEPreferencesKeyPredefinedColor            = @"PredefinedColor";
NSString * const CEPreferencesKeyNumberColor                = @"NumberColor";
NSString * const CEPreferencesKeyProjectColor               = @"ProjectColor";
NSString * const CEPreferencesKeyPreprocessorColor          = @"PreprocessorColor";
NSString * const CEPreferencesKeyWarningFlags               = @"WarningFlags";
NSString * const CEPreferencesKeyWarningFlagsPresetStrict   = @"WarningFlagsPresetStrict";
NSString * const CEPreferencesKeyWarningFlagsPresetNormal   = @"WarningFlagsPresetNormal";
NSString * const CEPreferencesKeyObjCFrameworks             = @"ObjCFrameworks";
NSString * const CEPreferencesKeyFileTypes                  = @"FileTypes";
NSString * const CEPreferencesKeyFirstLaunch                = @"FirstLaunch";
NSString * const CEPreferencesKeyTextEncoding               = @"TextEncoding";
NSString * const CEPreferencesKeyDefaultLanguage            = @"DefaultLanguage";
NSString * const CEPreferencesKeyDefaultLicense             = @"DefaultLicense";
NSString * const CEPreferencesKeyUserName                   = @"UserName";
NSString * const CEPreferencesKeyUserEmail                  = @"UserEmail";
NSString * const CEPreferencesKeyLineEndings                = @"LineEndings";
NSString * const CEPreferencesKeyShowInvisibles             = @"ShowInvisibles";
NSString * const CEPreferencesKeyShowSpaces                 = @"ShowSpaces";
NSString * const CEPreferencesKeyAutoExpandTabs             = @"AutoExpandTabs";
NSString * const CEPreferencesKeyAutoIndent                 = @"AutoIndent";
NSString * const CEPreferencesKeySoftWrap                   = @"SoftWrap";
NSString * const CEPreferencesKeyShowLineNumbers            = @"ShowLineNumbers";
NSString * const CEPreferencesKeyShowPageGuide              = @"ShowPageGuide";
NSString * const CEPreferencesKeyShowTabStops               = @"ShowTabStops";
NSString * const CEPreferencesKeyHighlightCurrentLine       = @"HighlightCurrentLine";
NSString * const CEPreferencesKeyColorThemes                = @"ColorThemes";
NSString * const CEPreferencesKeyTreatWarningsAsErrors      = @"TreatWarningsAsErrors";
NSString * const CEPreferencesKeyShowHiddenFiles            = @"ShowHiddenFiles";
NSString * const CEPreferencesKeyBookmarks                  = @"Bookmarks";
NSString * const CEPreferencesKeyLinkerObjects              = @"LinkerObjects";
NSString * const CEPreferencesKeyObjCLoadAll                = @"ObjCLoadAll";
NSString * const CEPreferencesKeyOptimizationLevel          = @"OptimizationLevel";
NSString * const CEPreferencesKeyFileBrowserHidden          = @"FileBrowserHidden";
NSString * const CEPreferencesKeyDebugAreaHidden            = @"DebugAreaHidden";
NSString * const CEPreferencesKeyFileBrowserWidth           = @"FileBrowserWidth";
NSString * const CEPreferencesKeyDebugAreaHeight            = @"DebugAreaHeight";
NSString * const CEPreferencesKeyDebugAreaSelectedIndex     = @"DebugAreaSelectedIndex";
NSString * const CEPreferencesKeyTabWidth					= @"TabWidth";
NSString * const CEPreferencesKeyPageGuideColumn			= @"PageGuideColumn";
NSString * const CEPreferencesKeySuggestWhileTyping			= @"SuggestWhileTyping";
NSString * const CEPreferencesKeySuggestWithEscape			= @"SuggestWithEscape";
NSString * const CEPreferencesKeyIndentSoloBrace			= @"IndentSoloBrace";
NSString * const CEPreferencesKeyIndentSoloBracket			= @"IndentSoloBracket";
NSString * const CEPreferencesKeyIndentSoloParenthesis		= @"IndentSoloParenthesis";
NSString * const CEPreferencesKeyIndentAfterBrace			= @"IndentAfterBrace";
NSString * const CEPreferencesKeyIndentAfterBracket			= @"IndentAfterBracket";
NSString * const CEPreferencesKeyIndentAfterParenthesis		= @"IndentAfterParenthesis";
NSString * const CEPreferencesKeyInsertClosingBrace			= @"InsertClosingBrace";
NSString * const CEPreferencesKeyInsertClosingBracket		= @"InsertClosingBracket";
NSString * const CEPreferencesKeyInsertClosingParenteshis	= @"InsertClosingParenteshis";
NSString * const CEPreferencesKeySuggestDelay               = @"SuggestDelay";
NSString * const CEPreferencesKeyFullScreenStyle            = @"FullScreenStyle";

@implementation CEPreferences

+ ( CEPreferences * )sharedInstance
{
    @synchronized( self )
    {
        if( __sharedInstance == nil )
        {
            __sharedInstance = [ [ super allocWithZone: NULL ] init ];
        }
    }
    
    return __sharedInstance;
}

+ ( id )allocWithZone:( NSZone * )zone
{
    ( void )zone;
    
    @synchronized( self )
    {
        return [ [ self sharedInstance ] retain ];
    }
}

- ( id )copyWithZone:( NSZone * )zone
{
    ( void )zone;
    
    return self;
}

- ( id )retain
{
    return self;
}

- ( NSUInteger )retainCount
{
    return UINT_MAX;
}

- ( oneway void )release
{}

- ( id )autorelease
{
    return self;
}

- ( id )init
{
    NSDictionary * defaults;
    
    if( ( self = [ super init ] ) )
    {
        defaults  = [ NSDictionary dictionaryWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"Defaults" ofType: @"plist" ] ];
        
        [ DEFAULTS registerDefaults: defaults ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ super dealloc ];
}

- ( void )enableWarningFlag: ( NSString * )name
{
    NSMutableDictionary * flags;
    
    flags = [ [ self warningFlags ] mutableCopy ];
    
    [ flags setObject: [ NSNumber numberWithBool: YES ] forKey: name ];
    
    [ DEFAULTS setObject: [ NSDictionary dictionaryWithDictionary: flags ] forKey: CEPreferencesKeyWarningFlags ];
    [ DEFAULTS synchronize ];
    
    __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyWarningFlags );
    
    [ flags release ];
}

- ( void )disableWarningFlag: ( NSString * )name
{
    NSMutableDictionary * flags;
    
    flags = [ [ self warningFlags ] mutableCopy ];
    
    [ flags setObject: [ NSNumber numberWithBool: NO ] forKey: name ];
    
    [ DEFAULTS setObject: [ NSDictionary dictionaryWithDictionary: flags ] forKey: CEPreferencesKeyWarningFlags ];
    [ DEFAULTS synchronize ];
    
    __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyWarningFlags );
    
    [ flags release ];
}

- ( void )addObjCFramework: ( NSString * )name
{
    NSMutableArray * frameworks;
    
    frameworks = [ [ self objCFrameworks ] mutableCopy ];
    
    if( [ frameworks containsObject: name ] == NO )
    {
        [ frameworks addObject: name ];
    
        [ DEFAULTS setObject: [ NSArray arrayWithArray: frameworks ] forKey: CEPreferencesKeyObjCFrameworks ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyWarningFlags );
    }
    
    [ frameworks release ];
}

- ( void )removeObjCFramework: ( NSString * )name
{
    NSMutableArray * frameworks;
    
    frameworks = [ [ self objCFrameworks ] mutableCopy ];
    
    if( [ frameworks containsObject: name ] == YES )
    {
        [ frameworks removeObject: name ];
    
        [ DEFAULTS setObject: [ NSArray arrayWithArray: frameworks ] forKey: CEPreferencesKeyObjCFrameworks ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyWarningFlags );
    }
    
    [ frameworks release ];
}

- ( void )addFileType: ( CESourceFileLanguage )type forExtension: ( NSString * )extension
{
    NSMutableDictionary * types;
    
    types = [ [ self fileTypes ] mutableCopy ];
    
    [ types setObject: [ NSNumber numberWithUnsignedInteger: ( NSUInteger )type ] forKey: extension ];
    
    [ DEFAULTS setObject: [ NSDictionary dictionaryWithDictionary: types ] forKey: CEPreferencesKeyFileTypes ];
    [ DEFAULTS synchronize ];
        
    __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFileTypes );
    
    [ types release ];
}

- ( void )removeFileTypeForExtension: ( NSString * )extension
{
    NSMutableDictionary * types;
    
    types = [ [ self fileTypes ] mutableCopy ];
    
    if( [ types objectForKey: extension ] != nil )
    {
        [ types removeObjectForKey: extension ];
        
        [ DEFAULTS setObject: [ NSDictionary dictionaryWithDictionary: types ] forKey: CEPreferencesKeyFileTypes ];
        [ DEFAULTS synchronize ];
            
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFileTypes );
    }
    
    [ types release ];
}

- ( void )setColorsFromColorTheme: ( CEColorTheme * )theme
{
    self.foregroundColor    = theme.foregroundColor;
    self.backgroundColor    = theme.backgroundColor;
    self.selectionColor     = theme.selectionColor;
    self.currentLineColor   = theme.currentLineColor;
    self.invisibleColor     = theme.invisibleColor;
    self.keywordColor       = theme.keywordColor;
    self.commentColor       = theme.commentColor;
    self.stringColor        = theme.stringColor;
    self.predefinedColor    = theme.predefinedColor;
    self.projectColor       = theme.projectColor;
    self.preprocessorColor  = theme.preprocessorColor;
    self.numberColor        = theme.numberColor;
}

- ( void )addBookmark: ( NSString * )path
{
    NSMutableArray * bookmarks;
    
    bookmarks = [ self.bookmarks mutableCopy ];
    
    if( [ bookmarks containsObject: path ] == NO )
    {
        [ bookmarks addObject: path ];
        [ DEFAULTS setObject: [ NSArray arrayWithArray: bookmarks ] forKey: CEPreferencesKeyBookmarks ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyBookmarks );
    }
    
    [ bookmarks release ];
}

- ( void )removeBookmark: ( NSString * )path
{
    NSMutableArray * bookmarks;
    
    bookmarks = [ self.bookmarks mutableCopy ];
    
    if( [ bookmarks containsObject: path ] == YES )
    {
        [ bookmarks removeObject: path ];
        [ DEFAULTS setObject: [ NSArray arrayWithArray: bookmarks ] forKey: CEPreferencesKeyBookmarks ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyBookmarks );
    }
    
    [ bookmarks release ];
}

- ( void )addLinkerObject: ( CELinkerObject * )object
{
    NSArray            * allObjects;
    NSMutableArray     * objects;
    NSDictionary       * objectDict;
    NSDictionary       * dict;
    NSString           * path;
    CELinkerObjectType   type;
    CESourceFileLanguage language;
    BOOL                 found;
    
    allObjects  = self.linkerObjects;
    objects     = [ self.linkerObjects mutableCopy ];
    found       = NO;
    
    for( objectDict in allObjects )
    {
        type     = ( CELinkerObjectType )[ ( NSNumber * )[ objectDict valueForKey: @"Type" ] integerValue ];
        language = ( CESourceFileLanguage )[ ( NSNumber * )[ objectDict valueForKey: @"Language" ] integerValue ];
        path     = [ objectDict valueForKey: @"Path" ];
        
        if
        (
               type     == object.type
            && language == object.language
            && [ path isEqualToString: object.path ]
        )
        {
            found = YES;
            
            break;
        }
    }
    
    if( found == NO )
    {
        dict = [ NSDictionary dictionaryWithObjectsAndKeys: object.path,                                        @"Path",
                                                            [ NSNumber numberWithInteger: object.type ],        @"Type",
                                                            [ NSNumber numberWithInteger: object.language ],    @"Language",
                                                            nil
               ];
        
        [ objects addObject: dict ];
        [ DEFAULTS setObject: [ NSArray arrayWithArray: objects ] forKey: CEPreferencesKeyLinkerObjects ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyLinkerObjects );
    }
    
    [ objects release ];
}

- ( void )removeLinkerObject: ( CELinkerObject * )object
{
    NSArray            * allObjects;
    NSMutableArray     * objects;
    NSDictionary       * objectDict;
    NSString           * path;
    CELinkerObjectType   type;
    CESourceFileLanguage language;
    NSUInteger           i;
    BOOL                 found;
    
    allObjects  = self.linkerObjects;
    objects     = [ self.linkerObjects mutableCopy ];
    i           = 0;
    found       = NO;
    
    for( objectDict in allObjects )
    {
        type     = ( CELinkerObjectType )[ ( NSNumber * )[ objectDict valueForKey: @"Type" ] integerValue ];
        language = ( CESourceFileLanguage )[ ( NSNumber * )[ objectDict valueForKey: @"Language" ] integerValue ];
        path     = [ objectDict valueForKey: @"Path" ];
        
        if
        (
               type     == object.type
            && language == object.language
            && [ path isEqualToString: object.path ]
        )
        {
            found = YES;
            
            break;
        }
        
        i++;
    }
    
    if( found == YES )
    {
        [ objects removeObjectAtIndex: i ];
        [ DEFAULTS setObject: [ NSArray arrayWithArray: objects ] forKey: CEPreferencesKeyLinkerObjects ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyLinkerObjects );
    }
    
    [ objects release ];
}

- ( void )setLanguage: ( CESourceFileLanguage )language ofLinkerObject: ( CELinkerObject * )object
{
    NSArray            * allObjects;
    NSMutableArray     * objects;
    NSDictionary       * objectDict;
    NSDictionary       * newObjectDict;
    NSString           * path;
    CELinkerObjectType   type;
    CESourceFileLanguage currentLanguage;
    NSUInteger           i;
    
    allObjects      = self.linkerObjects;
    objects         = [ allObjects mutableCopy ];
    i               = 0;
    newObjectDict   = nil;
    
    for( objectDict in objects )
    {
        type            = ( CELinkerObjectType )[ ( NSNumber * )[ objectDict valueForKey: @"Type" ] integerValue ];
        currentLanguage = ( CESourceFileLanguage )[ ( NSNumber * )[ objectDict valueForKey: @"Language" ] integerValue ];
        path            = [ objectDict valueForKey: @"Path" ];
        
        if
        (
               type            == object.type
            && currentLanguage == object.language
            && [ path isEqualToString: object.path ]
        )
        {
            newObjectDict = [ NSDictionary dictionaryWithObjectsAndKeys:    path,                                       @"Path",
                                                                            [ NSNumber numberWithInteger: type ],       @"Type",
                                                                            [ NSNumber numberWithInteger: language ],   @"Language",
                                                                            nil
                            ];
            break;
        }
        
        i++;
    }
    
    if( newObjectDict != nil )
    {
        [ objects replaceObjectAtIndex: i withObject: newObjectDict ];
        [ DEFAULTS setObject: objects forKey: CEPreferencesKeyLinkerObjects ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyLinkerObjects );
    }
    
    [ objects release ];
}

#pragma mark -
#pragma mark Getters

- ( NSString * )fontName
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyFontName ];
    }
}

- ( CGFloat )fontSize
{
    @synchronized( self )
    {
        return [ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyFontSize ] doubleValue ];
    }
}

- ( NSColor * )foregroundColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyForegoundColor ];
    }
}

- ( NSColor * )backgroundColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyBackgroundColor ];
    }
}

- ( NSColor * )selectionColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeySelectionColor ];
    }
}

- ( NSColor * )currentLineColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyCurrentLineColor ];
    }
}

- ( NSColor * )invisibleColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyInvisibleColor ];
    }
}

- ( NSColor * )keywordColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyKeywordColor ];
    }
}

- ( NSColor * )commentColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyCommentColor ];
    }
}

- ( NSColor * )stringColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyStringColor ];
    }
}

- ( NSColor * )predefinedColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyPredefinedColor ];
    }
}

- ( NSColor * )numberColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyNumberColor ];
    }
}

- ( NSColor * )projectColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyProjectColor ];
    }
}

- ( NSColor * )preprocessorColor
{
    @synchronized( self )
    {
        return [ self colorForKey: CEPreferencesKeyPreprocessorColor ];
    }
}

- ( NSDictionary * )warningFlags
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyWarningFlags ];
    }
}

- ( NSDictionary * )warningFlagsPresetStrict
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyWarningFlagsPresetStrict ];
    }
}

- ( NSDictionary * )warningFlagsPresetNormal
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyWarningFlagsPresetNormal ];
    }
}

- ( NSArray * )objCFrameworks
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyObjCFrameworks ];
    }
}

- ( NSDictionary * )fileTypes
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyFileTypes ];
    }
}

- ( BOOL )firstLaunch
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyFirstLaunch ];
    }
}

- ( NSStringEncoding )textEncoding
{
    @synchronized( self )
    {
        return [ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyTextEncoding ] unsignedIntegerValue ];
    }
}

- ( CESourceFileLanguage )defaultLanguage
{
    @synchronized( self )
    {
        return ( CESourceFileLanguage )[ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyDefaultLanguage ] unsignedIntegerValue ];
    }
}

- ( NSString * )defaultLicense
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyDefaultLicense ];
    }
}

- ( NSString * )userName
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyUserName ];
    }
}

- ( NSString * )userEmail
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyUserEmail ];
    }
}

- ( CESourceFileLineEndings )lineEndings
{
    @synchronized( self )
    {
        return ( CESourceFileLineEndings )[ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyLineEndings ] unsignedIntegerValue ];
    }
}

- ( BOOL )showInvisibles
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyShowInvisibles ];
    }
}

- ( BOOL )showSpaces
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyShowSpaces ];
    }
}

- ( BOOL )autoExpandTabs
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyAutoExpandTabs ];
    }
}

- ( BOOL )autoIndent
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyAutoIndent ];
    }
}

- ( BOOL )softWrap
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeySoftWrap ];
    }
}

- ( BOOL )showLineNumbers
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyShowLineNumbers ];
    }
}

- ( BOOL )showPageGuide
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyShowPageGuide ];
    }
}

- ( BOOL )showTabStops
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyShowTabStops ];
    }
}

- ( BOOL )highlightCurrentLine
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyHighlightCurrentLine ];
    }
}

- ( CEColorTheme * )currentColorTheme
{
    CEColorTheme * theme;
    
    theme = [ CEColorTheme colorThemeWithName: nil ];
    
    theme.foregroundColor    = self.foregroundColor;
    theme.backgroundColor    = self.backgroundColor;
    theme.selectionColor     = self.selectionColor;
    theme.currentLineColor   = self.currentLineColor;
    theme.invisibleColor     = self.invisibleColor;
    theme.keywordColor       = self.keywordColor;
    theme.commentColor       = self.commentColor;
    theme.stringColor        = self.stringColor;
    theme.predefinedColor    = self.predefinedColor;
    theme.projectColor       = self.projectColor;
    theme.preprocessorColor  = self.preprocessorColor;
    theme.numberColor        = self.numberColor;
    
    return theme;
}

- ( BOOL )treatWarningsAsErrors
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyTreatWarningsAsErrors ];
    }
}

- ( BOOL )showHiddenFiles
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyShowHiddenFiles ];
    }
}

- ( NSArray * )bookmarks
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyBookmarks ];
    }
}

- ( NSArray * )linkerObjects
{
    @synchronized( self )
    {
        return [ DEFAULTS objectForKey: CEPreferencesKeyLinkerObjects ];
    }
}

- ( BOOL )objCLoadAll
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyObjCLoadAll ];
    }
}

- ( CEOptimizationLevel )optimizationLevel
{
    @synchronized( self )
    {
        return ( CEOptimizationLevel )[ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyOptimizationLevel ] integerValue ];
    }
}

- ( BOOL )fileBrowserHidden
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyFileBrowserHidden ];
    }
}

- ( BOOL )debugAreaHidden
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyDebugAreaHidden ];
    }
}

- ( CGFloat )fileBrowserWidth
{
    @synchronized( self )
    {
        return ( CGFloat )[ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyFileBrowserWidth ] doubleValue ];
    }
}

- ( CGFloat )debugAreaHeight
{
    @synchronized( self )
    {
        return ( CGFloat )[ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyDebugAreaHeight ] doubleValue ];
    }
}

- ( NSUInteger )debugAreaSelectedIndex
{
    @synchronized( self )
    {
        return [ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyDebugAreaSelectedIndex ] unsignedIntegerValue ];
    }
}

- ( NSUInteger )tabWidth
{
    @synchronized( self )
    {
        return [ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyTabWidth ] unsignedIntegerValue ];
    }
}

- ( NSUInteger )pageGuideColumn
{
    @synchronized( self )
    {
        return [ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyPageGuideColumn ] unsignedIntegerValue ];
    }
}

- ( BOOL )suggestWhileTyping
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeySuggestWhileTyping ];
    }
}

- ( BOOL )suggestWithEscape
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeySuggestWithEscape ];
    }
}

- ( BOOL )indentSoloBrace
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyIndentSoloBrace ];
    }
}

- ( BOOL )indentSoloBracket
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyIndentSoloBracket ];
    }
}

- ( BOOL )indentSoloParenthesis
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyIndentSoloParenthesis ];
    }
}

- ( BOOL )indentAfterBrace
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyIndentAfterBrace ];
    }
}

- ( BOOL )indentAfterBracket
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyIndentAfterBracket ];
    }
}

- ( BOOL )indentAfterParenthesis
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyIndentAfterParenthesis ];
    }
}

- ( BOOL )insertClosingBrace
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyInsertClosingBrace ];
    }
}

- ( BOOL )insertClosingBracket
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyInsertClosingBracket ];
    }
}

- ( BOOL )insertClosingParenteshis
{
    @synchronized( self )
    {
        return [ DEFAULTS boolForKey: CEPreferencesKeyInsertClosingParenteshis ];
    }
}

- ( CGFloat )suggestDelay
{
    @synchronized( self )
    {
        return ( CGFloat )[ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeySuggestDelay ] doubleValue ];
    }
}

- ( CEPreferencesFullScreenStyle )fullScreenStyle
{
    @synchronized( self )
    {
        return ( CEPreferencesFullScreenStyle )[ ( NSNumber * )[ DEFAULTS objectForKey: CEPreferencesKeyFullScreenStyle ] integerValue ];
    }
}

#pragma mark -
#pragma mark Setters

- ( void )setFontName: ( NSString * )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: value forKey: CEPreferencesKeyFontName ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFontName );
    }
}

- ( void )setFontSize: ( CGFloat )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithDouble: value ] forKey: CEPreferencesKeyFontSize ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFontSize );
    }
}

- ( void )setForegroundColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyForegoundColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyForegoundColor );
    }
}

- ( void )setBackgroundColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyBackgroundColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyBackgroundColor );
    }
}

- ( void )setSelectionColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeySelectionColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeySelectionColor );
    }
}

- ( void )setCurrentLineColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyCurrentLineColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyCurrentLineColor );
    }
}

- ( void )setInvisibleColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyInvisibleColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyInvisibleColor );
    }
}

- ( void )setKeywordColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyKeywordColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyKeywordColor );
    }
}

- ( void )setCommentColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyCommentColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyCommentColor );
    }
}

- ( void )setStringColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyStringColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyStringColor );
    }
}

- ( void )setPredefinedColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyPredefinedColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyPredefinedColor );
    }
}

- ( void )setNumberColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyNumberColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyNumberColor );
    }
}

- ( void )setProjectColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyProjectColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyProjectColor );
    }
}

- ( void )setPreprocessorColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self setColor: value forKey: CEPreferencesKeyPreprocessorColor ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyPreprocessorColor );
    }
}

- ( void )setFirstLaunch: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyFirstLaunch ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFirstLaunch );
    }
}

- ( void )setTextEncoding: ( NSStringEncoding )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithUnsignedInteger: value ] forKey: CEPreferencesKeyTextEncoding ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyTextEncoding );
    }
}

- ( void )setDefaultLanguage: ( CESourceFileLanguage )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithUnsignedInteger: value ] forKey: CEPreferencesKeyDefaultLanguage ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyDefaultLanguage );
    }
}

- ( void )setDefaultLicense: ( NSString * )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: value forKey: CEPreferencesKeyDefaultLicense ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyDefaultLicense );
    }
}

- ( void )setUserName: ( NSString * )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: value forKey: CEPreferencesKeyUserName ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyUserName );
    }
}

- ( void )setUserEmail: ( NSString * )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: value forKey: CEPreferencesKeyUserEmail ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyUserEmail );
    }
}

- ( void )setLineEndings: ( CESourceFileLineEndings )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithUnsignedInteger: value ] forKey: CEPreferencesKeyLineEndings ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyLineEndings );
    }
}

- ( void )setShowInvisibles: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyShowInvisibles ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyShowInvisibles );
    }
}

- ( void )setShowSpaces: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyShowSpaces ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyShowSpaces );
    }
}

- ( void )setAutoExpandTabs: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyAutoExpandTabs ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyAutoExpandTabs );
    }
}

- ( void )setAutoIndent: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyAutoIndent ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyAutoIndent );
    }
}

- ( void )setSoftWrap: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeySoftWrap ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeySoftWrap );
    }
}

- ( void )setShowLineNumbers: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyShowLineNumbers ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyShowLineNumbers );
    }
}

- ( void )setShowPageGuide: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyShowPageGuide ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyShowPageGuide );
    }
}

- ( void )setShowTabStops: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyShowTabStops ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyShowTabStops );
    }
}

- ( void )setHighlightCurrentLine: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyHighlightCurrentLine ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyHighlightCurrentLine );
    }
}

- ( void )setTreatWarningsAsErrors: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyTreatWarningsAsErrors ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyTreatWarningsAsErrors );
    }
}

- ( void )setShowHiddenFiles: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyShowHiddenFiles ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyShowHiddenFiles );
    }
}

- ( void )setObjCLoadAll: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyObjCLoadAll ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyObjCLoadAll );
    }
}

- ( void )setOptimizationLevel: ( CEOptimizationLevel )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithInteger: value ] forKey: CEPreferencesKeyOptimizationLevel ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyOptimizationLevel );
    }
}

- ( void )setFileBrowserHidden: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyFileBrowserHidden ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFileBrowserHidden );
    }
}

- ( void )setDebugAreaHidden: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyDebugAreaHidden ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyDebugAreaHidden );
    }
}

- ( void )setFileBrowserWidth: ( CGFloat )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithDouble: ( double )value ] forKey: CEPreferencesKeyFileBrowserWidth ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFileBrowserWidth );
    }
}

- ( void )setDebugAreaHeight: ( CGFloat )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithDouble: ( double )value ] forKey: CEPreferencesKeyDebugAreaHeight ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyDebugAreaHeight );
    }
}

- ( void )setDebugAreaSelectedIndex: ( NSUInteger )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithUnsignedInteger: value ] forKey: CEPreferencesKeyDebugAreaSelectedIndex ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyDebugAreaSelectedIndex );
    }
}

- ( void )setTabWidth: ( NSUInteger )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithUnsignedInteger: value ] forKey: CEPreferencesKeyTabWidth ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyTabWidth );
    }
}

- ( void )setPageGuideColumn: ( NSUInteger )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithUnsignedInteger: value ] forKey: CEPreferencesKeyPageGuideColumn ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyPageGuideColumn );
    }
}

- ( void )setSuggestWhileTyping: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeySuggestWhileTyping ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeySuggestWhileTyping );
    }
}

- ( void )setSuggestWithEscape: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeySuggestWithEscape ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeySuggestWithEscape );
    }
}

- ( void )setIndentSoloBrace: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyIndentSoloBrace ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyIndentSoloBrace );
    }
}

- ( void )setIndentSoloBracket: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyIndentSoloBracket ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyIndentSoloBracket );
    }
}

- ( void )setIndentSoloParenthesis: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyIndentSoloParenthesis ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyIndentSoloParenthesis );
    }
}

- ( void )setIndentAfterBrace: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyIndentAfterBrace ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyIndentAfterBrace );
    }
}

- ( void )setIndentAfterBracket: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyIndentAfterBracket ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyIndentAfterBracket );
    }
}

- ( void )setIndentAfterParenthesis: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyIndentAfterParenthesis ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyIndentAfterParenthesis );
    }
}

- ( void )setInsertClosingBrace: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyInsertClosingBrace ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyInsertClosingBrace );
    }
}

- ( void )setInsertClosingBracket: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyInsertClosingBracket ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyInsertClosingBracket );
    }
}

- ( void )setInsertClosingParenteshis: ( BOOL )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithBool: value ] forKey: CEPreferencesKeyInsertClosingParenteshis ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyInsertClosingParenteshis );
    }
}

- ( void )setSuggestDelay: ( CGFloat )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithDouble: ( double )value ] forKey: CEPreferencesKeySuggestDelay ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeySuggestDelay );
    }
}

- ( void )setFullScreenStyle: ( CEPreferencesFullScreenStyle )value
{
    @synchronized( self )
    {
        [ DEFAULTS setObject: [ NSNumber numberWithInteger: value ] forKey: CEPreferencesKeyFullScreenStyle ];
        [ DEFAULTS synchronize ];
        
        __PREFERENCES_CHANGE_NOTIFY( CEPreferencesKeyFullScreenStyle );
    }
}

@end
