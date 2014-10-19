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
    tempProduct.product_id = @"00001";
    tempProduct.client_id = @"00001";
    tempProduct.GS_code = @"GS0001";
    tempProduct.name = @"Bicicleta Monark aro 20";
    tempProduct.desc = @"En perfecto estado. Comprada en 560 soles. MIRAFLORES";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"S/.";
    tempProduct.initial_price = 290.0;
    tempProduct.published_price = 290.0;
    tempProduct.publishing_date = [dateFormat dateFromString:@"20140501"];
    tempProduct.type = @"S";
    tempProduct.picture_link = @"https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-ash3/t1.0-9/10365873_837130456315654_6991006075101245277_n.jpg";
    //tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    tempProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.promotion_piority = 2;
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    
    // Add product #1 to the array
    [products addObject:tempProduct];
    
    // Create product #2
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"00002";
    tempProduct.client_id = @"00001";
    tempProduct.GS_code = @"GS3056";
    tempProduct.name = @"Mecedora Graco";
    tempProduct.desc = @"Tiene un sonidito casi imperceptible. Comprado en USA el año pasado. Solo ha sido usado durante 5 meses y muy poco. La Aurora - MIRAFLORES";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"S/.";
    tempProduct.initial_price = 300.0;
    tempProduct.published_price = 250.0;
    tempProduct.publishing_date = [dateFormat dateFromString:@"20140301"];
    tempProduct.picture_link = @"https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-prn1/t1.0-9/10341676_838515596177140_687032528327336304_n.jpg";
    //tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    tempProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.promotion_piority = 2;
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #2 to the array
    [products addObject:tempProduct];

    // Create product #3
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"00003";
    tempProduct.client_id = @"00002";
    tempProduct.GS_code = @"GS3205";
    tempProduct.name = @"HP Pavilion g6-1b70us 15.6'";
    tempProduct.desc = @"Comprada hace un año, en perfecto estado. Notebook (2.4 GHz Intel Core i3-370M Processor, 4 GB RAM, 500 GB Hard Drive, Windows... by HP. SAN ISIDRO";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"S/.";
    tempProduct.initial_price = 1200.0;
    tempProduct.published_price = 1100.0;
    tempProduct.publishing_date = [dateFormat dateFromString:@"20140219"];
    tempProduct.picture_link = @"https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-prn1/t1.0-9/10269440_835477799814253_5669782238393768165_n.jpg";
    //tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    tempProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.promotion_piority = 2;
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #3 to the array
    [products addObject:tempProduct];

    // Create product #4
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"00004";
    tempProduct.client_id = @"00002";
    tempProduct.GS_code = @"GS9999";
    tempProduct.name = @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit";
    tempProduct.desc = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec id eleifend mi, id faucibus lectus. In interdum sapien et nibh rhoncus, tempus scelerisque felis ullamcorper. Nunc facilisis rutrum elit. Nam at justo vitae ligula vulputate tempus et sit amet nisi. Donec in purus ac tortor commodo lacinia vel non odio. Nam erat lacus, vehicula vitae lobortis et, ullamcorper id augue. Morbi fermentum, elit sit amet faucibus tristique, magna magna venenatis massa, at porttitor libero sem et erat. Duis eu velit sagittis ipsum iaculis pulvinar. Pellentesque ut risus metus. Etiam dignissim accumsan imperdiet. Cras vel sem lobortis, tempor eros ac, tempor dolor. Proin mollis egestas erat, a placerat sapien vestibulum quis. Phasellus non felis elit. Phasellus malesuada semper purus, non tincidunt libero vehicula ac. Sed nec libero purus. Ut tempus, mi sit amet condimentum venenatis, enim magna rutrum sapien, eget blandit libero nulla et odio. Nunc volutpat libero mattis ligula facilisis mattis. Curabitur eu auctor ipsum. Mauris non varius lorem. Ut et libero adipiscing, condimentum ligula vestibulum, fringilla ipsum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Phasellus lectus ipsum, sodales non elementum congue, posuere condimentum metus. Ut aliquet et risus sit amet rhoncus. Nunc bibendum posuere varius. Fusce dui eros, sodales in facilisis id, ultrices eget massa. Donec cursus auctor nunc eu imperdiet. Pellentesque auctor dictum ultricies. Aliquam pretium vel erat quis ornare. Vestibulum interdum ultricies rhoncus. Sed tincidunt sollicitudin diam, at facilisis odio scelerisque id. Phasellus fringilla malesuada felis, vitae luctus mi gravida sed. Ut varius nec nisl vitae feugiat. Fusce tempus libero leo, a varius nisl dignissim ac. Sed non sollicitudin nisi. Aliquam vulputate ligula eu lacus dignissim placerat";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.currency = @"S/.";
    tempProduct.initial_price = 100000.0;
    tempProduct.published_price = 99900.0;
    tempProduct.publishing_date = [dateFormat dateFromString:@"20140315"];
    tempProduct.picture_link = @"https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xpf1/t1.0-9/1493150_830659133629453_2983286650637139401_n.jpg";
    //tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
    tempProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
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
    
    NSString *nextID = [NSString stringWithFormat:@"%d", mainDelegate.lastProductID];
    
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


@end
