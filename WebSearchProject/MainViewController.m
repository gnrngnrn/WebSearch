//
//  ViewController.m
//  WebSearchProject
//
//  Created by Gnrn on 28.12.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (){
    NSMutableArray *_linkObjects;
    NSMutableArray *_headingsObjects;
    NSMutableArray *_paragraphsObjects;
    NSMutableData *_webpageData;
}
@end

@implementation MainViewController
@synthesize startingURL,keywordsToSearch,resultField,urlSearchString,keywordsString,maxURLs;
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)searchButton:(id)sender {
    [self viewDidLoad];
    self.resultField.text = @"";
    urlSearchString = [self.startingURL text];
    keywordsString = [self.keywordsToSearch text];
    [self parseStart];
    
    
}
-(void) parseStart{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlSearchString]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void) parseStartWithURL : (NSString *) url{
    urlSearchString = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _webpageData =[[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_webpageData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self loadAllHeadings];
    [self loadAllParagraphs];
    [self loadAllLinks];
    [self resultMethod:keywordsString];
        for (LinkElement *l in _linkObjects) {
            ParagraphParser *parser = [[ParagraphParser alloc]init];
            parser.controllerDelegate = self;
            parser._urlString = l.url;
            parser._searchKeywords = keywordsString;
            [parser parsePageWithURL:l.url];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //self.resultField.text = @"URL connection fail";
    self.resultField.text = [self.resultField.text stringByAppendingString:@"URL connection fail!\n"];
    
}
-(void)resultMethod : (NSString *) keyword{
    if ([self containsKeywords:keywordsString]) {
        self.resultField.text = [self.resultField.text stringByAppendingString:@"Found on starting webpage!\n"];
    }else{
        self.resultField.text = [self.resultField.text stringByAppendingString:@"Not found on starting webpage!\n"];
    }
}
-(BOOL) containsKeywords : (NSString *) keywords{
    for (ParagraphElement *p in _paragraphsObjects) {
        if ([p.value rangeOfString:keywords].location == NSNotFound) {
            continue;
        }else{
            return YES;
        }
    } for (Heading1_3 *h in _headingsObjects) {
        if ([h.value rangeOfString:keywords].location == NSNotFound) {
            continue;
        }else{
            return YES;
        }
    }
    return NO;
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)backgroundTap:(id)sender {
    [self.startingURL resignFirstResponder];
    [self.keywordsToSearch resignFirstResponder];
    [self.maxURLs resignFirstResponder];
    
}
-(void)loadAllLinks{
    TFHpple *linksParser = [TFHpple hppleWithHTMLData:_webpageData];
    NSString *linkssXpathQueryString = @"//a";
    NSArray *linksNodes = [linksParser searchWithXPathQuery:linkssXpathQueryString];
    NSMutableSet *links = [[NSMutableSet alloc] initWithCapacity:0];
    for (TFHppleElement *element in linksNodes) {
        LinkElement *l = [[LinkElement alloc] init];
        [links addObject:l];
        l.url = [element objectForKey:@"href"];
        
    }
    _linkObjects = [links allObjects];
    int trim = [self.maxURLs.text intValue];
    if (trim != nil || trim != 0) {
    if (_linkObjects.count > trim) {
        _linkObjects = (NSMutableArray *)[_linkObjects subarrayWithRange:NSMakeRange(0, trim)];
    }
    }
}
-(void)loadAllParagraphs {
    TFHpple *paragraphsParser = [TFHpple hppleWithHTMLData:_webpageData];
    NSString *paragraphsXpathQueryString = @"//p";
    NSArray *paragraphsNodes = [paragraphsParser searchWithXPathQuery:paragraphsXpathQueryString];
    NSMutableArray *newParagraphs = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in paragraphsNodes) {
        ParagraphElement *p = [[ParagraphElement alloc] init];
        p.value = [element content];
        [newParagraphs addObject:p];
    }
    _paragraphsObjects = newParagraphs;
}
-(void)loadAllHeadings {
    TFHpple *headingsParser = [TFHpple hppleWithHTMLData:_webpageData];
    NSString *headingsXpathQueryString = @"//*[self::h1 or self::h2 or self::h3]";
    NSArray *headingsNodes = [headingsParser searchWithXPathQuery:headingsXpathQueryString];
    NSMutableArray *newheadings = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in headingsNodes) {
        Heading1_3 *p = [[Heading1_3 alloc] init];
        p.value = [element content];
        [newheadings addObject:p];
        
    }
    _headingsObjects = newheadings;
    
}

@end
