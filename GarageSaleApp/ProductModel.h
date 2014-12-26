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

@interface ProductModel : NSObject

- (NSMutableArray*)getProducts:(NSMutableArray*)productList;
- (NSString*)getNextProductID;
- (BOOL)addNewProduct:(Product*)newProduct;
- (void)updateProduct:(Product*)productToUpdate;
- (void)updateProduct:(Product*)productToUpdate withArray:(NSMutableArray*)arrayProducts;
- (Client*)getClient:(Product*)productFound;
- (NSMutableArray*)getOpportunitiesFromProduct:(Product*)productSelected;
- (NSString*)getProductIDfromFbPhotoId:(NSString*)photoFbIdToValidate;
- (UIImage*)getImageFromProductId:(NSString*)productIDtoSearch;
- (Product*)getProductFromProductId:(NSString*)productIDtoSearch;

@end
