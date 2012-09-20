//
//  OrderedDictionary.h
//  RingDNA Free
//
//  Created by Kyle Roche on 9/20/12.
//
//

#import <Foundation/Foundation.h>

@interface OrderedDictionary : NSMutableDictionary {
    NSMutableDictionary * dictionary;
    NSMutableArray * array;
}

@end
