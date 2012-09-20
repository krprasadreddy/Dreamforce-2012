#Dreamforce Session (Chatter)

## Variables
Name  | Value 
------------- | ------------- 
Manager User Record (Todd)    | @"00560000001j3pV" 
5 Star club Group 	| @"0F96000000006On"
Inbound Placeholder	| DREAMFORCE INBOUND
Seven button			| DREAMFORCE SEVEN

## Create Chatter Helper class
### basic text
```
-(void)postFeedItemText:(NSString*)text Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;
```

***method code***
```
-(void)postFeedItemText:(NSString*)text Response:(void (^)(id))callbackBlock Failure:(void (^)())failure {
    NSArray *segments= [NSArray arrayWithObjects:
                    [OrderedDictionary dictionaryWithObjectsAndKeys:@"text", @"type",
                     text, @"text",
                     nil],
                    nil];
    
    [self postChatterFeedItemSegments:segments Target:[NSString stringWithFormat:@"user-profile/%@", self.sfUserId] Response:callbackBlock Failure:failure];
}
```

### add mention
```
-(void)postFeedItemText:(NSString*)text Mention:(NSString*)mentionId Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;
```
***method code***
```
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
```

### mention and hashtag
```
-(void)postFeedItemText:(NSString*)text Mention:(NSString*)mentionId Hashtag:(NSString*)hashtag Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;
```

*** method code ***
```
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
```

### mention, hashtag and target
```
-(void)postFeedItemText:(NSString*)text Target:(NSString*)targetId Mention:(NSString*)mentionId Hashtag:(NSString*)hashtag Response:(void (^)(id))callbackBlock Failure:(void (^)())failure;
```

*** method code ***
```

- (void)postFeedItemText:(NSString *)text Target:(NSString *)targetId Mention:(NSString *)mentionId Hashtag:(NSString *)hashtag Response:(void (^)(id))callbackBlock Failure:(void (^)())failure {
    NSArray *segments= [NSArray arrayWithObjects:
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"mention",@"type",
                         mentionId,@"id",nil],
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"hashtag",@"type",
                         hashtag,@"tag",nil],
                        [OrderedDictionary dictionaryWithObjectsAndKeys:@"text", @"type",
                         text, @"text",
                         nil],
                        nil];
    
    [self postChatterFeedItemSegments:segments Target:[NSString stringWithFormat:@"record/%@", targetId] Response:callbackBlock Failure:failure];
}

```

## Add to inbound
create the object
```
    ChatterHelper *helper = [[ChatterHelper alloc] initWithInstanceURL:_appManager.coordinator.credentials.instanceUrl accessToken:_appManager.coordinator.credentials.accessToken sfUserId: [_appManager.userInformation objectForKey:@"sfUserId"]];
```
Add plain text post
```
[helper postFeedItemText:@"Hello World" Response:^(id JSON) {
        NSLog(@"success simple text");
    } Failure:^(){
        NSLog(@"fail simple text");
    }];
```

Add text with mention
```
[helper postFeedItemText:@" Hello World Mention" Mention:[_appManager.userInformation objectForKey:@"sfUserId"] Response:^(id JSON) {
        NSLog(@"success mention");
    } Failure:^(){
        NSLog(@"fail mention");
    }];
```

Add plain text with hashtag and mention
```
[helper postFeedItemText:@" Hello World Mention+Hashtag " Mention:[_appManager.userInformation objectForKey:@"sfUserId"] Hashtag:@"important" Response:^(id JSON) {
        NSLog(@"success mention+hashtag");
    } Failure:^(){
        NSLog(@"fail mention+hashtag");
    }];
```

Add the call to Targeted method
```
[helper postFeedItemText:@" Inbound Call" Target:[[_appManager.currentCallInfo objectForKey:@"sfContactInfo"] stringForKey:@"Id"] Mention:@"00560000001j3pV" Hashtag:@"inbound" Response:^(id JSON) {
        NSLog(@"inbound chatter posted");
    } Failure:^{
        NSLog(@"inbound chatter failed");
    }];
```

Add the call to 5 star club group
```
[helper postFeedItemText:@" Hello World Mention+Hashtag " Target:@"0F96000000006On" Mention:[_appManager.userInformation objectForKey:@"sfUserId"] Hashtag:@"important" Response:^(id JSON) {
        NSLog(@"success mention+hashtag");
    } Failure:^(){
        NSLog(@"fail mention+hashtag");
    }];

```