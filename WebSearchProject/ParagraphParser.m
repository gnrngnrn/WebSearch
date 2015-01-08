//
//  ParagraphElement.m
//  HTMLparsing
//
//  Created by Gnrn on 28.12.14.
//  Copyright (c) 2014 Gnrn. All rights reserved.
//

#import "ParagraphParser.h"

@implementation ParagraphParser
@synthesize _urlString,_linkObjects,_webpageData,_paragraphsObjects,_headingsObjects,controllerDelegate,_searchKeywords;

-(void) parsePageWithURL : (NSString *) urlSearchString{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlSearchString]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _webpageData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_webpageData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self loadAllParagraphs];
    [self loadAllHeadings];
    [self resultMethod:_searchKeywords];
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
-(void)resultMethod : (NSString *) keyword{
    if ([self containsKeywords:keyword]) {
        NSMutableString *string = [[NSMutableString alloc]initWithString:@"Found on - "];
        [string appendString:_urlString];
        [string appendString:@"\n"];
        self.controllerDelegate.resultField.text = [self.controllerDelegate.resultField.text stringByAppendingString:string];
    }else{
      
    }
}
-(BOOL) containsKeywords : (NSString *) keywords{
        for (Heading1_3 *h in _headingsObjects) {
            if ([h.value rangeOfString:keywords].location == NSNotFound) {
                continue;
            }else{
                return YES;
            }
        }
    for (ParagraphElement *p in _paragraphsObjects) {
        if ([p.value rangeOfString:keywords].location == NSNotFound) {
            continue;
        }else{
            return YES;
        }
    }
    return NO;
}
@end
