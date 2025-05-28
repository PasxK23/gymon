import sqlite3
from datetime import date, timedelta
from random import randint as rnd
from random import sample
import random
from argon2 import PasswordHasher
conn = sqlite3.connect("model/db/gym_on_database.db")

if(conn is None):
    print("❌ Η βάση δεδομένων δεν βρέθηκε.")
    exit()
cursor = conn.cursor()

# Ενεργοποίηση foreign keys
cursor.execute("PRAGMA foreign_keys = OFF;")

# Διαγραφή όλων των δεδομένων από όλους τους πίνακες με σωστή σειρά (πρώτα τα children)
tables = [
    "USER_RESERVES_SESSION",
    "USER_SUBSCRIPTION",
    "GYM_PROVIDES_PROGRAM_SESSION",
    "SESSION",
    "SUBSCRIPTION",
    "CATEGORY",
    "PROGRAM",
    "GYM",
    "USER"
]

for table in tables:
    cursor.execute(f"DELETE FROM {table};")
    cursor.execute(f"DELETE FROM sqlite_sequence WHERE name='{table}';")
#     conn.commit()
cursor.execute("PRAGMA foreign_keys = ON;")

passwordsbefore = ["pass1","pass2","pass3","pass4","pass5","pass6","pass7","pass8","pass9","pass10","pass11","pass12","pass13"]
hashed_passwords = []

ph = PasswordHasher()
# Δημιουργία hash από password
for passw in passwordsbefore:
    hashedpass = ph.hash(passw)
    hashed_passwords.append(hashedpass)



# 1. Εισαγωγή ΧΡΗΣΤΗΣ
users = [
    ("Γιώργος", 1, "giorgos1@gmail.com",hashed_passwords[0],"6900000001", "Μεζώνος 23", "Παπαδόπουλος"),
    ("Μαρία", 2, "maria2@gmail.com",hashed_passwords[1],"6900000002", "Παπαδημητρίου 49", "Ιωάννου"),
    ("Νίκος", 3, "nikos3@gmail.com",hashed_passwords[2],"6900000003", "Ζαΐμη 50", "Δημητρίου"),
    ("Έλενα", 4, "elena4@gmail.com",hashed_passwords[3],"6900000004", "Μεγάλου Αλεξάνδρου 32", "Αλεξίου"),
    ("Δήμητρα", 5, "dimitra5@gmail.com",hashed_passwords[4],"6900000005", "Ερμού 13", "Λεωνίδα"),
    ("Σταύρος", 6, "stavros6@gmail.com",hashed_passwords[5],"6900000006", "Αμαλίας 11", "Χατζής"),
    ("Αντώνης", 7, "antonis7@gmail.com",hashed_passwords[6],"6900000007", "Πατησίων 90", "Μακρής"),
    ("Σοφία", 8, "sofia8@gmail.com",hashed_passwords[7],"6900000008", "Πανεπιστημίου 70", "Βασιλείου"),
    ("Αγγελική", 9, "aggeliki9@gmail.com",hashed_passwords[8],"6900000009", "Αχαρνών 9", "Κωσταντίνου"),
    ("Κώστας", 10, "kostas10@gmail.com",hashed_passwords[9], "6900000010", "Γεροκωστοπούλου 2", "Παναγιώτου"),
    ("Γιάννης", 11, "giannis11@gmail.com",hashed_passwords[10], "6900000011", "Αγίας Σοφίας 5", "Αναγνωστόπουλος"),
    ("Αθηνά", 12, "athanasia12@gmail.com",hashed_passwords[11], "6900000012", "Σταδίου 15", "Αλεξάνδρου"),
    ("Πέτρος", 13, "petros13@gmail.com",hashed_passwords[12], "6900000013", "Αριστοτέλους 8", "Πετρόπουλος")
]

cursor.executemany("""
    INSERT INTO USER (Name, ID, Email, Password, Phone, Location, Surname)
    VALUES (?, ?, ?, ?, ?, ?, ?)
""", users)

