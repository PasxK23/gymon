import express from "express";
import { engine } from "express-handlebars";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";
import { router } from "./routes/router.mjs";
import compression from 'compression';
import sessionConf from "./app-setup/app-setup-session.mjs";

dotenv.config();

// Setup για __dirname σε ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Δημιουργία εξυπηρετητή Express
const app = express();

// Ρύθμιση Handlebars engine με helpers και partials
app.engine(
  "hbs",
  engine({
    extname: "hbs",
    defaultLayout: "main",
    layoutsDir: path.join(__dirname, "views/layouts"),
    partialsDir: path.join(__dirname, "views/partials"),
    helpers: {
      SplitLines: function (text) {
        if (typeof text !== "string") return "";
        const lines = text.split(",");
        return lines.map((line) => `<div>${line}</div>`).join("");
      },
      ifEquals: function (a, b, options) {
        return a == b ? options.fn(this) : options.inverse(this);
      },
    
     json: function(context) {
  return JSON.stringify(context);
},
    },
  })
);

app.set("view engine", "hbs");
app.set("views", path.join(__dirname, "views"));
app.use(compression());
app.use(express.static(path.join(__dirname, "public")));
app.use(express.urlencoded({ extended: false }));
app.use(sessionConf);
app.use((req, res, next) => {
  if (req.session) {
    res.locals.userId = req.session.loggedUserId;
  } else {
    res.locals.userId = null;
  }
  next();
});
// Χρήση router


app.use("/", router);
app.use((req, res, next) => {
  res.status(404).render("error", {
    title: "Σφάλμα 404",
    message: "Η σελίδα δεν βρέθηκε.",
    status: 404,
    css: "error.css",
  });
});

// Γενικός error handler
app.use((err, req, res, next) => {
  console.error(err.stack); // για logging στο terminal
  res.status(err.status || 500).render("error", {
    title: "Σφάλμα",
    message: "Κάτι πήγε στραβά.",
    status: err.status || 500,
    css: "error.css",
  });
});
// Εκκίνηση server
const PORT = process.env.PORT || "3003";
app.listen(PORT, () => {
  console.log(`Συνδεθείτε στη σελίδα: http://localhost:${PORT}`);
});
