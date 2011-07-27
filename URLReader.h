//
//  URLReader.h
//  bombajob.bg
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLReaderDelegate <NSObject>
@optional
- (void)urlRequestError:(id)sender errorMessage:(NSString *)errorMessage;
@end

@interface URLReader : NSObject {
	id<URLReaderDelegate> delegate;
}

@property (assign) id<URLReaderDelegate> delegate;

- (NSString *)getFromURL:(NSString *)URL postData:(NSString *)pData postMethod:(NSString *)pMethod;
- (NSString *)urlCryptedEncode:(NSString *)stringToEncrypt;

@end
