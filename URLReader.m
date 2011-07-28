//
//  URLReader.m
//  bombajob.bg
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import "URLReader.h"

@implementation URLReader

@synthesize delegate;

- (NSString *)getFromURL:(NSString *)URL postData:(NSString *)pData postMethod:(NSString *)pMethod {
	NSData *postData = [pData dataUsingEncoding:NSASCIIStringEncoding];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:URL]];
	[request setHTTPMethod:pMethod];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
	[request setHTTPBody:[pData dataUsingEncoding:NSUTF8StringEncoding]];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"getFromURL method = %@, postData = %@", pMethod, pData]];
	
	NSError *error = nil;
	NSURLResponse *response;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *data = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
	
	if (error != nil && [error localizedDescription] != nil) {
		data = @"";
		if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(urlRequestError:errorMessage:)])
			[delegate urlRequestError:self errorMessage:[error localizedFailureReason]];
	}

	return data;
}

- (NSString *)urlCryptedEncode:(NSString *)stringToEncrypt {
	NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																		   NULL,
																		   (CFStringRef)stringToEncrypt,
																		   NULL,
																		   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																		   kCFStringEncodingUTF8);
	return [result autorelease];
}

@end