# 2. Εισαγωγή ΓΥΜΝΑΣΤΗΡΙΟ
gyms = [
    ("Αθήνα (Μαρούσι)","Λεωφόρος Κηφισίας 101","210-1234567","Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή 10:00-17:00","gym_on_marousi@gymon.gr"),
    ("Αθήνα (Περιστέρι)","Σταδίου 10","210-1111111","Δευτέρα-Παρασκευή 07:00-22:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά","gym_on_peristeri@gymon.gr"),
    ("Αθήνα (Χαλάνδρι)","Ιεραποστόλου 12","210-2222222","Δευτέρα-Παρασκευή 07:00-22:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά","gym_on_chalandri@gymon.gr"),
    ("Θεσσαλονίκη (Κέντρο)","Τσιμισκή 22","2310-123456","Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά","gym_on_thess_cender@gymon.gr"),
    ("Πάτρα","Κορίνθου 50","2610-000000","Δευτέρα-Παρασκευή 09:00-20:00, Σάββατο 10:00-14:00, Κυριακή Κλειστά","gym_on_patra@gymon.gr"),
    ("Ηράκλειο","Λεωφόρος Κνωσού 33","2810-123456","Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά","gym_on_irakleio@gymon.gr"),
    ("Λάρισα","Αχιλλέως 90","2410-123456","Δευτέρα-Παρασκευή 09:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά","gym_on_larisa@gymon.gr"),
    ("Χανιά","Τζανακάκη 14","28210-123456","Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά","gym_on_chania@gymon.gr"),
    ("Θεσσαλονίκη (Τούμπα)","Λεωφόρος Γεωργικής Σχολής 45","2310-987654","Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή Κλειστά","gym_on_thess_toumpa@gymon.gr"),
    ("Αθήνα (Γλυφάδα)","Λεωφόρος Βουλιαγμένης 100","210-3333333","Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή Κλειστά","gym_on_glyfada@gymon.gr")
]

cursor.executemany("""
    INSERT INTO GYM (Location, Address, Phone, Schedule, Email)
    VALUES (?, ?, ?, ?, ?)
""", gyms)

# 3. Εισαγωγή ΚΑΤΗΓΟΡΙΑ
categories = ["1","3","6","12"]

cursor.executemany("INSERT INTO CATEGORY (DURATION) VALUES (?)",[(c,) for c in categories])





# 4. Δημιουργία πολλαπλών SUBSCRIPTION για κάθε GYM και CATEGORY

# 1. Κανονικά πάρε όλα τα locations:
gyms_locations = [gym[0] for gym in gyms]  # παίρνει τα names (location) όλων των gyms

# 2. Χωρίς περιορισμό subscription_id:
subscriptions = []
subscription_map = {}
used_combinations = set()

# Σταθερή αντιστοίχιση subscription_id -> category + price
fixed_subscriptions = {
    1: (categories[0], 50),
    2: (categories[1], 40),
    3: (categories[2], 35),
    4: (categories[3], 30)
}

print(categories)
for gym in gyms:
    gym_location = gym[0]

    # Για κάθε gym βάλε 3 ή 4 από τα παρακάτω subscription_id
    selected_ids = random.sample(list(fixed_subscriptions.keys()), k=random.randint(3, 4))

    for sid in selected_ids:
        key = (sid, gym_location)
        if key in used_combinations:
            continue  # απόφυγε διπλό συνδυασμό

        used_combinations.add(key)
        duration_str, price = fixed_subscriptions[sid]

        desc = "Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο"
        if str(duration_str) in ["6", "12"]:
            desc += ", 3 Δωρεάν Συνεδρίες"
        if str(duration_str) == "12":
            desc += ", Προσωπικό πρόγραμμα προπόνησης"

        subscriptions.append((sid, desc, str(price), duration_str, gym_location))
        subscription_map[(gym_location, duration_str)] = sid


cursor.executemany("""
    INSERT INTO SUBSCRIPTION (ID, Description, Price, CATEGORY_Duration, gym_Location)
    VALUES (?, ?, ?, ?, ?)
""", subscriptions)





user_subs = []
sub_durations = {
    categories[0]: 30,
    categories[1]: 90,
    categories[2]: 180,
    categories[3]: 365
}

today = date.today()
used_user_keys = set()

