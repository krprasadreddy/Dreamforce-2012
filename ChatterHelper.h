//
//  ChatterHelper.h
//  RingDNA Free
//
//  Created by Kyle Roche on 9/19/12.
//
//

#import <Foundation/Foundation.h>

@interface ChatterHelper : NSObject {

}
@property (nonatomic,strong) NSURL* instanceUrl;
@property (nonatomic,strong) NSString* accessToken;
@property (nonatomic,strong) NSString* sfUserId;

-(id)init;
-(id)initWithInstanceURL:(NSURL*)instanceURL accessToken:(NSString*)accessToken sfUserId:(NSString*)_sfUserId;
-(void)postFeedItemText:(NSString*)text Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;
-(void)postFeedItemText:(NSString*)text Mention:(NSString*)mentionId Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;
-(void)postFeedItemText:(NSString*)text Mention:(NSString*)mentionId Hashtag:(NSString*)hashtag Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;
-(void)postFeedItemText:(NSString*)text Target:(NSString*)targetId Mention:(NSString*)mentionId Hashtag:(NSString*)hashtag Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;

@end
