//
//  ViewController.h
//  WebSearchProject
//
//  Created by Gnrn on 28.12.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkElement.h"
#import "ParagraphParser.h"
#import "Heading1-3.h"
#import "TFHpple.h"

@interface MainViewController : UIViewController <NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startingURL;
@property (weak, nonatomic) IBOutlet UITextField *keywordsToSearch;
- (IBAction)searchButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *resultField;
@property (weak, nonatomic) IBOutlet UITextField *maxURLs;
@property (strong, nonatomic) NSString *urlSearchString;
@property (strong, nonatomic) NSString *keywordsString;
- (IBAction)textFieldDoneEditing:(id)sender;
-(void)loadAllLinks;
-(void)loadAllParagraphs;
-(void)loadAllHeadings;
@end
