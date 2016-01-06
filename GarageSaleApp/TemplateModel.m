//
//  TemplateModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 17/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "TemplateModel.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SettingsModel.h"
#import "CommonMethods.h"

@implementation TemplateModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveInitialDataforTemplates;
{
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    
    // Create template #1
    Template *tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00001";
    tempTemplate.title = @"Aviso comprador";
    tempTemplate.text = @"Hola #COMPRADOR. La dueña de es #DUENO y su teléfono es #D-TELEFONO. Coordina con #D-ELELLA cuando puedes ir a verlo, yo ya le avisé que #D-LALO vas a llamar. En caso lo llegues a comprar necesito que por favor me mandes un mensajito avisándome. Gracias. Saludos, Giuliana   #DESCRIPCION    #FBLINK";

    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];

    // Create template #2
    tempTemplate = [[Template alloc] init];
    
    tempTemplate.template_id = @"00002";
    tempTemplate.title = @"Sistema de trabajo";
    tempTemplate.text = @"Hola #COMPRADOR. Te cuento cuál es nuestro sistema de trabajo..... Para poder publicar tus cosas necesito que me mandes las fotos de cada cosa junto con el precio de venta, una pequeña descripción que incluya el estado en que se encuentra, tus teléfonos y distrito. La publicación es gratis y en caso se venda algo a través nuestro cobramos una comisión de 10% del precio de venta final y debe de estar incluido en el precio que nos das. Para qué la publicación sea aprobada los precios tienen que ser atractivos. Cuando una persona se interesa en un producto tuyo le damos tu teléfono por el inbox previa revisión de su perfil, por lo general son personas conocidas o referidas. Para el pago de la comisión tenemos una cuenta BCP donde puedes depositarnos o transferirnos. Si tienes alguna duda escríbeme. Saludos, Giuliana";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #3
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00003";
    tempTemplate.title = @"Interés inicial";
    tempTemplate.text = @"Si está disponible. Para poder mandarte los datos al inbox necesito que por favor aceptes mi solicitud de amistad y me avises una vez que lo hagas :)";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #4
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00004";
    tempTemplate.title = @"Confirmación de visita";
    tempTemplate.text = @"Hola #COMPRADOR. Cómo estás? Quería que por favor me cuentes si llegaste a ir por el #PRODUCTO. Espero tus comentarios. Gracias. Saludos, Giuliana";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #5
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00005";
    tempTemplate.title = @"Envío de cuenta";
    tempTemplate.text = @"Te paso nuestra cuenta para que puedas hacer el abono de la comisión (10%). BCP ahorros soles # 194-22457272-0-11 a nombre de Maria Giuliana Ugarelli Reinafarje.  Acuérdate de avisarme a penas lo hagas para saber que es tuyo y sacarte de la lista de pendientes.  Puede ser transferencia por internet o depósito (de preferencia en Agente y no en agencia).  Un beso, Giuliana";
    tempTemplate.type = @"O";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #6
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00006";
    tempTemplate.title = @"Confirmación de venta";
    tempTemplate.text = @"Hola #DUENO. Cómo estás? Quería que por favor me cuentes si fueron a ver el #PRODUCTO y llegaste a venderlo para coordinar lo de la comisión. Espero tus comentarios. Gracias. Saludos, Giuliana";
    tempTemplate.type = @"O";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #7
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00007";
    tempTemplate.title = @"Venta de ropa";
    tempTemplate.text = @"Si es ropa, no cobramos comisión, pero cobramos por nuestros servicios el 5% del precio de venta y debe ser abonado en nuestra cuenta BCP antes de la publicación y es muy independiente de si se vende o no el producto";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #8
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00008";
    tempTemplate.title = @"Sistema de aviso";
    tempTemplate.text = @"En este caso lo que hacemos es poner un aviso y en la descripción ponemos tu teléfono para que te contacten directamente. No cobramos comisión por venta, pero cobramos un monto de s/. 30 por nuestros servicios. Si te interesa avísame para pasarte nuestro número de cuenta BCP. Un beso, Giuliana";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];

}

- (NSMutableArray*)getTemplatesFromCoreData;
{
    NSMutableArray *templatesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Templates"];
    templatesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return templatesArray;
}

