//
//  ChatterHelper.m
//  RingDNA Free
//
//  Created by Kyle Roche on 9/19/12.
//
//

#import "ChatterHelper.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "OrderedDictionary.h"

@implementation ChatterHelper

@synthesize accessToken;
@synthesize instanceUrl;
@synthesize sfUserId;

-(id)init{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

-(id)initWithInstanceURL:(NSURL*)_instanceURL accessToken:(NSString*)_accessToken sfUserId:(NSString*)_sfUserId {
    self = [super init];
	if (self != nil) {
		self.instanceUrl = _instanceURL;
        self.accessToken = _accessToken;
        self.sfUserId = _sfUserId;
	}
	return self;
}

- (NSData*)toJSON:(NSDictionary *)dictionary
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) return nil;
    return result;    
}

-(void)postChatterFeedItemSegments:(NSArray*)segments Target:(NSString *)target Response:(void (^)(id))callbackBlock Failure:(void (^)())failure{
    NSString *targetUrl = [NSString stringWithFormat:@"%@/services/data/v25.0/chatter/feeds/%@/", self.instanceUrl, target];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:targetUrl]];

    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSDictionary dictionaryWithObjectsAndKeys:segments, @"messageSegments", nil],
                          @"body",
                          nil];
    
    NSString * toSend= [[NSString alloc] initWithData:[self toJSON:info] encoding:NSUTF8StringEncoding];
    NSLog(@"JSON: %@",toSend);
    
    NSMutableURLRequest * request = [client requestWithMethod:@"POST" path:@"feed-items" parameters:nil];
    
    [request setValue:[NSString stringWithFormat:@"OAuth %@",self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[toSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"success");
        callbackBlock(response);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"FAILED CHATTER Request: %@ - %@ - %@ - %@", [request URL], [request allHTTPHeaderFields], error.description, JSON);
        failure();
    }];
    
    [operation start];
}

-(void)postFeedItemText:(NSString*)text Response:(void (^)(id))callbackBlock Failure:(void (^)())failure {
    NSArray *segments= [NSArray arrayWithObjects:
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"text", @"type",
                         text, @"text",
                         nil],
                        nil];
    
    [self postChatterFeedItemSegments:segments Target:[NSString stringWithFormat:@"user-profile/%@", self.sfUserId] Response:callbackBlock Failure:failure];
}

-(void)postFeedItemText:(NSString*)text Mention:(NSString*)mentionId Response:(void (^)(id))callbackBlock Failure:(void (^)())failure {
    NSArray *segments= [NSArray arrayWithObjects:
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"mention",@"type",
                         mentionId,@"id",nil],
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"text", @"type",
                         text, @"text",
                         nil],
                        nil];
    
    [self postChatterFeedItemSegments:segments Target:[NSString stringWithFormat:@"user-profile/%@", self.sfUserId] Response:callbackBlock Failure:failure];
}

-(void)postFeedItemText:(NSString*)text Mention:(NSString*)mentionId Hashtag:(NSString*)hashtag Response:(void (^)(id))callbackBlock Failure:(void (^)())failure {
    NSArray *segments= [NSArray arrayWithObjects:
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"mention",@"type",
                         mentionId,@"id",nil],
                        
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"text", @"type",
                         text, @"text",
                         nil],
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"hashtag",@"type",
                         hashtag,@"tag",nil],
                        nil];
    
    [self postChatterFeedItemSegments:segments Target:[NSString stringWithFormat:@"user-profile/%@", self.sfUserId] Response:callbackBlock Failure:failure];
}

- (void)postFeedItemText:(NSString *)text Target:(NSString *)targetId Mention:(NSString *)mentionId Hashtag:(NSString *)hashtag Response:(void (^)(id))callbackBlock Failure:(void (^)())failure {
    NSArray *segments= [NSArray arrayWithObjects:
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"mention",@"type",
                         mentionId,@"id",nil],
                        
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"text", @"type",
                         text, @"text",
                         nil],
                         [OrderedDictionary dictionaryWithObjectsAndKeys:@"hashtag",@"type",
                         hashtag,@"tag",nil],
                        nil];
    
    [self postChatterFeedItemSegments:segments Target:[NSString stringWithFormat:@"record/%@", targetId] Response:callbackBlock Failure:failure];
}
@end