for user_id in range(1, 14):  # 13 users
    last_end = today
    used_keys = set()

    for _ in range(3):  # 3 παλιές συνδρομές
        attempts = 0
        while attempts < 10:
            gym_location = random.choice(gyms_locations)
            duration_str = random.choice(categories)
            key = (gym_location, duration_str)

            if key not in subscription_map or key in used_keys:
                attempts += 1
                continue

            sub_id = subscription_map[key]
            user_key = (user_id, sub_id, gym_location)
            if user_key in used_user_keys:
                attempts += 1
                continue

            used_keys.add(key)
            used_user_keys.add(user_key)

            duration_days = sub_durations[duration_str]
            start = last_end - timedelta(days=duration_days + 5)
            end = start + timedelta(days=duration_days)
            last_end = start

            user_subs.append((user_id, sub_id, gym_location, start.isoformat(), end.isoformat()))
            break  # go to next subscription

    # Μία ενεργή
    attempts = 0
    while attempts < 10:
        gym_location = random.choice(gyms_locations)
        duration_str = random.choice(categories)
        key = (gym_location, duration_str)

        if key not in subscription_map:
            attempts += 1
            continue

        sub_id = subscription_map[key]
        user_key = (user_id, sub_id, gym_location)
        if user_key in used_user_keys:
            attempts += 1
            continue

        used_user_keys.add(user_key)

        duration_days = sub_durations[duration_str]
        start = today - timedelta(days=random.randint(1, 5))
        end = start + timedelta(days=duration_days)

        user_subs.append((user_id, sub_id, gym_location, start.isoformat(), end.isoformat()))
        break

cursor.executemany("""
    INSERT INTO USER_SUBSCRIPTION ("USER-ID", "SUBSCRIPTION-ID", "gym_Location", "Start_Date", "End_Date")
    VALUES (?, ?, ?, ?, ?)
""", user_subs)



# ΠΡΟΓΡΑΜΜΑ
programs = [
    ("Yoga", """Μια χαλαρωτική και αναζωογονητική πρακτική που συνδυάζει διατάσεις, ενδυνάμωση, αναπνοές και διαλογισμό. Περιλαμβάνει στάσεις (asanas) που βοηθούν στην ευλυγισία, την ισορροπία και τη μυϊκή σταθερότητα.

Οφέλη για την υγεία:
– Μειώνει το άγχος και ενισχύει τη νοητική διαύγεια
– Βελτιώνει τη στάση σώματος και την κινητικότητα των αρθρώσεων
– Ρυθμίζει την αναπνοή και μειώνει την αρτηριακή πίεση
– Συμβάλλει στη συναισθηματική ισορροπία""", "10€"),

    ("Spinning", """Ένα δυναμικό πρόγραμμα ποδηλασίας σε στατικό ποδήλατο, με εναλλαγές έντασης και ρυθμού υπό μουσική. Ιδανικό για την τόνωση της καρδιάς και των ποδιών.

Οφέλη για την υγεία:
– Ενισχύει την καρδιοαναπνευστική ικανότητα
– Καίει πολλές θερμίδες και βοηθά στην απώλεια βάρους
– Τονώνει τα πόδια, τους γλουτούς και τον κορμό
– Μειώνει τον κίνδυνο καρδιοπαθειών""", "12€"),

    ("Kickboxing", """Ένα έντονο πρόγραμμα αυτοάμυνας και γυμναστικής που συνδυάζει κινήσεις από πολεμικές τέχνες και αερόβια άσκηση.

Οφέλη για την υγεία:
– Ενισχύει τη δύναμη, την ταχύτητα και την ευλυγισία
– Αυξάνει την αυτοπεποίθηση και μειώνει το στρες
– Βοηθά στην απώλεια βάρους μέσω έντονης καύσης θερμίδων
– Βελτιώνει την ισορροπία και τον συντονισμό σώματος-νου""", "15€"),

    ("Zumba", """Ένα διασκεδαστικό πρόγραμμα χορού με έντονη μουσική λάτιν και διεθνή ρυθμούς. Ιδανικό για άτομα που αγαπούν την κίνηση και τη διασκέδαση ενώ γυμνάζονται.

Οφέλη για την υγεία:
– Ενισχύει το καρδιοαναπνευστικό σύστημα
– Βοηθά στη μείωση του άγχους και αυξάνει τα επίπεδα ενέργειας
– Βελτιώνει την αντοχή, την ισορροπία και την ευλυγισία
– Ενισχύει τη διάθεση μέσω της μουσικοχορευτικής έκφρασης""", "12€"),

    ("Pilates", """Πρόγραμμα χαμηλής έντασης που στοχεύει στην ενδυνάμωση του πυρήνα (κοιλιακοί, ράχη, λεκάνη) και στη σταθερότητα. Επικεντρώνεται στον έλεγχο της αναπνοής και της κίνησης.

Οφέλη για την υγεία:
– Δυναμώνει τον κορμό και βελτιώνει τη στάση του σώματος
– Μειώνει τον πόνο στη μέση και τις κακώσεις
– Ενισχύει τη συγκέντρωση και την ισορροπία
– Βελτιώνει την κινητικότητα και τη σωματική ευαισθητοποίηση""", "13€"),

    ("Crossfit", """Ένα εντατικό και απαιτητικό πρόγραμμα που συνδυάζει βάρη, καρδιοαναπνευστική άσκηση, άλματα, κωπηλασία και γυμναστική. Κάθε προπόνηση είναι διαφορετική και προσαρμοσμένη.

Οφέλη για την υγεία:
– Αυξάνει τη γενική φυσική κατάσταση και την αντοχή
– Αναπτύσσει δύναμη, ταχύτητα και έκρηξη
– Βοηθά στη διαχείριση του στρες μέσω εντατικής δραστηριότητας
– Δημιουργεί αίσθημα κοινότητας και πειθαρχίας""", "20€")
]