- (void)syncCoreDataWithParse;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Get latest information from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Template"];
    [query whereKey:@"updatedAt" greaterThan:mainDelegate.sharedSettings.template_last_update];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find from Parse succeeded
            for (PFObject *parseObject in objects)
            {
                Template *templateFromParse = [[Template alloc] init];
                
                templateFromParse.template_id = [parseObject valueForKey:@"template_id"];
                templateFromParse.title = [parseObject valueForKey:@"title"];
                templateFromParse.text = [parseObject valueForKey:@"text"];
                templateFromParse.type = [parseObject valueForKey:@"type"];
                templateFromParse.updated_time = [parseObject valueForKey:@"updated_time"];
                templateFromParse.agent_id = [parseObject valueForKey:@"agent_id"];
                templateFromParse.update_db = [parseObject valueForKey:@"updatedAt"];
                
                // Update object in CoreData
                NSString *results = [self updateTemplateToCoreData:templateFromParse];
                
                if ([results isEqualToString:@"NOT FOUND"])
                {
                    // Object is new! Add to CoreData;
                    [self addNewTemplateToCoreData:templateFromParse];
                }
                else if (![results isEqualToString:@"OK"])
                {
                    NSLog(@"Failed to update the Template object in CoreData");
                    [self.delegate templatesSyncedWithCoreData:NO];
                }
            }
            
            // Send messages to delegates
            [self.delegate templatesSyncedWithCoreData:YES];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Failed to retrieve the Template object from Parse. Error: %@ %@", error, [error userInfo]);
            [self.delegate templatesSyncedWithCoreData:NO];
        }
    }];
}

- (NSMutableArray*)getTemplatesFromType:(NSString*)templateType;
{
    NSMutableArray *templatesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Templates"];
    
    NSPredicate *predicateFetch = [NSPredicate predicateWithFormat:@"type like[c] %@", templateType];
    [fetchRequest setPredicate:predicateFetch];
    
    templatesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return templatesArray;
}

- (NSString*)getNextTemplateID;
{
    NSMutableArray *templatesArray = [self getTemplatesFromCoreData];
    
    Template *templateToReview = [[Template alloc] init];
    int lastID = 0;
    
    for (int i=0; i<templatesArray.count; i=i+1)
    {
        templateToReview = [[Template alloc] init];
        templateToReview = (Template *)templatesArray[i];
        
        if ([templateToReview.template_id intValue] > lastID)
        {
            lastID = [templateToReview.template_id intValue];
        }
    }
    
    lastID = lastID + 1;
    
    NSString *nextID = [NSString stringWithFormat:@"00000000%d", lastID];
    nextID = [nextID substringFromIndex:[nextID length] - 5];
    
    return nextID;
}

- (void)addNewTemplate:(Template*)newTemplate;
{
    CommonMethods *commonMethods = [[CommonMethods alloc] init];
    
    // Save object in Parse
    PFObject *parseObject = [PFObject objectWithClassName:@"Template"];
    
    parseObject[@"template_id"] = [commonMethods stringNotNil:newTemplate.template_id];
    parseObject[@"title"] = [commonMethods stringNotNil:newTemplate.title];
    parseObject[@"text"] = [commonMethods stringNotNil:newTemplate.text];
    parseObject[@"type"] = [commonMethods stringNotNil:newTemplate.type];
    parseObject[@"updated_time"] = [commonMethods dateNotNil:newTemplate.updated_time];
    parseObject[@"agent_id"] = [commonMethods stringNotNil:newTemplate.agent_id];
    
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            // The object has been saved to Parse! ... Add to CoreData
            
            newTemplate.update_db = [NSDate date]; // Set update time to DB to now
            
            [self addNewTemplateToCoreData:newTemplate];
        }
        else
        {
            // There was a problem, check error.description
            NSLog(@"Can't Save Template in Parse! %@", error.description);
        }
    }];
}

- (void)addNewTemplateToCoreData:(Template *)newTemplate
{
    // Save object in Core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Templates" inManagedObjectContext:context];
    
    [coreDataObject setValue:newTemplate.template_id forKey:@"template_id"];
    [coreDataObject setValue:newTemplate.title forKey:@"title"];
    [coreDataObject setValue:newTemplate.text forKey:@"text"];
    [coreDataObject setValue:newTemplate.type forKey:@"type"];
    [coreDataObject setValue:newTemplate.updated_time forKey:@"updated_time"];
    [coreDataObject setValue:newTemplate.agent_id forKey:@"agent_id"];
    [coreDataObject setValue:newTemplate.update_db forKey:@"update_db"];
    
    NSError *error = nil;
    // Save the object to Core Data
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else // update successful!
    {
        // To have access to shared arrays from AppDelegate
        AppDelegate *mainDelegate;
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        //Update last update time
        [[[SettingsModel alloc] init] updateSettingsTemplateDataUptaded:newTemplate.update_db];
    }
}

