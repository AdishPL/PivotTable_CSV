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
            
            int indexCount = (int)[dictionaryOfRelations.allKeys count];
            
            int i = 0;
            
            for (id key in [[dictionaryOfRelations allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                NSMutableDictionary *dictionaryOfValues = [dictionaryOfRelations objectForKey:key];
                
                for (id relation in dictionaryOfValues) {
                    float value = [[dictionaryOfValues objectForKey:relation] floatValue];
                    
                    if ([summedDictionary objectForKey:relation] == nil) {
                        NSMutableArray *emptyArray = [NSMutableArray new];
                        for (int j = 0; j <= indexCount-1; j++) {
                            [emptyArray insertObject:[NSNull null] atIndex:j];
                        }
                        [summedDictionary setObject:emptyArray forKey:relation];
                    }
                    
                    NSMutableArray *arrayOfValues = [summedDictionary objectForKey:relation];
                    [arrayOfValues removeObjectAtIndex:i];
                    [arrayOfValues insertObject:[NSDictionary dictionaryWithObject:@(value) forKey:@(i)] atIndex:i];

                }
                i++;
            }
            
            
            NSMutableString *headString = [NSMutableString new];
            for (id key in [[dictionaryOfRelations allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                [headString appendString:[NSString stringWithFormat:@"; %@",key]];
            }
            
            NSLog(@"%@",headString);
            
            for (id dictionary in [[summedDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                NSMutableString *lineString = [NSMutableString new];
                [lineString appendString:[NSString stringWithFormat:@"%@",dictionary]];
                for (id array in [summedDictionary objectForKey:dictionary]) {
                    if (!(array == [NSNull null])) {
                        [lineString appendString:[NSString stringWithFormat:@";%@",[[array allValues] objectAtIndex:0]]];
                    } else {
                        [lineString appendString:@";"];
                    }
                }
                NSLog(@"%@",lineString);
            }
            
            
        }
        
    return 0;
    }
}