cursor.executemany("""
    INSERT INTO PROGRAM (Name, 'Description', 'Price_ana_Session')
    VALUES (?, ?, ?)
""", programs)

# ΣΥΝΕΔΡΙΑ
basic_sessions = []
session_count = 0
max_sessions = 85
from datetime import datetime, timedelta

start_date = today + timedelta(days=1)  # Αύριο
for day in range(0, 30):
    date_obj = start_date + timedelta(days=day)
    date_str = date_obj.strftime('%Y-%m-%d')
    weekday = date_obj.weekday()
    if weekday == 6:
        continue  # Κυριακή, skip
    if weekday == 5:
        hours = range(9, 15)  # Σάββατο 09:00-17:00
    else:
        hours = range(8, 22)  # Δευτέρα-Παρασκευή 08:00-21:00
    for hour in hours:
        if session_count >= max_sessions:
            break
        basic_sessions.append((date_str, f"{hour:02}:00", f"{rnd(10,20)}"))
        session_count += 1
    if session_count >= max_sessions:
        break
cursor.executemany("""
    INSERT INTO SESSION ('Date', 'Time', 'Max_Number_Of_People')
    VALUES (?, ?, ?)
""", basic_sessions)


# ΣΥΝΕΔΡΙΑ ΠΑΡΕΧΕΤΑΙ ΑΠΟ ΓΥΜΝΑΣΤΗΡΙΟ
sessions = []
session_id = 1

# Πάρε τα ονόματα των προγραμμάτων και των γυμναστηρίων
program_names = [p[0] for p in programs]
gym_locations = [g[0] for g in gyms]

import random

while session_id <= 85:
    program = random.choice(program_names)
    gym = random.choice(gym_locations)
    sessions.append((program, gym, session_id))
    session_id += 1

# Τώρα κάνε insert:
cursor.executemany("""
    INSERT INTO 'GYM_PROVIDES_PROGRAM_SESSION' ('PROGRAM_Name', 'GYM_Location', SESSION_ID)
    VALUES (?, ?, ?)
""", sessions)



user_sessions = []
num_users = 13  # id 1-13
num_sessions = 85

# Πάρε τα max_people για κάθε session
num_users = 13  # id 1-13
num_sessions = 85

# Πάρε τα max_people για κάθε session
session_max_people = {idx+1: int(session[2]) for idx, session in enumerate(basic_sessions)}
session_current_users = {sid: 0 for sid in range(1, num_sessions+1)}

for user_id in range(1, num_users + 1):
    # Πάρε έως 15 μοναδικά session ids για κάθε χρήστη
    available_sessions = list(range(1, num_sessions + 1))
    random.shuffle(available_sessions)
    count = 0
    for session_id in available_sessions:
        if session_current_users[session_id] < session_max_people[session_id]:
            user_sessions.append((user_id, session_id))
            session_current_users[session_id] += 1
            count += 1
            if count >= 15:
                break


cursor.executemany("""
    INSERT INTO 'USER_RESERVES_SESSION' ('USER-ID', 'SESSION-ID')
    VALUES (?, ?)
""", user_sessions)








conn.commit()
conn.close()

print("✅ Οι 10 εγγραφές έγιναν με επιτυχία.")
