//
//  TestFlowLayout.m
//  A&BMediaPhotoSelector
//
//  Created by Gregory Berngardt on 31/05/15.
//  Copyright (c) 2015 Gregory Berngardt. All rights reserved.
//

#import "TestFlowLayout.h"

@implementation TestFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++) {
        UICollectionViewLayoutAttributes *headerLayout = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        
        [layoutAttributes removeObject:headerLayout];
        
        CGFloat height = CGRectGetHeight(headerLayout.frame);
        CGRect frame = headerLayout.frame;
        frame.origin.y = [self yCoordinateForHeaderInSection:i height:height];
        headerLayout.frame = frame;
        
        headerLayout.zIndex = 1024;
        headerLayout.hidden = NO;
        
        [layoutAttributes addObject:headerLayout];
    }
    
    return [layoutAttributes copy];
}

- (CGFloat)maxYForSection:(NSInteger)section {
    UICollectionViewLayoutAttributes *cellLayout = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.collectionView numberOfItemsInSection:section] - 1 inSection:section]];
    return CGRectGetMaxY(cellLayout.frame) + self.sectionInset.top;
}

- (CGFloat)minYForSection:(NSInteger)section {
    UICollectionViewLayoutAttributes *cellLayout = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    return CGRectGetMinY(cellLayout.frame) - self.sectionInset.bottom;
}

- (CGFloat)yCoordinateForHeaderInSection:(NSInteger)section height:(CGFloat)headerHeight{
    CGFloat yOffset = CGRectGetMinY(self.collectionView.bounds);
    
    NSInteger previousSection = MAX(0, section - 1);
    NSInteger nextSection = MIN(section + 1, [self.collectionView numberOfSections] - 1);
    
    CGFloat A = MIN(MAX([self maxYForSection:section] - headerHeight,
                        yOffset),
                    section == 0 ? yOffset : yOffset + headerHeight);
    
    CGFloat B = MIN(MAX([self minYForSection:previousSection],
                        yOffset + CGRectGetHeight(self.collectionView.bounds) - headerHeight),
                    [self minYForSection:section] - headerHeight);
    
    CGFloat C = MIN(MAX(A, B), [self maxYForSection:nextSection] - 2*headerHeight);
    
    NSLog(@"S:%lu %f %f %f", section, A, B, C);
    NSLog(@"S:%lu %f %f %f", section, [self maxYForSection:section], yOffset, headerHeight);

    
    return C;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
