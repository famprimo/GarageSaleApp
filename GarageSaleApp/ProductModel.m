//
//  ProductModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductModel.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SettingsModel.h"
#import "CommonMethods.h"


@implementation ProductModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveInitialDataforProducts;
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    // Create product #1
    Product *tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000001";
    tempProduct.client_id = @"00001";
    tempProduct.codeGS = @"GS3024";
    tempProduct.name = @"Bajo Ibáñez";
    tempProduct.desc = @"GS3024 Bajo Ibáñez GSR395 Precio $270. 5 cuerdas. 2 Pastillas activas. Perfecto estado, solo 1 dueño. 1 quiñe No incluye estuche, ni correa. Si estás interesado te mandamos más fotos ";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.fb_link = @"http://www.facebook.com";
    tempProduct.currency = @"USD";
    tempProduct.price = [NSNumber numberWithFloat:270.0];
    tempProduct.created_time = [dateFormat dateFromString:@"20140501"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140501"];
    tempProduct.solddisabled_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.fb_updated_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.type = @"S";
    tempProduct.picture_link = @"http://jiahome.co.uk/images/thumbnails/Traditional-Hardwood-Furniture.jpg";
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"S";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140501"];
    tempProduct.promotion_piority = @"2";
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";
    
    // Add product #1 to the array
    [self addNewProduct:tempProduct];
    
    // Create product #2
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000002";
    tempProduct.client_id = @"00001";
    tempProduct.codeGS = @"GS3056";
    tempProduct.name = @"Silla Vienesas";
    tempProduct.desc = @"TBAJARON A s/. 160 c/u Sillas Vienesas GS1472";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.fb_link = @"http://www.facebook.com";
    tempProduct.currency = @"S/.";
    tempProduct.price = [NSNumber numberWithFloat:160.0];
    tempProduct.created_time = [dateFormat dateFromString:@"20140301"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140301"];
    tempProduct.solddisabled_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.fb_updated_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.type = @"S";
    tempProduct.picture_link = @"http://images-en.busytrade.com/240073800/Urban-Furniture.jpg";
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140301"];
    tempProduct.promotion_piority = @"2";
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #2 to the array
    [self addNewProduct:tempProduct];

    // Create product #3
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000003";
    tempProduct.client_id = @"00002";
    tempProduct.codeGS = @"GS2906";
    tempProduct.name = @"Silla Graco para bebé";
    tempProduct.desc = @"GS2906 Silla Graco para bebé, se puede usar desde 2.5 kg. (recién nacido) hasta 10 kg. s/. 200 Tiempo de uso 5 meses Está completo y casi nuevo (solo algunas marcas en el plástico de la base por el uso) base + silla portabebé + manual de usuario. SAN ISIDRO";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.fb_link = @"http://www.facebook.com";
    tempProduct.currency = @"S/.";
    tempProduct.price = [NSNumber numberWithFloat:200.0];
    tempProduct.created_time = [dateFormat dateFromString:@"20140219"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140219"];
    tempProduct.solddisabled_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.fb_updated_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.type = @"S";
    tempProduct.picture_link = @"http://www.weaverfurnituresales.com/images/categories/12/palisade%20amish%20furniture.jpg";
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140219"];
    tempProduct.promotion_piority = @"2";
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #3 to the array
    [self addNewProduct:tempProduct];

    // Create product #4
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000004";
    tempProduct.client_id = @"00002";
    tempProduct.codeGS = @"GS2308";
    tempProduct.name = @"Cocina de hierro";
    tempProduct.desc = @"Cocina de hierro marca Mónica s/. 1,100 GS2308";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.fb_link = @"http://www.facebook.com";
    tempProduct.currency = @"S/.";
    tempProduct.price = [NSNumber numberWithFloat:1100.0];
    tempProduct.created_time = [dateFormat dateFromString:@"20140315"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20140315"];
    tempProduct.solddisabled_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.fb_updated_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.type = @"S";
    tempProduct.picture_link = @"http://www.homeapplianceinfo.com/products/refrigerator/hotpoint_refrigerator/1.jpg";
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20140315"];
    tempProduct.promotion_piority = @"2";
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";

    // Add product #4 to the array
    [self addNewProduct:tempProduct];

    // Create product #5
    tempProduct = [[Product alloc] init];
    tempProduct.product_id = @"0000005";
    tempProduct.client_id = @"00004";
    tempProduct.codeGS = @"GSN2356";
    tempProduct.name = @"Ropa para ninos";
    tempProduct.desc = @"GSN2356 Ropa para ninos en buen estado";
    tempProduct.fb_photo_id = @"XXXX";
    tempProduct.fb_link = @"http://www.facebook.com";
    tempProduct.currency = @"S/.";
    tempProduct.price = [NSNumber numberWithFloat:0];
    tempProduct.created_time = [dateFormat dateFromString:@"20150115"];
    tempProduct.updated_time = [dateFormat dateFromString:@"20150115"];
    tempProduct.solddisabled_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.fb_updated_time = [dateFormat dateFromString:@"20000101"];
    tempProduct.type = @"A";
    tempProduct.picture_link = @"http://www.couponsandfreebiesmom.com/wp-content/uploads/2011/01/kohls-clothes.jpg";
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"U";
    tempProduct.last_promotion_time = [dateFormat dateFromString:@"20150215"];
    tempProduct.promotion_piority = @"2";
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";
    
    // Add product #5 to the array
    [self addNewProduct:tempProduct];

}

- (NSMutableArray*)getProductsFromCoreData;
{
    NSMutableArray *productsArray = [[NSMutableArray alloc] init];
    
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Products"];
    productsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    // Set last product ID
    Product *productToReview = [[Product alloc] init];
    int lastID = 0;
    
    for (int i=0; i<productsArray.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)productsArray[i];
        
        if ([productToReview.product_id intValue] > lastID)
        {
            lastID = [productToReview.product_id intValue];
        }
    }
    
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastProductID = lastID;
    
    return productsArray;
}

- (void)syncCoreDataWithParse;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Get latest information from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    [query setLimit: 1000];
    [query whereKey:@"updatedAt" greaterThan:mainDelegate.sharedSettings.product_last_update];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find from Parse succeeded
            for (PFObject *parseObject in objects)
            {
                Product *productFromParse = [[Product alloc] init];
                
                productFromParse.product_id = [parseObject valueForKey:@"product_id"];
                productFromParse.client_id = [parseObject valueForKey:@"client_id"];
                productFromParse.codeGS = [parseObject valueForKey:@"codeGS"];
                productFromParse.name = [parseObject valueForKey:@"name"];
                productFromParse.desc = [parseObject valueForKey:@"desc"];
                productFromParse.fb_photo_id = [parseObject valueForKey:@"fb_photo_id"];
                productFromParse.fb_link = [parseObject valueForKey:@"fb_link"];
                productFromParse.currency = [parseObject valueForKey:@"currency"];
                productFromParse.price = [parseObject valueForKey:@"price"];
                productFromParse.created_time = [parseObject valueForKey:@"created_time"];
                productFromParse.updated_time = [parseObject valueForKey:@"updated_time"];
                productFromParse.solddisabled_time = [parseObject valueForKey:@"solddisabled_time"];
                productFromParse.fb_updated_time = [parseObject valueForKey:@"fb_updated_time"];
                productFromParse.type = [parseObject valueForKey:@"type"];
                productFromParse.picture_link = [parseObject valueForKey:@"picture_link"];
                productFromParse.additional_pictures = [parseObject valueForKey:@"additional_pictures"];
                productFromParse.status = [parseObject valueForKey:@"status"];
                productFromParse.last_promotion_time = [parseObject valueForKey:@"last_promotion_time"];
                productFromParse.promotion_piority = [parseObject valueForKey:@"promotion_piority"];
                productFromParse.notes = [parseObject valueForKey:@"notes"];
                productFromParse.agent_id = [parseObject valueForKey:@"agent_id"];
                productFromParse.update_db = [parseObject valueForKey:@"updatedAt"];
                
                // Update object in CoreData
                NSString *results = [self updateProductToCoreData:productFromParse];
                
                if ([results isEqualToString:@"NOT FOUND"])
                {
                    // Object is new! Add to CoreData;
                    [self addNewProductToCoreData:productFromParse];
                }
                else if (![results isEqualToString:@"OK"])
                {
                    NSLog(@"Failed to update the Product object in CoreData");
                    [self.delegate productsSyncedWithCoreData:NO];
                }
             }
            
            // Send messages to delegates
            [self.delegate productsSyncedWithCoreData:YES];
       }
        else
        {
            // Log details of the failure
            NSLog(@"Failed to retrieve the Product object from Parse. Error: %@ %@", error, [error userInfo]);
            [self.delegate productsSyncedWithCoreData:NO];
        }
    }];
}

