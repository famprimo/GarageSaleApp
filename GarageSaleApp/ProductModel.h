//
//  ProductModel.h
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"
#import "Product.h"
#import "Opportunity.h"

@protocol ProductModelDelegate

-(void)productsSyncedWithCoreData:(BOOL)succeed;
-(void)productAddedOrUpdated:(BOOL)succeed;

@end

@interface ProductModel : NSObject

@property (nonatomic, strong) id<ProductModelDelegate> delegate;

- (void)saveInitialDataforProducts;
- (NSMutableArray*)getProductsFromCoreData;
- (void)syncCoreDataWithParse;
- (NSMutableArray*)getProductArray;
- (NSString*)getNextProductID;
- (void)addNewProduct:(Product*)newProduct;
- (void)updateProduct:(Product*)productToUpdate;
- (NSData*)getProductPhotoFrom:(Product*)productSelected;
- (void)updateProduct:(Product*)productToUpdate withArray:(NSMutableArray*)arrayProducts;
- (Client*)getClient:(Product*)productFound;
- (NSMutableArray*)getOpportunitiesFromProduct:(Product*)productSelected;
- (NSMutableArray*)getProductsFromClientId:(NSString*)clientIDtoSearch;
- (NSString*)getProductIDfromFbPhotoId:(NSString*)photoFbIdToValidate;
- (UIImage*)getImageFromProductId:(NSString*)productIDtoSearch;
- (Product*)getProductFromProductId:(NSString*)productIDtoSearch;
- (NSString*)getTextThatFollows:(NSString*)textToSearch fromMessage:(NSString*)messageText; // Search a text and returns the numbers that follows the text
- (NSString*)getProductNameFromFBPhotoDesc:(NSString*)messageText;
- (int)numberOfActiveProducts;
- (NSDate*)updateProductsWithCodeGS:(NSString*)codeGSToFind withClientID:(NSString*)clientIDtoUse;
- (NSString*)getNextCodeGS;

@end
