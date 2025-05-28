# GYM-ON Web App

## Περιγραφή

Το GYM-ON είναι μια web εφαρμογή διαχείρισης αλυσίδας γυμναστηρίου που επιτρέπει στους χρήστες να:

- Ενημερώνονται για τα προγράμματα και τα διαθέσιμα γυμναστήρια
- Κάνουν εγγραφή και σύνδεση
- Διαχειρίζονται τις συνδρομές τους (αγορά/ανανέωση)
- Κλείνουν και διαχειρίζονται συνεδρίες/μαθήματα
- Βλέπουν το προσωπικό τους πρόγραμμα (timetable)


Η εφαρμογή είναι πλήρως responsive και mobile-friendly

---

## Τεχνολογίες

- **Node.js** / **Express.js** (backend)
- **Handlebars** (templating)
- **SQLite** ή **PostgreSQL** (ανάλογα με το περιβάλλον)
- **CSS3** (responsive design, custom styles)
- **FontAwesome** (icons)

---

## Δομή φακέλων

- `controller/` : Express controllers
- `model/` : Database access (SQLite & PostgreSQL)
- `public/` : Static αρχεία (CSS, JS, images)
- `views/` : Handlebars templates (σελίδες, partials, layouts)
- `routes/` : Express router

---
## Προαπαιτούμενα

- [Node.js](https://nodejs.org/) (έκδοση 18 ή νεότερη)
- npm (συμπεριλαμβάνεται στο Node.js)
- [Git](https://git-scm.com/) (προαιρετικά, για κλωνοποίηση του αποθετηρίου)
- [SQLite3](https://www.sqlite.org/download.html) (αν χρησιμοποιείς SQLite, προαιρετικά για διαχείριση της βάσης)
- [PostgreSQL](https://www.postgresql.org/download/) (αν χρησιμοποιείς PostgreSQL)
- Πρόγραμμα περιήγησης (Chrome, Firefox, Edge κλπ)


## Οδηγίες εγκατάστασης

1. **Κλωνοποίησε το αποθετήριο**
```sh
   git clone https://github.com/PasxK23/gymon
   ```
2. **Εγκατέστησε τα dependencies**
   ```sh
   npm install
   ```
3. **Ρύθμισε το περιβάλλον**
   - Δημιούργησε ενα αρχειο .env βασισμενο στο some.env 
   - Για SQLite: Βεβαιώσου ότι υπάρχει το αρχείο `model/db/gym_on_database.db`
   - Για PostgreSQL: Ρύθμισε το `DATABASE_URL`στο `.env`, το sql αρχείο με τη βάση postgres βρίσκεται στον φάκελο `model\db\dump-gymon_db-202505281907.sql`
4. **Τρέξε την εφαρμογή**
   ```sh
   npm run start
   ```
5. **Άνοιξε τον browser** στη διεύθυνση  
   `http://localhost:PORT`  
   (αντικατέστησε το `PORT` με τον αριθμό που έχεις βάλει στο `.env`, π.χ. 8080)

---
## Περιβάλλον (Environment variables)

- `PORT`: Ο αριθμός θύρας για τον server (π.χ. 8080)
- `MODEL`: Το μοντέλο της βασης που χρησιμοποιείται(SQLite ή PostgreSQL)
- `DATABASE_URL`: Σύνδεσμος στη βάση δεδομένων PostgreSQL (προαιρετικό αν χρησιμοποιείς SQLite)
- `SESSION_SECRET`: Μυστικό για τις συνεδρίες (προτείνεται να οριστεί)

Μπορείς να δημιουργήσεις ένα αρχείο `.env` βασισμένο στο `some.env`.

