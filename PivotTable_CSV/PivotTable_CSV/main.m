//
//  main.m
//  PivotTable_CSV
//
//  Created by Adrian Kaczmarek on 06.06.2016.
//  Copyright © 2016 Adrian Kaczmarek. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *colA = [NSMutableArray array];
        NSMutableArray *colB = [NSMutableArray array];
        NSString* fileName = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"csv"];
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"Error reading file: %@", error.localizedDescription);
        } else {
        NSArray* rows = [fileContents componentsSeparatedByString:@"\n"];
        for (NSString *row in rows){
            NSArray* columns = [row componentsSeparatedByString:@";"];
            [colA addObject:columns[0]];
            [colB addObject:columns[1]];
        }
        
        NSLog(@"ColA %@",colA);
    
        }
        
    return 0;
    }
}