- (NSMutableArray*)getProductArray; // Return an array with all products
{
    NSMutableArray *productsArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    productsArray = mainDelegate.sharedArrayProducts;
    
    // Sort array to be sure new products are on top
    [productsArray sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Product*)a updated_time];
        NSDate *second = [(Product*)b updated_time];
        return [second compare:first];
    }];
    
    return productsArray;
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

- (void)addNewProduct:(Product*)newProduct;
{
    CommonMethods *commonMethods = [[CommonMethods alloc] init];
    
    // Save object in Parse
    PFObject *parseObject = [PFObject objectWithClassName:@"Product"];
    
    parseObject[@"product_id"] = [commonMethods stringNotNil:newProduct.product_id];
    parseObject[@"client_id"] = [commonMethods stringNotNil:newProduct.client_id];
    parseObject[@"codeGS"] = [commonMethods stringNotNil:newProduct.codeGS];
    parseObject[@"name"] = [commonMethods stringNotNil:newProduct.name];
    parseObject[@"desc"] = [commonMethods stringNotNil:newProduct.desc];
    parseObject[@"fb_photo_id"] = [commonMethods stringNotNil:newProduct.fb_photo_id];
    parseObject[@"fb_link"] = [commonMethods stringNotNil:newProduct.fb_link];
    parseObject[@"currency"] = [commonMethods stringNotNil:newProduct.currency];
    parseObject[@"price"] = [commonMethods numberNotNil:newProduct.price];
    parseObject[@"created_time"] = [commonMethods dateNotNil:newProduct.created_time];
    parseObject[@"updated_time"] = [commonMethods dateNotNil:newProduct.updated_time];
    parseObject[@"solddisabled_time"] = [commonMethods dateNotNil:newProduct.solddisabled_time];
    parseObject[@"fb_updated_time"] = [commonMethods dateNotNil:newProduct.fb_updated_time];
    parseObject[@"type"] = [commonMethods stringNotNil:newProduct.type];
    parseObject[@"picture_link"] = [commonMethods stringNotNil:newProduct.picture_link];
    parseObject[@"additional_pictures"] = [commonMethods stringNotNil:newProduct.additional_pictures];
    parseObject[@"status"] = [commonMethods stringNotNil:newProduct.status];
    parseObject[@"last_promotion_time"] = [commonMethods dateNotNil:newProduct.last_promotion_time];
    parseObject[@"promotion_piority"] = [commonMethods stringNotNil:newProduct.promotion_piority];
    parseObject[@"notes"] = [commonMethods stringNotNil:newProduct.notes];
    parseObject[@"agent_id"] = [commonMethods stringNotNil:newProduct.agent_id];

    newProduct.update_db = [NSDate date]; // Set update time to DB to now
    parseObject[@"update_db"] = newProduct.update_db;
    
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            // The object has been saved to Parse! ... Add to CoreData
            
            if ([self addNewProductToCoreData:newProduct])
            {
                [self.delegate productAddedOrUpdated:YES];
            }
            else
            {
                [self.delegate productAddedOrUpdated:NO];
            }
        }
        else
        {
            // There was a problem, check error.description
            NSLog(@"Can't Save Product in Parse! %@", error.description);
            [self.delegate productAddedOrUpdated:NO];
        }
    }];
}

