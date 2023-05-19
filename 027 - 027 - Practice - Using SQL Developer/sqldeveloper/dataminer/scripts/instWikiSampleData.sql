
-- loads WIKISAMPLE table
--
-- Paramters:
-- 1. User account - account to load the table into
-- Example:
-- @instWikiSampleData.sql <USER>
--------------------------------------------------------

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Load Data Miner demo table WIKISAMPLE.');
EXECUTE dbms_output.put_line('');


-- Drop table if it already exists
-- NOTE: ERRORS ARE OK FOR THE DROP TABLE AS IT CONFIRMS THE TABLE DOES NOT EXIST
DECLARE
v_sql varchar2(100); 
user_account_value varchar2(120);
BEGIN

user_account_value := q'[&&1]';

-- Change to the new user schema
BEGIN
v_sql := 'ALTER session set current_schema = "' || user_account_value || '" ' ; -- Enter the user schema
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': ***  Failed ***');
raise;
END;

v_sql := 'DROP TABLE WIKISAMPLE';
EXECUTE IMMEDIATE v_sql;
DBMS_OUTPUT.PUT_LINE (v_sql ||': succeeded');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE (v_sql ||': drop unneccessary - no table/view exists');
END;
/

--------------------------------------------------------
--  DDL for Table ODMR_CARS_DATA
--------------------------------------------------------

CREATE TABLE WIKISAMPLE("TITLE" VARCHAR2(2000), "TEXT" CLOB) NOLOGGING;

REM INSERTING INTO WIKISAMPLE
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Albedo','Albedo Albedo For other uses see disambiguation.
The albedo is a measure of reflectivity of a surface or body It is the ratio of electromagnetic radiation EM radiation reflected to the amount incident upon it The fraction usually expressed as a percentage from to is an important concept in climatology and astronomy This ratio depends on the frequency of the radiation considered unqualified it refers to an average across the spectrum of visible light It also depends on the angle of incidence of the radiation unqualified normal incidence Fresh snow albedos are high up to The ocean surface has a low albedo Earth has an average albedo of whereas the albedo of the Moon is about In astronomy the albedo of satellites and asteroids can be used to infer surface composition most notably ice content Enceladus a moon of Saturn has the highest known albedo of any body in the solar system with of EM radiation reflected The next highest albedo belongs to Alex.
Human activities have changed the albedo via forest clearance and farming for example of various areas around the globe However quantification of this effect is difficult on the global scale it is not clear whether the changes have tended to increase or decrease global warming.
The classical example of albedo effect is the snow temperature feedback If a snow covered area warms and the snow melts the albedo decreases more sunlight is absorbed and the temperature tends to increase The converse is true if snow forms a cooling cycle happens The intensity of the albedo effect depends on the size of the change in albedo and the amount of insolation for this reason it can be potentially very large in the tropics.
 Some examples of albedo effects.
 Fairbanks Alaska.
According to the National Climatic Data Center''s GHCN data which is composed of year smoothed climatic means for thousands of weather stations across the world the college weather station at Fairbanks Alaska is about C F warmer than the airport at Fairbanks partly because of drainage patterns but also largely because of the lower albedo at the college resulting from a higher concentration of pine trees and therefore less open snowy ground to reflect the heat back into space Neunke and Kukla have shown that this difference is especially marked during the late winter months when solar radiation is greater.
 The tropics.
Although the albedo temperature effect is most famous in colder regions of Earth because more snow falls there it is actually much stronger in tropical regions because in the tropics there is consistently more sunlight When Brazilian ranchers cut down dark tropical rainforest trees to replace them with even darker soil in order to grow crops the average temperature of the area appears to increase by an average of about C F year round.
 Small scale effects.
Albedo works on a smaller scale too People who wear dark clothes in the summertime put themselves at a greater risk of heatstroke than those who wear white clothes.
 Pine forests.
The albedo of a pine forest at N in the winter in which the trees cover the land surface completely is only about among the lowest of any naturally occurring land environment This is partly due to the color of the pines and partly due to multiple scattering of sunlight within the trees which lowers the overall reflected light level Due to light penetration the ocean''s albedo is even lower at about though this depends strongly on the angle of the incident radiation Dense swampland averages between and Deciduous trees average about A grassy field usually comes in at about A barren field will depend on the color of the soil and can be as low as or as high as with being about the average for farmland A desert or large beach usually averages around but varies depending on the color of the sand Reference Edward Walker''s study in the Great Plains in the winter around N.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Abu Dhabi','Abu Dhabi Abu Dhabi Satellite image of Abu Dhabi March.
A View of Hilton Baynunah the tallest hotel in Abu Dhabi and the Second tallest building in Abu Dhabi. Shaikh Zaid 
Abu Dhabi Arabic Ab aby is the largest of the seven emirates that comprise the United Arab Emirates and was also the largest of the former Trucial States Abu Dhabi is also a city of the same name within the Emirate that is the capital of the country in north central UAE The city lies on a T shaped island jutting into the Persian Gulf from the central western coast An estimated lived there in with about an expatriate population Abu Dhabi city is located at N E
 Al Ain is Abu Dhabi''s second largest urban area with a population of more than and located kilometres inland.
 History.
Parts of Abu Dhabi were settled as far back as the millennium B C and its early history fits the nomadic herding and fishing pattern typical of the broader region Modern Abu Dhabi traces its origins to the rise of an important tribal confederation the Bani Yas in the late century who also assumed control of Dubai In the century the Dubai and Abu Dhabi branches parted ways.
Into the mid century the economy of Abu Dhabi continued to be sustained mainly by camel herding production of dates and vegetables at the inland oases of Al Ain and Liwa and fishing and pearl diving off the coast of Abu Dhabi city which was occupied mainly during the summer months Most dwellings in Abu Dhabi city were at this time constructed of palm fronds barasti with the better off families occupying mud huts The growth of the cultured pearl industry in the first half of the century created hardship for residents of Abu Dhabi as pearls represented the largest export and main source of cash earnings.
In Sheikh Shakhbut bin Dhiyab granted Petroleum concessions and oil was first found in At first oil money had a marginal impact A few lowrise concete buildings were erected and the first paved road was completed in but Sheikh Shakbut uncertain whether the new oil royalties would last took a cautious approach prefering to save the revenue rather than investing it in development His brother Zayed bin Sultan Al Nahayan saw that oil wealth had the potential to transform Abu Dhabi The ruling Al Nahayan family decided that Sheikh Zayed should replace his brother as Ruler and carry out his vision of developing the country On August with the assistance of the British Sheikh Zayed became the new ruler See generally Al Fahim M From Rags to Riches A Story of Abu Dhabi Chapter Six London Centre of Arab Studies ISBN.
With the announcement by Britain in that it would withdraw from the Gulf area by Sheikh Zayed became the main driving force behind the formation of the United Arab Emirates.
After the Emirates gained independence in oil wealth continued to flow to the area and traditional mud brick huts were rapidly replaced with banks boutiques and modern highrises.
 Current Ruler.His Highness Sheikh Khalifa bin Zayed Al Nahayan is the hereditary emir and ruler of Abu Dhabi as well as the current president of the United Arab Emirates UAE.
 Postal History.
Now part of the United Arab Emirates Abu Dhabi was formerly the largest of the seven sheikdoms which made up the Trucial States on the so called Pirate Coast of eastern Arabia between Oman and Qatar The Trucial States as a whole had an area of some square miles of which Abu Dhabi alone had The capital was the town of Abu Dhabi which is on an offshore island and was first settled in.
The name Trucial States arose from treaties made with Great Britain in which ensured a condition of truce in the area and the suppression of piracy and slavery The treaty expired on December The decision to form the UAE was made on July and the federation was founded on August although the inaugural UAE stamps were not issued until January.
Oil production began on Das Island after prospecting during Das Island is part of Abu Dhabi but lies well offshore about miles north of the mainland.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Alabama','Alabama Alabama. This article is about the U S State for other meanings see disambiguation.
Jeff Sessions R.
Alabama is a state located in the southern United States.
 History.Main article History of Alabama
The memory of the Native American presence is particularly strong in Alabama Among Native American people once living in present Alabama were Alabama Alibamu Cherokee Chickasaw Choctaw Creek Koasati and Mobile Trade with the Northeast via the Ohio River began during the Burial Mound Period B C A D and continued until European contact Meso American influence is evident in the agrarian Mississippian culture that followed.
The French established the first European settlement in the state with the establishment of Mobile in Southern Alabama was French from part of British West Florida from and part of Spanish West Florida from Northern and central Alabama was part of British Georgia from and part of the American Mississippi territory thereafter Its statehood delayed by the lack of a coastline rectified when Andrew Jackson captured Spanish Mobile in Alabama became the state in.
The state of Alabama seceded from the Union on January and became the Alabama Republic and on February became a Confederate state While not many battles were fought in the state it contributed about soldiers to the Civil War After the war a provisional government was set up in and Alabama was officially readmitted to the Union on July.
The cradle of the Confederacy during the Civil War Alabama was at stage center in the civil rights movement of the and.
 Law and government.Main article Law and Government of Alabama
 Local amp County Government.Alabama has counties each having its own elected legislative branch usually called the Board of Commissioners which usually also has executive authority in the county Due to the restraints placed in the Alabama Constitution all but counties Jefferson Lee Mobile Madison Montgomery Shelby and Tuscaloosa in the state have little to no home rule Instead most counties in the state have to lobby to the Local Legislation Committee the state legislature to get simple local policies such as waste disposal to land use zoning.
 Political Climate.
The current governor of the state is Bob Riley and the two U S senators are Jefferson B Sessions III and Richard C Shelby all three from the Republican Party The current Alabama Constitution was adopted in.
During Reconstruction following the American Civil War Alabama was occupied by federal troops of the Third Military District under General John Pope In the Reconstruction period ended with the recognition of Rutherford B Hayes as President elect White Southerners assumed control of the government and passed laws to segregate and disenfranchise black residents The state became part of the Solid South a one party system in which the Democratic Party became essentially the only political party in every Southern state For nearly years local and state elections in Alabama were decided in the Democratic Party primary with generally no Republican challenger running.
From through Alabama supported only Democratic presidential candidates by margins as high as percentage points In Alabama gave most of its electoral votes to segregationist candidate Harry F Byrd In the national Republican Party began to win more votes in the South by following a Southern Strategy which emphasized states'' rights and the increasing liberalism of the national Democratic Party The first such candidate was conservative Barry Goldwater who became the first Republican candidate supported by Alabama In Alabama supported native son and American Independent Party Segregationist candidate George Wallace.
The last Democratic candidate to win Alabama''s votes in a presidential election was Southerner Jimmy Carter in Today the Republican party has become increasingly dominant in conservative Alabama politics However in local politics.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Achilles','Achilles Achilles.
 For other uses see Achilles disambiguation.
In Greek mythology  transliterated to Akhilleus or Achilleus in Roman letters Latinized from this ancient Greek to Achilles appearing in Etruscan as Achle was a hero ancient Greek heros defender of the Trojan War the greatest and the most central character of Homer''s Iliad.
The Name
The very first two lines of that magnificent and defining poem of ancient Greek culture indeed probably of the preceding Indo European culture read in transliteration.
 Menin aeide thea Peleiadeo Akhileos
 oulomenen he muri'' Akhaiois alge'' etheken.
 Sing Muse the wrath of Achilles the son of Peleus. the destructive wrath that brought a thousand griefs upon the Achaeans.
In these lines we see the name Akhilleus Peleides which is a praenomen and a patronymic the latter being formed from Peleus with the suffix ides Achilles the son of Peleus The system is similar to the names used by Scandinavians before modern times such as Leif Erikson It is no doubt much older than either culture.
Similarly Peleus'' name would be Peleus Aiakides Peleus the son of Aiakos There is no nomen gentile as among the Romans indicating that clan names might not be Indo European after all.
There is a very strong derivation of Achilles devised by Leonard Palmer and expostulated in the first work cited below by Gregory Nagy The name is Indo European whose laos has akhos where laos is a corps of soldiers and akhos is grief.
As it is used in the poem which is stuffed full of irony there is a double entendre when the hero is functioning rightly his men bring grief to the enemy but when wrongly his men get the grief The poem is in part about the misdirection of anger on the part of leadership.
Birth
Achilles was the son of the mortal Peleus king of the Myrmidons in Phthia southeast Thessaly and the sea nymph Thetis Zeus and Poseidon were rivals for the hand of Thetis That is until Prometheus the fire bringer revealed that if one of these gods wed Thetis she would bear a son greater than his father For this reason the two gods withdrew their pursuit When Achilles was born Thetis had tried to make Achilles immortal by dipping him in the river Styx but forgot to wet the heel she held him by leaving him vulnerable See Achilles'' tendon.
Homer however deliberately makes no mention of this Achilles cannot be a hero if he is not at risk Homer however does mention his being wounded although not seriously in the Iliad In an earlier and less popular version of the story Thetis anointed the boy in ambrosia and put him on top of a fire to burn away the mortal parts of his body She was interrupted by Peleus and abandoned both father and son in a rage Peleus gave him together with his young friend Patroclus to Chiron the Centaur on Mt Pelion to raise.
Achilles in the Trojan War
Telephus
When the Greeks left for the Trojan War they accidentally stopped in Mysia ruled by King Telephus In the battle Achilles wounded Telephus The wound would not heal and Telephus asked an oracle who stated that he that wounded shall heal.
According to others'' reports about Euripides'' lost play about Telephus he went to Aulis pretending to be a beggar and asked Achilles to help heal his wound Achilles refused claiming to have no medical knowledge Alternatively Telephus held Orestes for ransom the ransom being Achilles'' aid in healing the wound Odysseus reasoned that the spear had inflicted the wound and the spear must be able to heal it Pieces of the spear were scraped off onto the wound and Telephus healed This is an example of sympathetic magic.
During the Trojan War
 The Rage of Achilles by Giovanni Battista Tiepolo
Achilles is one of the only two people described as god like in the Iliad He shows a complete and total devotion to the excellence of his craft and like a god has almost no regard for life Not his own clearly he does not mind a swift death so long as it is glorious kleos and not really of others His anger is absolute.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Anarchism','Anarchism Anarchism.
 This article is about anarchism an anti authoritarian philosophy that rejects capitalism While this is the most widespread form of the anarchist tradition there are other political philosophies that make alternative use of the term For anarchism favoring capitalist economic relations see anarcho capitalism.
Anarchism is a generic term describing various political philosophies and social movements that advocate the elimination of all forms of social hierarchy In place of centralized political structures private ownership of the means of production and exploitative economic institutions such as rent and profit these movements favor social relations based upon voluntary interaction and self management and aspire to a society characterised by autonomy and freedom These philosophies use anarchy to mean a society based on voluntary interaction of free individuals and the idea that communities and individuals have a say in decisions to the degree that they are affected by their outcomes.
While opposition to coercive institutions and socially constructed hierarchies are primary tenets of anarchism anarchism is also a positive vision of how a voluntary society would work There is considerable variation amongst anarchist philosophies Opinions differ in various areas such as whether violence should be employed to foster anarchism what type of economic system should exist questions on the environment and industrialism and anarchists'' roles in other movements.
The terms anarchy and anarchism are derived from the Greek without archons rulers Thus anarchism in its most general meaning is the belief that rulership is unnecessary and should be abolished The word anarchy as most anarchists use it does not imply chaos or anomie but rather a stateless society with voluntary social relations.
 Precursors of anarchism.
Primitive cultures
Anarcho primitivists assert that for the longest period before recorded history human society was organized on anarchist principles They point to the egalitarian structure of hunter gatherer bands to the lack of division of labour and accumulated wealth and the lack of decreed law as indicators of such primitive anarchy.
Philosophical traces
Some anarchists have embraced Taoism which developed in Ancient China as a source of anarchistic attitudes Similarly anarchistic tendencies can be traced to the philosophers of Ancient Greece such as Zeno the founder of the Stoic philosophy and Aristippus who said that the wise should not give up their liberty to the state.Later movements such as Stregheria in the the Free Spirit in the Middle Ages.the Anabaptists The Diggers and the Ranters. have also expounded ideas that have been interpreted as anarchist.
Ancient Greece
The first known usage of the word anarchy appears in the play Seven Against Thebes by Aeschylus dated BC There Antigone openly refuses to abide by the rulers'' decree to leave her brother Polyneices'' body unburied as punishment for his participation in the attack on Thebes saying that even if no one else is willing to share in burying him I will bury him alone and risk the peril of burying my own brother Nor am I ashamed to act in defiant opposition to the rulers of the city ekhous apiston t nd anarkhian polei.
Ancient Greece also saw the first western instance of anarchism as a philosophical ideal in the form of the stoic philosopher Zeno of Citium who was according to Kropotkin t he best exponent of Anarchist philosophy in ancient Greece As summarized by Kropotkin Zeno repudiated the omnipotence of the state its intervention and regimentation and proclaimed the sovereignty of the moral law of the individual Within Greek philosophy Zeno''s vision of a free community without government is opposed to the state Utopia of Plato''s Republic Zeno argued that although the necessary instinct of self preservation leads humans to egotism nature has supplied a corrective to it by providing man with another instinct sociability.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Autism','Autism Autism.
Autism is classified as a neurodevelopmental disorder that manifests itself in markedly abnormal social interaction communication ability patterns of interests and patterns of behavior Although the specific etiology of autism is unknown autism most likely results from genetically mediated vulnerability to environmental triggers And while these environmental factors have not yet been ascertained with scientific certainty researchers have found at least seven major genes specifically linked to autism Prevalence in the United States is estimated at one child in but for families that already have one autistic child incidence is about one in twenty Diagnosis is based on a list of psychiatric criteria and a series of standardized clinical tests may also be used.
Physiologically autism may lack readily visible differences but it is linked to abnormal biological and neurochemical development of the brain A complete physical and neurological evaluation will typically be part of determining a diagnosis of autism Some now speculate that autism is in fact several distinct conditions that manifest themselves in similar ways rather than a single diagnosis.
By definition autism must manifest delays in social interaction language as used in social communication or symbolic or imaginative play with onset prior to age years DSM IV The ICD also says that symptoms must manifest before the age of three years There have been large increases in the reported incidence of autism for reasons that are heavily debated in the scientific community.
There are cases of children with autism who have improved their social and other skills to the point where they can fully participate in mainstream education and social events but there are lingering concerns that an absolute cure from autism is impossible with current technology since it involves aspects of neurological brain structure determined very early in development However many autistic children and adults who are able to communicate at least in writing are opposed to attempts to cure their conditions and see them as part of who they are.
History
Dr Hans Asperger described a form of autism in the that later became known as Asperger''s syndrome.
The word autism was first used in the English language by Swiss psychiatrist Eugene Bleuler in a number of the American Journal of Insanity The Oxford English Dictionary states that the word is derived from the Greek autos self When referring to a person with autism the term autistic is often used although the term person with autism may be used instead.
However the classification of autism did not occur until the middle of the twentieth century when in Dr Leo Kanner of the Johns Hopkins Hospital studied a group of children and introduced the label early infantile autism At the same time an Austrian scientist Dr Hans Asperger described a different form of autism that became known as Asperger''s syndrome but the widespread recognition of Asperger''s work was delayed by World War II in Germany in fact the majority of his work wasn''t officially recognised until.
Thus these two conditions were described and are today listed in the Diagnostic and Statistical Manual of Mental Disorders DSM IV TR fourth edition text revision as two of the five pervasive developmental disorders PDD more often referred to today as autism spectrum disorders ASD All of these conditions are characterized by varying degrees of difference in communication skills social interactions and restricted repetitive and stereotyped patterns of behavior.
Very few clinicians today solely use the DSM IV criteria for determining a diagnosis of autism which are based on the absence or delay of certain developmental milestones Many clinicians instead use an alternate means or a combination thereof to more accurately determine a diagnosis.
Characteristics
Dr Leo Kanner introduced the label early infantile autism in.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Abraham Lincoln','Abraham Lincoln Abraham Lincoln.
Abraham Lincoln February April sometimes called Abe Lincoln and nicknamed Honest Abe the Rail Splitter and the Great Emancipator was the President of the United States to and the first president from the Republican Party.
Lincoln staunchly opposed the expansion of slavery into federal territories and his victory in the presidential election further polarized the nation Before his inauguration in March of seven Southern slave states seceded from the United States formed the Confederate States of America and took control of U S forts and other properties within their boundaries These events soon led to the American Civil War.
Lincoln is often praised for his work as a wartime leader who proved adept at balancing competing considerations and at getting rival groups to work together toward a common goal Lincoln had to negotiate between Radical and Moderate Republican leaders who were often far apart on the issues while attempting to win support from War Democrats and loyalists in the seceding states He personally directed the war effort which ultimately led the Union forces to victory over the Confederacy.
His leadership qualities were evident in his diplomatic handling of the border slave states at the beginning of the fighting in his defeat of a congressional attempt to reorganize his cabinet in in his many speeches and writings which helped mobilize and inspire the North and in his defusing of the peace issue in the presidential campaign He is sometimes criticized for issuing executive orders suspending habeas corpus imprisoning opposing government officials and ordering the arrest of a number of publishers.
Some historians also argue that Lincoln had a lasting influence on U S political and social institutions The most important may have been setting the precedent for greater centralization of powers in the federal government and a weakening of the powers of the individual state governments.This claim however is disputed as the federal government largely reverted to its former weakness after Reconstruction and the modern administrative state would only emerge with the New Deal some seventy years later.
Lincoln is most famous for his role in ending slavery in the United States with the enactment of the Emancipation Proclamation as a pragmatic war measure which would set the stage for the complete abolition of the institution.
Lincoln was also the president who declared Thanksgiving as a national holiday established the U S Department of Agriculture though not as a Cabinet level department revived national banking and banks and admitted West Virginia and Nevada as states He also encouraged efforts to expand white settlement in western North America signing the Homestead Act.
Lincoln is usually ranked as one of the greatest presidents He is criticized by some for overstepping the traditional bounds of executive power Others fault him for his refusal to make efforts at compromise with the seceding states.Because of his role in ending slavery and his guiding the Union to victory in the civil war his assassination made him a martyr to millions of Americans.
Early life
Abraham Lincoln was born on February in a one room log cabin on acre km Sinking Spring Farm in the Southeast part of Hardin County Kentucky then considered the frontier now part of LaRue Co in Nolin Creek three miles km south of Hodgenville to Thomas Lincoln and Nancy Hanks Lincoln was named after his deceased grandfather Abraham Lincoln who was killed in in a conflict with local Indians He was given just his grandfather''s first and last name and was not given any middle name Lincoln''s parents were largely uneducated Later when Lincoln became more renowned reporters and storytellers often exaggerated the poverty and obscurity of Lincoln''s birth In fact Lincoln''s father Thomas was a respected and relatively affluent citizen of the Kentucky backcountry.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Aristotle','Aristotle Aristotle Aristotle marble copy of bronze by Lysippos Louvre Museum.
Aristotle Greek.Aristotel s BC March BC was an ancient Greek philosopher Student of Plato and teacher of Alexander the Great Aristotle and Plato are often considered as the two most influential philosophers in Western thought He wrote many books about physics poetry zoology logic government and biology.
The three most influential ancient Greek philosophers were Aristotle Plato a teacher of Aristotle and Socrates ca BC BC whose thinking deeply influenced Plato Among them they transformed Presocratic Greek philosophy into the foundations of Western philosophy as we know it Socrates did not leave any writings possibly as a result of the reasons articulated against writing philosophy attributed to him in Plato''s dialogue Phaedrus His ideas are known to us only indirectly through Plato and a few other writers The writings of Plato and Aristotle form the core of Ancient philosophy.Aristotle by contrast placed much more value on knowledge gained from the senses and would correspondingly be better classed among modern empiricists see materialism and empiricism He also achieved a grounding of dialectic in the Topics by allowing interlocutors to begin from commonly held beliefs Endoxa his goal being non contradiction rather than Truth He set the stage for what would eventually develop into the scientific method centuries later Although he wrote dialogues early in his career no more than fragments of these have survived The works of Aristotle that still exist today are in treatise form and were for the most part unpublished texts These were probably lecture notes or texts used by his students and were almost certainly revised repeatedly over the course of years As a result these works tend to be eclectic dense and difficult to read Among the most important ones are Physics Metaphysics Nicomachean Ethics Politics De Anima On the Soul and Poetics.Their works although connected in many fundamental ways are very different in both style and substance Plato mainly wrote philosophical dialogues that is arguments in the form of conversations usually with Socrates as a participant Though the early dialogues are concerned mainly with methods of acquiring knowledge and most of the last ones with justice and practical ethics his most famous works expressed a synoptic view of ethics metaphysics reason knowledge and human life The fundamental idea of Plato is that knowledge gained through the senses is always confused and impure true knowledge being acquired by the contemplative soul that turns away from the world To attain such true knowledge the philosopher must make use of the royal science of dialectic One of the necessary obstacles of dialectic is dialogue itself which guides the interlocutors away from the paths to truth The soul alone can have knowledge of the Forms the real essences of things of which the world we see is but an imperfect copy Such knowledge has ethical as well as scientific importance Plato can be called with qualification an idealist and a rationalist.
Aristotle is known for being one of the few figures in history who studied almost every subject possible at the time In science Aristotle studied anatomy astronomy embryology geography geology meteorology physics and zoology In philosophy Aristotle wrote on aesthetics economics ethics government metaphysics politics psychology rhetoric and theology He also dealt with education foreign customs literature and poetry His combined works practically comprise an encyclopedia of Greek knowledge.
 Biography.Early life and studies at the Academy