- (void)updateTemplate:(Template*)templateToUpdate;
{
    // Update object in Parse
    
    PFQuery *query = [PFQuery queryWithClassName:@"Template"];
    [query whereKey:@"template_id" equalTo:templateToUpdate.template_id];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseObject, NSError *error) {
        if (!parseObject)
        {
            NSLog(@"Failed to retrieve the Template object from Parse");
        }
        else
        {
            // The find from Parse succeeded... Update values
            parseObject[@"template_id"] = templateToUpdate.template_id;
            parseObject[@"title"] = templateToUpdate.title;
            parseObject[@"text"] = templateToUpdate.text;
            parseObject[@"type"] = templateToUpdate.type;
            parseObject[@"updated_time"] = templateToUpdate.updated_time;
            parseObject[@"agent_id"] = templateToUpdate.agent_id;

            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    // The object has been saved to Parse! ... Update CoreData
                    
                    templateToUpdate.update_db = [NSDate date]; // Set update time to DB to now
                    
                    [self updateTemplateToCoreData:templateToUpdate];
                }
                else
                {
                    // There was a problem, check error.description
                    NSLog(@"Can't Save Template in Parse! %@", error.description);
                }
            }];
        }
    }];
}

- (NSString*)updateTemplateToCoreData:(Template*)templateToUpdate
{
    NSString *updateResults = @"OK";
    
    // Update object in Core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Templates" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"template_id", templateToUpdate.template_id];
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
            
            [coreDataObject setValue:templateToUpdate.template_id forKey:@"template_id"];
            [coreDataObject setValue:templateToUpdate.title forKey:@"title"];
            [coreDataObject setValue:templateToUpdate.text forKey:@"text"];
            [coreDataObject setValue:templateToUpdate.type forKey:@"type"];
            [coreDataObject setValue:templateToUpdate.updated_time forKey:@"updated_time"];
            [coreDataObject setValue:templateToUpdate.agent_id forKey:@"agent_id"];
            [coreDataObject setValue:templateToUpdate.update_db forKey:@"update_db"];
            
            // Save object to Core Data
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateResults = @"ERROR";
            }
            else // update successful!
            {
                //Update last update time
                [[[SettingsModel alloc] init] updateSettingsTemplateDataUptaded:templateToUpdate.update_db];
            }
        }
    }
    return updateResults;
}

- (NSString*)changeKeysForText:(NSString*)textToReview usingBuyer:(Client*)clientBuyer andOwner:(Client*)clientOwner andProducts:(NSMutableArray*)relatedProductsArray;
{
    NSMutableString *reviewedText = [NSMutableString stringWithString:textToReview];
    NSRange keyRange;

    if ([clientBuyer.client_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#COMPRADOR"];
        if ((keyRange.location != NSNotFound) && (clientBuyer.name != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientBuyer.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-TELEFONO"];
        if ((keyRange.location != NSNotFound) && (clientBuyer.phone1 != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientBuyer.phone1];
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-LALO"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"lo"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"la"];
            }
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-ELELLA"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"el"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"ella"];
            }
        }
    }
    
    if ([clientOwner.client_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#DUENO"];
        if ((keyRange.location != NSNotFound) && (clientOwner.name != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-TELEFONO"];
        if ((keyRange.location != NSNotFound) && (clientOwner.phone1 != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.phone1];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-ZONA"];
        if ((keyRange.location != NSNotFound) && (clientOwner.client_zone != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.client_zone];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-LALO"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"lo"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"la"];
            }
        }
 
        keyRange = [reviewedText rangeOfString:@"#D-ELELLA"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"el"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"ella"];
            }
        }
       
    }
    
    if (relatedProductsArray.count > 0)
    {
        Product *relatedProduct = (Product*)relatedProductsArray[0];
        
        keyRange = [reviewedText rangeOfString:@"#PRODUCTO"];
        if ((keyRange.location != NSNotFound) && (relatedProduct.name != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:relatedProduct.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#PRECIO"];
        if ((keyRange.location != NSNotFound) && (relatedProduct.price != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:[NSString stringWithFormat:@"%@", relatedProduct.price]];
        }

        keyRange = [reviewedText rangeOfString:@"#DESCRIPCION"];
        if ((keyRange.location != NSNotFound) && (relatedProduct.desc != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:[NSString stringWithFormat:@"%@", relatedProduct.desc]];
        }

        keyRange = [reviewedText rangeOfString:@"#FBLINK"];
        if ((keyRange.location != NSNotFound) && (relatedProduct.fb_link != nil))
        {
            [reviewedText replaceCharactersInRange:keyRange withString:[NSString stringWithFormat:@"%@", relatedProduct.fb_link]];
        }
        
        keyRange = [reviewedText rangeOfString:@"#LISTAPRODUCTOS"];
        if ((keyRange.location != NSNotFound) && (relatedProduct.name != nil))
        {
            NSMutableString *productList = [[NSMutableString alloc] init];
            for (int i=0; i<relatedProductsArray.count; i=i+1)
            {
                relatedProduct = (Product*)relatedProductsArray[i];
                [productList appendString:[NSString stringWithFormat:@"\n%@\n", relatedProduct.name]];
                [productList appendString:[NSString stringWithFormat:@"%@\n", relatedProduct.fb_link]];
            }
            [reviewedText replaceCharactersInRange:keyRange withString:productList];
        }
    }    
    
    return [NSString stringWithString:reviewedText];
}

@end