- (BOOL)addNewProductToCoreData:(Product *)newProduct
{
    BOOL updateSucceed = YES;
    
    // Save object in Core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Products" inManagedObjectContext:context];
    
    [coreDataObject setValue:newProduct.product_id forKey:@"product_id"];
    [coreDataObject setValue:newProduct.client_id forKey:@"client_id"];
    [coreDataObject setValue:newProduct.codeGS forKey:@"codeGS"];
    [coreDataObject setValue:newProduct.name forKey:@"name"];
    [coreDataObject setValue:newProduct.desc forKey:@"desc"];
    [coreDataObject setValue:newProduct.fb_photo_id forKey:@"fb_photo_id"];
    [coreDataObject setValue:newProduct.fb_link forKey:@"fb_link"];
    [coreDataObject setValue:newProduct.currency forKey:@"currency"];
    [coreDataObject setValue:newProduct.price forKey:@"price"];
    [coreDataObject setValue:newProduct.created_time forKey:@"created_time"];
    [coreDataObject setValue:newProduct.updated_time forKey:@"updated_time"];
    [coreDataObject setValue:newProduct.solddisabled_time forKey:@"solddisabled_time"];
    [coreDataObject setValue:newProduct.fb_updated_time forKey:@"fb_updated_time"];
    [coreDataObject setValue:newProduct.type forKey:@"type"];
    [coreDataObject setValue:newProduct.picture_link forKey:@"picture_link"];
    [coreDataObject setValue:newProduct.additional_pictures forKey:@"additional_pictures"];
    [coreDataObject setValue:newProduct.status forKey:@"status"];
    [coreDataObject setValue:newProduct.last_promotion_time forKey:@"last_promotion_time"];
    [coreDataObject setValue:newProduct.promotion_piority forKey:@"promotion_piority"];
    [coreDataObject setValue:newProduct.notes forKey:@"notes"];
    [coreDataObject setValue:newProduct.agent_id forKey:@"agent_id"];
    [coreDataObject setValue:newProduct.update_db forKey:@"update_db"];

    NSError *error = nil;
    // Save the object to Core Data
    if (![context save:&error]) {
        NSLog(@"Can't Save Product! %@ %@", error, [error localizedDescription]);
        updateSucceed = NO;
    }
    else // update successful!
    {
        // Add object to Shared Array
        AppDelegate *mainDelegate;
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        [mainDelegate.sharedArrayProducts addObject:newProduct];
        
        // Update last update time
        [[[SettingsModel alloc] init] updateSettingsProductDataUptaded:newProduct.update_db];
        
        // Update last product ID if needed
        if ([newProduct.product_id intValue] > mainDelegate.lastProductID)
        {
            mainDelegate.lastProductID = [newProduct.product_id intValue];
        }
    }
    
    return updateSucceed;
}

