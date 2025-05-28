BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "CATEGORY" (
	"DURATION"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("DURATION")
);
CREATE TABLE IF NOT EXISTS "GYM" (
	"Location"	string NOT NULL,
	"Address"	varchar NOT NULL,
	"Phone"	varchar NOT NULL,
	"Email"	varchar NOT NULL UNIQUE,
	"Schedule"	varchar NOT NULL,
	PRIMARY KEY("Location")
);
CREATE TABLE IF NOT EXISTS "GYM_PROVIDES_PROGRAM_SESSION" (
	"PROGRAM_Name"	varchar NOT NULL,
	"GYM_Location"	string NOT NULL,
	"SESSION_ID"	integer NOT NULL,
	PRIMARY KEY("PROGRAM_Name","GYM_Location","SESSION_ID"),
	FOREIGN KEY("GYM_Location") REFERENCES "GYM"("Location") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("PROGRAM_Name") REFERENCES "PROGRAM"("Name") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("SESSION_ID") REFERENCES "SESSION"("ID") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "PROGRAM" (
	"Name"	varchar NOT NULL,
	"Description"	text,
	"Price_ana_Session"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("Name")
);
CREATE TABLE IF NOT EXISTS "SESSION" (
	"ID"	integer NOT NULL,
	"Max_Number_Of_People"	INTEGER NOT NULL DEFAULT 0,
	"Date"	date NOT NULL,
	"Time"	time NOT NULL,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "SUBSCRIPTION" (
	"Description"	text,
	"Price"	INTEGER NOT NULL DEFAULT 0,
	"ID"	integer NOT NULL,
	"CATEGORY_Duration"	INTEGER NOT NULL,
	"gym_Location"	string NOT NULL,
	PRIMARY KEY("ID","gym_Location"),
	FOREIGN KEY("CATEGORY_Duration") REFERENCES "CATEGORY"("DURATION") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("gym_Location") REFERENCES "GYM"("Location") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "USER" (
	"Name"	varchar NOT NULL,
	"ID"	integer NOT NULL,
	"Email"	varchar NOT NULL UNIQUE,
	"Password"	varchar NOT NULL,
	"Phone"	varchar NOT NULL,
	"Location"	varchar NOT NULL,
	"Surname"	varchar NOT NULL,
	PRIMARY KEY("ID" AUTOINCREMENT),
	CONSTRAINT "PASS_CHECK" CHECK(LENGTH(CAST("Password" AS TEXT)) >= 5)
);
CREATE TABLE IF NOT EXISTS "USER_RESERVES_SESSION" (
	"USER-ID"	INTEGER NOT NULL,
	"SESSION-ID"	integer NOT NULL,
	PRIMARY KEY("USER-ID","SESSION-ID"),
	FOREIGN KEY("SESSION-ID") REFERENCES "SESSION"("ID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("USER-ID") REFERENCES "USER"("ID") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "USER_SUBSCRIPTION" (
	"USER-ID"	INTEGER NOT NULL,
	"SUBSCRIPTION-ID"	INTEGER NOT NULL,
	"Start_Date"	date NOT NULL,
	"End_Date"	date NOT NULL,
	"gym_Location"	string NOT NULL,
	PRIMARY KEY("USER-ID","SUBSCRIPTION-ID","gym_Location"),
	FOREIGN KEY("USER-ID") REFERENCES "USER"("ID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("gym_Location","SUBSCRIPTION-ID") REFERENCES "SUBSCRIPTION"("gym_Location","ID"),
	CONSTRAINT "DATE_CHECK" CHECK("Start_Date" < "End_Date")
);
INSERT INTO "CATEGORY" VALUES (1);
INSERT INTO "CATEGORY" VALUES (3);
INSERT INTO "CATEGORY" VALUES (6);
INSERT INTO "CATEGORY" VALUES (12);
INSERT INTO "GYM" VALUES ('Αθήνα (Μαρούσι)','Λεωφόρος Κηφισίας 101','210-1234567','gym_on_marousi@gymon.gr','Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή 10:00-17:00');
INSERT INTO "GYM" VALUES ('Αθήνα (Περιστέρι)','Σταδίου 10','210-1111111','gym_on_peristeri@gymon.gr','Δευτέρα-Παρασκευή 07:00-22:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Αθήνα (Χαλάνδρι)','Ιεραποστόλου 12','210-2222222','gym_on_chalandri@gymon.gr','Δευτέρα-Παρασκευή 07:00-22:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Θεσσαλονίκη (Κέντρο)','Τσιμισκή 22','2310-123456','gym_on_thess_cender@gymon.gr','Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Πάτρα','Κορίνθου 50','2610-000000','gym_on_patra@gymon.gr','Δευτέρα-Παρασκευή 09:00-20:00, Σάββατο 10:00-14:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Ηράκλειο','Λεωφόρος Κνωσού 33','2810-123456','gym_on_irakleio@gymon.gr','Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Λάρισα','Αχιλλέως 90','2410-123456','gym_on_larisa@gymon.gr','Δευτέρα-Παρασκευή 09:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Χανιά','Τζανακάκη 14','28210-123456','gym_on_chania@gymon.gr','Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Θεσσαλονίκη (Τούμπα)','Λεωφόρος Γεωργικής Σχολής 45','2310-987654','gym_on_thess_toumpa@gymon.gr','Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή Κλειστά');
INSERT INTO "GYM" VALUES ('Αθήνα (Γλυφάδα)','Λεωφόρος Βουλιαγμένης 100','210-3333333','gym_on_glyfada@gymon.gr','Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή Κλειστά');
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Χαλάνδρι)',1);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Μαρούσι)',2);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Λάρισα',3);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Αθήνα (Περιστέρι)',4);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Αθήνα (Γλυφάδα)',5);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Μαρούσι)',6);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Αθήνα (Γλυφάδα)',7);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Μαρούσι)',8);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Χανιά',9);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Πάτρα',10);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Λάρισα',11);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Περιστέρι)',12);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Περιστέρι)',13);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Ηράκλειο',14);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Χανιά',15);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Χανιά',16);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Μαρούσι)',17);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Θεσσαλονίκη (Τούμπα)',18);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Αθήνα (Γλυφάδα)',19);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Θεσσαλονίκη (Τούμπα)',20);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Ηράκλειο',21);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Αθήνα (Χαλάνδρι)',22);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Λάρισα',23);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Περιστέρι)',24);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Χανιά',25);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Χανιά',26);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Γλυφάδα)',27);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Θεσσαλονίκη (Τούμπα)',28);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Θεσσαλονίκη (Τούμπα)',29);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Χανιά',30);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Πάτρα',31);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit','Αθήνα (Χαλάνδρι)',32);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Χαλάνδρι)',33);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Περιστέρι)',34);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Αθήνα (Χαλάνδρι)',35);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit','Αθήνα (Περιστέρι)',36);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit','Ηράκλειο',37);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Θεσσαλονίκη (Τούμπα)',38);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Αθήνα (Γλυφάδα)',39);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Περιστέρι)',40);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Γλυφάδα)',41);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Θεσσαλονίκη (Τούμπα)',42);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Χανιά',43);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Πάτρα',44);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit','Θεσσαλονίκη (Κέντρο)',45);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Γλυφάδα)',46);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Χαλάνδρι)',47);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Χανιά',48);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Χαλάνδρι)',49);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Αθήνα (Περιστέρι)',50);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Θεσσαλονίκη (Κέντρο)',51);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Αθήνα (Γλυφάδα)',52);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Λάρισα',53);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Χαλάνδρι)',54);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Πάτρα',55);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Αθήνα (Χαλάνδρι)',56);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Θεσσαλονίκη (Τούμπα)',57);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Θεσσαλονίκη (Τούμπα)',58);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Θεσσαλονίκη (Κέντρο)',59);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Ηράκλειο',60);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Ηράκλειο',61);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Χαλάνδρι)',62);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Πάτρα',63);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Περιστέρι)',64);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Χανιά',65);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Αθήνα (Μαρούσι)',66);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Γλυφάδα)',67);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Χαλάνδρι)',68);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Γλυφάδα)',69);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Θεσσαλονίκη (Τούμπα)',70);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Χανιά',71);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Αθήνα (Χαλάνδρι)',72);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Χανιά',73);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Ηράκλειο',74);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning','Αθήνα (Περιστέρι)',75);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Χανιά',76);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Πάτρα',77);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Θεσσαλονίκη (Κέντρο)',78);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Χανιά',79);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates','Αθήνα (Γλυφάδα)',80);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing','Θεσσαλονίκη (Τούμπα)',81);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit','Αθήνα (Γλυφάδα)',82);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga','Λάρισα',83);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba','Αθήνα (Χαλάνδρι)',84);
INSERT INTO "GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit','Ηράκλειο',85);
INSERT INTO "PROGRAM" VALUES ('Yoga','Μια χαλαρωτική και αναζωογονητική πρακτική που συνδυάζει διατάσεις, ενδυνάμωση, αναπνοές και διαλογισμό. Περιλαμβάνει στάσεις (asanas) που βοηθούν στην ευλυγισία, την ισορροπία και τη μυϊκή σταθερότητα.

Οφέλη για την υγεία:
– Μειώνει το άγχος και ενισχύει τη νοητική διαύγεια
– Βελτιώνει τη στάση σώματος και την κινητικότητα των αρθρώσεων
– Ρυθμίζει την αναπνοή και μειώνει την αρτηριακή πίεση
– Συμβάλλει στη συναισθηματική ισορροπία','10€');
INSERT INTO "PROGRAM" VALUES ('Spinning','Ένα δυναμικό πρόγραμμα ποδηλασίας σε στατικό ποδήλατο, με εναλλαγές έντασης και ρυθμού υπό μουσική. Ιδανικό για την τόνωση της καρδιάς και των ποδιών.

Οφέλη για την υγεία:
– Ενισχύει την καρδιοαναπνευστική ικανότητα
– Καίει πολλές θερμίδες και βοηθά στην απώλεια βάρους
– Τονώνει τα πόδια, τους γλουτούς και τον κορμό
– Μειώνει τον κίνδυνο καρδιοπαθειών','12€');
INSERT INTO "PROGRAM" VALUES ('Kickboxing','Ένα έντονο πρόγραμμα αυτοάμυνας και γυμναστικής που συνδυάζει κινήσεις από πολεμικές τέχνες και αερόβια άσκηση.

Οφέλη για την υγεία:
– Ενισχύει τη δύναμη, την ταχύτητα και την ευλυγισία
– Αυξάνει την αυτοπεποίθηση και μειώνει το στρες
– Βοηθά στην απώλεια βάρους μέσω έντονης καύσης θερμίδων
– Βελτιώνει την ισορροπία και τον συντονισμό σώματος-νου','15€');
INSERT INTO "PROGRAM" VALUES ('Zumba','Ένα διασκεδαστικό πρόγραμμα χορού με έντονη μουσική λάτιν και διεθνή ρυθμούς. Ιδανικό για άτομα που αγαπούν την κίνηση και τη διασκέδαση ενώ γυμνάζονται.

Οφέλη για την υγεία:
– Ενισχύει το καρδιοαναπνευστικό σύστημα
– Βοηθά στη μείωση του άγχους και αυξάνει τα επίπεδα ενέργειας
– Βελτιώνει την αντοχή, την ισορροπία και την ευλυγισία
– Ενισχύει τη διάθεση μέσω της μουσικοχορευτικής έκφρασης','12€');
INSERT INTO "PROGRAM" VALUES ('Pilates','Πρόγραμμα χαμηλής έντασης που στοχεύει στην ενδυνάμωση του πυρήνα (κοιλιακοί, ράχη, λεκάνη) και στη σταθερότητα. Επικεντρώνεται στον έλεγχο της αναπνοής και της κίνησης.

Οφέλη για την υγεία:
– Δυναμώνει τον κορμό και βελτιώνει τη στάση του σώματος
– Μειώνει τον πόνο στη μέση και τις κακώσεις
– Ενισχύει τη συγκέντρωση και την ισορροπία
– Βελτιώνει την κινητικότητα και τη σωματική ευαισθητοποίηση','13€');
INSERT INTO "PROGRAM" VALUES ('Crossfit','Ένα εντατικό και απαιτητικό πρόγραμμα που συνδυάζει βάρη, καρδιοαναπνευστική άσκηση, άλματα, κωπηλασία και γυμναστική. Κάθε προπόνηση είναι διαφορετική και προσαρμοσμένη.

Οφέλη για την υγεία:
– Αυξάνει τη γενική φυσική κατάσταση και την αντοχή
– Αναπτύσσει δύναμη, ταχύτητα και έκρηξη
– Βοηθά στη διαχείριση του στρες μέσω εντατικής δραστηριότητας
– Δημιουργεί αίσθημα κοινότητας και πειθαρχίας','20€');
INSERT INTO "SESSION" VALUES (1,15,'2025-05-28','08:00');
INSERT INTO "SESSION" VALUES (2,10,'2025-05-28','09:00');
INSERT INTO "SESSION" VALUES (3,12,'2025-05-28','10:00');
INSERT INTO "SESSION" VALUES (4,17,'2025-05-28','11:00');
INSERT INTO "SESSION" VALUES (5,10,'2025-05-28','12:00');
INSERT INTO "SESSION" VALUES (6,20,'2025-05-28','13:00');
INSERT INTO "SESSION" VALUES (7,17,'2025-05-28','14:00');
INSERT INTO "SESSION" VALUES (8,15,'2025-05-28','15:00');
INSERT INTO "SESSION" VALUES (9,18,'2025-05-28','16:00');
INSERT INTO "SESSION" VALUES (10,18,'2025-05-28','17:00');
INSERT INTO "SESSION" VALUES (11,13,'2025-05-28','18:00');
INSERT INTO "SESSION" VALUES (12,15,'2025-05-28','19:00');
INSERT INTO "SESSION" VALUES (13,10,'2025-05-28','20:00');
INSERT INTO "SESSION" VALUES (14,11,'2025-05-28','21:00');
INSERT INTO "SESSION" VALUES (15,19,'2025-05-29','08:00');
INSERT INTO "SESSION" VALUES (16,20,'2025-05-29','09:00');
INSERT INTO "SESSION" VALUES (17,14,'2025-05-29','10:00');
INSERT INTO "SESSION" VALUES (18,11,'2025-05-29','11:00');
INSERT INTO "SESSION" VALUES (19,14,'2025-05-29','12:00');
INSERT INTO "SESSION" VALUES (20,20,'2025-05-29','13:00');
INSERT INTO "SESSION" VALUES (21,16,'2025-05-29','14:00');
INSERT INTO "SESSION" VALUES (22,15,'2025-05-29','15:00');
INSERT INTO "SESSION" VALUES (23,16,'2025-05-29','16:00');
INSERT INTO "SESSION" VALUES (24,12,'2025-05-29','17:00');
INSERT INTO "SESSION" VALUES (25,17,'2025-05-29','18:00');
INSERT INTO "SESSION" VALUES (26,10,'2025-05-29','19:00');
INSERT INTO "SESSION" VALUES (27,16,'2025-05-29','20:00');
INSERT INTO "SESSION" VALUES (28,17,'2025-05-29','21:00');
INSERT INTO "SESSION" VALUES (29,19,'2025-05-30','08:00');
INSERT INTO "SESSION" VALUES (30,11,'2025-05-30','09:00');
INSERT INTO "SESSION" VALUES (31,10,'2025-05-30','10:00');
INSERT INTO "SESSION" VALUES (32,13,'2025-05-30','11:00');
INSERT INTO "SESSION" VALUES (33,20,'2025-05-30','12:00');
INSERT INTO "SESSION" VALUES (34,20,'2025-05-30','13:00');
INSERT INTO "SESSION" VALUES (35,19,'2025-05-30','14:00');
INSERT INTO "SESSION" VALUES (36,13,'2025-05-30','15:00');
INSERT INTO "SESSION" VALUES (37,17,'2025-05-30','16:00');
INSERT INTO "SESSION" VALUES (38,20,'2025-05-30','17:00');
INSERT INTO "SESSION" VALUES (39,13,'2025-05-30','18:00');
INSERT INTO "SESSION" VALUES (40,19,'2025-05-30','19:00');
INSERT INTO "SESSION" VALUES (41,13,'2025-05-30','20:00');
INSERT INTO "SESSION" VALUES (42,14,'2025-05-30','21:00');
INSERT INTO "SESSION" VALUES (43,12,'2025-05-31','09:00');
INSERT INTO "SESSION" VALUES (44,19,'2025-05-31','10:00');
INSERT INTO "SESSION" VALUES (45,18,'2025-05-31','11:00');
INSERT INTO "SESSION" VALUES (46,11,'2025-05-31','12:00');
INSERT INTO "SESSION" VALUES (47,11,'2025-05-31','13:00');
INSERT INTO "SESSION" VALUES (48,10,'2025-05-31','14:00');
INSERT INTO "SESSION" VALUES (49,20,'2025-06-02','08:00');
INSERT INTO "SESSION" VALUES (50,20,'2025-06-02','09:00');
INSERT INTO "SESSION" VALUES (51,13,'2025-06-02','10:00');
INSERT INTO "SESSION" VALUES (52,16,'2025-06-02','11:00');
INSERT INTO "SESSION" VALUES (53,10,'2025-06-02','12:00');
INSERT INTO "SESSION" VALUES (54,18,'2025-06-02','13:00');
INSERT INTO "SESSION" VALUES (55,15,'2025-06-02','14:00');
INSERT INTO "SESSION" VALUES (56,13,'2025-06-02','15:00');
INSERT INTO "SESSION" VALUES (57,16,'2025-06-02','16:00');
INSERT INTO "SESSION" VALUES (58,13,'2025-06-02','17:00');
INSERT INTO "SESSION" VALUES (59,15,'2025-06-02','18:00');
INSERT INTO "SESSION" VALUES (60,11,'2025-06-02','19:00');
INSERT INTO "SESSION" VALUES (61,10,'2025-06-02','20:00');
INSERT INTO "SESSION" VALUES (62,11,'2025-06-02','21:00');
INSERT INTO "SESSION" VALUES (63,15,'2025-06-03','08:00');
INSERT INTO "SESSION" VALUES (64,10,'2025-06-03','09:00');
INSERT INTO "SESSION" VALUES (65,14,'2025-06-03','10:00');
INSERT INTO "SESSION" VALUES (66,15,'2025-06-03','11:00');
INSERT INTO "SESSION" VALUES (67,17,'2025-06-03','12:00');
INSERT INTO "SESSION" VALUES (68,14,'2025-06-03','13:00');
INSERT INTO "SESSION" VALUES (69,15,'2025-06-03','14:00');
INSERT INTO "SESSION" VALUES (70,16,'2025-06-03','15:00');
INSERT INTO "SESSION" VALUES (71,18,'2025-06-03','16:00');
INSERT INTO "SESSION" VALUES (72,13,'2025-06-03','17:00');
INSERT INTO "SESSION" VALUES (73,18,'2025-06-03','18:00');
INSERT INTO "SESSION" VALUES (74,17,'2025-06-03','19:00');
INSERT INTO "SESSION" VALUES (75,18,'2025-06-03','20:00');
INSERT INTO "SESSION" VALUES (76,10,'2025-06-03','21:00');
INSERT INTO "SESSION" VALUES (77,14,'2025-06-04','08:00');
INSERT INTO "SESSION" VALUES (78,13,'2025-06-04','09:00');
INSERT INTO "SESSION" VALUES (79,12,'2025-06-04','10:00');
INSERT INTO "SESSION" VALUES (80,15,'2025-06-04','11:00');
INSERT INTO "SESSION" VALUES (81,15,'2025-06-04','12:00');
INSERT INTO "SESSION" VALUES (82,12,'2025-06-04','13:00');
INSERT INTO "SESSION" VALUES (83,19,'2025-06-04','14:00');
INSERT INTO "SESSION" VALUES (84,18,'2025-06-04','15:00');
INSERT INTO "SESSION" VALUES (85,13,'2025-06-04','16:00');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Αθήνα (Μαρούσι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Αθήνα (Μαρούσι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Αθήνα (Μαρούσι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Αθήνα (Μαρούσι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Αθήνα (Περιστέρι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Αθήνα (Περιστέρι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Αθήνα (Περιστέρι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Αθήνα (Περιστέρι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Αθήνα (Χαλάνδρι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Αθήνα (Χαλάνδρι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Αθήνα (Χαλάνδρι)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Θεσσαλονίκη (Κέντρο)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Θεσσαλονίκη (Κέντρο)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Θεσσαλονίκη (Κέντρο)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Θεσσαλονίκη (Κέντρο)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Πάτρα');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Πάτρα');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Πάτρα');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Ηράκλειο');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Ηράκλειο');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Ηράκλειο');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Ηράκλειο');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Λάρισα');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Λάρισα');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Λάρισα');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Χανιά');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Χανιά');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Χανιά');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',50,1,1,'Χανιά');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Θεσσαλονίκη (Τούμπα)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Θεσσαλονίκη (Τούμπα)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Θεσσαλονίκη (Τούμπα)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο',40,2,3,'Αθήνα (Γλυφάδα)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης',30,4,12,'Αθήνα (Γλυφάδα)');
INSERT INTO "SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες',35,3,6,'Αθήνα (Γλυφάδα)');
INSERT INTO "USER" VALUES ('Γιώργος',1,'giorgos1@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$p9XD+Ew6cHKcG5mOMbMPpg$Rz4qOPNLVBJ3cDixcfM/fHacp57K85wVCJt+mg908UE','6900000001','Μεζώνος 23','Παπαδόπουλος');
INSERT INTO "USER" VALUES ('Μαρία',2,'maria2@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$8Uw7pIdCvulBOtMI+1SOIA$BDWUhlMGhSUInrWKtMjOKwLpN19HI3oY/UgfKX9uAEw','6900000002','Παπαδημητρίου 49','Ιωάννου');
INSERT INTO "USER" VALUES ('Νίκος',3,'nikos3@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$/UKXnUAAkaQEqEqDk69g2w$kT+sh3guA0ewo1pP1HU7KLMnTxTW4PnuQh2+iPmi++A','6900000003','Ζαΐμη 50','Δημητρίου');
INSERT INTO "USER" VALUES ('Έλενα',4,'elena4@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$KYXPzhVQEk4xbMPU9vXuUw$lyAaNxq8C1OibU88WXwzXC5UyoZhv41woiTfSf+5q+g','6900000004','Μεγάλου Αλεξάνδρου 32','Αλεξίου');
INSERT INTO "USER" VALUES ('Δήμητρα',5,'dimitra5@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$9UOPYwOpIUVPDM6CRNH5sQ$XlZvbGMTmHVCmWrHPUUUjygFqxL9iwfkCLk5XDQreHw','6900000005','Ερμού 13','Λεωνίδα');
INSERT INTO "USER" VALUES ('Σταύρος',6,'stavros6@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$J3ik4UzSJOfiwNEKMXzCQw$GkLTwL4qoqXpBKLFYtnertIjEUPk7hbISqQwz54RKs4','6900000006','Αμαλίας 11','Χατζής');
INSERT INTO "USER" VALUES ('Αντώνης',7,'antonis7@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$9MVb5gQ6t0AbAFhf4c/OAA$AYEnozuOW2AWh+wQgX73i5UlJ2DMLov4Md0rCDh7bl4','6900000007','Πατησίων 90','Μακρής');
INSERT INTO "USER" VALUES ('Σοφία',8,'sofia8@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$NqaioxKhI3w1S5KDE6ZRfw$9f+8zyeVo6Ox3GuyfqMVIJwGnUdqZwlgDbyJE7qI+Do','6900000008','Πανεπιστημίου 70','Βασιλείου');
INSERT INTO "USER" VALUES ('Αγγελική',9,'aggeliki9@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$1nnD++CBZO8FqNBsTZP3Yw$nghMHbpbSh5pvEPxI7PJNcPasu8SsI88kovDQ5KH4jU','6900000009','Αχαρνών 9','Κωσταντίνου');
INSERT INTO "USER" VALUES ('Κώστας',10,'kostas10@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$gTBmpAgU/RzDwrory2SrPw$IlLvjX9mwscs7OKIEtReLdFCnZY0Xpgc0lZYFTjW/Cs','6900000010','Γεροκωστοπούλου 2','Παναγιώτου');
INSERT INTO "USER" VALUES ('Γιάννης',11,'giannis11@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$WFFoq1EFUUuyxGi1Y1Kgrw$iQApqzIvJ4Q4K5JOkk1PiW8277OHubedewj5eaMlDBc','6900000011','Αγίας Σοφίας 5','Αναγνωστόπουλος');
INSERT INTO "USER" VALUES ('Αθηνά',12,'athanasia12@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$L90hWX527LrZqYIsQkUN6g$JUvHEr8JpwPzh4hTcrrIxzp/RBORWoqm0HpKpymXX4w','6900000012','Σταδίου 15','Αλεξάνδρου');
INSERT INTO "USER" VALUES ('Πέτρος',13,'petros13@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$R68IVWsFVf4w3+AmbHgiUw$IevzYynvD3wypk1Tv68vbtIQVFyMc3xoa+LBlBzuW9s','6900000013','Αριστοτέλους 8','Πετρόπουλος');
INSERT INTO "USER_RESERVES_SESSION" VALUES (1,34);
INSERT INTO "USER_RESERVES_SESSION" VALUES (1,35);
INSERT INTO "USER_RESERVES_SESSION" VALUES (1,54);
INSERT INTO "USER_RESERVES_SESSION" VALUES (2,74);
INSERT INTO "USER_RESERVES_SESSION" VALUES (2,77);
INSERT INTO "USER_RESERVES_SESSION" VALUES (2,70);
INSERT INTO "USER_RESERVES_SESSION" VALUES (3,47);
INSERT INTO "USER_RESERVES_SESSION" VALUES (3,26);
INSERT INTO "USER_RESERVES_SESSION" VALUES (3,16);
INSERT INTO "USER_RESERVES_SESSION" VALUES (4,1);
INSERT INTO "USER_RESERVES_SESSION" VALUES (4,32);
INSERT INTO "USER_RESERVES_SESSION" VALUES (4,84);
INSERT INTO "USER_RESERVES_SESSION" VALUES (5,65);
INSERT INTO "USER_RESERVES_SESSION" VALUES (5,8);
INSERT INTO "USER_RESERVES_SESSION" VALUES (5,74);
INSERT INTO "USER_RESERVES_SESSION" VALUES (6,15);
INSERT INTO "USER_RESERVES_SESSION" VALUES (6,70);
INSERT INTO "USER_RESERVES_SESSION" VALUES (6,42);
INSERT INTO "USER_RESERVES_SESSION" VALUES (7,5);
INSERT INTO "USER_RESERVES_SESSION" VALUES (7,65);
INSERT INTO "USER_RESERVES_SESSION" VALUES (8,65);
INSERT INTO "USER_RESERVES_SESSION" VALUES (8,82);
INSERT INTO "USER_RESERVES_SESSION" VALUES (8,48);
INSERT INTO "USER_RESERVES_SESSION" VALUES (8,68);
INSERT INTO "USER_RESERVES_SESSION" VALUES (9,30);
INSERT INTO "USER_RESERVES_SESSION" VALUES (9,36);
INSERT INTO "USER_RESERVES_SESSION" VALUES (9,18);
INSERT INTO "USER_RESERVES_SESSION" VALUES (9,25);
INSERT INTO "USER_RESERVES_SESSION" VALUES (9,53);
INSERT INTO "USER_RESERVES_SESSION" VALUES (10,58);
INSERT INTO "USER_RESERVES_SESSION" VALUES (10,80);
INSERT INTO "USER_RESERVES_SESSION" VALUES (10,70);
INSERT INTO "USER_RESERVES_SESSION" VALUES (10,30);
INSERT INTO "USER_RESERVES_SESSION" VALUES (11,56);
INSERT INTO "USER_RESERVES_SESSION" VALUES (11,83);
INSERT INTO "USER_RESERVES_SESSION" VALUES (11,81);
INSERT INTO "USER_RESERVES_SESSION" VALUES (11,20);
INSERT INTO "USER_RESERVES_SESSION" VALUES (12,81);
INSERT INTO "USER_RESERVES_SESSION" VALUES (12,64);
INSERT INTO "USER_RESERVES_SESSION" VALUES (12,10);
INSERT INTO "USER_RESERVES_SESSION" VALUES (12,28);
INSERT INTO "USER_RESERVES_SESSION" VALUES (13,18);
INSERT INTO "USER_RESERVES_SESSION" VALUES (13,12);
INSERT INTO "USER_RESERVES_SESSION" VALUES (13,44);
INSERT INTO "USER_SUBSCRIPTION" VALUES (1,3,'2024-11-23','2025-05-22','Αθήνα (Περιστέρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (1,4,'2023-11-19','2024-11-18','Θεσσαλονίκη (Τούμπα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (1,1,'2023-10-15','2023-11-14','Αθήνα (Μαρούσι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (1,2,'2025-05-24','2025-08-22','Αθήνα (Περιστέρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (2,4,'2024-05-22','2025-05-22','Πάτρα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (2,1,'2024-04-17','2024-05-17','Χανιά');
INSERT INTO "USER_SUBSCRIPTION" VALUES (2,3,'2023-10-15','2024-04-12','Αθήνα (Μαρούσι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (2,4,'2025-05-26','2026-05-26','Αθήνα (Χαλάνδρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (3,3,'2024-11-23','2025-05-22','Αθήνα (Γλυφάδα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (3,4,'2023-11-19','2024-11-18','Αθήνα (Γλυφάδα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (3,2,'2023-08-16','2023-11-14','Χανιά');
INSERT INTO "USER_SUBSCRIPTION" VALUES (3,4,'2025-05-24','2026-05-24','Αθήνα (Μαρούσι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (4,4,'2024-05-22','2025-05-22','Λάρισα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (4,2,'2024-02-17','2024-05-17','Αθήνα (Μαρούσι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (4,1,'2024-01-13','2024-02-12','Πάτρα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (4,4,'2025-05-24','2026-05-24','Αθήνα (Μαρούσι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (5,3,'2024-11-23','2025-05-22','Αθήνα (Μαρούσι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (5,2,'2024-08-20','2024-11-18','Αθήνα (Περιστέρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (5,3,'2024-02-17','2024-08-15','Θεσσαλονίκη (Κέντρο)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (5,1,'2025-05-25','2025-06-24','Αθήνα (Χαλάνδρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (6,4,'2024-05-22','2025-05-22','Λάρισα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (6,3,'2023-11-19','2024-05-17','Ηράκλειο');
INSERT INTO "USER_SUBSCRIPTION" VALUES (6,1,'2023-10-15','2023-11-14','Χανιά');
INSERT INTO "USER_SUBSCRIPTION" VALUES (6,3,'2025-05-23','2025-11-19','Αθήνα (Γλυφάδα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (7,4,'2024-05-22','2025-05-22','Αθήνα (Γλυφάδα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (7,3,'2023-11-19','2024-05-17','Ηράκλειο');
INSERT INTO "USER_SUBSCRIPTION" VALUES (7,1,'2023-10-15','2023-11-14','Αθήνα (Χαλάνδρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (7,3,'2025-05-25','2025-11-21','Θεσσαλονίκη (Τούμπα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (8,3,'2024-11-23','2025-05-22','Αθήνα (Περιστέρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (8,1,'2024-10-19','2024-11-18','Λάρισα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (8,4,'2023-10-15','2024-10-14','Αθήνα (Χαλάνδρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (8,2,'2025-05-23','2025-08-21','Αθήνα (Περιστέρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (9,4,'2024-05-22','2025-05-22','Θεσσαλονίκη (Τούμπα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (9,2,'2024-02-17','2024-05-17','Ηράκλειο');
INSERT INTO "USER_SUBSCRIPTION" VALUES (9,2,'2023-11-14','2024-02-12','Θεσσαλονίκη (Τούμπα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (9,3,'2025-05-25','2025-11-21','Πάτρα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (10,1,'2025-04-22','2025-05-22','Πάτρα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (10,2,'2025-01-17','2025-04-17','Αθήνα (Γλυφάδα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (10,4,'2024-01-13','2025-01-12','Ηράκλειο');
INSERT INTO "USER_SUBSCRIPTION" VALUES (10,1,'2025-05-25','2025-06-24','Χανιά');
INSERT INTO "USER_SUBSCRIPTION" VALUES (11,4,'2024-05-22','2025-05-22','Ηράκλειο');
INSERT INTO "USER_SUBSCRIPTION" VALUES (11,2,'2024-02-17','2024-05-17','Χανιά');
INSERT INTO "USER_SUBSCRIPTION" VALUES (11,4,'2023-02-12','2024-02-12','Λάρισα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (11,3,'2025-05-26','2025-11-22','Χανιά');
INSERT INTO "USER_SUBSCRIPTION" VALUES (12,3,'2024-11-23','2025-05-22','Θεσσαλονίκη (Τούμπα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (12,3,'2024-05-22','2024-11-18','Ηράκλειο');
INSERT INTO "USER_SUBSCRIPTION" VALUES (12,4,'2023-05-18','2024-05-17','Αθήνα (Γλυφάδα)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (12,4,'2025-05-25','2026-05-25','Αθήνα (Χαλάνδρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (13,2,'2025-02-21','2025-05-22','Λάρισα');
INSERT INTO "USER_SUBSCRIPTION" VALUES (13,2,'2024-11-18','2025-02-16','Χανιά');
INSERT INTO "USER_SUBSCRIPTION" VALUES (13,4,'2023-11-14','2024-11-13','Αθήνα (Μαρούσι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (13,1,'2025-05-23','2025-06-22','Αθήνα (Χαλάνδρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (2,1,'2025-05-27','2025-06-27','Αθήνα (Περιστέρι)');
INSERT INTO "USER_SUBSCRIPTION" VALUES (2,2,'2025-05-27','2025-08-27','Λάρισα');
COMMIT;
