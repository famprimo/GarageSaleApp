//
//  ProductModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductModel.h"
#import "AppDelegate.h"


@implementation ProductModel

- (NSMutableArray*)getProducts:(NSMutableArray*)productList;
{
    // Array to hold the listing data
    NSMutableArray *products = [[NSMutableArray alloc] init];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    // Create product #1
    Product *tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000001";
    tempProduct.client_id = @"00001";
    tempProduct.GS_code = @"GS3024";
    tempProduct.name = @"Bajo Ibáñez";
    tempProduct.desc = @"GS3024 Bajo Ibáñez GSR395 Precio $270. 5 cuerdas. 2 Pastillas activas. Perfecto estado, solo 1 dueño. 1 quiñe No incluye estuche, ni correa. Si estás interesado te mandamos más fotos ";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"USD";
    tempProduct.initial_price = 270.0;
    tempProduct.published_price = 270.0;
    tempProduct.created_time = [dateFormat dateFromString:@"20140501"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140501"];
    tempProduct.solddisabled_time = nil;
    tempProduct.fb_updated_time = nil;
    tempProduct.type = @"S";
    tempProduct.picture_link = @"https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/1376503_708105319218169_2045785718_n.jpg?oh=9253637c8d6b70101c67951b37c9311f&oe=5521BD25&__gda__=1429145356_7b2f69769a6ae3da56923e8260bab2c4";
    tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"S";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140501"];
    tempProduct.promotion_piority = 2;
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    
    // Add product #1 to the array
    [products addObject:tempProduct];
    
    // Create product #2
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000002";
    tempProduct.client_id = @"00001";
    tempProduct.GS_code = @"GS3056";
    tempProduct.name = @"Silla Vienesas";
    tempProduct.desc = @"TBAJARON A s/. 160 c/u Sillas Vienesas GS1472";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"S/.";
    tempProduct.initial_price = 200.0;
    tempProduct.published_price = 160.0;
    tempProduct.created_time = [dateFormat dateFromString:@"20140301"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140301"];
    tempProduct.solddisabled_time = nil;
    tempProduct.fb_updated_time = nil;
    tempProduct.type = @"S";
    tempProduct.picture_link = @"https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-ash2/v/t1.0-9/529445_473861852642518_1828250631_n.jpg?oh=23fe791f1a77d614d50285707b93ee38&oe=553A9F8F&__gda__=1429866536_5dc8e85fe0171ac093af304277b9fe0c";
    tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    //tempProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140301"];
    tempProduct.promotion_piority = 2;
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #2 to the array
    [products addObject:tempProduct];

    // Create product #3
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000003";
    tempProduct.client_id = @"00002";
    tempProduct.GS_code = @"GS2906";
    tempProduct.name = @"Silla Graco para bebé";
    tempProduct.desc = @"GS2906 Silla Graco para bebé, se puede usar desde 2.5 kg. (recién nacido) hasta 10 kg. s/. 200 Tiempo de uso 5 meses Está completo y casi nuevo (solo algunas marcas en el plástico de la base por el uso) base + silla portabebé + manual de usuario. SAN ISIDRO";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"S/.";
    tempProduct.initial_price = 200.0;
    tempProduct.published_price = 200.0;
    tempProduct.created_time = [dateFormat dateFromString:@"20140219"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140219"];
    tempProduct.solddisabled_time = nil;
    tempProduct.fb_updated_time = nil;
    tempProduct.type = @"S";
    tempProduct.picture_link = @"https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-prn2/v/t1.0-9/533606_660543743974327_2061893536_n.jpg?oh=91032b496fe2c9e3ee985b3cf6417a37&oe=5521F20D&__gda__=1433366363_1618f174046b4e67b5dc406189e59fa1";
    tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    //tempProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140219"];
    tempProduct.promotion_piority = 2;
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #3 to the array
    [products addObject:tempProduct];

    // Create product #4
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000004";
    tempProduct.client_id = @"00002";
    tempProduct.GS_code = @"GS2308";
    tempProduct.name = @"Cocina de hierro";
    tempProduct.desc = @"Cocina de hierro marca Mónica s/. 1,100 GS2308";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"S/.";
    tempProduct.initial_price = 1100.0;
    tempProduct.published_price = 1100.0;
    tempProduct.created_time = [dateFormat dateFromString:@"20140315"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140315"];
    tempProduct.solddisabled_time = nil;
    tempProduct.fb_updated_time = nil;
    tempProduct.type = @"S";
    tempProduct.picture_link = @"https://scontent-a.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/s720x720/540629_572941262734576_1798615268_n.jpg?oh=ead54861abe199b5c8e064ffd4492ef7&oe=5540E1FC";
    tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    //tempProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140315"];
    tempProduct.promotion_piority = 2;
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #4 to the array
    [products addObject:tempProduct];
    
    // Set last product ID
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastProductID = 4;

    // Return the producct array as the return value
    return products;
}

- (NSString*)getNextProductID;
{
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastProductID = mainDelegate.lastProductID + 1;
    
    NSString *nextID = [NSString stringWithFormat:@"00000000%d", mainDelegate.lastProductID];
    nextID = [nextID substringFromIndex:[nextID length] - 7];
    
    return nextID;
}

- (BOOL)addNewProduct:(Product*)newProduct;
{
    BOOL updateSuccessful = YES;
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    [mainDelegate.sharedArrayProducts addObject:newProduct];
    
    return updateSuccessful;
}

- (void)updateProduct:(Product*)productToUpdate;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Product *productToReview = [[Product alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayProducts.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)mainDelegate.sharedArrayProducts[i];
        
        if ([productToReview.product_id isEqual:productToUpdate.product_id])
        {
            [mainDelegate.sharedArrayProducts replaceObjectAtIndex:i withObject:productToUpdate];
            break;
        }
    }
}

- (void)updateProduct:(Product*)productToUpdate withArray:(NSMutableArray*)arrayProducts;
{
    Product *productToReview = [[Product alloc] init];
    
    for (int i=0; i<arrayProducts.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)arrayProducts[i];
        
        if ([productToReview.product_id isEqual:productToUpdate.product_id])
        {
            [arrayProducts replaceObjectAtIndex:i withObject:productToUpdate];
            break;
        }
    }
}

- (Client*)getClient:(Product*)productBase;
{
    Client *clientFound = [[Client alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
 
    for (int i = 0; i < mainDelegate.sharedArrayClients.count; i++)
    {
        Client* clientTemp = [mainDelegate.sharedArrayClients objectAtIndex: i];
        if (productBase.client_id == clientTemp.client_id)
        {
            clientFound = clientTemp;
            break;
        }
    }
    
    return clientFound;

}

- (NSMutableArray*)getOpportunitiesFromProduct:(Product *)productSelected;
{
    NSMutableArray *opportunities = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    for (int i = 0; i < mainDelegate.sharedArrayOpportunities.count; i++)
    {
        Opportunity *opportunityTemp = [mainDelegate.sharedArrayOpportunities objectAtIndex: i];
        if (productSelected.product_id == opportunityTemp.product_id)
        {
            [opportunities addObject:opportunityTemp];
        }
    }
    
    return opportunities;

}


- (NSString*)getProductIDfromFbPhotoId:(NSString*)photoFbIdToValidate;
{
    // Review an array of Products to check if a given FB Photo ID exists
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    NSString *productID = @"Not Found";
    
    Product *productToReview = [[Product alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayProducts.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)mainDelegate.sharedArrayProducts[i];
        
        if ([productToReview.fb_photo_id isEqual:photoFbIdToValidate])
        {
            productID = productToReview.product_id;
            break;
        }
    }
    return productID;
}

- (UIImage*)getImageFromProductId:(NSString*)productIDtoSearch;
{
    // Review the array of Products and returns the image related to the product
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIImage *productImage = nil;
    
    Product *productToReview = [[Product alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayProducts.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)mainDelegate.sharedArrayProducts[i];
        
        if ([productToReview.product_id isEqual:productIDtoSearch])
        {
            productImage = [UIImage imageWithData:productToReview.picture];
            break;
        }
    }
    return productImage;
}

- (Product*)getProductFromProductId:(NSString*)productIDtoSearch;
{
    // Review the array of Products and returns Product object related
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Product *productToReview = [[Product alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayProducts.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)mainDelegate.sharedArrayProducts[i];
        
        if ([productToReview.product_id isEqual:productIDtoSearch])
        {
            break;
        }
    }
    return productToReview;
}

@end
