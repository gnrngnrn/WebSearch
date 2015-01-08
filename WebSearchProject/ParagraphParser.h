//
//  ParagraphElement.h
//  HTMLparsing
//
//  Created by Gnrn on 28.12.14.
//  Copyright (c) 2014 Gnrn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "ParagraphElement.h"
#import "MainViewController.h"
@class MainViewController;

@interface ParagraphParser : NSObject <NSURLConnectionDelegate>
@property (nonatomic, copy) NSString *_urlString;
@property (nonatomic, copy) NSString *_searchKeywords;
@property MainViewController *controllerDelegate;
@property (nonatomic, strong) NSMutableArray *_linkObjects;
@property (nonatomic, strong) NSMutableArray *_headingsObjects;
@property (nonatomic, strong) NSMutableArray *_paragraphsObjects;
@property (nonatomic, strong) NSMutableData *_webpageData;
-(void) parsePageWithURL : (NSString *) urlSearchString;
@end