- (void)updateProduct:(Product*)productToUpdate;
{
    // Update object in Parse
    
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    [query whereKey:@"product_id" equalTo:productToUpdate.product_id];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseObject, NSError *error) {
        if (!parseObject)
        {
            NSLog(@"Failed to retrieve the Product object from Parse");
            [self.delegate productAddedOrUpdated:NO];
        }
        else
        {
            // The find from Parse succeeded... Update values
            parseObject[@"product_id"] = productToUpdate.product_id;
            parseObject[@"client_id"] = productToUpdate.client_id;
            parseObject[@"codeGS"] = productToUpdate.codeGS;
            parseObject[@"name"] = productToUpdate.name;
            parseObject[@"desc"] = productToUpdate.desc;
            parseObject[@"fb_photo_id"] = productToUpdate.fb_photo_id;
            parseObject[@"fb_link"] = productToUpdate.fb_link;
            parseObject[@"currency"] = productToUpdate.currency;
            parseObject[@"price"] = productToUpdate.price;
            parseObject[@"created_time"] = productToUpdate.created_time;
            parseObject[@"updated_time"] = productToUpdate.updated_time;
            parseObject[@"solddisabled_time"] = productToUpdate.solddisabled_time;
            parseObject[@"fb_updated_time"] = productToUpdate.fb_updated_time;
            parseObject[@"type"] = productToUpdate.type;
            parseObject[@"picture_link"] = productToUpdate.picture_link;
            parseObject[@"additional_pictures"] = productToUpdate.additional_pictures;
            parseObject[@"status"] = productToUpdate.status;
            parseObject[@"last_promotion_time"] = productToUpdate.last_promotion_time;
            parseObject[@"promotion_piority"] = productToUpdate.promotion_piority;
            parseObject[@"notes"] = productToUpdate.notes;
            parseObject[@"agent_id"] = productToUpdate.agent_id;

            productToUpdate.update_db = [NSDate date]; // Set update time to DB to now
            parseObject[@"update_db"] = productToUpdate.update_db;

            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    // The object has been saved to Parse! ... Update CoreData
                    
                    if ([[self updateProductToCoreData:productToUpdate] isEqualToString:@"OK"])
                    {
                        [self.delegate productAddedOrUpdated:YES];
                    }
                    else
                    {
                        [self.delegate productAddedOrUpdated:NO];
                    }
                }
                else
                {
                    // There was a problem, check error.description
                    NSLog(@"Can't Save Product in Parse! %@", error.description);
                    [self.delegate productAddedOrUpdated:NO];
                }
            }];
        }
    }];
}

