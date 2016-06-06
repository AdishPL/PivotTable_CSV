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
        
        NSMutableDictionary *dictionaryOfRelations = [NSMutableDictionary new];
        
        NSString* fileName = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"csv"];
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"Error reading file: %@", error.localizedDescription);
        } else {
            NSArray* rows = [fileContents componentsSeparatedByString:@"\n"];
            
            for (NSString *row in rows){
                NSArray* columns = [row componentsSeparatedByString:@";"];
                
                id indexColumn = columns[0];
                id relationColumn = columns[1];
                id valueColumn = columns[2];
                
                if ([dictionaryOfRelations objectForKey:indexColumn] == nil) {
                    [dictionaryOfRelations setObject:[NSMutableDictionary new] forKey:indexColumn];
                }
                
                NSMutableDictionary *currentEntries = [dictionaryOfRelations objectForKey:indexColumn];
                
//                NSMutableDictionary *flexibleMapping = [NSMutableDictionary new];
//                
//                for (NSMutableDictionary *dict in currentEntries) {
//                    if ([dict objectForKey:relationColumn] == nil) {
//                        [dict setObject:[NSMutableDictionary new] forKey:relationColumn];
//                    }
//                    
//                    id actuallValue = [dict objectForKey:relationColumn];
//                    id newValue = [NSString stringWithFormat:@"%@ + %@",actuallValue,valueColumn];
//                    
//                    NSMutableDictionary *dictionaryRelationValue = [NSMutableDictionary dictionaryWithObject:newValue forKey:relationColumn];
//                    
//                    [flexibleMapping setObject:dictionaryOfRelations forKey:indexColumn];
//
//                }
                float stringToFloat = [[valueColumn stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];

                id currentValueForRelation = [currentEntries objectForKey:relationColumn];

                float summedValues = [currentValueForRelation floatValue] + stringToFloat;
                
                if (currentValueForRelation == nil) {
                    summedValues = stringToFloat;
                }
                  
                [currentEntries setObject:@(summedValues) forKey:relationColumn];
                
                [dictionaryOfRelations setObject:currentEntries forKey:indexColumn];
            }
        
        NSLog(@"ditionary %@",dictionaryOfRelations);
            
            NSMutableDictionary *summedDictionary = [NSMutableDictionary new];
            
            for (id newEntry in dictionaryOfRelations) {
                for (id values in [dictionaryOfRelations objectForKey:newEntry]) {
                    
                    NSLog(@"values - %@",values);
                }
            }
    
        }
        
    return 0;
    }
}
