//
// TBTableDataContext.h
// TableViewBuddy
//
// Copyright (c) 2014 Hironori Ichimiya <hiron@hironytic.com>
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

@class TBTableData;
@class TBTableDataRow;
@class TBTableDataSection;

/**
 `TBTableDataContext` represents a contextual information for changing table data models.
 
 When you modify a table data model, `TBTableDataContext` is required.
 Each method that changes the data model takes context parameter.
 Some methods require a object of specific derived class of `TBTableDataContext`,
 but others require just a `TBTableDataContext` object.
 
 For example, when you want to hide a `TBTableDataRow`,
 you should call `-[TBTableDataRow setHidden:withContext:]` which takes a context in the second parameter.
 And the context object is required to be of `TBTableDataInitializationContext` or `TBTableDataUpdateContext`.
 So you call it in a manner of:
 
    [tableData updateAnimated:YES updater:^(TBTableDataUpdateContext *context) {
         [row setHidden:YES withContext:context];
    }];
 
 On the other hand, when you want to disable a `TBTableDataRow`,
 the second parameter of `-[TBTableDataRow setEnabled:withContext:]` is nothing special.
 So you can call it as below:
 
    [row setEnabled:NO withContext:[TBTableDataContext context]];
 
 To know what kind of context is required in a method, read a parameter description of the method in this document.
 If nothing in particular is written, the method takes just a `TBTableDataContext` object.
 */
@interface TBTableDataContext : NSObject

+ (instancetype)context;

@end


@interface TBTableDataInitializationContext: TBTableDataContext

@property(nonatomic, strong, readonly) TBTableData *tableData;
@property(nonatomic, strong, readonly) TBTableDataSection *section;
@property(nonatomic, strong, readonly) TBTableDataRow *row;

@end


@interface TBTableDataUpdateContext: TBTableDataContext

@property(nonatomic, assign) UITableViewRowAnimation insertionAnimation;
@property(nonatomic, assign) UITableViewRowAnimation deletionAnimation;
@property(nonatomic, assign) UITableViewRowAnimation reloadingAnimation;

@end