- (NSString*)updateProductToCoreData:(Product*)productToUpdate;
{
    NSString *updateResults = @"OK";

    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Products" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"product_id", productToUpdate.product_id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
        updateResults = @"ERROR";
    }
    else
    {
        if (result.count == 0)
        {
            NSLog(@"No records retrieved");
            updateResults = @"NOT FOUND";
        }
        else
        {
            // Set updated values
            NSManagedObject *coreDataObject = (NSManagedObject *)[result objectAtIndex:0];
            
            [coreDataObject setValue:productToUpdate.product_id forKey:@"product_id"];
            [coreDataObject setValue:productToUpdate.client_id forKey:@"client_id"];
            [coreDataObject setValue:productToUpdate.codeGS forKey:@"codeGS"];
            [coreDataObject setValue:productToUpdate.name forKey:@"name"];
            [coreDataObject setValue:productToUpdate.desc forKey:@"desc"];
            [coreDataObject setValue:productToUpdate.fb_photo_id forKey:@"fb_photo_id"];
            [coreDataObject setValue:productToUpdate.fb_link forKey:@"fb_link"];
            [coreDataObject setValue:productToUpdate.currency forKey:@"currency"];
            [coreDataObject setValue:productToUpdate.price forKey:@"price"];
            [coreDataObject setValue:productToUpdate.created_time forKey:@"created_time"];
            [coreDataObject setValue:productToUpdate.updated_time forKey:@"updated_time"];
            [coreDataObject setValue:productToUpdate.solddisabled_time forKey:@"solddisabled_time"];
            [coreDataObject setValue:productToUpdate.fb_updated_time forKey:@"fb_updated_time"];
            [coreDataObject setValue:productToUpdate.type forKey:@"type"];
            [coreDataObject setValue:productToUpdate.picture_link forKey:@"picture_link"];
            [coreDataObject setValue:productToUpdate.additional_pictures forKey:@"additional_pictures"];
            [coreDataObject setValue:productToUpdate.status forKey:@"status"];
            [coreDataObject setValue:productToUpdate.last_promotion_time forKey:@"last_promotion_time"];
            [coreDataObject setValue:productToUpdate.promotion_piority forKey:@"promotion_piority"];
            [coreDataObject setValue:productToUpdate.notes forKey:@"notes"];
            [coreDataObject setValue:productToUpdate.agent_id forKey:@"agent_id"];
            [coreDataObject setValue:productToUpdate.update_db forKey:@"update_db"];
            
            // Save object to Core Data
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateResults = @"ERROR";
            }
            else // update successful!
            {
                // Replace object in Shared Array
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
                                
                //Update last update time
                [[[SettingsModel alloc] init] updateSettingsProductDataUptaded:productToUpdate.update_db];
            }
        }
    }
    return updateResults;
}