A bust of Aristotle is a nearly ubiquitous ornament in places of high culture in the West.
Aristotle was born at Stageira a colony of Andros on the Macedonian peninsula of Chalcidice in BC His father Nicomachus was court physician to King Amyntas III of Macedon It is believed that Aristotle''s ancestors held this position under various kings of Macedonia.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('An American in Paris','An American in Paris An American in Paris An American In Paris is also a film musical starring Gene Kelly.
An American in Paris is a symphonic composition by American composer George Gershwin which debuted in Inspired by Gershwin''s time in Paris it is in the form of an extended tone poem evoking the sights and energy of the French capital in the In addition to the standard instruments of the symphony orchestra the score features period automobile horns Gershwin brought back some Parisian taxi cab horns for the New York premiere of the composition.
 An American In Paris is second only to Rhapsody In Blue as a favorite of Gershwin''s classical compositions.
 The score also features instruments rarely seen in the concert hall celesta and saxophones.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Academy Award','Academy Award Academy Award Oscar Award
Although he never won an Oscar for any of his movie performances the comedian Bob Hope received five honorary Oscars for contributions to cinema and humanitarian work.
The Academy Awards commonly known as The Oscars are the most prominent film awards in the United States The Awards are granted by the Academy of Motion Picture Arts and Sciences a professional honorary organization which as of had a voting membership of Actors with a membership of make up the largest voting bloc The most recent awards were the Academy Awards.
History
The Academy Awards were the brainchild of MGM executive Louis B Mayer in The industry was in need of a touch of a class and a public relations coup The awards served this purpose The awards were first given at a banquet in the Blossom Room of the Hollywood Roosevelt Hotel on May The evening included a banquet dancing and the presentation of awards The winners had been announced three months prior eliminating all suspense The whole presentation took five minutes as there were no speeches.
To qualify a film had to open in Los Angeles during the twelve months ending on July of the preceding year The and later awards have all been based on openings in the previous calendar year The awards were based on a month qualifying period The opened in Los Angeles clause allowed Charlie Chaplin to win his only voted Oscar for Limelight which was made in but did not open until The rules have changed since then so films more than two years old are not eligible.
Name
The official name of the Oscar statuette is the Academy Award of Merit Made of gold plated britannium it is inches cm tall and depicts a knight holding a crusader''s sword standing on a reel of film The Academy Award statuette was allegedly nicknamed Oscar when Academy librarian Margaret Herrick saw it on a table and said it looks just like my uncle Oscar The nickname stuck and is used almost as commonly as Academy Award even by the Academy itself In fact the Academy''s domain name is oscars org and the official website for the Academy Awards is at oscars com.
Awards night
The awards night itself is an elaborate extravaganza with the invited guests walking up the red carpet in the creations of the most prominent fashion designers of the day The ceremony and extravagant afterparties including the Academy''s Governors Ball are televised around the world.
Nominations
The members of each branch determine the nominees in their respective category after which the entire membership votes for the winner in all categories The ballot itself contains just the title of a work not the persons involved for all categories except acting.
Less subjectively it is clear that movie studios spend large amounts of money on campaigning for their films Around nomination and voting time film trade publications are filled with ads headed For Your Consideration Miramax has been the most widely discussed and arguably successful studio to use this technique An award can give a film a huge boost at the box office and make an artist an industry power player overnight In the past few decades the advent of VHS and DVD have given Academy Awards a new level of importance as the attachment of a win or even nomination in a prominent category can dramatically increase sales and rentals The Academy has made a public effort to crack down on these campaigns but the results have been mixed Such influence is nothing new for example it is widely believed William Randolph Hearst ran a campaign to ensure that Citizen Kane a film regarded by many as the greatest of all time did not receive any Academy Award nominations The film ended up receiving only one trophy despite nominations in nine categories.
Rules
Academy Award rules are reviewed annually Recent rule changes include the following.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('International Atomic Time','International Atomic Time International Atomic Time Temps Atomique International TAI or International Atomic Time is a very accurate and stable time scale It is a weighted average of the time kept by about atomic clocks including a large number of caesium atomic clocks in over national laboratories worldwide It has been available since and became the international standard on which UTC is based on January as decided by the General Conference on Weights and Measures CGPM The International Bureau of Weights and Measures is in charge of the realization of TAI.
The highest precision realization of TAI times can only be determined retrospectively as the timescale is defined by periodic comparisons among its participating atomic clocks However these corrections are usually only needed for applications that require nanosecond scale accuracy Most time service users use realtime estimates of TAI provided by atomic clocks that have been previously referenced to the composite timescale GPS is a commonly used realtime source of time traceable back to TAI.
Coordinated Universal Time UTC is the basis for legal time worldwide and always differs from TAI by an integral number of seconds In mid UTC was behind TAI by seconds The difference is due to leap seconds which are periodically inserted into UTC due to slight irregularities in the Earth''s rate of rotation While TAI is a continuous and stable timescale UTC has intentional discontinuities to keep it from drifting more than seconds from a timescale defined by the Earth''s rotation Roughly speaking solar noon the time at which the sun is directly overhead would drift away from without leap second corrections is computed by the International Earth Rotation and Reference Systems Service IERS TAI was defined such that TAI on January.
Because UTC is a discontinuous timescale it is not possible to compute the exact time interval elapsed between two UTC timestamps without consulting a table that describes how many leap seconds occurred during that interval Therefore many scientific applications that require precise measurement of long multi year intervals use TAI instead TAI is also commonly used by systems that can not handle leap seconds.
See also
 Terrestrial Time
 Coordinated Universal Time
 Universal Time
 Sidereal Time
 Time and frequency transfer
 Clock synchronization
 Network Time Protocol
External links
 Bureau International des Poids et Mesures
 website
 NIST Time and Frequency FAQs');
 
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Altruism','Altruism Altruism Altruism is either a practice or habit in the view of many a virtue as well as an ethical doctrine In Buddhism it can also be seen as a fundamental property of human nature.
Altruism can refer to.
 being helpful to other people with little or no interest in being rewarded for one''s efforts the colloquial definition This is distinct from merely helping others.
 actions that benefit others with a net detrimental or neutral effect on the actor regardless of the actor''s own psychology motivation or the cause of her actions This type of altruistic behavior is referred to in ecology as Commensalism.
 an ethical doctrine that holds that individuals have a moral obligation to help others if necessary to the exclusion of one''s own interest or benefit One who holds such a doctrine is known as an altruist.
The concepts have a long history in philosophical and ethical thought and have more recently become a topic for psychologists sociologists evolutionary biologists and ethologists While ideas about altruism from one field can have an impact on the other fields the different methods and focuses of these fields lead to different perspectives on altruism.
Altruism in philosophy and ethics
The word altruism French altruisme from autrui other people derived from Latin alter other was coined by Auguste Comte the French founder of positivism in order to describe the ethical doctrine he supported He believed that individuals had a moral obligation to serve the interest of others or the greater good of humanity Comte says in his Catechisme Positiviste that the social point of view cannot tolerate the notion of rights for such notion rests on individualism We are born under a load of obligations of every kind to our predecessors to our successors to our contemporaries After our birth these obligations increase or accumulate for it is some time before we can return any service This to live for others the definitive formula of human morality gives a direct sanction exclusively to our instincts of benevolence the common source of happiness and duty Man must serve Humanity whose we are entirely As the name of the ethical doctrine is altruism doing what the ethical doctrine prescribes has also come to be referred to by the term altruism serving others through placing their interests above one''s own.
Comte asserts that individual rights are not compatible with the supposed obligation to serve others Some argue that the ethical doctrine if taken to its logical conclusion leads to tyranny Adolf Hitler is sometimes presented as an example of this and has been described as advocating altruism He says in Mein Kampf. The self sacrificing will to give one''s personal labor and if necessary one''s own life for others is most strongly developed in the Aryan The Aryan is not greatest in his mental qualities as such but in the extent of his willingness to put all his abilities into the service of the community In him the instinct of self preservation has reached the noblest form since he willingly subordinates his own ego to the life of the community and if the hour demands even sacrifices it.
However the idea that one has a moral obligation to serve others is much older than Auguste Comte For example many of the world''s oldest and most widespread religions particularly Buddhism and Christianity advocate it In the New Testament of the Christian Bible it is explained as follows. Jesus made answer and said A certain man was going down from Jerusalem to Jericho and he fell among robbers who both stripped him and beat him and departed leaving him half dead And by chance a certain priest was going down that way and when he saw him he passed by on the other side And in like manner a Levite also when he came to the place and saw him passed by on the other side.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Ang Lee','Ang Lee Ang Lee Ang Lee Chinese pinyin L n born October is an ethnic Chinese Hollywood director born and raised in Taiwan but educated in the United States Many of his films have focused on the interactions between modernity and tradition.
His films have also tended to have a light hearted comedic tone which marks a break from the tragic historical realism which characterized Taiwanese filmmaking after the end of the martial law period in He created the gay genre in Asian films and also created the A list Hollywood wuxia film.
He is highly educated having completed his bachelor''s degree in Theater from the University of Illinois and received his MFA from New York University''s Tisch School of the Arts where in he made a thesis film called Fine Line He was also classmates with Spike Lee He was a Visiting Fellow at Dartmouth College in where he premiered Crouching Tiger Hidden Dragon His most recent films Hulk and Brokeback Mountain have been lauded for their artistic originality Ang Lee''s latest film Brokeback Mountain won the best film award in Venice International Film Festival.
Selected films
 Hulk. Brokeback Mountain. Hulk. Crouching Tiger Hidden Dragon. Ride with the Devil. The Ice Storm. Sense and Sensibility. Eat Drink Man Woman. Wedding Banquet. Pushing Hands.
Bibliography
 Ang Lee Bibliography via UC Berkeley.
External links
 Ang Lee at the Internet Movie Database
 The stub template below has been proposed for deletion or renaming See stub types for deletion to help reach a consensus on what to do. This article about a film director is a stub You can help Wikipedia by expanding it.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Ayn Rand','Ayn Rand Ayn Rand Novelist and philosopher best known for her philosophy of Objectivism
Ayn Rand February March first name pronounced IPA a n rhymes with ''mine'' born Alissa Zinovievna Rosenbaum was best known for her philosophy of Objectivism and her novels The Fountainhead and Atlas Shrugged Her philosophy and her fiction both emphasize above all her concepts of individualism rational egoism rational self interest and capitalism Believing government has a legitimate but relatively minimal role in a free society she was not an anarchist but a minarchist though she did not use the term minarchist Her novels were based upon the archetype of the Randian hero a man whose ability and independence causes conflict with the masses but who perseveres nevertheless to achieve his values Rand viewed this hero as the ideal and made it the express goal of her literature to showcase such heroes She believed. That man must choose his values and actions by reason. That the individual has a right to exist for his own sake neither sacrificing self to others nor others to self and. That no one has the right to seek values from others by physical force or impose ideas on others by physical force.
 Biography.
 Early life.
Rand was born in Saint Petersburg Russia and was the eldest of three daughters of a Jewish family Her parents were agnostic and largely non observant From an early age she displayed a strong interest in literature and films She started writing screenplays and novels from the age of seven Her mother undertook to teach her French and subscribed to a magazine featuring stories for boys where Rand found her first childhood hero Cyrus Paltons an Indian army officer in a Rudyard Kipling style story called The Mysterious Valley Throughout her youth she read the novels of Sir Walter Scott Alexandre Dumas and other Romantic writers and expressed a passionate enthusiasm toward the Romantic movement as a whole She discovered Victor Hugo at the age of thirteen and fell deeply in love with his novels Later she would cite him as her favourite novelist and the greatest novelist of world literature She studied philosophy and history at the University of Petrograd Her major literary discoveries in university were the works of Edmond Rostand Friedrich Schiller and Fyodor Dostoevsky She admired Rostand for his richly romantic imagination and Schiller for his grand heroic scale She admired Dostoevsky for his sense of drama and his intense moral judgments but was deeply against his philosophy and his sense of life She continued to write short stories and screenplays and wrote sporadically in her diary which contained intensely anti Soviet ideas She also encountered the philosophical ideas of Nietzsche and loved his exaltation of the heroic and independent individual in Thus Spoke Zarathustra nevertheless she was strongly critical of his philosophy going so far as to attack it in the introductions of her novels Her greatest influence by far is Aristotle especially his work Organon Logic She considered him the greatest philosopher ever She then entered the State Institute for Cinema Arts in to study screenwriting in late however she was granted a visa to visit American relatives She arrived in the United States in February at the age of twenty one After a brief stay with her relatives in Chicago she resolved never to return to the Soviet Union and set out for Los Angeles to become a screenwriter She then changed her name to Ayn Rand There is a story told that she named herself after the Remington Rand typewriter but recent evidence has proved that this is not the case She stated that her first name ''Ayn'' was an adaptation of the name of a Finnish writer This may have been the Finnish Estonian author Aino Kallas.
 Major works.
Initially Rand struggled in Hollywood and took odd jobs to pay her basic living expenses.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Alain Connes','Alain Connes Alain Connes Alain Connes born April is a French mathematician currently Professor at the College de France Paris France IHES Bures sur Yvette France and Vanderbilt University Nashville Tennessee He is a specialist of Von Neumann algebras and succeeded in completing the classification of factors of these objects.
The remarkable links between this subject the tools he and others devised to tackle the problem and other subjects in theoretical physics particle physics and differential geometry made him emphasize Noncommutative geometry which is also the title of his major book to date.
He was awarded the Fields Medal in the Crafoord Prize in and the gold medal of the CNRS in.
See cyclic homology factor functional analysis Higgs boson C algebra M Theory Groupoid Jean Louis Loday.
External links
 Alain Connes Official Web Site
 Alain Connes Biography');
 
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Economy of Algeria','Economy of Algeria Economy of Algeria.
In the economy of Algeria the hydrocarbons sector is the backbone accounting for roughly of budget revenues of GDP and over of export earnings Algeria has the fifth largest reserves of natural gas in the world and is the second largest gas exporter it ranks fourteenth for oil reserves Algiers'' efforts to reform one of the most centrally planned economies in the Arab world stalled in as the country became embroiled in political turmoil.
Burdened with a heavy foreign debt Algiers concluded a one year standby arrangement with the International Monetary Fund in April and the following year signed onto a three year extended fund facility which ended April Some progress on economic reform Paris Club debt reschedulings in and and oil and gas sector expansion contributed to a recovery in growth since reducing inflation to approximately and narrowing the budget deficit Algeria''s economy has grown at about annually since The country''s foreign debt has fallen from a high of billion in to its current level of billion The spike in oil prices in and the government''s tight fiscal policy as well as a large increase in the trade surplus and the near tripling of foreign exchange reserves has helped the country''s finances However an ongoing drought the after effects of the November floods and an uncertain oil market make prospects for more problematic The government pledges to continue its efforts to diversify the economy by attracting foreign and domestic investment outside the energy sector However it has thus far had little success in reducing high unemployment officially estimated at and improving living standards.
President Bouteflika has announced sweeping economic reforms which if implemented will significantly restructure the economy Still the economy remains heavily dependent on volatile oil and gas revenues The government has continued efforts to diversify the economy by attracting foreign and domestic investment outside the energy sector but has had little success in reducing high unemployment and improving living standards Other priority areas include banking reform improving the investment environment and reducing government bureaucracy.
The government has announced plans to sell off state enterprises sales of a national cement factory and steel plant have been completed and other industries are up for offer In Algeria signed an Association Agreement with the European Union it has started accession negotiations for entry into the World Trade Organization.
Agriculture
Since Roman times Algeria has been noted for the fertility of its soil About a quarter of the inhabitants are engaged in agricultural pursuits More than acres km are devoted to the cultivation of cereal grains The Tell is the grain growing land During the time of French rule its productivity was increased substantially by the sinking of artesian wells in districts which only required water to make them fertile Of the crops raised wheat barley and oats are the principal cereals A great variety of vegetables and of fruits especially citrus products is exported.
A considerable amount of cotton was grown at the time of the United States'' Civil War but the industry declined afterwards In the early years of the century efforts to extend the cultivation of the plant were renewed A small amount of cotton is also grown in the southern oases Large quantities of crin vegetal vegetable horse hair an excellent fibre are made from the leaves of the dwarf palm The olive both for its fruit and Petroleum and tobacco are cultivated with great success.
Algeria also exports figs dates esparto grass and cork.
Wine Production
Throughout Algeria the soil of favours the growth of vines The country in the words of an expert sent to report on the subject by the French government. can produce an infinite variety of wines suitable to every constitution and to every caprice of taste.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Algeria','Algeria Algeria.
 Arabic We Swear By The Lightning That Destroys.
 N E.
Prime Minister.
Abdelaziz Bouteflika
Ahmed Ouyahia.
July.
 Total
 Water.
 km.
 est.
 census
 Density
 km.
 Total
 Per capita
 Summer DST.
 UTC.The People''s Democratic Republic of Algeria Arabic     or Algeria Arabic  is a presidential state in north Africa and the second largest country on the African continent Sudan being the largest It is bordered by Tunisia in the northeast Libya in the east Niger in the southeast Mali and Mauritania in the southwest and Morocco as well as a few kilometers of its annexed territory Western Sahara in the west Constitutionally it is defined as an Islamic Arab and Amazigh Berber country The name Algeria is derived from the name of the city of Algiers from the Arabic word al jaz ir which translates as the islands referring to the four islands which lay off that city''s coast until becoming part of the mainland in.
 History.Main article History of Algeria
Algeria has been inhabited by Berbers or Amazigh since at least BC From BC on the Carthaginians became an influence on them establishing settlements along the coast Berber kingdoms began to emerge most notably Numidia and seized the opportunity offered by the Punic Wars to become independent of Carthage only to be taken over soon after by the Roman Republic in BC As the western Roman Empire collapsed the Berbers became independent again in much of the area while the Vandals took over parts until later expelled by the generals of the Byzantine Emperor Justinian I The Byzantine Empire then retained a precarious grip on the east of the country until the coming of the Arabs in the century.
Roman arch of Trajan at Thamugadi Timgad Algeria
After some decades of fierce resistance under leaders such as Kusayla and Kahina the Berbers adopted Islam en masse but almost immediately expelled the Caliphate from Algeria establishing an Ibadi state under the Rustamids Having converted the Kutama of Kabylie to its cause the Shia Fatimids overthrew the Rustamids and conquered Egypt They left Algeria and Tunisia to their Zirid vassals when the latter rebelled and adopted Sunnism they sent in a populous Arab tribe the Banu Hilal to weaken them thus incidentally initiating the Arabization of the countryside The Almoravids and Almohads Berber dynasties from the west founded by religious reformers brought a period of relative peace and development however with the Almohads'' collapse Algeria became a battleground for their three successor states the Algerian Zayyanids Tunisian Hafsids and Moroccan Merinids In the fifteenth and sixteenth centuries Spain started attacking and taking over many coastal cities prompting some to seek help from the Ottoman Empire.
Algeria was brought into the Ottoman Empire by Khair ad Din and his brother Aruj who established Algeria''s modern boundaries in the north and made its coast a base for the corsairs their privateering peaked in Algiers in the Piracy on American vessels in the Mediterranean resulted in the First and Second Barbary War with the United States On the pretext of a slight to their consul the French invaded Algiers in however intense resistance from such personalities as Emir Abdelkader made for a slow conquest of Algeria not technically completed until the early when the last Tuareg were conquered.Constantine Algeria 
Meanwhile however the French had made Algeria an integral part of France a status that would end only with the collapse of the Fourth Republic Tens of thousands of settlers from France Italy Spain and Malta moved in to farm the Algerian coastal plain and occupy the most prized parts of Algeria''s cities benefiting from the French government''s confiscation of communally held land People of European descent in Algeria the so called pieds noirs as well as the native Algerian Jews were full French citizens starting from the end of the century by contrast the vast majority of Muslim Algerians remained outside of French law a');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Characters in Atlas Shrugged','Characters in Atlas Shrugged Characters in Atlas Shrugged Characters in Ayn Rand''s novel Atlas Shrugged.
Spoiler warning Plot and or ending details follow.
Balph Eubank
Called the literary leader of the age despite the fact that he is incapable of writing anything that people actually want to read What people want to read he says is irrelevant He complains that it is disgraceful that artists are treated as peddlers and that there should be a law limiting the sales of books to ten thousand copies He is a member of the Looters Balph Eubank appears in section.Ben Nealy
A railroad contractor whom Dagny Taggart hires to replace the track on the Rio Norte Line with Rearden Metal Nealy is incompetent but Dagny can find no one better in all the country Nealy believes that anything can get done with enough muscle power He sees no role for intelligence in human achievement and this is manifest in his inability to organize the project and to make decisions He relies on Dagny and Ellis Wyatt to run things and resents them for doing it because it appears to him like they are just bossing people around Ben Nealy appears in section.
Bertram Scudder
Editorial writer for the magazine The Future He typically bashes business and businessmen but he never says anything specific in his articles relying on innuendo sneers and denunciation He wrote a hatchet job on Hank Rearden called The Octopus He is also vocal in support of the Equalization of Opportunity Bill Bertram Scudder appears in section.
Betty Pope
A wealthy socialite who is having a meaningless sexual affair with James Taggart that coincides with the overall meaninglessness of her life She regrets having to wake up every morning because she has to face another empty day She is deliberately crude in a way that casts ridicule on her high social position Betty Pope appears in sections and.Brakeman
An unnamed employee working on the Taggart Comet train Dagny Taggart hears Brakeman whistling the theme of a concerto When she asks him what piece it is from he says it is Halley''s Fifth Concerto When Dagny points out that Richard Halley only wrote four concertos Brakeman claims he made a mistake and he doesn''t recall where he heard the piece.
Later after Dagny instructs the train crew how to proceed he asks a co worker who she is and learns she is the one who runs Taggart Transcontinental.
It is later discovered that the unknown brakeman is one of the strikers when Dagny meets him in the valley Brakeman appears in sections and.
Cherryl Brooks
Dime store shopgirl who marries James Taggart after a chance encounter in her store the night the John Galt Line was deemed his greatest success She marries him thinking he is the heroic person behind Taggart Transcontinental She is horrible to Dagny until the night before she commits suicide when she confesses to Dagny that she married Jim thinking she was marrying Dagny Like Eddie Willers Cherryl is one representation of a good person who lacks the extraordinary capacities of the primary heroes of the novel.
Claude Slagenhop
The president of political organization Friends of Global Progress which is supported by Philip Rearden and one of Lillian Rearden''s friends He believes that ideas are just air that this is no time for talk but for action He is not bothered by the fact that action unguided by ideas is random and pointless Global Progress is a sponsor of the Equalization of Opportunity Bill Claude Slagenhop appears in section.Cuffy Meigs
A Looter who''s assigned by Wesley Mouch to keep watch over the workings of Taggart Transcontinental and later assumes control over the company after Dagny Taggart leaves He carries a pistol and wears a military uniform The intellectual heir of Dr Robert Stadler Meigs comes to a fitting end at the hands of Project X.Dagny Taggart
The main character in Atlas Shrugged also the name of her namesake Mrs Nathaniel Taggart Dagny is Vice President in Charge of Operation at Taggart Transcontinental.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Companies in Atlas Shrugged','Companies in Atlas Shrugged Companies in Atlas Shrugged Companies in Atlas Shrugged the Ayn Rand novel generally are divided into two groups thse that are operated by sympathetic characters are given the name of the owner while companies operated by evil or incompetent characters are given generic names In Atlas Shrugged men who give their names to their companies all become Strikers in due time.
Amalgamated Switch and Signal
A company run by Mr Mowen and located in Connecticut They have supplied Taggart Transcontinental for generations Dagny Taggart orders Rearden Metal switches from them.
Amalgamated Switch and Signal appears in section.
Associated Steel
Associated Steel is the company owned by Orren Boyle The company was started with just a few hundred thousand dollars of Boyle''s own money and hundreds of millions of dollars in government grants Boyle used this money to buy out his competitors and now relies on influence peddling and political favors to run his business.
Associated Steel is mentioned in sections and.
Ayers Music Publishing Company
Ayers Music Publishing Company is the publisher of the music of Richard Halley Dagny Taggart contacts Mr Ayers to inquire as to the existence of Halley''s Fifth Concerto.
Ayers Music Publishing Company is mentioned in section.
Barton and Jones
The company located in Denver that supplies food for the workers rebuilding the Rio Norte Line They go bankrupt in the middle of the project.
Barton and James is mentioned in section.
d''Anconia Copper
A copper and mining company founded by Sebastian d''Anconia in Argentina during the time of the Inquisition Each man who ran the company saw it grow by in his lifetime so by the time Francisco d''Anconia heads the company it is the largest in the world His dream from childhood is to increase the size of the company by.
d''Anconia Copper is mentioned in sections and.
Hammond Motors
A car company in Colorado They make the best cars on the market until the founder disappears.
Hank Rearden buys a Hammond on his trip to Colorado in section.
Incorporated Tool
A company that is contracted to deliver drill heads to Taggart Transcontinental but who fail to do this It is mentioned in section.
Phoenix Durango
The Phoenix Durango is an old small railroad located in the Southwest run by Dan Conway that has been insignificant for most of its existence However the Phoenix Durango grows rapidly when Ellis Wyatt revives the economy of Colorado and Taggart Transcontinental''s Rio Norte Line fails to service Wyatt adequately Later James Taggart conspires to get the Phoenix Durango driven out of Colorado with the Anti dog eat dog Rule.
The Phoenix Durango is mentioned in sections alluded to and.
Rearden Coal
A business founded by Hank Rearden prior to the founding of Rearden Steel It is mentioned in section.
Rearden Limestone
A business founded by Hank Rearden prior to the founding of Rearden Steel It is mentioned in section.
Rearden Ore
The first business founded by Hank Rearden It is mentioned in section.
Rearden Steel
A company founded by Hank Rearden about ten years prior to the start of the story in the novel Rearden bought an abandoned steel mill in Philadelphia at a time when all the experts thought that such a venture would be hopeless He turned it into the most reliable and profitable steel company in the country.
As Dagny Taggart struggles to save Taggart Transcontinental she becomes increasingly dependent on Rearden Steel.
Rearden Steel is mentioned in sections alluded to and.
Summit Casting
A company in Illinois under contract to deliver rail spikes to Taggart Transcontinental They go bankrupt before they can deliver prompting Dagny Taggart to fly to Chicago and buy the company to get it started again.
Summit Casting is mentioned in section.
Taggart Transcontinental
The fictional railroad run by Dagny Taggart Her commitment to the railroad creates one of the book''s major conflicts.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Things in Atlas Shrugged','Things in Atlas Shrugged Things in Atlas Shrugged This is a list of general items in Ayn Rand''s Atlas Shrugged.
Spoiler warning Plot and or ending details follow.
Anti dog eat dog Rule
The Anti dog eat dog Rule is passed by the National Alliance of Railroads in section allegedly to prevent destructive competition between railroads The rule gives the Alliance the authority to forbid competition between railroads in certain parts of the country It was crafted by Orren Boyle as a favor for James Taggart with the purpose of driving the Phoenix Durango out of Colorado.
Bracelet
The very first thing made from Rearden Metal is a bracelet The bracelet is used to illustrate Rand''s Theory of Sex.
The bracelet symbolizes the value created by Hank Rearden''s long struggle to invent Rearden Metal When he gives it to Lillian Rearden as a present in section she says It''s fully as valuable as a piece of railroad rails However Lillian fully grasps the significance of the gift her snide remark is her way of denigrating her husband''s ethos.
In section Lillian wears this bracelet at a party thrown on her anniversary She makes fun of it all night long and when Dagny Taggart hears Lillian say she would gladly trade it for a common diamond bracelet Dagny takes her up on it.
Lillian later asks for it back upon realizing her power over her husband was slowly diminishing Dagny denies the offer.
The bracelet appears in sections and.
Cub Club
A night club in New York When Francisco d''Anconia returns to New York in section he explains he came because of a hat check girl at the Cub Club and the liverwurst at Moe''s Delicatessen on Third Avenue.
Equalization of Opportunity Bill
A bill designed by the Looters that proposes to limit the number of businesses any one person can own to one It is aimed primarily at Hank Rearden who uses Rearden Ore to guarantee Rearden Steel with a supply of iron ore By passing this Bill the Looters can seize Rearden''s other businesses for themselves and then deny him the iron he needs to run his steel mills.
The Looters claim the Bill is meant to give a chance to the little guy.
The Equalization of Opportunity Bill is appears in section.
Galt''s Gulch
A secluded refuge in a valley of Colorado where the men of ability have retreated after relinquishing participation in American society Nicknamed Galt''s Gulch by its inhabitants it is in fact the property of Midas Mulligan one of the early strikers to follow John Galt''s call This call was to the great men of mind and action to abandon the increasingly slave state inclinations of a decaying United States to go on strike thereby withdrawing the only thing supporting the parasites and looters.
Sarcastically nicknamed Midas in the press because everything he seemed to touch turned to gold Mulligan adopted the nickname during his explosive investment career before dropping out of sight He had purchased this land among his far ranging speculative endeavors and subsequently retreated to it upon his disappearance Other strikers soon followed him there including John Galt renting or buying land for summer retreats as a respite from continuing their search for fellow strikers among the increasingly collapsing American society Eventually a society develops in Galt''s Gulch as more people live there year round as the outside world becomes virtually unsafe to visit.
We are introduced to Galt''s Gulch in the final section of the Novel in the first chapter entitled Atlantis The people live with each other in completely free society and embody everything which is the thesis of the Novel the appropriate values for a society of Mankind philosophical moral economic legal aesthetic and sexual among others too numerous to mention.
We find industrious ambitious happy people continuing their chosen fields of endeavor without the yokes of any taxation or regulation Conversely there is a reverence for private property everything transacted is paid for with the re invented currency of solid gold coin struck');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Aberdeen (disambiguation)','Aberdeen disambiguation Aberdeen disambiguation Aberdeen may refer to.
 Places.In Scotland. Aberdeen a major port city in north east Scotland
In Australia. Aberdeen New South Wales
In Canada. Aberdeen British Columbia two locations. Aberdeen British Columbia Fraser Valley. Aberdeen British Columbia Thompson Nicola Regional District. Aberdeen New Brunswick
 Aberdeen Nova Scotia
 New Aberdeen Nova Scotia
 Aberdeen Bay Nunavut
 Aberdeen Lake Nunavut
 Aberdeen Ontario two locations. Aberdeen Ontario Grey County. Aberdeen Ontario Prescott and Russell County. Aberdeen Township Ontario
 Macdonald Merideth and Aberdeen Additional Ontario
 Sheen Esher Aberdeen et Malakoff Quebec
 Aberdeen Saskatchewan
 Aberdeen No Saskatchewan
In China. Aberdeen Harbour Hong Kong
In South Africa. Aberdeen South Africa
In the United States. Aberdeen Idaho
 Aberdeen Maryland
 Aberdeen Mississippi
 Aberdeen Township New Jersey
 Aberdeen North Carolina
 Aberdeen Ohio
 Aberdeen South Dakota
 Aberdeen Washington
 Aberdeen West Virginia
 Other. Aberdeen band an American rock band. Aberdeen movie a movie directed by Hans Petter Moland starring Stellan Skarsg rd and Lena Headey. Aberdeen Proving Ground a U S Army installation in Maryland.
This is a disambiguation page a list of pages that otherwise might share the same title If an article link referred you to this title you might want to go back and fix it to point directly to the intended page.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Algae','Algae Algae A seaweed Laurencia up close the branches are multicellular and only about mm thick Much smaller algae are seen attached to the structure extending upwards near the lower right corner
 This article is about an organism See algae programming language for a programming language in computing.The algae singular alga comprise several different groups of living organisms usually found in wet places or water bodies and that capture light energy through photosynthesis converting inorganic substances into simple sugars with the captured energy Algae were traditionally regarded as simple plants and some are closely related to the higher plants Others appear to represent different protist groups alongside other organisms that are traditionally considered more animal like protozoa Thus algae do not represent a single evolutionary group but a level of organization that may have developed several times in the early evolutionary history of life on earth.
Algae range from single celled organisms to multi cellular organisms some with fairly complex differentiated form and called seaweeds All lack leaves roots flowers and other organ structures that characterize higher plants They are distinguished from other protozoa in that they are photoautotrophic although this is not a hard and fast distinction as some groups may contain members that are mixotrophic deriving energy both from photosynthesis as well as through the uptake of organic carbon either by osmotrophy myzotrophy or phagotrophy Some unicellular algae rely entirely on external energy sources and have reduced or lost their photosynthetic apparatus.
All algae have photosynthetic machinery ultimately derived from the cyanobacteria and so produce oxygen as a by product of photosynthesis unlike other non cyanobacterial photosynthetic bacteria.
Algae are common in terrestrial as well as aquatic environments but usually inconspicuous on the land and more common in moist tropical climates see however Lichens The various sorts of algae play significant roles in aquatic ecology Microscopic forms that live suspended in the water column called phytoplankton provide the food base for most marine food chains In very high densities so called algal blooms they may discolor the water and outcompete or poison other life forms The seaweeds grow mostly in shallow marine waters some are used as human food or are harvested for useful substances such as agar or fertilizer The study of algae is called phycology or algology.
 Relationships among algal groups. Prokaryotic algae.Traditionally the cyanobacteria have been included among the algae referred to as the cyanophytes or Blue green Algae though some recent treatises on algae specifically exclude them Cyanobacteria is one of the first groups of living things to appear in the fossil record dating back some million years ago Precambrian when they may have played a major role in creating Earth''s oxygen atmosphere They have a prokaryotic cell structure typical of bacteria and conduct photosynthesis directly within the cytoplasm rather than in specialized organelles.
 Eukaryotic algae.All other algae are eukaryotes and conduct photosynthesis within membrane bound structures organelles called chloroplasts Chloroplasts contain DNA and are similar in structure to cyanobacteria presumably representing reduced cyanobacterial endosymbionts The exact nature of the chloroplasts is different among the different lines of algae possibly reflecting different endosymbiotic events There are three groups that have primary chloroplasts.
 Green algae together with higher plants
 Red algae
 Glaucophytes
In these groups the chloroplast is surrounded by two membranes both now thought to come from the chloroplast The chloroplasts of red algae have a more or less typical cyanobacterial pigmentation while the green algae and higher plants have chloroplasts with chlorophyll a and b the latter found in some cyanobacteria but not most.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Analysis of variance','Analysis of variance Analysis of variance In statistics analysis of variance ANOVA is a collection of statistical models and their associated procedures which compare means by splitting the overall observed variance into different parts The initial techniques of the analysis of variance were pioneered by the statistician and geneticist Ronald Fisher in the and and is sometimes known as Fisher''s ANOVA or Fisher''s analysis of variance.
Overview
There are three conceptual classes of such models. Fixed effects model assumes that the data come from normal populations which differ in their means. Random effects models assume that the data describe a hierarchy of different populations whose differences are constrained by the hierarchy. Mixed models describe situations where both fixed and random effects are present.
The fundamental technique is a partitioning of the total sum of squares into components related to the effects in the model used For example we show the model for a simplified ANOVA with one type of treatment at different levels If the treatment levels are quantitative and the effects are linear a linear regression analysis may be appropriate.
 SS_ hbox Total SS_ hbox Error SS_ hbox Treatments.
The number of degrees of freedom abbreviated df can be partitioned in a similar way and specifies the chi square distribution which describes the associated sums of squares.
 df_ hbox Total df_ hbox Error df_ hbox Treatments.
 Fixed effects model.
The fixed effects model of analysis of variance applies to situations in which the experimenter has subjected his experimental material to several treatments each of which affects only the mean of the underlying normal distribution of the response variable.
 Random effects model.
Random effects models are used to describe situations in which incomparable differences in experimental material occur The simplest example is that of estimating the unknown mean of a population whose individuals differ from each other In this case the variation between individuals is confounded with that of the observing instrument..
 Degrees of freedom.
Degrees of freedom indicates the effective number of observations which contribute to the sum of squares in an ANOVA the total number of observations minus the number of linear constraints in the data.
 Tests of significance.
Analyses of variance lead to tests of statistical significance using Fisher''s F distribution.
See also
 ANCOVA
 MANOVA
 Important publications in analysis of variance
 Multiple comparisons
 Duncan''s new multiple range test
 External links. Analysis Of Variance sixsigmafirst.');
 
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Alkane','Alkane Alkane For saturated hydrocarbons containing one or more rings see Cycloalkane.
An alkane in organic chemistry is a saturated hydrocarbon without cycles that is an acyclic hydrocarbon in which the molecule has the maximum possible number of hydrogen atoms and so has no double bonds.Alkanes are also often known as paraffins or collectively as the paraffin series these terms however are also used to apply only to alkanes whose carbon atoms form a single unbranched chain when this is done branched chain alkanes are called isoparaffins.Alkanes are aliphatic compounds.
The general formula for alkanes is C n H the simplest possible alkane is therefore methane CH The next simplest is ethane C H the series continues indefinitely Each carbon atom in an alkane has sp hybridization.
Isomerism
The atoms in alkanes with more than three carbon atoms can be arranged in multiple ways forming different isomers Normal alkanes have a linear unbranched configuration The number of isomers increases rapidly with the number of carbon atoms for alkanes with to carbon atoms the number of isomers equals and respectively sequence in OEIS.
Nomenclature of alkanes
The names of all alkanes end with ane.
Alkanes with unbranched carbon chains
The first four members of the series in terms of number of carbon atoms are named as follows. methane CH. ethane C H. propane C H. butane C H.Alkanes with five or more carbon atoms are named by adding the suffix ane to the appropriate numerical multiplier with elision of a terminal a from the basic numerical term Hence pentane C H hexane C H heptane C H octane C H etc For a more complete list see List of alkanes.
Straight chain alkanes are sometimes indicated by the prefix n for normal to distinguish them from branched chain alkanes having the same number of carbon atoms Although this is not strictly necessary the usage is still common in cases where there is an important difference in properties between the straight chain and branched chain isomers e g n hexane is a neurotoxin while its branched chain isomers are not.
Alkanes with branched carbon chains
Branched alkanes are named as follows.
 Identify the longest straight chain of carbon atoms.
 Number the atoms in this chain starting from at one end and counting upwards to the other end.
 Examine the groups attached to the chain in order and form their names.
 Form the name by looking at the different attached groups and writing for each group the following.
 The number or numbers of the carbon atom or atoms where it is attached.
 The prefixes di tri tetra etc if the group is attached in etc places or nothing if it is attached in only one place.
 The name of the attached group.
 The formation of the name is finished by writing down the name of the longest straight chain.
To carry out this algorithm we must know how to name the substituent groups This is done by the same method except that instead of the longest chain of carbon atoms the longest chain starting from the attachment point is used also the numbering is done so that the carbon atom next to the attachment point has the number.
For example the compound
is the only carbon alkane possible apart from butane Its formal name is methylpropane.
Pentane however has two branched isomers in addition to its linear normal form.
 dimethylpropane and methylbutane.
Trivial names
The following nonsystematic names are retained in the IUPAC system. isobutane for methylpropane
 isopentane for methylbutane
 neopentane for dimethylpropane
The name isooctane is very widely used in the petrochemical industry to refer to trimethylpentane.
Occurrence
Methane and ethane make up a large proportion of Jupiter''s atmosphere
Alkanes occur both on Earth and in the solar system however only the first hundred or so and even then mostly only in traces The light hydrocarbons especially methane and ethane are of great importance for other heavenly bodies they are found for example both in the tail of the comet Hyakutake and in some ');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Appeal','Appeal Appeal This article is about the legal term For other usages see Appeal disambiguation.
An appeal is the act or fact of challenging a judicially cognizable and binding judgment to a higher judicial authority In common law jurisdictions most commonly this means formally filing a notice of appeal with a lower court indicating one''s intention to take the matter to the next higher court with jurisdiction over the matter and then actually filing the appeal with the appropriate appellate court.
In the old English common law the term appeal was used to describe a process peculiar to English criminal procedure It was a right of prosecution possessed as a personal privilege by a party individually aggrieved by a felony a privilege of which the crown could not directly or indirectly deprive him since he could use it alike when the prisoner was tried and acquitted and when he was convicted and pardoned It was chiefly known in practice as the privilege of the nearest relation of a murdered person When in after Colonel Oglethorpe''s inquiry and report on the London prisons Banbridge and other gaolers were indicted for their treatment of prisoners but were acquitted for deficiency of evidence appeals for murder were freely brought by relatives of deceased prisoners In the case of Slaughterford the accused was charged with murdering a woman whom he had seduced the evidence was very imperfect and he was acquitted on indictment But public indignation being aroused by the atrocities alleged to have been perpetrated an appeal was brought and on conviction he was hanged as his execution was a privilege belonging to the prosecutor of which the crown could not deprive him by a pardon In an appeal was ingeniously met by an offer of battle since if the appellee were an able bodied man he had the choice between combat or a jury see wager This neutralizing of one obsolete and barbarous process by another called the attention of the legislature to the subject and appeal in criminal cases along with trial by battle was abolished in The history of this appeal is fully dealt with in Pollock and Maitland History of English Law.
In its usual modern sense the term appeal is applied to the proceeding by which the decision of a court of justice is brought for review before another tribunal of higher authority In Roman jurisprudence it was used in this and in other significations it was sometimes equivalent to prosecution or the calling up of an accused person before a tribunal where the accuser appealed to the protection of the magistrate against injustice or oppression The derivation from appellare call suggests that its earliest meaning was an urgent outcry or prayer against injustice During the republic the magistrate was generally supreme within his sphere and those who felt themselves outraged by injustice threw themselves on popular protection by provocatio instead of looking to redress from a higher official authority Under the empire different grades of jurisdiction were established and the ultimate remedy was an appeal to the emperor thus Paul when brought before Festus appealed unto Caesar Such appeals were however not heard by the emperor in person but by a supreme judge representing him In the Corpus Juris the appeal to the emperor is called indiscriminately appellatio and provocatio A considerable portion of the book of the Pandects is devoted to appeals but little of the practical operation of the system is to be deduced from the propositions there brought together.
During the middle ages full scope was afforded for appeals from the lower to the higher authorities in the church In matters ecclesiastical including those matrimonial testamentary and other departments which the church ever tried to bring within the operation of the canon law there were various grades of appeal ending with the pope.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Answer','Answer Answer ANSWER is also the name of an anti war protest group
An answer derived from and against and the same root as swear was originally a solemn assertion in opposition to some one or something and thus generally any counter statement or defence a reply to a question or objection or a correct solution of a problem In the common law an answer is the first pleading by a defendant usually filed and served upon the plaintiff within a certain strict time limit after a civil complaint or criminal information or indictment has been served upon the defendant It may have been preceded by an optional pre answer motion to dismiss or demurrer if such a motion is unsuccessful the defendant must file an answer to the complaint or risk an adverse default judgment.
The answer establishes which allegations cause of action in civil matters set forth by the complaining party will be contested by the defendant and states all the defendant''s defenses thus establishing the nature and parameters of the controversy to be decided by the court.
In the case of a criminal case there is usually an arraignment or some other kind of appearance before the court by the defendant The pleading in the criminal case which is entered on the record in open court is either guilty or not guilty Generally speaking in private civil cases there is no guilt or innocence There is only a judgment that grants money damages or some other kind of equitable remedy such as restitution or an injunction Criminal cases may lead to fines or other punishment such as imprisonment.
The famous Latin Responsa Prudentum answers of the learned were the accumulated views of many successive generations of Roman lawyers a body of legal opinion which gradually became authoritative.
In music an answer is the technical name in counterpoint for the repetition by one part or instrument of a theme proposed by another.
Wiktionary logo en png. Look up answer on Wiktionary the free dictionary.
Generally an answer is a reply to a questions a solution retaliation or response.
 References. This article incorporates text from the Encyclop dia Britannica which is in the public domain.');
 
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('America the Beautiful','America the Beautiful America the Beautiful America the Beautiful is an American patriotic song which rivals The Star Spangled Banner the national anthem of the United States in popularity It is often found in Christian hymnals in a wide variety of churches in the United States and may be sung as part of a Christian service of worship to God.
History
The words are by Katharine Lee Bates an English teacher at Wellesley College She had taken a train trip to Colorado Springs Colorado in to teach a short summer school session at Colorado College and several of the sights on her trip found their way into her poem. The World''s Columbian Exposition in Chicago Illinois the White City with its promise of the future contained within its alabaster buildings. The wheat fields of Kansas through which her train was riding on July. The majestic view of the Great Plains from atop Pike''s Peak.On that mountain the words of the poem started to come to her and she wrote them down upon returning to her hotel room at the original Antlers Hotel The poem was initially published two years later in The Congregationalist to commemorate the Fourth of July It quickly caught the public''s fancy Amended versions were published in and.
Several existing pieces of music were adapted to the poem The hymn Materna composed in by Samuel A Ward was generally considered the best music as early as and is still the popular tune today Ward had been similarly inspired The tune came to him while he was on a ferryboat trip from Coney Island back to his home in New York City after a leisurely summer day and he immediately wrote it down Ward died in not knowing the national stature his music would attain Miss Bates was more fortunate as the song''s popularity was well established by her death in.
At various times in the nearly years that have elapsed since the song as we know it was born particularly during the John F Kennedy administration there have been efforts to give America the Beautiful legal status either as a national hymn or as a national anthem equal to or in place of The Star Spangled Banner but so far this has not succeeded Proponents prefer America the Beautiful for various reasons saying it is easier to sing more melodic and more adaptable to new orchestrations while still remaining as easily recognizable as The Star Spangled Banner Some prefer America the Beautiful over The Star Spangled Banner due to the latter''s war oriented imagery Others prefer The Star Spangled Banner for the same reason While that national dichotomy has stymied any effort at changing the tradition of the national anthem America the Beautiful continues to be held in high esteem by a large number of Americans.
Popularity of the song soared following the September attacks at some sporting events it was sung in addition to the traditional singing of the national anthem.
Ray Charles is credited with the song''s most well known rendition in current times His recording is very commonly played at major sporting events such as the Super Bowl His unique take on it places the third verse first after which he sings the usual first verse In the third verse see below the author scolds the materialistic and self serving robber barons of her day and urges America to live up to its noble ideals and to honor with both word and deed the memory of those who died for their country a message that resonates just as strongly today.
An amusing oddity of the song is that its meter technically common meter double or is identical to that of Auld Lang Syne The two songs can be sung perfectly with lyrics interchanged.
Lyrics
Oh beautiful for spacious skies.
For amber waves of grain.
For purple mountain majesties
Above the fruited plain.
America America God shed his grace on thee.
And crown thy good with brotherhood from sea to shining sea.
Oh beautiful for pilgrims'' feet
Whose stern impassioned stress
A thoroughfare for freedom beat
Across the wilderness.
America America God mend thine ev''ry flaw.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('American Football Conference','American Football Conference American Football Conference American Football Conference
The American Football Conference or AFC is one of the two conferences that compose the National Football League The AFC was formed before the NFL season from the American Football League when the AFL merged with the NFL It was agreed that the new conferences should be equal in number and thus the Baltimore Colts Cleveland Browns and Pittsburgh Steelers were obliged to join the new AFC Initially this proved to be very unpopular with fans in these cities.
The AFC currently consists of teams organized into four divisions North South East and West of four teams each Each team plays the other teams in their division twice home amp away during the regular season in addition to other games teams assigned to their schedule by the NFL in the May before of these games are assigned on the basis of the teams'' final record in the previous season The remaining games are split between the roster of two other NFL divisions This assignment shifts each year For instance in the regular season each team in the NFC East will play a game apiece against each team in both the AFC West and the NFC West In this way division competition consists of common opponents with the exception of the games assigned on the strength of the each team''s prior season record.
At the end of each football season there are playoff games involving the top six teams in the AFC the four division champions by place standing and the top two remaining non division champion teams wildcards by record The two teams remaining play in the AFC Championship game with the winner receiving the Lamar Hunt Trophy The AFC Champion plays the NFC Champion in the Super Bowl.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Agriculture','Agriculture Agriculture A farmer in Germany working the land in the traditional way with a horse and plough
Agriculture is the process of producing food feed fiber and other desired products by the cultivation of certain plants and the raising of domesticated animals livestock The practice of agriculture is also known as farming while scientists inventors and others devoted to improving farming methods and implements are also said to be engaged in agriculture.
More people in the world are involved in agriculture as their primary economic activity than in any other yet it only accounts for four percent of the world''s GDP.
Overview
Tea plantation in Java Indonesia
Agriculture can refer to subsistence agriculture the production of enough food to meet just the needs of the farmer agriculturalist and his her family.It may also refer to industrial agriculture often refered to as factory farming long prevalent in developed nations and increasingly so elsewhere which consists of obtaining financial income from the cultivation of land to yield produce the commercial raising of animals animal husbandry or both.
Agriculture is also short for the study of the practice of agriculture more formally known as agricultural science Agricultural students are known sometimes derisively as Aggies.
Increasingly in addition to food for humans and animal feeds agriculture produces goods such as cut flowers ornamental and nursery plants timber or lumber fertilizers animal hides leather industrial chemicals starch sugar ethanol alcohols and plastics fibers cotton wool hemp and flax fuels methane from biomass biodiesel and both legal and illegal drugs biopharmaceuticals tobacco marijuana opium cocaine Genetically engineered plants and animals produce specialty drugs.
In the Western world the use of gene manipulation better management of soil nutrients and improved weed control have greatly increased yields per unit area At the same time the use of mechanization has decreased labour requirements The developing world generally produces lower yields having less of the latest science capital and technology base.
Modern agriculture depends heavily on engineering and technology and on the biological and physical sciences Irrigation drainage conservation and sanitary engineering each of which is important in successful farming are some of the fields requiring the specialized knowledge of agricultural engineers.
Agricultural chemistry deals with other vital farming concerns such as the application of fertilizer insecticides see Pest control and fungicides soil makeup analysis of agricultural products and nutritional needs of farm animals.
Plant breeding and genetics contribute immeasurably to farm productivity Genetics has also made a science of livestock breeding Hydroponics a method of soilless gardening in which plants are grown in chemical nutrient solutions may help meet the need for greater food production as the world''s population increases.
The packing processing and marketing of agricultural products are closely related activities also influenced by science Methods of quick freezing and dehydration have increased the markets for farm products see Food preservation Meat packing industry.
Mechanization the outstanding characteristic of late and century agriculture has eased much of the backbreaking toil of the farmer More significantly mechanization has enormously increased farm efficiency and productivity see Agricultural machinery Animals including horses mules oxen camels llamas alpacas and dogs however are still used to cultivate fields harvest crops and transport farm products to markets in many parts of the world.
Airplanes helicopters trucks and tractors are used in agriculture for seeding spraying operations for insect and disease control Aerial topdressing transporting perishable products and fighting forest fires Radio and television disseminate vital weather reports and other information such as market reports that concern farmers Computers ');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Aldous Huxley','Aldous Huxley Aldous Huxley Aldous Huxley
Aldous Leonard Huxley July November was a British writer who emigrated to the United States He was a member of the famous Huxley family who produced a number of brilliant scientific minds Best known for his novels and wide ranging output of essays he also published short stories poetry travel writing and film stories and scripts Through his novels and essays Huxley functioned as an examiner and sometimes critic of social mores societal norms and ideals and possible misapplications of science in human life While his earlier concerns might be called humanist ultimately he became quite interested in spiritual subjects like parapsychology and mystically based philosophy which he also wrote about By the end of his life Huxley was considered in certain learned circles a ''leader of modern thought''.
Biography
Early years
Family tree
Huxley was born in Godalming Surrey England He was the son of the writer Leonard Huxley by his first wife Julia Arnold and grandson of the famous proponent of Charles Darwin Thomas Huxley His brother Julian Huxley was a biologist also noted for his evolutionary theories Huxley understandably excelled in the areas he took up professionally for on his father''s side were a number of noted men of science while on his mother''s were people of literary accomplishment.
Huxley was a lanky delicately framed child who was gifted intellectually His father was a professional herbalist as well as an author so Aldous began his learning in his father''s well equipped botanical laboratory then continued in a school named Hillside which his mother supervised for several years until she became terminally ill From the age of nine Aldous was then educated in the British boarding school system He took readily to the handling of ideas.
His mother Julia died in when Aldous was only fourteen and his sister Roberta died of an unrelated incident in the same month Three years later Aldous suffered an illness keratitis punctata which seriously damaged his eyesight His older brother Trev committed suicide in Aldous''s near blindness disqualified him from service in World War I Once his eyesight recovered he was able to read English literature at Balliol College Oxford.
Maturing as a lean young man well over six feet in height the cerebrotonic Huxley''s initial interest in literature was primarily intellectual While he was noted for his personal kindliness only considerably later some say under the influence of such friends as D H Lawrence did he heartily embrace feelings as matters of importance in his evolving personal philosophy and literary expression.
Following his education at Balliol Huxley was financially indebted to his father and had to earn a living For a short while in he was employed acquiring provisions at the Air Ministry But never desiring a career in administration or in business Huxley''s lack of inherited means propelled him into applied literary work.
Huxley had completed his first unpublished novel at the age of seventeen and began writing seriously in his early twenties He wrote great novels on dehumanising aspects of scientific progress most famously Brave New World and on pacifist themes e g Eyeless in Gaza Huxley was strongly influenced by F Matthias Alexander and included him as a character in Eyeless in Gaza.
Middle years
Already a noted satirist and social thinker during World War I Huxley spent much of his time at Garsington Manor home of Lady Ottoline Morrell Later in Crome Yellow he caricatured the Garsington lifestyle but remained friendly with the Morrells He married Maria Nys whom he had met at Garsington.
Huxley moved to Llano California in but like his friend the philosopher Gerald Heard who accompanied him Huxley was denied citizenship since he refused to ascribe his pacifism to religious beliefs In his book Ends and Means most people in modern civilization agree that they want a world of ''liberty peace justice and brotherly love'' though they haven''t been able ');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Ada','Ada Ada. Wiktionary logo en png. Look up ADA and Ada in Wiktionary the free dictionary.
Ada may refer to. People
 Jewish variant transliteration of Adah. Ada Lady Lovelace
 Ada sister of Charlemagne for whom the Ada Gospels at Trier were produced. Ada satrap of Caria deposed by her brother Idreus restored by Alexander the Great
 Places
 Ada Afghanistan
 Ada Saskatchewan Canada
 Ada Ghana
 Ada Greece
 Ada Nigeria
 Ada Serbia
 Ada Minnesota United States
 Ada Ohio United States
 Ada Oklahoma United States
 Ada Township Michigan United States
 Ada Township North Dakota United States
 Ada Township South Dakota United States
 Ada County Idaho United States
 Initialisms. Aeronautical Development Agency of India''s Ministry of Defence
 Air Defense Artillery a branch of the United States Army
 American Decency Association
 American Dental Association
 American Diabetes Association
 American Dietetic Association
 Americans For Democratic Action
 Americans with Disabilities Act
 Aotearoa Digital Arts Assistant district attorney
 Average Daily Attendance
 Other. Ada programming language
 Ada a genus of orchids
 The short title of Ada or Ardor A Family Chronicle a novel by Vladimir Nabokov. Ada A demon after which Adasaurus was named.
This page concerning a three letter acronym or abbreviation is a disambiguation page a navigational aid which lists other pages that might otherwise share the same title If an article link referred you here you might want to go back and fix it to point directly to the intended page.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Anarchy (word)','Anarchy word Anarchy word.
Anarchy New Latin anarchia from Greek no rule is a term that has several usages Specific meanings include
 Absence of any form of state. Societal harmony through voluntary cooperation In contrast to the following Political disorder and confusion ''meaning'' Also known as anarchism. Political disorder and confusion. Absence of a ruler ruling class ruling political party or parties or power elite.Etymology
The word anarchy comes from the Greek word anarchia which means without a ruler an meaning without arch root denoting rule and ia corresponding to the English suffix y in monarchy It originated from the word anarchos which means either without head or chief or without beginning Liddell amp Scott''s Greek English Lexicon Anarchos was a description often applied to God to be uncaused was considered divine A King or founder might be called the archegos from arch agein to lead or just the arch n participle of archein to rule or the archos from archein os masculine ending which mean ruler Athenian democracy was not considered anarchia because like modern England Athens had Kings In fact there were nine archontes led by an arch n Liddell amp Scott These rulers served mainly religious and magisterial purposes but their existence precluded the Athenians from calling their government anarchia Instead of calling themselves anarchos the Athenians described their situation as eleutheros free.
Anarchy in Ancient Greece
In Athens the year BC was commonly referred to as the year of anarchy According to the historian Xenophon this happened even though Athens was at the times under the rule of the oligarchy of The Thirty installed by the Spartans following their victory in the second Peloponnesian war and despite the presence of an Archon nominated by the oligarchs in the person of Pythodorus However Athenians refused to apply here their custom of calling the year by that archon''s name since he was elected during the oligarchy and preferred to speak of it as the ''year of anarchy''.
The Greek philosophers Plato and Aristotle used the term anarchy negatively in association with democracy which they mistrusted as inherently vulnerable and prone to deteriorate into tyranny Plato believed that the corruption created by democracy loosens the natural hierarchy between social classes genders and age groups to the extent that anarchy finds a way into the private houses and ends by getting among the animals and infecting them ''Republic'' book Aristotle spoke of it in book of the ''Politics'' when discussing revolutions saying that the upper classes may be motivated to stage a coup by their contempt for the prevailing disorder and anarchy ataxias kai anarkhias in the affairs of the state He also claimed it would give license among slaves anarkhia te doul n as well as among women and children A constitution of this sort he concludes will have a large number of supporters as disorderly living z n atakt s is pleasanter to the masses than sober living.
See also
 Anarchism
External links
World Wide Web links
 Anarchist FAQ large site includes many questions and answers on anarchy and anarchism. Anarchist Theory FAQ covers both anarcho capitalism and leftist anarchism. OED definition
 The Anarchist International Information Service
 Rebel Alliance Forum also harbours a few communists and socialists. National Anarchism
 AnarchyZERO com a community based on anarchy
 Anarchy STRONG online anarchist community
 The Anarchists'' Abode A new Anarchists'' Forum set up to replace the previous Anarchist forums that have closed down. Green Anarchy Anti civilization anarchist magazine.
Freenet links
 Note These freesite links cannot be viewed without prior set up For explanation on how to set up a connection see Ways to view a freesite. localhost is assumed as the base for the freesite. SSK Anarchy Freesite allowing everybody to publish new editions. Anarchy Freesite allowing everybody to edit the current edition.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Animation','Animation Animation.
This animation moves at frames per second.
This animation moves at frames per second At this rate the individual frames should be discernible.
Animation is the illusion of motion created by the consecutive display of images of static elements In film and video production this refers to techniques by which which each frame of a film or movie is produced individually These frames may be generated by computers or by photographing a drawn or painted image or by repeatedly making small changes to a model unit see claymation and stop motion and then photographing the result with a special animation camera When the frames are strung together and the resulting film is viewed there is an illusion of continuous movement due to the phenomenon known as persistence of vision Generating such a film tends to be very labour intensive and tedious though the development of computer animation has greatly sped up the process.
Graphics file formats like GIF MNG SVG and Flash allow animation to be viewed on a computer or over the Internet.
History
For a more in depth look at the history of animation please see the Wikipedia articles Animated cartoon and History of Animation.
The major use of animation has always been for entertainment However there is growing use of instructional animation and educational animation to support explanation and learning.
The classic form of animation the animated cartoon as developed in the early and refined by Walt Disney and others requires up to distinct drawings for one second of animation This technique is described in detail in the article Traditional animation.
Because animation is very time consuming and often very expensive to produce the majority of animation for TV and movies comes from professional animation studios However the field of independent animation has existed at least since the with animation being produced by independent studios and sometimes by a single person Several independent animation producers have gone on to enter the professional animation industry.
Limited animation is a way of increasing production and decreasing costs of animation by using short cuts in the animation process This method was pioneered by UPA and popularized some say exploited by Hanna Barbera and adapted by other studios as cartoons moved from movie theaters to television It is also the basis of animation.
The animations shown before consist of these frames.
Famous names in animation
Famous names of the past.
Famous names of the present day
Animation studios
Animation Studios like Movie Studios may be production facilities or financial entities In some cases especially in Anime they have things in common with artists studios where a Master or group of talented individuals oversee the work of lesser artists and crafts persons in realising their vision.
Animation studios of the past
 Bray Productions
 DePatie Freleng Enterprises
 Filmation
 Fleischer Studios and Famous Studios
 Grantray Lawrence Animation
 Hanna Barbera Productions now Cartoon Network Studios. Harman Ising Productions
 Leon Schesinger Productions Warner Bros Cartoons Inc a k a Termite Terrace now known as Warner Brothers Animation. Metro Goldwyn Mayer
 Rankin Bass
 Soyuzmultfilm
 United Productions of America UPA. Van Beuren Studios
 Walter Lantz Studio
Animation studios of the present era
Styles of animation
 Traditional animation hand drawn. Rotoscoping
 Computer animation
 skeletal animation
 Per vertex animation
 Cutout animation
 Analog computer animation
 Motion capture
 Stop motion animation
 claymation
 Pixilation
 Puppet animation
 Limited animation
 Pinscreen animation
 Drawn on film animation
 Under camera animation
 Replacement animation
See also Animated series Anime Japanese animation List of movie genres
Techniques
 Character animation
 Special effects animation
 Onion skinning
 skeletal animation
 Per vertex animation
 Cel shaded animation
Further Readings
 Frank Thomas and Ollie Johnston Disney animation ');
 
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Apollo','Apollo Apollo For other uses see disambiguation.
Apollo Greek Ap ll n is a god in Greek and Roman mythology the son of Zeus and Leto and the twin of Artemis goddess of the hunt one of the most important and many sided of the Olympian divinities In later times he became in part confused or equated with Helios god of the sun and his sister similarly equated with Selene goddess of the moon in religious contexts But Apollo and Helios Sol remained quite separate beings in literary mythological texts In Etruscan mythology he was known as Aplu.
Worship
Apollo is considered to have dominion over the plague light healing colonists medicine archery poetry prophecy dance reason intellectualism Shamans and as the patron defender of herds and flocks Apollo had a famous oracle in Crete and other notable ones in Clarus and Branchidae Apollo the son of Zeus and the mortal Leto.
Apollo is known as the leader of the Muses musagetes and director of their choir His attributes include swans wolves dolphins bows and arrows a laurel crown the cithara or lyre and plectrum The sacrificial tripod is another attribute representative of his prophetic powers The Pythian Games were held in his honor every four years at Delphi Paeans were the name of hymns sung to Apollo.
The most usual attributes of Apollo were the lyre and the bow the tripod especially was dedicated to him as the god of prophecy Among plants the bay used in expiatory sacrifices and also for making the crown of victory at the Pythian games and the palm tree under which he was born in Delos were sacred to him among animals and birds the wolf the roe the swan the hawk the raven the crow the snake the mouse the grasshopper and the griffin a mixture of the eagle and the lion evidently of Eastern origin The swan and grasshopper symbolize music and song the hawk raven crow and snake have reference to his functions as the god of prophecy.
The chief festivals held in honour of Apollo were the Carneia Daphnephoria Delia Hyacinthia Pyanepsia Pythia and Thargelia.
Among the Romans the worship of Apollo was adopted from the Greeks There is a tradition that the Delphian oracle was consulted as early as the period of the kings during the reign of Tarquinius Superbus and in a temple was dedicated to Apollo on the occasion of a pestilence and during the Second Punic War in the Ludi Apollinares were instituted in his honour It was in the time of Augustus who considered himself under the special protection of Apollo and was even said to be his son that his worship developed and he became one of the chief gods of Rome After the battle of Actium Augustus enlarged his old temple dedicated a portion of the spoil to him and instituted quinquennial games in his honour He also erected a new temple on the Palatine hill and transferred the secular games for which Horace composed his Carmen Saeculare to Apollo and Diana.
As god of colonization Apollo gave guidance on colonies especially during the height of colonization BC According to Greek tradition he helped Cretan or Arcadian colonists find the city of Troy However this story may reflect a cultural influence which had the reverse direction Hittite cuneiform texts mention a Minor Asian god called Appaliunas or Apalunas in connection with the city of Wilusa which is now regarded as being identical with the Greek Illios by most scholars In this interpretation Apollo s title of Lykegenes can simply be read as born in Lycia which effectively severs the god''s supposed link with wolves possibly a folk etymology.
Apollo popularly e g in literary criticism represents harmony order and reason characteristics contrasted by those of Dionysus god of wine who popularly represents emotion and chaos The contrast between the roles of these gods is reflected in the adjectives Apollonian and Dionysian However Greeks thought of the two qualities as complementary the two gods are brothers and when Apollo at winter left for Hyperborea he would leave the Delphi Oracle to Dionysus.
Toge');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Andre Agassi','Andre Agassi Andre Agassi.
Andre Kirk Agassi born April in Las Vegas Nevada is a former World No men''s professional tennis player from the United States He has won eight Grand Slam singles titles and is one of only five players to have won all four Grand Slam events He is considered to be among the all time great tennis players.
Prodigy
Agassi''s father Mike Agassi a former Olympic boxer was intent on having a child win all four Grand Slams He called Agassi''s two older siblings guinea pigs in the development of his coaching techniques He honed Agassi''s eye coordination when he was an infant by hanging tennis balls above his crib He gave Agassi paddles and balloons when he was still in a high chair When Agassi started playing tennis his ball collection filled garbage cans with balls per can and Agassi would hit balls every day When Andre was years old he was already practicing with pros such as Jimmy Connors and Roscoe Tanner.
Mike Agassi learned tennis by watching tapes of champions He modelled each of Andre''s shots out of the champion that hit that shot better than anyone else He watched Boris Becker hit the ball on the rise and Ivan Lendl swing on the volley and he modelled Agassi''s game after that Mike Agassi took a very systematic approach to the physics and psychology of tennis and still remains active in the sport More information can be found in Mike Agassi''s book The Agassi Story.
Tennis career
Agassi turned professional in at the age of and won his first top level singles title in at Itaparica He won six further tournaments in and by December that year he had surpassed US million in career prize money after playing in just tournaments the quickest player in history to do so.
As a young up and coming player Agassi embraced a rebel image He grew his hair to rock star length sported an earring and wore colorful shirts that pushed tennis'' still strict sartorial boundaries He boasted of a cheeseburger heavy diet and endorsed the Canon Rebel camera Image is everything was the ads''s tag line and it became Agassi''s as well.
Strong performances on the tour meant that Agassi was quickly tipped as a future Grand Slam champion But he began the with a series of near misses He reached his first Grand Slam final in at the French Open where he lost in four sets to the seasoned veteran player Andr s G mez Later that year he lost in the final of the US Open to another up and coming teenaged star Pete Sampras The rivalry between the two American players was to become the dominant rivalry in tennis over the rest the of the decade In Agassi reached his second consecutive French Open final where he faced his former Bollettieri Academy mate Jim Courier Courier emerged the victor in a dramatic rain interrupted five set final. px
Agassi chose not to play at Wimbledon from and publicly stated that he did not wish to play there because of the event''s traditionalism particularly its predominantly white dress code which players at the event are required to conform to Many observers at the time speculated that Agassi''s real motivation was that his strong baseline game would not be suited to Wimbledon''s grass court surface He decided to play there in leading to weeks of speculation in the media about what he would wear he eventually emerged for the first round in a completely white outfit He reached the quarter finals on that occasion To the surprise of many Agassi''s Grand Slam breakthrough came at Wimbledon in when he beat Goran Ivani evi in a tight five set final.
Following wrist surgery in Agassi came back strongly in and captured the US Open beating Michael Stich in the final He then captured his first Australian Open title in beating Sampras in a four set final He won a career high seven titles that year and he reached the World No ranking for the first time that April He held it for weeks on that occasion through to November.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Austro-Asiatic languages','Austro Asiatic languages Austro Asiatic languages The Austroasiatic languages are a large language family of Southeast Asia and India The name comes from the Greek word for South Asia.
Austroasiatic languages have a disjunct distribution across India and Southeast Asia separated by regions where other languages are spoken It is widely believed that the Austroasiatic languages are the autochthonous languages of Southeast Asia and eastern India and that the other languages of the region including the Indo European Tai Kadai and Sino Tibetan languages are the result of later migrations of people There are for example Austroasiatic words in the Tibeto Burman languages of eastern Nepal Some linguists have attempted to prove that Austroasiatic languages are related to Austronesian languages thus forming the Austric superfamily.
Linguists traditionally recognize two major divisions of Austroasiatic the Mon Khmer languages of Southeast Asia and the Munda languages of east central and central India Ethnologue identifies Austroasiatic languages of which are Mon Khmer languages and are Munda languages However no evidence for this classification has ever been published and it remains speculative.
Each of the subdivisions of the classification below that is written in boldface type is accepted as a valid family However the relationships between these families within Austroasiatic is debated It should be noted that little of the data used for competing classifications has ever been published and therefore cannot be evaluated by peer review The classification used here is that of Diffloth in press which does not accept traditional Mon Khmer as a valid unit.
 Munda languages India. Koraput languages. Core Munda languages
 Kharian Juang languages. North Munda languages
 Korku language. Kherwarian languages.
 Khasi Khmuic languages
 Khasian languages of eastern India and Bangladesh. Palaungo Khmuic languages
 Khmuic languages of Laos and Thailand.
 Palaungo Pakanic languages
 Pakanic or Palyu languages of southern China
 Palaungic languages of Myanmar southern China and Thailand plus Mang of Vietnam.
 Core Mon Khmer languages
 Khmero Vietic languages
 Vieto Katuic languages
 Viet Muong or Vietic languages of Vietnam and Laos includes the Vietnamese language which has the most speakers of any Austroasiatic language These are the only Austroasiatic languages to have highly developed tone systems. Katuic languages of Laos Vietnam and Thailand.
 Khmero Bahnaric languages
 Bahnaric languages of Vietnam Laos and Cambodia. Khmeric languages
 The Khmer language of Cambodia Thailand and Vietnam. Pearic languages of Cambodia.
 Nico Monic languages
 Nicobarese languages languages of the Nicobar Islands a territory of India.
 Asli Monic languages
 Aslian languages of peninsular Malaysia and Thailand. Monic languages includes the Mon language of Myanmar and the Nyahkur language of Thailand.
There are in addition several unclassified languages of southern China.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Afro-Asiatic languages','Afro Asiatic languages Afro Asiatic languages Map showing the distribution of Afro Asiatic languages
The Afro Asiatic languages are a language family of about languages and million people widespread throughout North Africa East Africa the Sahel and Southwest Asia Other names sometimes given to this family include Afrasian Hamito Semitic deprecated Lisramic Hodge Erythraean Tucker.
The following language subfamilies are included.
 Berber languages
 Chadic languages
 Egyptian languages
 Semitic languages
 Cushitic languages
 Beja language subclassification controversial widely classified as part of Cushitic. Omotic languages controversial sometimes argued to be outside Afro Asiatic.
The Ongota language is often considered to be Afro Asiatic but its classification within the family remains controversial partly for lack of data Harold Fleming tentatively suggests that it is an independent branch of non Omotic Afro Asiatic.
It is not generally agreed on where Proto Afro Asiatic was spoken Africa e g Igor Diakonoff Lionel Bender has often been suggested particularly Ethiopia because it includes the majority of the diversity of the Afro Asiatic language family and has very diverse groups in close geographic proximity often considered a telltale sign for a linguistic geographic origin The western Red Sea coast and the Sahara have also been put forward e g Christopher Ehret Alexander Militarev suggests that their homeland was in the Levant specifically he identifies them with the Natufian culture.
The Semitic languages are the only Afro Asiatic subfamily based outside of Africa however in historical or near historical times some Semitic speakers crossed from South Arabia back into Ethiopia so some modern Ethiopian languages such as Amharic are Semitic rather than belonging to the substrate Cushitic or Omotic groups A minority of academics e g A Murtonen dispute this view suggesting that Semitic may have originated in Ethiopia.
Tonal languages are found in the Omotic Chadic and South amp East Cushitic branches of Afro Asiatic according to Ehret The Semitic Berber and Egyptian branches are not tonal.
Common features and cognates
Common features of the Afro Asiatic languages include. a two gender system in the singular with the feminine marked by the t sound. VSO typology with SVO tendencies. a set of emphatic consonants variously realized as glottalized pharyngealized or implosive and
 a templatic morphology in which words inflect by internal changes as well as prefixes and suffixes.
Some cognates are. b n build Ehret b n attested in Chadic Semitic bny Cushitic m n m n house and Omotic Dime bin build create. m t die Ehret maaw attested in Chadic eg Hausa mutu Egyptian mwt mt Coptic mu Berber mmet pr yemmut Semitic mwt and Cushitic Proto Somali umaaw am w t die also similar to the Latin mortis indicating a possible vocabluary drift
 s n know attested in Chadic Berber and Egyptian. l s tongue Ehret lis'' to lick attested in Semitic lasaan lisaan Egyptian ns Coptic las Berber ils Chadic eg Hausa harshe and possibly Omotic Dime lits'' lick. s m name Ehret s m s m attested in Semitic sm Berber ism Chadic eg Hausa suna Cushitic and Omotic though the Berber form ism and the Omotic form sunts are sometimes argued to be Semitic loanwords The Egyptian smi report announce may also be cognate. d m blood Ehret d m d m attested in Berber idammen Semitic dam Chadic and arguably Omotic Cushitic d m d m red may be cognate.
In the verbal system Semitic Berber and Cushitic including Beja all provide evidence for a prefix conjugation.
A causative affix s is widespread found in all its subfamilies but is also found in other groups such as the Niger Congo languages.
The possessive pronoun suffixes are supported by Semitic Berber Cushitic including Beja and Chadic.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Andorra','Andorra Andorra For the play by Max Frisch see Andorra play.
 Latin Virtue united is stronger ''''.
 Population.
 Coordinates Andorra la Vella
 est.
 N E.
 Total.
 water.
 km.
 Negligible.
 Total.
 Density.
 km.
 in summer
 CEST UTC.
The Principality of Andorra Catalan Principat d''Andorra French Principaut d''Andorre Spanish Principado de Andorra is a small landlocked principality in south western Europe located in the eastern Pyrenees mountains and bordered by France and Spain Once isolated it is currently a prosperous country mainly because of tourism and its status as a tax haven Andorra is not to be confused with the Comune di Andora.
 Origin and history of the name.
The name Andorra probably originates from a Navarrese word andurrial which translates as shrub covered land.
 History.
Main article History of Andorra
Tradition holds that Charlemagne granted a charter to the Andorran people in return for their fighting the Moors Overlordship over the territory was passed to the local count of Urgell and eventually to the bishop of the diocese of Urgell In the century a dispute arose between the bishop and his northern French neighbour over Andorra.
In the conflict was resolved by the signing of a parage which provided that Andorra''s sovereignty be shared between the French count of Foix whose title would ultimately transfer to the French head of state and the bishop of La Seu d''Urgell in the Catalonia region of Spain This gave the small principality its territory and political form.
Over the years the title passed to the kings of Navarre After Henry of Navarre became King Henry IV of France he issued an edict that established the head of the French state and the Bishop of Urgell as co princes of Andorra.
In the period the French Empire annexed Catalonia and divided it in four departments Andorra was also annexed and made part of the district of Puigcerd d partement of S gre.
In France occupied Andorra as a result of social unrest before elections On July an adventurer named Boris Skossyreff issued a proclamation in Urgel declaring himself Boris I sovereign prince of Andorra simultaneously declaring war on the bishop of Urgel He was arrested by Spanish authorities on July and ultimately expelled from Spain From to a French detachment was garrisoned in Andorra to prevent influences of the Spanish Civil War and Franco''s Spain.
In Andorra declared peace with Germany having been forgotten on the Treaty of Versailles and remaining legally at war.
Given its relative isolation Andorra has existed outside the mainstream of European history with few ties to countries other than France and Spain In recent times however its thriving tourist industry along with developments in transportation and communications have removed the country from its isolation and its political system was thoroughly modernized in.
 Politics.
Main articles Politics of Andorra Constitution of Andorra.
Until very recently Andorra''s political system had no clear division of powers into executive legislative and judicial branches Ratified and approved in the constitution establishes Andorra as a sovereign parliamentary democracy that retains the co princes as heads of state but the head of government retains executive power The two co princes serve coequally with limited powers that do not include veto over government acts They are represented in Andorra by a delegate.
View of the Pas de la Casa
The way in which the two princes are chosen makes Andorra one of the most politically distinct nations on earth One co Prince is the man or woman who is currently serving as President of France currently Jacques Chirac it has historically been any Head of State of France including Kings and Emperors of France The other is the current Catholic bishop of the Spanish city of La Seu d''Urgell currently Joan Enric Vives i Sicilia As neither prince lives in Andorra their role is almost entirely ceremonial.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Arithmetic mean','Arithmetic mean Arithmetic mean In mathematics and statistics the arithmetic mean of a set of numbers is the sum of all the members of the set divided by the number of items in the set cardinality The word set is used perhaps somewhat loosely for example the number could occur more than once in such a set The arithmetic mean is what pupils are taught very early to call the average If the set is a statistical population then we speak of the population mean If the set is a statistical sample we call the resulting statistic a sample mean.
The mean may be conceived of as an estimate of the median When the mean is not an accurate estimate of the median the set of numbers or frequency distribution is said to be skewed.
We denote the set of data by X x x x n The symbol Greek mu is used to denote the arithmetic mean of a population We use the name of the variable X with a horizontal bar over it as the symbol X bar for a sample mean Both are computed in the same way.
 bar x rm arithmetic mean cdots x_n n.
The arithmetic mean is greatly influenced by outliers For instance reporting the average net worth in Redmond Washington as the arithmetic mean of all annual net worths would yield a surprisingly high number because of Bill Gates These distortions occur when the mean is different from the median and the median is a superior alternative when that happens.
In certain situations the arithmetic mean is the wrong concept of average altogether For example if a stock rose in the first year in the second year and fell in the third year then it would be incorrect to report its average increase per year over this three year period as the arithmetic mean the correct average in this case is the geometric mean which yields an average increase per year of only.
If X is a random variable then the expected value of X can be seen as the long term arithmetic mean that occurs on repeated measurements of X This is the content of the law of large numbers As a result the sample mean is used to estimate unknown expected values.
Note that several other means have been defined including the generalized mean the generalized f mean the harmonic mean the arithmetic geometric mean and the weighted mean.
Alternate notations
The arithmetic mean may also be expressed using the sum notation.
 bar x sum_ i n x_i.
Pronunciation
When used as a noun the word arithmetic is pronounced with the emphasis on the second syllable aRITHmetic but when used as an adjective as in the title of this article the emphasis is on the third syllable arithMETic.
See also
mean average summary statistics variance central tendency standard deviation inequality of arithmetic and geometric means Muirhead''s inequality
External links
 Calculations and comparisons between arithmetic and geometric mean between two numbers
 Arithmetic and geometric means');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Al Gore','Al Gore Al Gore For the Senior Al Gore see Albert Gore Sr.
Albert Arnold Gore Jr born March is a former American politician and current businessman who served as the Vice President of the United States from to He ran for President in following Bill Clinton''s two four year terms but was narrowly defeated by the Republican candidate George W Bush in a bitterly contested election that included multiple recounts and a Supreme Court decision that effectively decided the election in favor of Bush While Gore received the most popular votes the states Bush won gave him a majority in the U S Electoral College and Bush was elected President The election remains one of the most divisive and controversial topics in recent American politics.
Gore currently serves as President of the American televison channel Current and Chairman of Generation Investment Management sits on the board of directors of Apple Computer and serves as an unofficial advisor to Google''s senior management Although speculation about a possible presidential run in still continues he has repeatedly stated that he does not plan to return to politics.
 Early and personal life. Family.Gore was born in Washington DC to Albert A Gore Sr and Pauline LaFon Gore Since his father was a veteran Democratic senator from Tennessee Al Gore Jr divided his childhood between Washington DC and Carthage Tennessee.
During the school year the younger Gore lived in a hotel in Washington where he attended the Sheridan School and later the elite St Albans School during summer vacations he lived in Carthage where he worked on the Gore family farm.
 For more information on Gore''s academic records see
In Gore enrolled at Harvard College where he majored in government His roommate in Dunster House was actor Tommy Lee Jones Gore graduated from Harvard in June of with a Bachelor of Arts degree.
In Gore married Mary Elizabeth Aitcheson Tipper Gore whom he had first met many years before at his high school senior prom St Albans School in Washington DC They have four children Karenna born August married to Drew Schiff Kristin born June Sarah born January and Al III born October The Gores also have two grandchildren Wyatt born July and Anna Schiff.
The Gores now reside in Nashville Tennessee USA and own a small farm near Carthage Tennessee The family attends New Salem Missionary Baptist Church in Carthage.
Vietnam War service
Vietnam and journalism
Although opposed to the Vietnam war on August Gore enrolled in the army to participate in the Vietnam War effort After completing training as a military journalist Gore shipped to Vietnam in early He served as an Army war correspondent until May of that year slightly less than two years after he enlisted.
 For more information on Gore''s Vietnam service see as well as further information below.
After returning from Vietnam Gore spent five years as a reporter for the Tennessean a newspaper headquartered in Nashville Tennessee During this time Gore also attended Vanderbilt Divinity School and Law School although he did not complete a degree at either choosing instead to run for an open seat in Tennessee''s Congressional District Gore''s mother was a member of Vanderbilt Law School''s first class to accept women.
 Military service.
Gore served as a field reporter in Vietnam for five months.
Gore served in the Army from August to May The chronology of his military service is as follows. August Enlisted at the Newark New Jersey recruiting office. August to October weeks of basic training at Fort Dix New Jersey
 Late October to December Fort Rucker Alabama on the job occupational training at the Army Flier newspaper. January to May field reporter in Vietnam part of the Engineer Brigade stationed primarily at Bien Hoa Air Base near Saigon. May Discharged after granting of routine early discharge request as part of general troop reductions.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Animal Farm','Animal Farm Animal Farm Animal Farm book cover
Animal Farm is a satirical novel which can also be understood as a modern fable or allegory by George Orwell ostensibly about a group of animals who oust the humans from the farm they live on and run it themselves only to have it corrupted into a brutal tyranny on its own It was written during World War II and published in although it was not widely recognized until the late.
Animal Farm is a thinly veiled critique and satire of Communist totalitarianism Many events in the book are based on ones from the Soviet Union during the Stalin era For example the character Snowball who is expelled from the Farm by Napoleon is clearly modeled on Trotsky George Orwell though a left winger he was for many years a member of the Independent Labour Party was a critic of Stalin and suspicious of Moscow directed communism after his experiences in the Spanish Civil War.
 Plot. Spoiler warning Plot and or ending details follow.
The local prize winning pig Old Major calls a meeting of all the animals of Manor Farm He tells them that he has had a dream where mankind is gone and animals are free to live in peace and harmony He then proceeds to teach them a revolutionary song Beasts of England The other animals begin to hope and dream for the revolution of such a day When Old Major dies a mere three days later three pigs Snowball who teaches the animals to read though how he learned to read is not clear Napoleon and Squealer assume command and turn his dream into a full fledged philosophy The philosophy of Animalism has Seven Commandments the first of which is that all animals are equal and which are written on the wall of a barn for all to see One night the starved animals suddenly revolt and drive Mr Jones his wife and his pet raven off the farm and take control The farm is renamed Animal Farm as the animals work towards a future utopia to which the workhorse Boxer does more than his fair share and adopts a maxim of his own I will work harder.
It seems at first that Animal Farm is off to a great start Snowball was teaching all of the animals to read and write food was plentiful due to a good harvest and the entire Farm was organized and running smoothly Even when Mr Jones tries his last ditch effort to retake control of the farm the animals are easily able to defeat him at the later called the Battle of the Cowshed Soon however things begin to unravel as Napoleon and Snowball begin an epic power struggle over the farm When Snowball announces his idea for a windmill Napoleon quickly opposes it A meeting is held and when Snowball makes his passionate and articulate speech in favour of the windmill Napoleon only makes a brief retort and then a strange noise like a whistle This noise signals the arrival of the nine puppies Napoleon had educated who had grown into vicious attack dogs They burst in and chase Snowball off of the farm In his absence Napoleon declares himself the leader of the farm and makes instant changes He announces that meetings will no longer be held as before and a committee of pigs alone would decide what happened with the farm.
Napoleon changes his mind about the windmill claiming through Squealer that Snowball had stolen the idea and the animals begin to work After a violent storm the animals wake to find the fruit of their labour utterly annihilated Though neighbouring farmers scoff at the thin walls Napoleon and Squealer convince everyone that Snowball destroyed it Napoleon begins to purge the farm killing many animals accused of consorting with Snowball In the meantime Boxer has taken a second mantra Napoleon is always right.
Napoleon begins to abuse his powers even more and life on the farm becomes harder and harder for the rest of the animals The pigs impose more and more controls on them while reserving privileges for themselves History is rewritten to villainise Snowball and glorify Napoleon even further Each step of this development is justified by the pig Squealer who on se');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Amphibian','Amphibian Amphibian For other uses see disambiguation.
 Orders
Subclass Labyrinthodontia extinct
Subclass Lepospondyli extinct
Subclass Lissamphibia
 Anura
 Caudata
 Gymnophiona
Amphibians class Amphibia are a taxon of animals that include all tetrapods four legged vertebrates that do not have amniotic eggs Amphibians from Greek both and life generally spend part of their time on land but they do not have the adaptations to an entirely terrestrial existence found in most other modern tetrapods amniotes There are about living species of amphibians The study of amphibians and reptiles is known as herpetology The fear of amphibians and reptiles is known as herpetophobia.
 History of amphibians.Amphibians developed with the characteristics of pharyngeal slits gills a dorsal nerve cord a notochord and a post anal tail at different stages of their life They have persisted since the dawn of tetrapods million years ago in the Devonian period when they were the first four legged animals to develop lungs During the following Carboniferous period they also developed the ability to walk on land to avoid aquatic competition and predation while allowing them to travel from water source to water source As a group they maintained the status of the dominant animal for nearly million years Throughout their history they have ranged in size from the foot long Devonian Ichthyostega to the slightly larger foot long Permian Eryops and down to the tiny Brachycephalus didactylus Brazilian Gold Frog and Eleutherodactylus iberia from Cuba with a total length of millimeters Amphibians have mastered almost every climate on earth from the hottest deserts to the frozen arctic and have adapted to climatic change with ease.
 Solomon Berg Martin Biology
 Duellman Trueb Biology of Amphibians
 Classification.Traditionally the amphibians are taken to include all tetrapods that are not amniotes Recent amphibians all belong to a single subgroup of these called the Lissamphibia Recently there has been a tendency to restrict the class Amphibia to the Lissamphibia i e to exclude tetrapods that are not more closely related to modern forms than they are to modern reptiles birds and mammals.
There are two ancient extinct subclasses.
 Subclass Labyrinthodontia paraphyletic. Subclass Lepospondyli
Of the remaining modern subclass Lissamphibia there are three orders.
 Order Anura frogs and toads in Superorder Salientia species
 Order Caudata or Urodela salamanders species
 Order Gymnophiona or Apoda caecilians species
Authorities disagree on whether Salientia is a Superorder that includes the order Anura or whether Anura is a sub order of the order Salientia In effect Salientia includes all the Anura plus a single Triassic proto frog species Triadobatrachus massinoti Practical considerations seem to favour using the former arrangement now.
 Reproduction.For the purpose of reproduction most amphibians are bound to fresh water A few tolerate brackish water but there are no true sea water amphibians Several hundred frog species in adaptive radiations e g Eleutherodactylus the Pacific Platymantines the Australo Papuan microhylids and many other tropical frogs however do not need any water whatsoever They reproduce via direct development an ecological and evolutionary adaptation that has allowed them to be completely independent from free standing water Almost all of these frogs live in wet tropical rainforests and their eggs hatch directly into miniature versions of the adult bypassing the tadpole stage entirely Several species have also adapted to arid and semi arid environments but most of them still need water to lay their eggs The larvae tadpoles or polliwogs breathe with exterior gills After hatching they start to transform gradually into the adult''s appearance This process is called metamorphosis Typically the animals then leave the water and become terrestrial adults but
there are many interesting exceptions to this general way of reproduction.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Alaska','Alaska Alaska This article is about the U S state for other meanings see disambiguation For information about the history of Alaska see History of Alaska.
Lisa Murkowski R.
Aleutian UTC west of 30''.
Alaska is the state of the United States It was admitted on January The population of the state is as of according to the census The name Alaska is most likely derived from the Aleut word Alyeska meaning greater land as opposed the Aleut word Aleutia meaning lesser land To the Aleuts this distinction was a linguistic variation distinguishing the mainland from an island.
It is bordered by Yukon Territory and British Columbia Canada to the east the Gulf of Alaska and the Pacific Ocean to the south the Bering Sea Bering Strait and Chukchi Sea to the west and the Beaufort Sea and the Arctic Ocean to the north Alaska is the largest state by area in the United States It is larger in area than all but of the world''s nations.
History
Main article History of Alaska
Alaska was probably first inhabited by humans who came across the Bering Land Bridge Eventually Alaska became populated by the Inupiaq Inuit and Yupik Eskimos Aleuts and a variety of American Indian groups Most if not all of the pre Columbian population of the Americas probably took this route and continued further south and east.
The first written accounts indicate that the first Europeans to reach Alaska came from Russia Vitus Bering sailed east and saw Mt St Elias The Russian American Company hunted sea otters for their fur The colony was never very profitable because of the costs of transportation.
At the instigation of U S Secretary of State William Seward the United States Senate approved the purchase of Alaska from Russia for approximately in dollars adjusted for inflation on April and the United States flag was raised on October of that same year now called Alaska Day Coincident with the ownership change the de facto International Date Line was moved westward and Alaska changed from the Julian calendar to the Gregorian calendar Therefore for residents Friday October was followed by Friday October two Fridays in a row because of the date line shift.
The first American administrator of Alaska was Polish immigrant W odzimierz Krzy anowski The purchase was not popular in the contiguous United States where Alaska became known as Seward''s Folly or Seward''s Icebox Alaska celebrates the purchase each year on the last Monday of March calling it Seward''s Day After the purchase of Alaska between and the name was changed to the Department of Alaska Between and it was called the district of Alaska.
President Dwight D Eisenhower signed the Alaska Statehood Act into United States law on July which paved the way for Alaska''s admission into the Union on January.
Alaska suffered one of the worst earthquakes in recorded North American history on Good Friday see Good Friday Earthquake.
In the people of Alaska amended the state''s constitution establishing the Alaska Permanent Fund The fund invests a portion of the state''s mineral revenue including revenue from the Trans Alaskan Pipeline System to benefit all generations of Alaskans In March the fund''s value was over billion.
Prior to the state lay across four different time zones Pacific Standard Time UTC hours in the extreme southeast a small area of Yukon Standard Time UTC hours around Juneau Alaska Hawaii Standard Time UTC hours in the Anchorage and Fairbanks vicinity with the Nome area and most of the Aleutian Islands observing Bering Standard Time UTC hours In the number of time zones was reduced to two with the entire mainland plus the inner Aleutian Islands going to UTC hours and this zone then being renamed Alaska Standard Time as the Yukon Territory had several years earlier circa adopted a single time zone identical to Pacific Standard Time and the remaining Aleutian Islands were slotted into the UTC hours zone which was then renamed Hawaii Aleutian Standard Time.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Architecture (disambiguation)','Architecture disambiguation Architecture disambiguation Architecture may refer to.
 Architecture the art and science of designing buildings
 Landscape architecture the desing of land man made constructs
 Computer architecture the theory behind the design of a computer. Software architecture a coherent set of abstract patterns guiding the design of each aspect of a larger software system
 Enterprise architecture a framework to align an organization''s structure processes information operations and projects with the organization''s overall strategy. Information architecture the art and science of structuring knowledge to be published in a web and defining user interactions
 Product design or product architecture the structure of a product or product family
 Vehicle architecture an automobile platform made from a set of components common to a number of different vehicles
This is a disambiguation page a list of pages that otherwise might share the same title If an article link referred you to this title you might want to go back and fix it to point directly to the intended page.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Amoeboid','Amoeboid Amoeboid Amoeba Chaos diffluens.Foraminiferan Ammonia tepida.Heliozoan Actinophrys sol.Amoeboids are cells that move or feed by means of temporary projections called pseudopods false feet They have appeared in a number of different groups Some cells in multicellular animals may be amoeboid for instance our white blood cells which consume pathogens Many protists exist as individual amoeboid cells or take such a form at some point in their life cycle The most famous such organism is Amoeba proteus the name amoebae is variously used to describe its close relatives other organisms similar to it or the amoeboids in general.
Amoeboids may be divided into several morphological categories based on the form and structure of the pseudopods Those where the pseudopods are supported by regular arrays of microtubules are called actinopods and forms where they are not are called rhizopods further divided into lobse filose and reticulose amoebae There is also a strange group of giant marine amoeboids the xenophyophores that do not fall into any of these categories.
 Lobose pseudopods are blunt and there may be one or several on a cell which is usually divided into a layer of clear ectoplasm surrounding more granular endoplasm Most including Amoeba itself move by the body mass flowing into an anterior pseudopod The vast majority form a monophyletic group called the Amoebozoa which also includes most slime moulds A second group the Percolozoa includes protists that can transform between amoeboid and flagellate forms.
 Filose pseudopods are narrow and tapering The vast majority of filose amoebae including all those that produce shells are placed within the Cercozoa together with various flagellates that tend to have amoeboid forms The naked filose amoebae comprise two other groups the vampyrellids and nucleariids The latter appear to be close relatives of animals and fungi.
 Reticulose pseudopods are cytoplasmic strands that branch and merge to form a net They are found most notably among the Foraminifera a large group of marine protists that generally produce multi chambered shells There are only a few sorts of naked reticulose amoeboids notably the gymnophryids and their relationships are not certain.
 Actinopods are divided into the radiolaria and heliozoa The radiolaria are mostly marine protists with complex internal skeletons including central capsules that divide the cells into granular endoplasm and frothy ectoplasm that keeps them buoyant The heliozoa include both freshwater and marine forms that use their axopods to capture small prey and only have simple scales or spines for skeletal elements Both groups appear to be polyphyletic.
Traditionally the amoeboid protozoa are grouped together as the Sarcodina variously ranked from class to phylum with each of the above categories as a formal subtaxon However since they are all based on form rather than phylogeny newer systems generally separate some out or abandon them entirely Most amoeboids are now included in two major supergroups the Amoebozoa including most lobose amoebae and slime moulds and the Rhizaria including the Cercozoa Foraminifera radiolarian classes and certain heliozoa However amoeboids have appeared separately in many other groups including various different lines of algae not listed above.
 External links.
 The Amoebae website brings together information from published sources. 
 Amoebas are more than just blobs sun animacules and amoebas');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('America','America America America is usually meant as either.
 The Americas a set of continents and islands between the Atlantic and Pacific Oceans usually subdivided into. North America. Central America and the Caribbean
 South America
 The United States of America The usage of America to refer to the United States is commonly used in the US and elsewhere but is highly contested in many parts of the world See Use of the word American and Alternative words for American.
America is also. America Netherlands
 America Cambridgeshire England
America is the title or name of. America a song by Simon and Garfunkel
 America a song by Prince
 America band a rock and roll band
 America the title of their debut album
 ''''America a film directed by D W Griffith
 America a racing yacht that won the first ever America''s Cup in 
 Am rica a Brazilian telenovela soap opera. America a multi engine airplane used by Richard E Byrd and his crew on a transatlantic flight
 America a passenger liner commanded by George Fried involved in a famous sea rescue in 
 America a weekly Catholic magazine. America The Book a book written by the staff of The Daily Show with Jon Stewart. America a book by Jean Baudrillard examining the state sociologically
 '' America a song from West Side Story by Leonard Bernstein also performed by the UK rock group The Nice
 America XM XM Satellite Radio channel 
 USS America the name of three United States Navy ships
 America television station an Argentinian television station
America is an alternative title for. My Country ''Tis of Thee a U S patriotic song
America is an adaptation of the name of Amerigo Vespucci.
This is a disambiguation page a list of pages that otherwise might share the same title If an article link referred you to this title you might want to go back and fix it to point directly to the intended page.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Austin','Austin Austin Austin is a word that may refer to various things.
 Places in the U S.Austin may be the name of a town or city in the U S. Austin Texas the capital of Texas
 Austin Arkansas
 Austin Colorado
 Austin Indiana
 Austin Kentucky
 Austin Township Michigan
 Austin Minnesota
 Austin Nevada
 Austin North Carolina
 Austin Pennsylvania
 Austin Utah
 Port Austin Michigan
 Austinburg Ohio
Other places in the U S named Austin. Austin Chicago a neighborhood in Chicago
 Austin College a college in Sherman Texas
 Lake Austin
 Places in Canada. Austin Flat British Columbia
 Austin Heights British Columbia
 Austin Subdivision No British Columbia
 Austin Subdivision No British Columbia
 Austin Manitoba
 Austin Ontario
 Austin Quebec
 Names of people named Austin. Austin Powers a fictional movie spy
 Albert Austin
 Herbert Austin Sir Herbert Austin founder of the Austin Motor Company
 John Austin legal philosophy. J L Austin philosopher
 John Arnold Austin United States Navy warrant officer
 Phil Austin member of the Firesign Theatre
 Sherrie Austin musician
 Stephen F Austin founder of Texas
 Steve Austin fictional character the title character in Martin Caidin''s novel Cyborg which inspired the TV series The Six Million Dollar Man. Col Steve Austin fictional character the lead character played by Lee Majors in the TV series The Six Million Dollar Man. Stone Cold Steve Austin a Professional wrestler turned actor
 Saint Augustine noticeable in the English version Austin Friars to refer to the Augustinian Order.
 See also Jane Austen the author.
 Things named Austin. Austin Motor Company a British make of car
 American Austin Car Company a short lived United States make of automobile
 Austin brand a brand owned by the Kellogg Company
 USS Austin a sloop of war originally in the Texas Navy. USS Austin DE a destroyer escort
 USS Austin LPD an amphibious transport dock
This is a disambiguation page a list of pages that otherwise might share the same title If an article link referred you to this title you might want to go back and fix it to point directly to the intended page.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Concepts in Atlas Shrugged','Concepts in Atlas Shrugged Concepts in Atlas Shrugged Some of the important concepts discussed in Atlas Shrugged include the Sanction of the Victim and the Theory of Sex.
Sanction of the Victim
The Sanction of the Victim is defined as the willingness of the good to suffer at the hands of the evil to accept the role of sacrificial victim for the ''sin'' of creating values.
The entire story of Atlas Shrugged can be seen as an answer to the question what would happen if this sanction was revoked When Atlas shrugs relieving himself of the burden of carrying the world he is revoking his sanction.
The concept is apparently original in the thinking of Ayn Rand and is foundational to her moral theory She holds that evil is a parasite on the good and can only exist if the good tolerates it To quote from Galt''s Speech Evil is impotent and has no power but that which we let it extort from us and I saw that evil was impotent and the only weapon of its triumph was the willingness of the good to serve it Morality requires that we do not sanction our own victimhood.
Throughout Atlas Shrugged numerous characters admit that there is something wrong with the world but they cannot put their finger on what it is The concept they cannot grasp is the sanction of the victim The first person to grasp the concept is John Galt who vows to stop the motor of the world by getting the creators of the world to withhold their sanction.
We first glimpse the concept in section when Hank Rearden feels he is duty bound to support his family despite their hostility towards him.
In section the principle is stated explicitly by Dan Conway I suppose somebody''s got to be sacrificed If it turned out to be me I have no right to complain.
Theory of Sex
In rejecting the traditional Christian altruist moral code Rand also rejects the sexual code that in her view is a logical implication of altruism.
Rand introduces a theory of sex in Atlas Shrugged which is purportedly implied by her broader ethical and psychological theories Far from being a debasing animal instinct sex is the highest celebration of our greatest values Sex is a physical response to intellectual and spiritual values a mechanism for giving concrete expression to values that could otherwise only be experienced in the abstract.
One is sexually attracted to those who embody one''s values Those who have base values will be attracted to baseness to those who also have ignoble values Those who lack any clear purpose will find sex devoid of meaning People of high values will respond sexually to those who embody high values.
That our sexual desire is a response to the embodiment of our values in others is a radical and original theory However even those who are sympathetic to this theory have criticized it as being incomplete For instance since according to Rand the economy is also such an expression of values and since it is always possible to encounter someone who embodies one''s values more completely this would seem to make family undesirable Indeed Rand treats family as a sort of trap Furthermore promiscuity prostitution and an endless round robin of values driven sexual relationships would become inevitable From this viewpoint one could say that Aldous Huxley portrayed the ideal sexual state Brave New World features humans who are incapable of deviating from their caste oriented values which naturally include a code of sexual desirability.
Her sexual theory is illustrated in the contrasting relationships of Hank Rearden with Lillian Rearden and Dagny Taggart and later with Dagny Taggart and John Galt.
Other important illustrations of this theory are found in.
Section recounts Dagny''s relationship with Francisco d''Anconia.
Section recounts Hank and Lillian Rearden''s courtship and Lillian''s attitude towards sex.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Topics of note in Atlas Shrugged','Topics of note in Atlas Shrugged Topics of note in Atlas Shrugged Atlas
As told in Atlas Shrugged Atlas carried the world on his shoulders But in the Greek Myths the Titan Atlas stands on the earth and holds up the sky In the statues that represent Atlas the big round thing on his back represents the heavens which because of the apparent circular motion of the planets around the earth were conceived of as being round Some tellings of the Atlas myth have him carrying both the earth and the heavens on his back but this appears to be a modern retelling further research might confirm this.
Character names
Some of the character names are or appear to be puns or have some other significance See also Characters in Atlas Shrugged.When asked why so many of her names have syllables with many hard consonants like dag tag den stad Rand said that she just liked those sounds.
 Ragnar Danneskjold sounds like ''Dane''s Gold'' a tribute paid by the medieval English to the Vikings to bribe them into being peaceful However note skjold means shield not gold However the hero of Victor Hugo''s first novel Hans of Iceland becomes the first of the Counts of Dannesjk ld In the Rand told Marsha Familaro Enright that her use of this name was not plagiarism because there really were Counts of Dannesjk ld. Robert Stadler sounds like the German word for state Staat Dr Stadler is a statist in that he believes it appropriate and necessary for the state to fund scientific research. Francisco d''Anconia Rand''s husband was Frank O''Connor. John Galt the name of a century Scottish novelist though this is apparently coincidental Galt is close to ''Geld'' and ''gold'' The name was probably used because it had to be such that it could become proverbial this would not be possible with a long awkward name.
Crime
Common street crime is conspicuously absent in Atlas Shrugged Characters walk the streets with no thought of being mugged or attacked.
Historical figures and events
Atlas Shrugged takes place in a world with a different history from our own but there are some historical figures and events that are mentioned.
 Aristotle section Francisco d''Anconia wrote a thesis on the influence of Aristotle''s theory of the Immovable Mover. Dark Ages section Ragnar Danneskjold''s piracy is likened to something out of the Dark Ages. Inquisition section Sebastian d''Anconia flees Spain to escape persecution under the Inquisition. Middle Ages section It is said that Ragnar Danneskjold hides in the Norwegian fjords as the Vikings did in the Middle Ages. Nero section Francisco d''Anconia compares himself to the Emperor Nero. Patrick Henry section The eponym of Patrick Henry University. Vikings section It is said that Ragnar Danneskjold hides in the Norwegian fjords as the Vikings did in the Middle Ages.
Humor
In section Francisco cracks that the Mexican government was promising a roast of pork every Sunday for every man woman child and abortion.
In section Francisco lists the various buildings constructed for the workers of the San Sebastian Mines and notes how they are all poorly built and can be expected to collapse except for the church The church I think will stand They''ll need it he quips Since the other things are things of value houses roads etc it is ironic that only the church was built to last to Rand and her heroes a church is of no real value.
Almost every nation in the world except the United States is referred to as The People''s State of and they are all apparently the recipients of relief supplies from the United States In conversation people casually refer to them as The People''s State of rather than just say France or Norway It is obvious that people would not refer to countries by their formal names in casual conversation we don''t call Canada The Dominion of Canada or Germany The Federal Republic of Germany so by having her characters do this Rand is exercising her dry wit.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Atlas Shrugged','Atlas Shrugged Atlas Shrugged Atlas Shrugged cover
Atlas Shrugged is a novel by Ayn Rand first published in in the USA It is a highly philosophical and allegorical story that deals with themes of Rand''s own Objectivist philosophy.
Spoiler warning Plot and or ending details follow.
Philosophy and writing
The theme of Atlas Shrugged is that independent rational thought is the motor that powers the world In the book men of the mind go on strike allowing the collapse of what only they hold together a peaceful cohesiveness Rand claims that humans may create wherever forceful human interference is absent Given no alternative they remove themselves from the looters The book is rooted in Objectivism the philosophical system founded by Rand.
Rand suggests that society stagnates when independence and individual achievement are discouraged or demonized and that inversely a society will become more prosperous as it allows encourages and rewards independence and individual achievement Rand believed that independence flourishes to the extent that people are free and that achievement is rewarded best when private property is respected strictly She advocated laissez faire capitalism as the political system that is most consistent with these beliefs These considerations make Atlas Shrugged a highly political book especially in its portrayal of fascism socialism and communism or indeed any form of state intervention in societal affairs as fatally flawed However Rand claimed that it is not a fundamentally political book but that the politics portrayed in the novel are a result of her attempt to display her image of the ideal man and the position of the human mind in society.
Rand argues that independence and individual achievement drive the world and should be embraced Her worldview requires a rational moral code She disputes the notion that self sacrifice is a virtue and is similarly dismissive of human faith in a god or higher being The book positions itself against Christianity specifically often directly within the characters'' dialogue.
 Setting.
Exactly when Atlas Shrugged is meant to take place is kept deliberately vague In section the population of New York City is given as million The historical New York City reached million people in the which might place the novel sometime after that There are many early century technologies available but the political situation is clearly different from actual history One interpretation is that the novel takes place a hundred or perhaps hundreds of years in the future implying that since the world lapsed into its socialistic morass a global wide stagnation has occurred in technological growth population growth and indeed growth of any kind the wars economic depressions and other events of the century would be a distant memory to all but scholars and academicians This would be in line with Rand''s ideas and commentary on other novels depicting utopian and dystopian societies The concept of societal stagnation in the wake of collectivist systems is central to the plot of another of Rand''s works Anthem.
All countries outside the US have become or become during the novel People''s States There are many examples of early century technology in Atlas Shrugged but no post war advances such as nuclear weapons helicopters or computers Jet planes are mentioned briefly as being a relatively new technology Television is a novelty that has yet to assume any cultural significance while radio broadcasts are prominent Though Rand does not use in the book many of the technological innovations available while she was writing she introduces some advanced fictional inventions e g sound based weapon of mass destruction torture device power plant.
Most of the action in Atlas Shrugged occurs in the United States However there are important events around the world such as in the People''s States of Mexico Chile and Argentina and piracy at sea.
Plot
A section by section analysis of Atlas Shrugged is available on Wikibooks.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Anthropology','Anthropology Anthropology Anthropology from the Greek word human consists of the study of humankind see genus Homo It is holistic in two senses it is concerned with all humans at all times and with all dimensions of humanity A primary trait that traditionally distinguished anthropology from other humanistic disciplines is an emphasis on cross cultural comparisons This distinction has however become increasingly the subject of controversy and debate with anthropological methods now being commonly applied in single society group studies.
In the United States ''anthropology'' is traditionally divided into four sub disciplines. physical anthropology which studies primate behavior human evolution and population genetics this field is also sometimes called biological anthropology. cultural anthropology called social anthropology in the United Kingdom and now often known as socio cultural anthropology Areas studied by cultural anthropologists include social networks diffusion social behavior kinship patterns law politics ideology religion beliefs patterns in production and consumption exchange socialization gender and other expressions of culture with strong emphasis on the importance of fieldwork i e living among the social group being studied for an extended period of time. linguistic anthropology which studies variation in language across time and space the social uses of language and the relationship between language and culture and
 archaeology which studies the material remains of human societies Archaeology itself is normally treated as a separate but related field in the rest of the world although closely related to the anthropological field of material culture which deals with physical objects created or used within a living or past group as mediums of understanding its cultural values.
More recently some anthropology programs began dividing the field into two one emphasizing the humanities and critical theory the other emphasizing the natural sciences and empirical observation.
Historical and institutional context
 Main Article History of anthropology.The anthropologist Eric Wolf once characterized anthropology as the most scientific of the humanities and the most humanistic of the sciences Understanding how anthropology developed contributes to understanding how it fits into other academic disciplines.
Contemporary anthropologists claim a number of earlier thinkers as their forebearers and the discipline has several sources However anthropology can best be understood as an outgrowth of the Age of Enlightenment It was during this period that Europeans attempted systematically to study human behavior Traditions of jurisprudence history philology and sociology developed during this time and informed the development of the social sciences of which anthropology was a part At the same time the romantic reaction to the Enlightenment produced thinkers such as Herder and later Wilhelm Dilthey whose work formed the basis for the culture concept which is central to the discipline.
These intellectual movements in part grappled with one of the greatest paradoxes of modernity as the world is becoming smaller and more integrated people''s experience of the world is increasingly atomized and dispersed As Karl Marx and Friedrich Engels observed in the.
 All old established national industries have been destroyed or are daily being destroyed They are dislodged by new industries whose introduction becomes a life and death question for all civilized nations by industries that no longer work up indigenous raw material but raw material drawn from the remotest zones industries whose products are consumed not only at home but in every quarter of the globe. In place of the old wants satisfied by the production of the country we find new wants requiring for their satisfaction the products of distant lands and climes.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Archaeology','Archaeology Archaeology.
Archaeology or archeology from the Greek words ancient and word speech discourse is the study of human cultures through the recovery documentation and analysis of material remains and environmental data including architecture artefacts biofacts human remains and landscapes.
The goals of archaeology are to document and explain the origins and development of human culture understand culture history chronicle cultural evolution and study human behaviour and ecology for both prehistoric and historic societies.
Ontology and definition
In the Old World archaeology has tended to focus on the study of physical remains the methods used in recovering them and the theoretical and philosophical underpinnings in achieving the subject''s goals The discipline''s roots in antiquarianism and the study of Latin and Ancient Greek provided it with a natural affinity with the field of history In the New World archaeology is more commonly devoted to the study of human societies and is treated as one of the four subfields of Anthropology The other subfields of anthropology supplement the findings of archaeology in a holistic manner These subfields are cultural anthropology which studies behavioural symbolic and material dimensions of culture linguistics which studies language including the origins of language and language groups and physical anthropology which includes the study of human evolution and physical and genetic characteristics Other disciplines also supplement archaeology such as paleontology paleozoology paleoethnobotany paleobotany geography geology art history and classics.
Archaeology has been described as a craft that enlists the sciences to illuminate the humanities Writing in the American archaeologist Walter Taylor asserted that Archaeology is neither history nor anthropology As an autonomous discipline it consists of a method and a set of specialised techniques for the gathering or ''production'' of cultural information.
Archaeology is an approach to understanding human culture through its material remains regardless of chronology In England archaeologists have uncovered the long lost layouts of medieval villages abandoned after the crises of the century and the equally lost layouts of century parterre gardens swept away by a change in fashion In downtown New York City archaeologists have exhumed the century remains of the Black burial ground Traditional Archaeology is viewed as the study of pre historical human cultures that is cultures that existed before the development of writing for that culture Historical archaeology is the study of post writing cultures.
In the study of relatively recent cultures which have been observed and studied by Western scholars archaeology is closely allied with ethnography This is the case in large parts of North America Oceania Siberia and other places where the study of archaeology mingles with the living traditions of the cultures being studied Kennewick_Man is an example of archaeology interacting with modern culture In the study of cultures that were literate or had literate neighbours history and archaeology supplement one another for broader understanding of the complete cultural context as at Hadrian''s Wall.Excavation is just one stage of archaeological research.
Importance and applicability
Most of human history is not described by any written records Writing did not exist anywhere in the world until about years ago and only spread among a relatively small number of technologically advanced civilisations In contrast Homo sapiens have existed for at least years and other species of Homo for millions of years see Human evolution These civilisations are not coincidentally the best known they have been open to the inquiry of historians for centuries while the study of pre historic cultures has arisen only recently Even within a civilisation that is literate at some levels many important human practices are not officially recorded.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Agricultural science','Agricultural science Agricultural science Agricultural science is a broad multidisciplinary field that encompasses the parts of exact natural economic and social sciences that are used in the practice and understanding of agriculture Veterinary science is often excluded from the definition.
Agriculture and agricultural science.
The two terms are often confused However they cover different concepts.
 Agriculture is the set of activities that transform the environment for the production of animals and plants for human use Agriculture concerns techniques including the application of agronomic research.
 Agronomy is research and development related to studying and improving plant based agriculture.
Agricultural sciences include research and development on.
 Production techniques e g irrigation management recommended nitrogen inputs. Improving production in terms of quantity and quality e g selection of drought resistant crops development of new pesticides yield sensing technologies simulation models of crop growth in vitro cell culture techniques. Transformation of primary products into end consumer products e g production preservation and packaging of dairy products. Prevention and correction of adverse environmental effects e g soil degradation waste management bioremediation. Theoretical production ecology relating to crop production modelling.
 Agricultural science a local science.
With the exception of theoretical agronomy research in agronomy more than in any other field is strongly related to local areas It can be considered a science of ecoregions because it is closely linked to soil properties and climate which are never exactly the same from one place to another Many people think an agricultural production system relying on local weather soil characteristics and specific crops has to be studied locally Others feel a need to know and understand production systems in as many areas as possible.
 History of agricultural science.Main Article History of agricultural science
Agricultural science today is very different from what it was before about Intensification of agriculture since the in developed and developing countries often referred to as the Green Revolution was closely tied to progress made in selecting and improving crops and animals for high productivity as well as to developing additional inputs such as artificial fertilizers and phytosanitary products.
However environmental damage due to intensive agriculture industrial development and population growth have raised many questions among agricultural scientists and have led to the development and emergence of new fields e g integrated pest management waste treatment technologies landscape architecture genomics.
New technologies such as biotechnology and computer science for data processing and storage and technological advances have made it possible to develop new research fields including genetic engineering agrophysics improved statistical analysis and precision farming.
 Prominent agricultural scientists.
 Norman Borlaug
 Luther Burbank
 Louis Pasteur
 Gregor Mendel
 Ren Dumont
 George Washington Carver
 Agricultural science and agriculture crisis
Agriculture sciences seek to feed the world''s population while preventing biosafety problems that may affect human health and the environment This requires promoting good management of natural resources and respect for the environment.
Economic environmental and social aspects of agriculture sciences are subjects of ongoing debate Recent crises such as mad cow disease and issues such as the use of genetically modified organisms illustrate the complexity and importance of this debate.
 Fields of agricultural science.
 Agricultural engineering
 Biosystems engineering
 Aquaculture
 Agronomy and Horticulture
 Agrophysics. Animal science
 Plant fertilization animal and human nutrition
 Plant protection and animal health
 Soil science especially edaphology. water science. Biotechnology genetic engineering and microbiology');
 
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Alchemy','Alchemy Alchemy For other uses see disambiguation.
Alchemy is an early protoscientific practice combining elements of chemistry physics astrology art semiotics metallurgy medicine and mysticism These practices were usually used outside of what is now known as the scientific method however alchemy can be regarded as the precursor of the modern science of chemistry prior to the formulation of the scientific method.
The most well known goal of alchemy was the transmutation of any metal into either gold or silver Alchemists also tried to create a Panacea a remedy that supposedly would cure all diseases and prolong life indefinitely The Philosopher''s stone was believed to be an essential ingredient in these goals This mythical substance was hypothesized to have the ability to do both A third goal of many alchemists was creating human life.
Over time the goals of alchemy were totally reinterpreted by many readers of the subject Many readers came to believe that these goals of alchemy were really metaphors for a spiritual transformation of the self They then wrote manuals that reinterpreted alchemy as a spiritual practice For this reason many alchemy manuals describe the Philosopher''s Stone as a gift that every man potentially has unto himself the Transmutation as the process that transform the alchemist by studying sciences and the Panacea as the true meaning of love and science These writers felt that when reading a book on alchemy the reader must read over the words to figure out the way to follow decoding the secret text to discover its true meaning This approach remains common to adherents of Kabbalah Jewish mysticism who often employ gematria and notariqon to expand their understanding of their religious texts especially the Torah.
Etymology
Wiktionary logo en png. Look up alchemy on Wiktionary the free dictionary.
The word alchemy comes from the Arabic al k miya or al kh miya or which is probably formed from the article al and the Greek word chumeia meaning cast together pour together weld alloy etc from khumatos that which is poured out an ingot.
Some believe that the Arabic word al k miya means the Egyptian science borrowing the Coptic word k me or from the mediaeval Bohairic dialect of Coptic which wrote the word kh me meaning Egypt The Coptic word derives from Demotic km itself from ancient Egyptian kmt The ancient Egyptian word referred to both the country and the colour black Egypt was the Black land by contrast with the Red land the surrounding desert so it is thought that such a borrowing in Arabic was appropriate for Egyptian black arts However a decree of Diocletian written about CE in Greek speaks against the ancient writings of the Egyptians which treat of the kh mia transmutation of gold and silver The Arabic therefore could derive from a purely Greek word not Coptic and have been later connected with ancient Egypt through what linguists term a folk etymology.
Overview
The alchemist by Sir William Fettes Douglas
The common perception of alchemists is that they were pseudo scientists who attempted to turn lead into gold believed all existence was composed of the four elements of earth air fire and water which they saw as similar in concept to the ''phase states'' of modern chemistry rather than types of atoms as modern science uses the word ''element ''.
They were attempting to explore and investigate nature before the basic scientific tools and practices were available relying instead on rules of thumb traditions basic observations and mysticism to fill in the gaps Alchemists were often involved in mysticism and magic.
To the alchemist there was no compelling reason to separate the chemical material dimension from the interpretive symbolic or philosophical one In those times a physics devoid of metaphysical insight would have been as partial and incomplete as a metaphysics devoid of physical manifestation.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Automatic Dependent Surveillance-Broadcast','Automatic Dependent Surveillance Broadcast Automatic Dependent Surveillance Broadcast Automatic Dependent Surveillance Broadcast also called ADS B is a system by which airplanes constantly broadcast their current position and altitude category of aircraft airspeed identification and whether the aircraft is turning climbing or descending over a dedicated radio datalink This functionality is known as ADS B out and is the basic level of ADS B functionality.
The ADS B system was developed in the It relies on data from the Global Positioning System or any navigation system that provides an equivalent or better service The maximum range of the system is line of sight typically less than nautical miles km.
The ADS B transmissions are received by air traffic control stations and all other ADS B equipped aircraft within reception range Reception by aircraft of ADS B data is known as ADS B in.
The initial use of ADS B is expected to be by air traffic control and for surveillance purposes and for enhancing pilot situational awareness ADS B is lower cost than conventional radar and permits higher quality surveillance of airborne and surface movements ADS B is effective in remote areas or in mountainous terrain where there is no radar coverage or where radar coverage is limited The outback of Australia is one such area where ADS B will provide surveillance where previously none existed ADS B also enhances surveillance on the airport surface so it can also be used to monitor traffic on the taxiways and runways of an airport.
ADS B equipped aircraft may also have a display unit in the cockpit picturing surrounding air traffic from ADS B data ADS B in and TIS B Traffic Information Service Broadcast data derived from air traffic radar Both Pilots and air traffic controllers will then be able to see the positions of air traffic in the vicinity of the aircraft and this may be used to provide an ASAS Airborne Separation Assurance System.
Airborne Collision Avoidance Systems may also make use of ADS B in supplementing the existing TCAS collision avoidance system.
Airbus and Boeing are now expected to include ADS B out i e the transmitter of information as standard on new build aircraft from onwards This is in part due to the European requirements for Mode S Elementary Surveillance which uses Extended Squitter and some common functionality with ADS B out.
The currently used data links for ADS B are i MHz the same frequency the transponder replies to secondary surveillance radar interrogations ii MHz Universal Access Transceiver and iii VHF Digital link mode VDL Mode MHz Extended Squitter is the globally agreed standard for ADS B for air carrier aircraft with existing Mode S transponders The has limited capacity and is therefore limited to supporting just ADS B The UAT has been used operationally in the United States since and supports air traffic separation services in Alaska The UAT provides significant communications bandwidth and in addition to ADS B provides no fee traffic TIS B and weather FIS B uplink services see FAA''s Safe Flight link below The VDL has been used in several demonstration programs throughout Europe.
 Projects and Trials.The FAA has been developing ADS B since the early and has transitioned its demonstration programs into operational systems. 	Safe Flight Capstone followed by Capstone II 
 Safe Flight East Coast Deployment of Broadcast Services present
ADS B initial projects and trials in Europe first started around Standardisation activities started at a similar time and have grown in intensity since Both areas are now seeing a significant amount of work.
It is expected that implementations of pre operational and then operational systems will occur in future years for example the SEAP project South European ADS B Project and NUP II project are both looking at pre operational trials in.
Dates of some example ADS B projects and trials evaluations are.
 	NEAN January December 
 OpEval Operational Evaluation at Wilmington Ohio');
 
INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Austria','Austria Austria.
 N E.
 Slovenian reg Croatian reg Hungarian reg.
 Chancellor.
 Heinz Fischer
 Wolfgang Sch ssel
 State Treaty
 July 
 Total
 Water.
 km.
 est.
 census
 Density
 km.
 Total
 Per capita
 billion.
 Summer DST.
 CEST UTC.
The Republic of Austria German Republik sterreich is a landlocked country in central Europe It borders Germany and the Czech Republic to the north Slovakia and Hungary to the east Slovenia and Italy to the south and Switzerland and Liechtenstein to the west The capital is the city of Vienna.
Austria is a parliamentary representative democracy consisting of nine federal states and is one of two European countries that have declared their everlasting neutrality the other being Switzerland Austria is a member of United Nations and the European Union.
 Origin and history of the name.
The German name sterreich can be translated into English as the eastern realm which is derived from the Old German Ostarr chi Reich can also mean empire and this connotation is the one that is understood in the context of the Austrian Austro Hungarian Empire German Empire Third Reich or Holy Roman Empire although not in the context of the modern Republic of sterreich The term probably originates in a vernacular translation of the Medieval Latin name for the region Marchia orientalis which translates as eastern border as it was situated at the eastern edge of the Holy Roman Empire that was also mirrored in the name Ostmark applied after Anschluss to the Third Reich.
 History. For more details on this topic see History of Austria.
 Austria and the Holy Roman Empire.
The territory of Austria by then the Celtic kingdom of Noricum which was a long time ally of Rome cattle and early steel and rather occupied than conquered by the Romans during the reign of Augustus and made the province Noricum in BC Later it was conquered by Huns Rugii Lombards Ostrogoths Bavarii Avars till about and Franks in that order Finally after years of Hungarian rule to the core territory of Austria was awarded to Leopold of Babenberg in Being part of the Holy Roman Empire the Babenbergs ruled and expanded Austria from the century to the century.
Battle of Vienna 
After Duke Frederick II died in and left no successor the German King Rudolf I of Habsburg gave the lands to his sons marking the beginning of the line of the Habsburgs who continued to govern Austria until the century.
With the short exception of Charles VII Albert of Bavaria Austrian Habsburgs held the position of German Emperor beginning in with Albert II of Habsburg until the end of the Holy Roman Empire During the and century Austria continued to expand its territory until it reached the position of a European superpower at the end of the century until the end of the Habsburg monarchy in.
 Modern history.
After the abolition of the Holy Roman Empire in the Empire of Austria was founded which was transformed in into the double monarchy Austria Hungary The empire was split into several independent states in after the defeat of the Central Powers in World War I with most of the German speaking parts becoming a republic See Treaty of Saint Germain Between and it was officially known as the Republic of German Austria Republik Deutsch sterreich After the Entente powers forbade German Austria to unite with Germany they also forbade the name and then it was changed to simply Republic of Austria The democratic republic lasted until when the chancellor Engelbert Dollfu established an autocratic regime oriented towards Italian fascism Austrofascism.
Austria became part of Germany in the Anschlu amidst popular acclaim After the defeat of the Axis Powers the Allies occupied Austria at the end of World War II in Europe until when the country again became a fully independent republic under the condition that it remained neutral see also Austrian State Treaty.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Australia','Australia Australia.
 S E.
 Governor General
 Prime Minister.
 Elizabeth II
 Michael Jeffery
 John Howard
 Constitution Act
 Statute of Westminster
 Australia Act
 January 
 December 
 March 
 Total
 Water.
 km.
 September est.
 census
 Density
 km.
 Total
 Per capita
 billion.
 Summer DST.
 various UTC.
The Commonwealth of Australia is a country in the Southern Hemisphere comprising the world''s smallest continent and a number of islands in the Southern Indian and Pacific Oceans Australia''s neighbouring countries are Indonesia East Timor and Papua New Guinea to the north the Solomon Islands Vanuatu and New Caledonia to the north east and New Zealand to the south east.
The continent of Australia has been inhabited for over years by Indigenous Australians After sporadic visits by fishermen from the north and by European explorers and merchants starting in the century the eastern half of the continent was claimed by the British in and officially settled as the penal colony of New South Wales on January As the population grew and new areas were explored another five largely self governing Crown Colonies were successively established over the course of the century.
On January the six colonies federated and the Commonwealth of Australia was formed Since federation Australia has maintained a stable liberal democratic political system and remains a Commonwealth Realm The current population of around million is concentrated mainly in the large coastal cities of Sydney Melbourne Brisbane Perth and Adelaide.
 Origin and history of the name.
The name Australia is derived from the Latin australis meaning southern Legends of an unknown southern land terra australis incognita date back to the Roman times and were commonplace in medi val geography but they were not based on any actual knowledge of the continent The Dutch adjectival form Australische Australian in the sense of southern was used by Dutch officials in Batavia to refer to the newly discovered land to the south as early as The first English language writer to use the word Australia was Alexander Dalrymple in An Historical Collection of Voyages and Discoveries in the South Pacific Ocean published in He used the term to refer to the entire South Pacific region not specifically to the Australian continent In George Shaw and Sir James Smith published Zoology and Botany of New Holland in which they wrote of the vast island or rather continent of Australia Australasia or New Holland.View of Port Jackson taken from the South Head from A Voyage to Terra Australis Sydney was established on this site.The name Australia was popularised by the work A Voyage to Terra Australis by the navigator Matthew Flinders Despite its title which reflected the view of the Admiralty Flinders used the word Australia in the book which was widely read and gave the term general currency Governor Lachlan Macquarie of New South Wales subsequently used the word in his dispatches to England In he recommended that it be officially adopted In the British Admiralty finally accepted that the continent should be known officially as Australia.
The word Australia in Australian English is pronounced st lj st li or st j.
 History. Main article History of Australia.Lieutenant James Cook charted the East coast of Australia on HM Bark Endeavour claiming the land for Britain in This replica was built in Fremantle in for Australia''s bicentenary.The first human habitation of Australia is estimated to have occurred between and years ago The first Australians were the ancestors of the current Indigenous Australians they arrived via land bridges and short sea crossings from present day Southeast Asia Most of these people were hunter gatherers with a complex oral culture and spiritual values based on reverence for the land and a belief in the Dreamtime.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('American Samoa','American Samoa American Samoa This article was imported from the CIA World Factbook and needs to be rewritten and or reformatted in accordance with Wikipedia styles.
 Total
 water
 km.
 Total.
 Density.
 km.
American Samoa Samoan Amerika Samoa is an unorganized unincorporated territory of the United States in the South Pacific Ocean to the East of the larger state of Samoa.
History
Originally inhabited as early as BC Samoa was reached by European explorers in the century.
International rivalries in the latter half of the century were settled by an Treaty of Berlin in which Germany and the U S divided the Samoan archipelago The U S formally occupied its portion a smaller group of eastern islands with the noted harbor of Pago Pago the following year see History of Samoa for more The western islands are now the independent state of Samoa.
After the U S took possesion of American Samoa the U S Navy built a coaling station in Pago Pago Bay for its Pacific Squadron and appointed a local Secretary The navy secured a Deed of Cession of Tutuila in and a Deed of Cession of Manu a in During World War II U S Marines in American Samoa outnumbering the local population had a huge cultural influence After the war Organic Act a U S Department of Interior sponsored attempt to incorporate American Samoa was defeated in Congress primarily through the efforts of American Samoan chiefs led by Tuiasosopo Mariota These chiefs'' efforts led to the creation of a local legislature the American Samoa Fono.
In time the Navy appointed governor was replaced by a locally elected one Although technically considered unorganized in that the U S Congress has not passed an Organic Act for the territory American Samoa is self governing under a constitution that became effective on July The U S Territory of American Samoa is on the United Nations list of Non Self Governing Territories a listing which is disputed by the country.
Trivia
 American Samoa is the location of Rose Atoll the southernmost point in the United States if insular areas and territories are included see extreme points for more information. Goods manufactured in territories or protectorates of the United States including American Samoa can be labeled Made in the USA. About ethnic Samoans many from American Samoa currently play in the National Football League It has been estimated that a Samoan male either an American Samoan or a Samoan living in the United States is times more likely to play in the NFL than a non Samoan American A number have also ventured into professional wrestling. Persons born in American Samoa are United States nationals but not United States citizens This is virtually the only circumstance under which an individual would be one and not the other. The American Samoa national soccer team holds an unwanted world record in international soccer the record defeat in an international match a crushing by Australia on April.
Map
American Samoa
See also
Government
 List of American Samoa Governors''''
 Elections in American_Samoa
Sports
 American Samoa at the Summer Olympics
 American Samoa at the Summer Olympics
 American Samoa national rugby league team
 American Samoa national soccer team
CIA Factbook Data
From the CIA World Factbook. Geography of American Samoa
 Demographics of American Samoa
 Politics of American Samoa
 Economy of American Samoa
 Communications in American Samoa
 Transportation in American Samoa
 Military Defense is the responsibility of the US
External links
Wikinews
 Wikinews has news related to. American Samoa
 CIA The World Factbook American Samoa CIA''s Factbook on American Samoa
 History of American Samoa Essay which looks at the history of the territory from ancient to more modern times. Jane''s American Samoa Page
 Library of Congress Portals of the World American Samoa Library of Congress resource which provides links to resources on American Samoa. Map of American Samoa.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Alien','Alien Alien. Wiktionary logo en png. Look up alien on Wiktionary the free dictionary.
Alien may mean. Extraterrestrial life in both scientific and popular contexts
 Alien law a person who is neither a native nor a citizen of their country of residence
 Alien film by Ridley Scott which spawned several sequels. Aliens
 Alien. Alien Resurrection
 Alien vs Predator a crossover with the Predator series of films
 Xenomorph the fictional creature featured in the Alien series
 Alien biology a non native species
 Alien computing a program that converts between different Linux package distribution file formats
Aliens may mean. The Aliens Roky Erickson''s backing band
 Aliens From Space a novel by Donald Keyhoe
 Aliens of the Deep a documentary by James Cameron
This is a disambiguation page a list of pages that otherwise might share the same title If an article link referred you to this title you might want to go back and fix it to point directly to the intended page.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Astronomer','Astronomer Astronomer An astronomer or astrophysicist is a scientist whose area of research is astronomy or astrophysics.Johannes Hevelius was famed for his work on sunspots and being the first to study the surface of the moon.
Astronomy is generally thought to have begun in ancient Babylon by the Persian Zoroastrian priests the magi Recent studies of Babylonian records have shown them to be extremely accurate for the ancient night sky Following the Babylonians the egyptians also had an emphasis on observations of the sky.
Mixtures of religious interpretations of the sky as mythic tales of the gods led to a duality that we now identify as astrology It is important to recognize that before about there was no distinction between astronomy and astrology.
Unlike most scientists astronomers cannot directly interact with the celestial bodies and so instead must resort to detailed observation in order to make discoveries Generally astronomers use telescopes or other imaging equipment to make such observations.
 Famous astronomers.
 See also.
 Amateur astronomy
 List of astronomers
There is also a well known painting by Johannes Vermeer titled The Astronomer which is often linked to Vermeer''s The Geographer These paintings are both thought to represent the growing influence and rise in prominence of scientific inquiry in Europe at the time of their painting.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('ASCII','ASCII ASCII For other uses see disambiguation.There are printable ASCII characters numbered to.ASCII American Standard Code for Information Interchange generally pronounced ski ASK ee is a character set and a character encoding based on the Roman alphabet as used in modern English see English alphabet ASCII codes represent text in computers in other communications equipment and in control devices that work with text Most recent character encoding has an ASCII like base.
ASCII defines the following printable characters presented here in numerical order of their ASCII value.
 amp ''.. ABCDEFGHIJKLMNOPQRSTUVWXYZ _
 abcdefghijklmnopqrstuvwxyz
 Printable Representation the Unicode glyphs reserved for representing control characters when it is necessary to print or display them rather than have them perform their intended function. Control key Sequence the traditional key sequences for inputting control characters The caret represents the Control or Ctrl key that must be held down while pressing the second key in the sequence The caret key representation is also used by some software to represent control characters. The Backspace character can also be entered by pressing the Backspace Bksp or key on some systems. The Delete character can also be entered by pressing the Delete or Del key It can also be entered by pressing the Backspace Bksp or key on some systems. The Escape character can also be entered by pressing the Escape or Esc key on some systems. The Carriage Return character can also be entered by pressing the Return Ret Enter or key on most systems. The ambiguity surrounding the Backspace key comes from systems that translated the DEL control character into a BS backspace before transmitting it Some software was unable to process the character and would display H instead H persists in messages today as a deliberate humorous device e g there''s a sucker H H H H H H potential customer born every minute A less common variant of this involves the use of W which in some text editors means delete previous word The example sentence would therefore also work as there''s a sucker W potential customer born every minute.
ASCII printable characters
Code the space character denotes the space between words as produced by the large space bar of a keyboard Codes to known as the printable characters represent letters digits punctuation marks and a few miscellaneous symbols.
Seven bit ASCII provided seven national characters and if the combined hardware and software permit can use overstrikes to simulate some additional international characters in such a scenario a backspace can precede a grave accent which the American and British standards but only those standards also call opening single quotation mark a tilde or a breath mark inverted vel.
Processors can convert uppercase characters to lowercase by adding to their ASCII value in binary devices can accomplish this simply by setting the sixth least significant bit to.
Aliases for ASCII
RFC published in June and the IANA registry of character sets ongoing both recognize the following case insensitive aliases for ASCII as suitable for use on the Internet.
 canonical name. 
 ASCII
 US ASCII preferred MIME name. us
 US
 irv 
 iso ircs
 ASCII
Of these only the aliases US ASCII and ASCII have achieved widespread use One often finds them in the optional charset parameter in the Content Type header of some MIME messages in the equivalent meta element of some HTML documents and in the encoding declaration part of the prolog of some XML documents.
Variants of ASCII
As computer technology spread throughout the world different standards bodies and corporations developed many variations of ASCII in order to facilitate the expression of non English languages that used Roman based alphabets One could class some of these variations as ASCII extensions although some mis apply that term to cover all variants including those that do not preserve ASCII''s character map in the bit range.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Africa','Africa Africa.
Africa is the world''s second largest continent and second most populous after Asia At about km mi including its adjacent islands it covers percent of the total land area on Earth With over million human inhabitants in countries it accounts for about one seventh of the world human population A satellite composite image of Africa
Etymology
World map showing Africa geographically The name Africa came into Western use through the Romans who used the name Africa terra land of the Afri plural or Afer singular for the northern part of the continent as the province of Africa with its capital Carthage corresponding to modern day Tunisia.
The origin of Afer may either come from. the Phoenician afar dust. the Afri a tribe possibly Berber who dwelt in North Africa in the Carthage area. the Greek word aphrike meaning without cold see also List of traditional Greek place names. or the Latin word aprica meaning sunny.
The historian Leo Africanus attributed the origin to the Greek word phrike meaning cold and horror combined with the negating prefix a so meaning a land free of cold and horror However the change of sound from ph to f in Greek is datable to about the first century so this cannot really be the origin of the name.
Egypt was considered part of Asia by the ancients and first assigned to Africa by the geographer Ptolemy AD who accepted Alexandria as Prime Meridian and made the isthmus of Suez and the Red Sea the boundary between Asia and Africa As Europeans came to understand the real extent of the continent the idea of Africa expanded with their knowledge.
Geography
Main article Geography of Africa
Africa in the Blue marble picture with Antarctica to the south and the Sahara and Arabian peninsula at the top of the globe
Africa is the largest of the three great southward projections from the main mass of the Earth''s surface It includes within its remarkably regular outline an area of c km mi including the islands.
Separated from Europe by the Mediterranean Sea it is joined to Asia at its northeast extremity by the Isthmus of Suez transected by the Suez Canal km miles wide Geopolitically Egypt''s Sinai Peninsula east of the Suez Canal is often considered part of Africa as well From the most northerly point Cape Spartel in Morocco a little west of Cape Blanc in N to the most southerly point Cape Agulhas in South Africa S is a distance approximately of km miles from Cape Verde W the westernmost point to Ras Hafun in Somalia E the most easterly projection is a distance also approximately of km miles The length of coast line is km miles and the absence of deep indentations of the shore is shown by the fact that Europe which covers only km square miles has a coast line of km miles.
The main structural lines of the continent show both the east to west direction characteristic at least in the eastern hemisphere of the more northern parts of the world and the north to south direction seen in the southern peninsulas Africa is thus composed of two segments at right angles the northern running from east to west the southern from north to south the subordinate lines corresponding in the main to these two directions.
History
Main article History of Africa
Map of Africa 
Africa is home to the oldest inhabited territory on earth with the human race originating from this continent The Ishango Bone carbon dated to c years ago shows tallies in mathematical notation.
Throughout humanity''s prehistory Africa like all other continents had no nation states and was instead inhabited by groups of hunter gatherers.Around B C the nation state of Egypt developed which existed with various levels of influence until B C Other civilizations include Ethiopia the Nubian kingdom the kingdoms of the Sahel Ghana Mali and Songhai and Great Zimbabwe.
In the Portuguese established the first of many trading stations along the Guinea coast at Elmina.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Allan Dwan','Allan Dwan Allan Dwan Allan Dwan April December was a pioneering Canadian born American motion picture director producer and screenwriter.
Born Joseph Aloysius Dwan in Toronto Ontario Canada his family moved to the United States when he was eleven years of age At university he trained as an engineer and began working for a lighting company in Chicago Illinois However he had a strong interest in the fledgling motion picture industry and when Essanay Studios offered him the opportunity to become a scriptwriter he took the job At that time some of the East Coast movie makers began to spend winters in California where the climate allowed them to continue productions requiring warm weather Soon a number of movie companies worked there year round and in Dwan began working part time in Hollywood While still in New York in he was the founding president of the East Coast chapter of the Motion Picture Directors Association.
Allan Dwan became a true innovator in the motion picture industry After making a series of westerns and comedies he directed fellow Canadian Mary Pickford in several very successful movies as well as her husband Douglas Fairbanks notably in the acclaimed Robin Hood.
Following the introduction of the talkies in he directed child star Shirley Temple in Heidi and Rebecca of Sunnybrook Farm the following year.
Over his long and successful career spanning over fifty years he directed over motion pictures many of them highly acclaimed such as the box office smash The Sands of Iwo Jima His last movie was in.
Dwan is one of the directors who spanned the silent to sound era Most of the silent movies he directed are lost due to poor preservation Little historical writing has been devoted to Dwan but some believe that he will be the last discovered great director from the Classic Hollywood Era.
He died in Los Angeles at the age of ninety six and is interred in the San Fernando Mission Cemetery Mission Hills California.
Allan Dwan has a star on the Hollywood Walk of Fame at Hollywood Boulevard in Hollywood.
Selected films
As director. Manhattan Madness. Fairbanks Fine Arts. Fairbanks Fragments also screenwriter. Robin Hood. The Iron Mask. Heidi. Rebecca of Sunnybrook Farm The Little Colonel. Rebecca of Sunnybrook Farm. The Three Musketeers. The Gorilla. Young People. Look Who''s Laughing also producer. Friendly Enemies. Around the World also producer
 Up in Mabel''s Room. Abroad With Two Yanks. Getting Gertie''s Garter also screenwriter. Brewster''s Millions. Driftwood. Calendar Girl. Northwest Outpost also associate producer. Sands of Iwo Jima. Montana Belle. Silver Lode. Passion. Cattle Queen of Montana. Tennessee''s Partner. Pearl of the South Pacific. Escape to Burma. Slightly Scarlet. The Restless Breed. Enchanted Island.
See also Canadian pioneers in early Hollywood');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Technology in Atlas Shrugged','Technology in Atlas Shrugged Technology in Atlas Shrugged Technology in Atlas Shrugged Ayn Rand''s novel includes a variety of technological products and devices In addition to real world technology aircraft automobiles diesel engines phonograph records radios telephones television and traffic signals Atlas Shrugged also includes various fictional technologies or fictional variants on real inventions.
Spoiler warning Plot and or ending details follow.
Fictional technology
Fictional inventions mentioned in the book include refractor rays Gulch mirage Rearden Metal a sonic death ray Project X voice activated door locks Gulch power station motors powered by static electricity palm activated door locks Galt''s NY lab shale oil drilling and a nerve induction torture machine.
Traffic Signals
Early on the book mentions the screech of a traffic signal as it changes This implies the older technology of mechanical traffic signals the kind which displayed a pennant or flag indicating stop or go and the inverse indicator in the opposite direction Traffic signals using lights have been around for over years so anything of this type is very old compared to today.
Project X
Project X is an invention of the scientists at the state science institute requiring tons of Rearden Metal Basically it is a death ray and is capable of destroying anything The scientists claim that the project will be used to preserve peace and squash rebellion It is destroyed towards the end of the book and emits a pulse of radiation that destroys everything in the surrounding area including Cuffy Meigs and Dr Stadler as well as the Taggart Bridge.
Rearden Metal
Rearden metal is a fictitious metal alloy invented by Hank Rearden It is lighter than traditional steel but stronger and is to steel what steel was to iron It is described as greenish blue Among its ingredients are iron and copper.
Initially no one is willing to use Rearden metal because no one wants to stick his neck out and be the first to try it Finally Dagny Taggart places an order for Rearden Metal when she needs rails to rebuild the dying Rio Norte Line.
The first thing made from Rearden metal is a bracelet.
Rearden metal is mentioned in sections and.');

INSERT INTO WIKISAMPLE(TITLE,TEXT) values ('Arraignment','Arraignment Arraignment Arraignment is a common law term for the formal reading of a criminal complaint in the presence of the defendant to inform him of the charges against him In response to arraignment the accused is expected to enter a plea Acceptable pleas vary from jurisdiction to jurisdiction but they generally include guilty not guilty and the peremptory pleas or pleas in bar which set out reasons why a trial cannot proceed In addition US jurisdictions allow pleas of nolo contendere no contest and the Alford plea in some circumstances.
In the UK arraignment is the first of eleven stages in a criminal trial and involves the clerk of the court reading out the indictment The defendant is asked whether they plead guilty or not guilty to each individual charge.
Guilty and Not Guilty pleas
If the defendant pleads guilty an evidentiary hearing usually follows The court is not required to accept a guilty plea During that hearing the judge will assess the offense mitigating factors and the defendant''s character and then pass sentence If the defendant pleads not guilty a date will be set for a preliminary hearing or trial.
What if the defendant enters no plea.In the past a defendant who refused to plea or stood mute would be subjected to peine forte et dure But today in all common law jurisdictions defendants who refuse to enter a plea will have a plea of not guilty entered for them on their behalf.
The Federal Rules of Criminal Procedure
The US Federal Rules of Criminal Procedure state arraignment shall consist of an open reading of the indictment to the defendant and calling on him to plead thereto He shall be given a copy of the indictment before he is called upon to plead.');

SELECT * FROM DUAL;
COMMIT;