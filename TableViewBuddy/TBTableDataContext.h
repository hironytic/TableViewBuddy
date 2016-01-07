//
// TBTableDataContext.h
// TableViewBuddy
//
// Copyright (c) 2014-2016 Hironori Ichimiya <hiron@hironytic.com>
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TBTableData;
@class TBTableDataRow;
@class TBTableDataSection;

/**
 `TBTableDataContext` represents a contextual information for changing table data models.
 
 When you modify a table data model, `TBTableDataContext` is required.
 Each method that changes the data model takes context parameter.
 Some methods require an object of specific derived class of `TBTableDataContext`,
 but others require just a `TBTableDataContext` object.
 
 For example, when you want to hide a `<TBTableDataRow>`,
 you should call `<[TBTableDataRow setHidden:withContext:]>` which takes a context in the second parameter.
 And the context object is required to be of `<TBTableDataInitializationContext>` or `<TBTableDataUpdateContext>`.
 So you call it in a manner of:
 
    [tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
         [row setHidden:YES withContext:context];
    }];
 
 On the other hand, when you want to disable a `<TBTableDataRow>`,
 the second parameter of `<[TBTableDataRow setEnabled:withContext:]>` is nothing special.
 So you can call it as below:
 
    [row setEnabled:NO withContext:[TBTableDataContext context]];
 
 To know what kind of context is required in a method, read a parameter description of the method in this document.
 If nothing in particular is written, the method takes just a `TBTableDataContext` object.
 */
@interface TBTableDataContext : NSObject

/**
 Returns an empty context.
 @return TBTableDataContext object.
 */
+ (instancetype)context;

@end


/**
 `TBTableDatainitializationContext` represents a contextual information
 about initialization of table data model.
 
 You can obtain this context as parameter of the block which is passed
 to `<[TBTableData tableDataWithConfigurator:]>`,
 `<[TBTableDataSection sectionGeneratorWithConfigurator:]>`, or
 `<[TBTableDataRow rowGeneratorWithConfigurator:]>`.
 
 You can also get this context from `<[TBTableDataBuilder context]>`.
 */
@interface TBTableDataInitializationContext : TBTableDataContext

/**
 `<TBTableData>` object which is initializing now.
 */
@property(nonatomic, strong, readonly) TBTableData *tableData;

/**
 `<TBTableDataSection>` object which is initializing now.
 */
@property(nonatomic, strong, readonly) TBTableDataSection *section;

/**
 `<TBTableDataRow>` object which is initializing now.
 */
@property(nonatomic, strong, readonly) TBTableDataRow *row;

@end


/**
 `TBTableDataUpdateContext` represents a contextual information
 about updating table data model.
 
 You can obtain this context as parameter of the block which is passed
 to `<[TBTableData updateAnimated:updater:]>`.
 */
@interface TBTableDataUpdateContext : TBTableDataContext

/**
 The kind of animation to insert cell.
 */
@property(nonatomic, assign) UITableViewRowAnimation insertionAnimation;

/**
 The kind of animation to delete cell.
 */
@property(nonatomic, assign) UITableViewRowAnimation deletionAnimation;

/**
 The kind of animation to reload cell.
 */
@property(nonatomic, assign) UITableViewRowAnimation reloadingAnimation;

@end