- (NSData*)getProductPhotoFrom:(Product*)productSelected;
{
    NSData *productPhoto;
    BOOL fetchSuccessful = YES;

    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProductPhotos" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"product_id", productSelected.product_id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
        fetchSuccessful = NO;
    }
    else
    {
        if (result.count == 0)
        {
             fetchSuccessful = NO;
        }
        else
        {
            NSManagedObject *coreDataObject = (NSManagedObject *)[result objectAtIndex:0];
            
            // Get data for picture
            productPhoto = [coreDataObject valueForKey:@"picture"];
        }
    }
    
    if (!fetchSuccessful)
    {
        // Use a Generic Picture
        productPhoto = UIImagePNGRepresentation([UIImage imageNamed:@"GenericProduct"]);

        // Ask for photo in background
        if (productSelected.picture_link)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:productSelected.picture_link]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Save photo on Core Data
                    NSManagedObjectContext *context = [self managedObjectContext];
                    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"ProductPhotos" inManagedObjectContext:context];
                    
                    [coreDataObject setValue:productSelected.product_id forKey:@"product_id"];
                    [coreDataObject setValue:picture forKey:@"picture"];
                    
                    NSError *error = nil;
                    // Save the object to Core Data
                    if (![context save:&error]) {
                        NSLog(@"Can't Save Product Photo! %@ %@", error, [error localizedDescription]);
                    }
                });
            });
        }
    }
    
    // Review if product is sold to update the picture
    
    if ([productSelected.status isEqualToString:@"S"])
    {
        UIImage *mergedImage = [self mergeImage:[UIImage imageWithData:productPhoto] withImage:[UIImage imageNamed:@"Sold"]];
        productPhoto = UIImagePNGRepresentation(mergedImage);
    }
    
    return productPhoto;
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
        if ([productSelected.product_id isEqualToString:opportunityTemp.product_id])
        {
            [opportunities addObject:opportunityTemp];
        }
    }
    
    return opportunities;
}

- (NSMutableArray*)getProductsFromClientId:(NSString*)clientIDtoSearch;
{
    NSMutableArray *productsArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    for (int i = 0; i < mainDelegate.sharedArrayProducts.count; i++)
    {
        Product *productTemp = [mainDelegate.sharedArrayProducts objectAtIndex: i];
        if ([productTemp.client_id isEqualToString:clientIDtoSearch])
        {
            [productsArray addObject:productTemp];
        }
    }
    
    return productsArray;
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
            // productImage = [UIImage imageWithData:productToReview.picture];
            productImage = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:productToReview]];
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
    
    Product *productFound = [[Product alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayProducts.count; i=i+1)
    {
        Product *productToReview = (Product *)mainDelegate.sharedArrayProducts[i];
        
        if ([productToReview.product_id isEqual:productIDtoSearch])
        {
            productFound = productToReview;
            break;
        }
    }
    return productFound;
}

- (NSString*)getTextThatFollows:(NSString*)textToSearch fromMessage:(NSString*)messageText; // Search a text and returns the numbers that follows the text
{
    NSString *textThatFollows;
    NSString *characterToEvaluate;
    
    NSRange match = [messageText rangeOfString:textToSearch];
    
    if (match.location == NSNotFound)
    {
        textThatFollows = @"Not Found";
    }
    else
    {
        BOOL found = NO;
        int initialPosition = match.location + match.length;
        int finalPosition = initialPosition;
        
        while ((found == NO) && (finalPosition < messageText.length))
        {
            
            characterToEvaluate = [messageText substringWithRange:NSMakeRange(finalPosition, 1)];
            if ([characterToEvaluate isEqualToString:@" "] || [characterToEvaluate isEqualToString:@"\n"] ) {
                found = YES;
            }
            finalPosition = finalPosition + 1;
        }
        
        textThatFollows = [messageText substringWithRange:NSMakeRange(initialPosition, finalPosition - initialPosition)];
    }
    
    return textThatFollows;
}

