import dotenv from "dotenv";

if (process.env.NODE_ENV !== "production") {
  dotenv.config();
}
const userModel = await import(
  `../model/${process.env.MODEL}/model-${process.env.MODEL}.mjs`
);
import argon2d from "argon2";

export let showLogInForm = function (req, res) {
  res.render("login", {
    title: "Σύνδεση",
    css: "authentication.css",
    metaDescription:
      "Σύνδεση στο GYM-ON για να διαχειριστείς τα προγράμματά σου και να έχεις πρόσβαση στις υπηρεσίες μας.",
  });
};

export let showRegisterForm = function (req, res) {
  res.render("register", {
    title: "Εγγραφή",
    css: "authentication.css",
    metaDescription:
      "Δημιουργία νέου λογαριασμού στο GYM-ON για να ξεκινήσεις το δικό σου πρόγραμμα γυμναστικής.",
  });
};

export let doRegister = async function (req, res) {
  try {
    const registrationResult = await userModel.registerUser(
      req.body.name,
      req.body.password,
      req.body.email,
      req.body.phone,
      req.body.address,
      req.body.surname
    );

    if (registrationResult?.message) {
      res.render("register", {
        message: registrationResult.message,
        css: "authentication.css",
        metaDescription:
          "Δημιουργία νέου λογαριασμού στο GYM-ON για να ξεκινήσεις το δικό σου πρόγραμμα γυμναστικής.",
      });
    } else if (registrationResult) {
      res.render("login", {
        message: "Επιτυχής εγγραφή! Μπορείτε να συνδεθείτε τώρα.",
        css: "authentication.css",
        metaDescription:
          "Σύνδεση στο GYM-ON για να διαχειριστείς τα προγράμματά σου και να έχεις πρόσβαση στις υπηρεσίες μας.",
      });
    } else {
      res.render("register", {
        message: "Η εγγραφή απέτυχε. Προσπαθήστε ξανά.",
        metaDescription:
          "Δημιουργία νέου λογαριασμού στο GYM-ON για να ξεκινήσεις το δικό σου πρόγραμμα γυμναστικής.",
      });
    }
  } catch (error) {
    res.render("register", {
      message: "Σφάλμα κατά την εγγραφή." + error,
      css: "authentication.css",
      metaDescription:
        "Δημιουργία νέου λογαριασμού στο GYM-ON για να ξεκινήσεις το δικό σου πρόγραμμα γυμναστικής.",
    });
  }
};

export let doLogin = async function (req, res) {
  //Ελέγχει αν το username και το password είναι σωστά και εκτελεί την
  //συνάρτηση επιστροφής authenticated
  console.log("login", req.body.email);
  //Αν δεν έχει συμπληρωθεί το email ή το password
  const user = await userModel.getUserByEmail(req.body.email);
  if (user === undefined || !user.Email) {
    res.render("login", {
      message: "Δε βρέθηκε αυτός ο χρήστης",
      css: "authentication.css",
      metaDescription:
        "Σύνδεση στο GYM-ON για να διαχειριστείς τα προγράμματά σου και να έχεις πρόσβαση στις υπηρεσίες μας.",
    });
  } else {
    const match = await argon2d.verify(user.Password, req.body.password ?? "");
    if (match) {
      //Θέτουμε τη μεταβλητή συνεδρίας "loggedUserId"
      req.session.loggedUserId = user.ID;
      //Αν έχει τιμή η μεταβλητή req.session.originalUrl, αλλιώς όρισέ τη σε "/"
      // res.redirect("/");
      const redirectTo = req.session.originalUrl || "/";
      res.redirect(redirectTo);
    } else {
      res.render("login", {
        message: "Ο κωδικός πρόσβασης είναι λάθος",
        css: "authentication.css",
        metaDescription:
          "Σύνδεση στο GYM-ON για να διαχειριστείς τα προγράμματά σου και να έχεις πρόσβαση στις υπηρεσίες μας.",
      });
    }
  }
};

export let doLogout = (req, res) => {
  //Σημειώνουμε πως ο χρήστης δεν είναι πια συνδεδεμένος
  req.session.destroy();
  res.redirect("/");
};

//Τη χρησιμοποιούμε για να ανακατευθύνουμε στη σελίδα /login όλα τα αιτήματα από μη συνδεδεμένους χρήστες
export let checkAuthenticated = function (req, res, next) {
  //Αν η μεταβλητή συνεδρίας έχει τεθεί, τότε ο χρήστης είναι συνεδεμένος
  if (req.session.loggedUserId) {
    console.log("user is authenticated", req.originalUrl);
    //Καλεί τον επόμενο χειριστή (handler) του αιτήματος
    next();
  } else {
    //Ο χρήστης δεν έχει ταυτοποιηθεί, αν απλά ζητάει το /login ή το register δίνουμε τον
    //έλεγχο στο επόμενο middleware που έχει οριστεί στον router
    if (req.originalUrl === "/login" || req.originalUrl === "/register") {
      next();
    } else {
      //Στείλε το χρήστη στη "/login"
      console.log("not authenticated, redirecting to /login");
      res.redirect("/login");
    }
  }
};
