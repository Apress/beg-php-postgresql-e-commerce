-- Create category table
CREATE TABLE category
(
  category_id   SERIAL      NOT NULL,
  department_id INTEGER     NOT NULL,
  name          VARCHAR(50) NOT NULL,
  description   VARCHAR(1000),
  CONSTRAINT pk_category_id   PRIMARY KEY (category_id),
  CONSTRAINT fk_department_id FOREIGN KEY (department_id)
             REFERENCES department (department_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Populate category table
INSERT INTO category (category_id, department_id, name, description)
 VALUES (1, 1, 'Christmas Hats',
 'Enjoy browsing our collection of Christmas hats!');
INSERT INTO category (category_id, department_id, name, description)
 VALUES (2, 1, 'Halloween Hats',
 'Find the hat you''ll wear this Halloween!');
INSERT INTO category (category_id, department_id, name, description)
 VALUES (3, 1, 'St. Patrick''s Day Hats',
 'Try one of these beautiful hats on St. Patrick''s Day!');
INSERT INTO category (category_id, department_id, name, description)
 VALUES (4, 2, 'Berets',
 'An amazing collection of berets from all around the world!');
INSERT INTO category (category_id, department_id, name, description)
 VALUES (5, 2, 'Driving Caps',
 'Be an original driver! Buy a driver''s hat today!');
INSERT INTO category (category_id, department_id, name, description)
 VALUES (6, 3, 'Theatrical Hats',
 'Going to a costume party? Try one of these hats to complete your costume!');
INSERT INTO category (category_id, department_id, name, description)
 VALUES (7, 3, 'Military Hats',
 'This collection contains the most realistic replicas of military hats!');

-- Update the sequence
ALTER SEQUENCE category_category_id_seq RESTART WITH 8;

-- Create product table
CREATE TABLE product
(
  product_id       SERIAL         NOT NULL,
  name             VARCHAR(50)    NOT NULL,
  description      VARCHAR(1000)  NOT NULL,
  price            NUMERIC(10, 2) NOT NULL,
  discounted_price NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
  image            VARCHAR(150),
  thumbnail        VARCHAR(150),
  display          SMALLINT       NOT NULL DEFAULT 0,
  CONSTRAINT pk_product PRIMARY KEY (product_id)
);

-- Populate product table
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (1, 'Christmas Candy Hat', 'Be everyone''s "sweetie" while wearing this fun and festive peppermint candy hat. The Christmas Candy hat, made by Elope, stands about 15 inches tall and has a sizing adjustment on the inside.', 24.99, 0.00, 'ChristmasCandyHat.jpg', 'ChristmasCandyHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (2, 'Hanukah Hat', 'The Hanukah hat is a fun and festive way for you to enjoy yourself during the holiday. Made by Elope and adorned with 9 candles, this menorah is sure to brighten the winter celebration.', 24.99, 21.99, 'HanukahHat.jpg', 'HanukahHat.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (3, 'Springy Santa Hat', 'Santa Hat - Boing-Boing-Boing. Santa will be springing into town with this outrageous cap! If your children are whiney and clingy ... and your head''s going ping-pong-pingy ... and you feel like just rowing away in your rubber dinghy ... Take heart! You''ll bounce bounce back ... if you just put on our Santa hat that''s Springy!', 19.99, 0.00, 'SpringySantaHat.jpg', 'SpringySantaHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (4, 'Plush Santa Hat', 'Get into the spirit of the season with this plush, velvet-like, Santa hat. Comes in a beautiful crimson red color with a faux-fur trim.', 12.99, 0.00, 'PlushSantaHat.jpg', 'PlushSantaHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (5, 'Red Santa Cowboy Hat', 'This velvet Cowboy Santa Hat is one size fits all and has white faux-fur trim all around. Here comes Santa Claus ... Here comes Santa Claus ... right down Cowboy Lane!', 24.99, 0.00, 'RedSantaCowboyHat.jpg', 'RedSantaCowboyHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (6, 'Santa Jester Hat', 'This three-prong velvet jester is one size fits all and has an adjustable touch fastener back for perfect fitting.', 24.99, 0.00, 'SantaJesterHat.jpg', 'SantaJesterHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (7, 'Santa''s Elf Hat', 'Be Santa''s best looking helper with this velvet hat, complete with attached ears. So, if you don''t wanna be yourself ... don''t worry ... this Christmas, just be Santa''s elf! Happy Holidays!', 24.99, 16.95, 'Santa''sElfHat.jpg', 'Santa''sElfHat.thumb.jpg', 1);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (8, 'Chauffeur Hat', 'Uniform Chauffeur Cap. This cap is the real thing. Well-made and professional looking, our Chauffeur hat gets so many compliments from our customers who buy (and wear) them. It''s absolutely amazing how many of these we sell. One thing''s for sure, this authentic professional cap will let everyone know exactly who''s in the driver''s seat. So ... whether you''re driving Miss Daisy ... or driving yourself crazy ... I''ll bet your wife will coo and purr ... when she sees you in our authentic chauffer!', 69.99, 0.00, 'ChauffeurHat.jpg', 'ChauffeurHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (9, 'The Pope Hat', 'We''re not sure what the Vatican''s official position is on this hat, but we do know your friends will love you in this soft velour hat with gold lame accents. If you''re somewhat lacking in religion ... if you''re looking for some hope ... you might acquire just a smidgeon ... by faithfully wearing our Pope!', 29.99, 0.00, 'ThePopeHat.jpg', 'ThePopeHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (10, 'Vinyl Policeman Cop Hat', 'A hat that channels the 70s. This oversized vinyl cap with silver badge will make you a charter member of the disco era ... or is that disco error?', 29.99, 0.00, 'VinylPolicemanCopHat.jpg', 'VinylPolicemanCopHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (11, 'Burgundy Kings Crown', 'Our burgundy Kings Crown is one size fits all. This crown is adorned with gold ribbon, gems, and a faux-fur headband. Be King for a Day ... Finally get your say ... Put your foot down ... and do it with humor, wearing our Elegant Burgundy King''s Crown!', 34.99, 25.95, 'BurgandyKingsCrown.jpg', 'BurgandyKingsCrown.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (12, '454 Black Pirate Hat', 'Our wool felt Pirate Hat comes with the front and back brims turned upward. This sized hat has the pirate emblem on the front. So, ho, ho, ho and a bottle of rum ... if you''re about as crazy as they come ... wear our Pirate hat this coming Halloween ... and with an eyepatch to boot, you''ll be lusty, lean and mean!', 39.99, 0.00, '454BlackPirateHat.jpg', '454BlackPirateHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (13, 'Black Puritan Hat', 'Haentze Hatcrafters has been making quality theatrical and military headgear for decades. Each hat is made meticulously by hand with quality materials. Many of these hats have been used in movies and historical reproductions and re-enactments.', 89.99, 75.99, 'BlackPuritanHat.jpg', 'BlackPuritanHat.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (14, 'Professor McGonagall Witch Hat', 'Professor McGonagall, Deputy Headmistress of Hogwarts and Head of Gryffindor House, commands respect in this dramatic witch hat - and so will you! The inside of this hat has a touch fastener size-adjustment tab. The hat is a must for all Harry Potter fans!', 24.99, 0.00, 'ProfessorMcGonagallWitchHat.jpg', 'ProfessorMcGonagallWitchHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (15, 'Black Wizard Hat', 'This cool Merlin-style wizard hat by Elope has a dragon that lays around the whole hat. The wizard hat is one size fits all and has a touch fastener on the inside to adjust accordingly.', 34.99, 0.00, 'BlackWizardHat.jpg', 'BlackWizardHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (16, 'Leprechaun Hat', 'Show them the green! This hand-blocked, wool felt hat will make you the hit of this year''s St. Paddy''s Day Celebration! Oh yes, the green you will don ... and what better way, hon ... than if this St. Patrick''s Day ... you''re wearing our cool Leprechaun!', 88.99, 0.00, 'LeprechaunHat.jpg', 'LeprechaunHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (17, '9 Green MadHatter Top Hat', 'Each of our MadHatter hats is made meticulously by hand with quality materials. Many of these hats have been used in movies and historical reproductions and re-enactments.', 149.99, 124.95, '9GreenMadHatterTopHat.jpg', '9GreenMadHatterTopHat.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (18, 'Winter Walking Hat', 'Our declarative English walking hat by Christy''s of London comes in 100% Lana Wool and reveals a finished satin lining. Christy''s has been making hats since 1773 and knows how to make the best! Want proof? Try this one ... Irish eyes will be smiling.', 49.99, 0.00, 'WinterWalkingHat.jpg', 'WinterWalkingHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (19, 'Green MadHatter Hat', 'St. Patrick''s Day Hat - Luck o'' the Irish! This oversized green velveteen MadHatter is great for St.Patrick''s day or a MadHatter''s tea party.One size fits most adults.', 39.99, 28.99, 'GreenMadHatterHat.jpg', 'GreenMadHatterHat.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (20, 'Hole in One Golf Costume Hat', 'Golf Hat - OK, Ace. This spoof golfer''s hat sports an astro-turf "green," has an attached golf ball and flag, and includes a soft elastic band  for comfort. This hat also makes a great gift that is definitely "up to par" for any goofball''s - uh - golfballer''s taste. Perfect for Dad! And don''t you fore-get-it!', 29.99, 0.00, 'HoleinOneGolfCostumeHat.jpg', 'HoleinOneGolfCostumeHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (21, 'Luck of the Irish Bowler', 'This one size fits all Irish Derby comes with a shamrock attached to the side. This hat is made of a soft velvet and is comfortably sized.', 29.99, 0.00, 'LuckoftheIrishBowler.jpg', 'LuckoftheIrishBowler.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (22, 'St. Patrick''s Irish Green Derby', 'This quality bowler will last you more than one St. Patrick''s Day! A proper derby for the day, it is made of wool felt and has a green grosgrain band. This hat is not lined.', 39.99, 0.00, 'St.Patrick''sIrishGreenDerby.jpg', 'St.Patrick''sIrishGreenDerby.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (23, 'Black Basque Beret', 'This is our tried and true men''s classic beret hat(tam). Our Basque beret is superbly crafted, 100% wool, and has a comfortable leather sweatband. Lined and water resistant, the beret is great for everyday wear and rolls up nicely to fit in your pocket. So ... if you''re antsy ... in your pantsy ... cause you wanna catch the fancy ... of the lady near your way ... then please don''t delay ... just get this beret ... today ... and soon you''ll be making hay!', 49.99, 0.00, 'BlackBasqueBeret.jpg', 'BlackBasqueBeret.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (24, 'Cotton Beret', 'The Parkhurst SunGuard line of headwear offers the comfort and breathability of cotton and provides up to 50 times your natural protection from the sun''s rays. Fashionable, durable, and washable, Sunguard is the only choice.', 12.95, 7.95, 'CottonBeret.jpg', 'CottonBeret.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (25, 'Wool Beret', 'This classic tam from Kangol is one size fits all. It''s composed of 100% wool and measures 11" in diameter.', 24.99, 0.00, 'WoolBeret.jpg', 'WoolBeret.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (26, 'Military Beret', 'As one of our best selling berets, this Black Military Beret is especially popular in these war-torn days. Made of wool felt, it''s a facsimile of what Monty wore in the deserts of Africa in World War II. We don''t guarantee any sweeping victories with this beret, but you might score a personal triumph or two!', 19.99, 12.95, 'MilitaryBeret.jpg', 'MilitaryBeret.thumb.jpg', 3);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (27, 'Bond-Leather Driver', 'Leather was never so stylish. The Bond-Driver has an elastic sweatband for a sure fit. Seamed and unlined, this driver is perfect for cruising around town or saving the world.', 49.99, 0.00, 'Bond-LeatherDriver.jpg', 'Bond-LeatherDriver.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (28, 'Moleskin Driver', 'This quality ivy cap made by Christy''s comes with a finished lining. The material of this ivy is called moleskin and is very soft. If your life''s kinda in a hole ... and you wish you had a little more soul ... no need to beat your head against a pole, Ken ... just purchase our Christy''s Ivy Cap in Moleskin!', 29.99, 25.00, 'MoleskinDriver.jpg', 'MoleskinDriver.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (29, 'Herringbone English Driver', 'Herringbone is everywhere this year from head to toe. The English Driver ivy cap is made of wool with a cotton sweatband on the inside.', 29.99, 0.00, 'HerringboneEnglishDriver.jpg', 'HerringboneEnglishDriver.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (30, 'Confederate Civil War Kepi', 'Rebel Hat - Southern Hat - This kepi comes with the crossed musket emblem on the front.', 14.99, 0.00, 'ConfederateCivilWarKepi.jpg', 'ConfederateCivilWarKepi.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (31, 'Hillbilly Hat', 'Blocked wool, with a rope band. Please allow 1-2 weeks for delivery. Some sizes available for immediate shipment. Corn Cob pipe not included! So, go ahead Joe, or Carl, or Billy ... act nutso and be silly ... because we''ve got you covered willy-nilly ... in our sleepy-hollow Hillbilly!', 139.99, 124.95, 'HillbillyHat.jpg', 'HillbillyHat.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (32, 'Mother Goose Hat', 'Sorceress Witch Hat - Boil, Boil, Toil and Trouble! Mix up a pot of your best witch''s brew in this blocked wool felt hat. Available in almost all color combinations - email us for more information.', 149.99, 0.00, 'MotherGooseHat.jpg', 'MotherGooseHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (33, 'Uncle Sam Top Hat', 'Patriotic Hats, Uncle Sam Top Hat - This silk topper is a show stopper. Hand-fashioned quality will transform you into a Yankee Doodle Dandy ... Or you can call us a macaroni (something like that).', 199.00, 175.00, 'UncleSamTopHat.jpg', 'UncleSamTopHat.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (34, 'Velvet Sombrero Hat', 'Ay Caramba! This is the real thing! Get into this velvet sombrero, which is richly embossed with sequins. Comes in red and black.', 79.99, 0.00, 'VelvetSombreroHat.jpg', 'VelvetSombreroHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (35, 'Conductor Hat', 'Train Railroad Conductor Hat - You been working on the railroad all the live-long day? Well now, you can wear our Conductor''s hat, and your troubles will all go away! We sell a ton of these! Set the scene correctly with an authentic train or streetcar conductor''s uniform hat. Also makes a great gift for transportation enthusiasts. Don''t be a drain ... get on the train!', 69.99, 0.00, 'ConductorHat.jpg', 'ConductorHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (36, 'Traditional Colonial Tricorn Hat', 'Truly revolutionary headgear. This hat is blocked from black wool, and edges are finished with white ribbon. The edges are tacked up for durability. So if you''re glad to be born ... if you wanna toot your own horn ... just hop out of bed some lovely morn ... and put on our Traditional Colonial Tricorn!', 39.99, 0.00, 'TraditionalColonialTricornHat.jpg', 'TraditionalColonialTricornHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (37, 'Metal Viking Helmet', 'You can almost hear the creaking oars of your warship as you glide across open seas! Conquer new worlds with this authentic Nordic reproduction. Crafted from metal and horn, the Viking helmet is a necessity for any adventure. Would you adorn it while biking? ... How about on the wooded trials while hiking? ... Betcha it''ll always be to your liking ... wherever you wear our Metal Viking!', 119.99, 105.95, 'MetalVikingHelmet.jpg', 'MetalVikingHelmet.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (38, 'Confederate Slouch Hat', 'Our replica Confederate Slouch Hat from the Civil War comes with Cavalry yellow straps and crossed-sword emblem.', 129.99, 101.99, 'ConfederateSlouchHat.jpg', 'ConfederateSlouchHat.thumb.jpg', 1);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (39, 'Campaign Hat', 'Dress the part of Dudley-Do-Right, State Trooper Bob, Smokey the Bear, or WWI Doughboy. Wear it in the rain ... wear it carrying a cane ... wear it if you''re crazy or sane ... just wear our versatile Campaign!', 44.99, 0.00, 'CampaignHat.jpg', 'CampaignHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (40, 'Civil War Union Slouch Hat', 'This Yankee slouch hat from the Civil War era comes in a black wool felt material and has the U.S. metal emblem on the front. This Union hat comes with the officer''s cords.', 129.99, 0.00, 'CivilWarUnionSlouchHat.jpg', 'CivilWarUnionSlouchHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (41, 'Civil War Leather Kepi Cap', 'Calling all Civil War buffs! Yanks grab the blue, and Rebs get the gray. You''ll all be victorious in this suede cap worn in the "War Between the States." So, if on the Civil War you''re hep-eee ... then by all means, you gotta have our kepi!', 39.99, 0.00, 'CivilWarLeatherKepiCap.jpg', 'CivilWarLeatherKepiCap.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (42, 'Cavalier Hat - Three Musketeers', 'Reproduction of the original Cavalier hat complete with a feather! Handblocked from 100% wool felt. This is as close to the real thing as you get. It is better than downing a beer ... it is better than having your honey say, "Come on over here, Dear" ... All you gotta do is let go of your fear ... and order this stunning, galant Cavalier!', 185.00, 0.00, 'CavalierHat-ThreeMusketeers.jpg', 'CavalierHat-ThreeMusketeers.thumb.jpg', 1);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (43, 'Hussar Military Hat', 'A "Hussar" was an enlisted Cavalry soldier. All hussar soldiers were taught to read and write, and they commonly kept journals of some sort - probably helping them to pass the time while they were away from home in the service of their country. They were required to keep records of their duties and work, as well.', 199.99, 0.00, 'HussarMilitaryHat.jpg', 'HussarMilitaryHat.thumb.jpg', 0);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (44, 'Union Civil War Kepi Cap', 'Union Soldier''s Cap - Yankee Cap - This kepi comes with the crossed musket emblem on the front.', 14.99, 0.00, 'UnionCivilWarKepiCap.jpg', 'UnionCivilWarKepiCap.thumb.jpg', 2);
INSERT INTO product (product_id, name, description, price, discounted_price, image, thumbnail, display) VALUES (45, 'Tarbucket Helmet Military Hat', 'This is a reproduction Tarbucket type hat. This style was a popular military style in the early to mid 1800s. The style is similar to a shako hat, with the main difference being that the crown flairs outward.', 299.99, 0.00, 'TarbucketHelmetMilitaryHat.jpg', 'TarbucketHelmetMilitaryHat.thumb.jpg', 0);

-- Update the sequence
ALTER SEQUENCE product_product_id_seq RESTART WITH 46;

-- Create product_category table
CREATE TABLE product_category
(
  product_id  INTEGER NOT NULL,
  category_id INTEGER NOT NULL,
  CONSTRAINT pk_product_id_category_id PRIMARY KEY (product_id, category_id),
  CONSTRAINT fk_product_id             FOREIGN KEY (product_id)
             REFERENCES product (product_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_category_id            FOREIGN KEY (category_id)
             REFERENCES category (category_id)
             ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Populate product_category table
INSERT INTO product_category VALUES (1, 1);
INSERT INTO product_category VALUES (2, 1);
INSERT INTO product_category VALUES (3, 1);
INSERT INTO product_category VALUES (4, 1);
INSERT INTO product_category VALUES (5, 1);
INSERT INTO product_category VALUES (6, 1);
INSERT INTO product_category VALUES (7, 1);
INSERT INTO product_category VALUES (8, 2);
INSERT INTO product_category VALUES (9, 2);
INSERT INTO product_category VALUES (10, 2);
INSERT INTO product_category VALUES (11, 2);
INSERT INTO product_category VALUES (12, 2);
INSERT INTO product_category VALUES (13, 2);
INSERT INTO product_category VALUES (14, 2);
INSERT INTO product_category VALUES (15, 2);
INSERT INTO product_category VALUES (16, 3);
INSERT INTO product_category VALUES (17, 3);
INSERT INTO product_category VALUES (18, 3);
INSERT INTO product_category VALUES (19, 3);
INSERT INTO product_category VALUES (20, 3);
INSERT INTO product_category VALUES (21, 3);
INSERT INTO product_category VALUES (22, 3);
INSERT INTO product_category VALUES (23, 4);
INSERT INTO product_category VALUES (24, 4);
INSERT INTO product_category VALUES (25, 4);
INSERT INTO product_category VALUES (26, 4);
INSERT INTO product_category VALUES (8, 5);
INSERT INTO product_category VALUES (27, 5);
INSERT INTO product_category VALUES (28, 5);
INSERT INTO product_category VALUES (29, 5);
INSERT INTO product_category VALUES (30, 6);
INSERT INTO product_category VALUES (31, 6);
INSERT INTO product_category VALUES (32, 6);
INSERT INTO product_category VALUES (33, 6);
INSERT INTO product_category VALUES (34, 6);
INSERT INTO product_category VALUES (35, 6);
INSERT INTO product_category VALUES (26, 7);
INSERT INTO product_category VALUES (36, 7);
INSERT INTO product_category VALUES (37, 7);
INSERT INTO product_category VALUES (38, 7);
INSERT INTO product_category VALUES (39, 7);
INSERT INTO product_category VALUES (40, 7);
INSERT INTO product_category VALUES (41, 7);
INSERT INTO product_category VALUES (42, 7);
INSERT INTO product_category VALUES (43, 7);
INSERT INTO product_category VALUES (44, 7);
INSERT INTO product_category VALUES (45, 7);

-- Create department_details type
CREATE TYPE department_details AS
(
  name        VARCHAR(50),
  description VARCHAR(1000)
);

-- Create catalog_get_department_details function
CREATE FUNCTION catalog_get_department_details(INTEGER)
RETURNS department_details LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId ALIAS FOR $1;
    outDepartmentDetailsRow department_details;
  BEGIN
    SELECT INTO outDepartmentDetailsRow
           name, description
    FROM   department
    WHERE  department_id = inDepartmentId;
    RETURN outDepartmentDetailsRow;
  END;
$$;

-- Create category_list type
CREATE TYPE category_list AS
(
  category_id INTEGER,
  name        VARCHAR(50)
);

-- Create catalog_get_categories_list function
CREATE FUNCTION catalog_get_categories_list(INTEGER)
RETURNS SETOF category_list LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId ALIAS FOR $1;
    outCategoryListRow category_list;
  BEGIN
    FOR outCategoryListRow IN
      SELECT   category_id, name
      FROM     category
      WHERE    department_id = inDepartmentId
      ORDER BY category_id
    LOOP
      RETURN NEXT outCategoryListRow;
    END LOOP;
  END;
$$;

-- Create category_details type
CREATE TYPE category_details AS
(
  name        VARCHAR(50),
  description VARCHAR(1000)
);

-- Create catalog_get_category_details function
CREATE FUNCTION catalog_get_category_details(INTEGER)
RETURNS category_details LANGUAGE plpgsql AS $$
  DECLARE
    inCategoryId ALIAS FOR $1;
    outCategoryDetailsRow category_details;
  BEGIN
    SELECT INTO outCategoryDetailsRow
           name, description
    FROM   category
    WHERE  category_id = inCategoryId;
    RETURN outCategoryDetailsRow;
  END;
$$;

-- Create catalog_count_products_in_category function
CREATE FUNCTION catalog_count_products_in_category(INTEGER)
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    inCategoryId ALIAS FOR $1;
    outCategoriesCount INTEGER;
  BEGIN
    SELECT     INTO outCategoriesCount
               count(*)
    FROM       product p
    INNER JOIN product_category pc
                 ON p.product_id = pc.product_id
    WHERE      pc.category_id = inCategoryId;
    RETURN outCategoriesCount;
  END;
$$;

-- Create product_list type
CREATE TYPE product_list AS
(
  product_id       INTEGER,
  name             VARCHAR(50),
  description      VARCHAR(1000),
  price            NUMERIC(10, 2),
  discounted_price NUMERIC(10, 2),
  thumbnail        VARCHAR(150)
);

-- Create catalog_get_products_in_category function
CREATE FUNCTION catalog_get_products_in_category(
                  INTEGER, INTEGER, INTEGER, INTEGER)
RETURNS SETOF product_list LANGUAGE plpgsql AS $$
  DECLARE
    inCategoryId                    ALIAS FOR $1;
    inShortProductDescriptionLength ALIAS FOR $2;
    inProductsPerPage               ALIAS FOR $3;
    inStartItem                     ALIAS FOR $4;
    outProductListRow product_list;
  BEGIN
    FOR outProductListRow IN
      SELECT     p.product_id, p.name, p.description, p.price,
                 p.discounted_price, p.thumbnail
      FROM       product p
      INNER JOIN product_category pc
                   ON p.product_id = pc.product_id
      WHERE      pc.category_id = inCategoryId
      ORDER BY   p.product_id
      LIMIT      inProductsPerPage
      OFFSET     inStartItem
    LOOP
      IF char_length(outProductListRow.description) > 
         inShortProductDescriptionLength THEN
        outProductListRow.description :=
          substring(outProductListRow.description, 1,
                    inShortProductDescriptionLength) || '...';
      END IF;
      RETURN NEXT outProductListRow;
    END LOOP;
  END;
$$;

-- Create catalog_count_products_on_department function
CREATE FUNCTION catalog_count_products_on_department(INTEGER)
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId ALIAS FOR $1;
    outProductsOnDepartmentCount INTEGER;
  BEGIN
    SELECT DISTINCT INTO outProductsOnDepartmentCount
                    count(*)
    FROM            product p
    INNER JOIN      product_category pc
                      ON p.product_id = pc.product_id
    INNER JOIN      category c
                      ON pc.category_id = c.category_id
    WHERE           (p.display = 2 OR p.display = 3)
                    AND c.department_id = inDepartmentId;
    RETURN outProductsOnDepartmentCount;
  END;
$$;

-- Create catalog_get_products_on_department function
CREATE FUNCTION catalog_get_products_on_department(
                  INTEGER, INTEGER, INTEGER, INTEGER)
RETURNS SETOF product_list LANGUAGE plpgsql AS $$
  DECLARE
    inDepartmentId                  ALIAS FOR $1;
    inShortProductDescriptionLength ALIAS FOR $2;
    inProductsPerPage               ALIAS FOR $3;
    inStartItem                     ALIAS FOR $4;
    outProductListRow product_list;
  BEGIN
    FOR outProductListRow IN
      SELECT DISTINCT p.product_id, p.name, p.description, p.price,
                      p.discounted_price, p.thumbnail
      FROM            product p
      INNER JOIN      product_category pc
                        ON p.product_id = pc.product_id
      INNER JOIN      category c
                        ON pc.category_id = c.category_id
      WHERE           (p.display = 2 OR p.display = 3)
                      AND c.department_id = inDepartmentId
      ORDER BY        p.product_id
      LIMIT           inProductsPerPage
      OFFSET          inStartItem
    LOOP
      IF char_length(outProductListRow.description) > 
         inShortProductDescriptionLength THEN
        outProductListRow.description :=
          substring(outProductListRow.description, 1,
                    inShortProductDescriptionLength) || '...';
      END IF;
      RETURN NEXT outProductListRow;
    END LOOP;
  END;
$$;

-- Create catalog_count_products_on_catalog function
CREATE FUNCTION catalog_count_products_on_catalog()
RETURNS INTEGER LANGUAGE plpgsql AS $$
  DECLARE
    outProductsOnCatalogCount INTEGER;
  BEGIN
      SELECT INTO outProductsOnCatalogCount
             count(*)
      FROM   product
      WHERE  display = 1 OR display = 3;
      RETURN outProductsOnCatalogCount;
  END;
$$;

-- Create catalog_get_products_on_catalog function
CREATE FUNCTION catalog_get_products_on_catalog(INTEGER, INTEGER, INTEGER)
RETURNS SETOF product_list LANGUAGE plpgsql AS $$
  DECLARE
    inShortProductDescriptionLength ALIAS FOR $1;
    inProductsPerPage               ALIAS FOR $2;
    inStartItem                     ALIAS FOR $3;
    outProductListRow product_list;
  BEGIN
    FOR outProductListRow IN
      SELECT   product_id, name, description, price,
               discounted_price, thumbnail
      FROM     product
      WHERE    display = 1 OR display = 3
      ORDER BY product_id
      LIMIT    inProductsPerPage
      OFFSET   inStartItem
    LOOP
      IF char_length(outProductListRow.description) >
         inShortProductDescriptionLength THEN
        outProductListRow.description :=
          substring(outProductListRow.description, 1,
                    inShortProductDescriptionLength) || '...';
      END IF;
      RETURN NEXT outProductListRow;
    END LOOP;
  END;
$$;

-- Create product_details type
CREATE TYPE product_details AS
(
  product_id       INTEGER,
  name             VARCHAR(50),
  description      VARCHAR(1000),
  price            NUMERIC(10, 2),
  discounted_price NUMERIC(10, 2),
  image            VARCHAR(150)
);

-- Create catalog_get_product_details function
CREATE FUNCTION catalog_get_product_details(INTEGER)
RETURNS product_details LANGUAGE plpgsql AS $$
  DECLARE
    inProductId ALIAS FOR $1;
    outProductDetailsRow product_details;
  BEGIN
    SELECT INTO outProductDetailsRow
           product_id, name, description,
           price, discounted_price, image
    FROM   product
    WHERE  product_id = inProductId;
    RETURN outProductDetailsRow;
  END;
$$;