- (NSString*)getProductNameFromFBPhotoDesc:(NSString*)messageText;
{
    NSString *productName;
    
    // Divide the string into an array
    NSArray *paragraphs = [messageText componentsSeparatedByString:@"\n"];
    
    for (int i=0; i<paragraphs.count; i=i+1)
    {
        // Review if it is from a line with GS code or product price
        if ( [paragraphs[i] rangeOfString:@"GS"].location == NSNotFound )
        {
            if ( [paragraphs[i] rangeOfString:@"s/."].location == NSNotFound )
            {
                if ( [paragraphs[i] rangeOfString:@"USD"].location == NSNotFound )
                {
                    if ( [paragraphs[i] rangeOfString:@"VENDID"].location == NSNotFound )
                    {
                        productName = [NSString stringWithString:paragraphs[i]];
                        break;
                    }
                }
            }
        }
    }
    
    return [productName stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (int)numberOfNewProducts;
{
    int newProducts = 0;
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Product *productToReview = [[Product alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayProducts.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)mainDelegate.sharedArrayProducts[i];
        
        if ([productToReview.status isEqual:@"N"])
        {
            newProducts = newProducts + 1;
        }
    }

    return newProducts;
}

- (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second
{
    // get size of the first image
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    // get size of the second image
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    // build merged size
    CGFloat maxWidth = MAX(firstWidth, secondWidth);
    CGFloat maxHeight = MAX(firstHeight, secondHeight);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, maxWidth, maxHeight)];
    [second drawInRect:CGRectMake(0, 0, maxWidth, maxHeight)];

    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)updateProductsWithCodeGS:(NSString*)codeGSToFind withClientID:(NSString*)clientIDtoUse;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Product *productToReview = [[Product alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayProducts.count; i=i+1)
    {
        productToReview = [[Product alloc] init];
        productToReview = (Product *)mainDelegate.sharedArrayProducts[i];
        
        NSString *productCodeGS = [productToReview.codeGS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([codeGSToFind containsString:productCodeGS])
        {
             // Update Product!
            productToReview.client_id = clientIDtoUse;
            
            [self updateProduct:productToReview];
        }
    }
}

- (NSString*)getNextCodeGS;
{
    int maxCodeGS = 0;

    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    for (int i = 0; i < mainDelegate.sharedArrayProducts.count; i++)
    {
        Product *productTemp = [mainDelegate.sharedArrayProducts objectAtIndex: i];
        
        int productCodeGS = [[self getTextThatFollows:@"GS" fromMessage:productTemp.codeGS] intValue];
        
        if (maxCodeGS < productCodeGS)
        {
            maxCodeGS = productCodeGS;
        }
    }
    
    maxCodeGS = maxCodeGS + 1;
    
    NSString *nextID = [NSString stringWithFormat:@"00000000%d", maxCodeGS];
    if (maxCodeGS < 10000)
    {
        nextID = [nextID substringFromIndex:[nextID length] - 4];
    }
    else if (maxCodeGS < 100000)
    {
        nextID = [nextID substringFromIndex:[nextID length] - 5];
    }
    else if (maxCodeGS < 1000000)
    {
        nextID = [nextID substringFromIndex:[nextID length] - 6];
    }
    else if (maxCodeGS < 10000000)
    {
        nextID = [nextID substringFromIndex:[nextID length] - 7];
    }
    nextID = [NSString stringWithFormat:@"GS%@", nextID];;
    
    return nextID;
}

@end
