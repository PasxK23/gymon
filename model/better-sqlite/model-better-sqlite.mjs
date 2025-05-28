"use strict";
import argon2d from "argon2";

import { default as bettersqlite3 } from "better-sqlite3";
const sql = new bettersqlite3("model/db/gym_on_database.db", {
  fileMustExist: true,
});

const getAllGyms = () => {
  const query = "SELECT Location FROM GYM";

  try {
    const gyms = sql.prepare(query).all();
    return gyms;
  } catch (error) {
    console.error("Error fetching gyms:", error);
    throw error;
  }
};

const getAllPrograms = () => {
  const query = "SELECT Name FROM PROGRAM";
  try {
    const programs = sql.prepare(query).all();
    return programs;
  } catch (error) {
    console.error("Error fetching programs:", error);
    throw error;
  }
};

const getAllSubscriptions = () => {
  const query = "SELECT  * FROM SUBSCRIPTION  GROUP BY ID order by price desc";
  try {
    const subscriptions = sql.prepare(query).all();
    return subscriptions;
  } catch (error) {
    console.error("Error fetching subscriptions:", error);
    throw error;
  }
};
const getSubscriptionsByGym = (gymLocation) => {
  const subQuery =
    "SELECT [SUBSCRIPTION-ID] FROM USER_SUBSCRIPTION WHERE gym_Location = ?";
  const subIds = sql
    .prepare(subQuery)
    .all(gymLocation)
    .map((row) => row["SUBSCRIPTION-ID"]);

  if (subIds.length === 0) return [];

  const placeholders = subIds.map(() => "?").join(",");
  const query = `SELECT * FROM SUBSCRIPTION WHERE ID IN (${placeholders}) GROUP BY ID order by price desc`;

  try {
    const subscriptions = sql.prepare(query).all(...subIds);
    return subscriptions;
  } catch (error) {
    console.error("Error fetching subscriptions by gym:", error);
    throw error;
  }
};

const getGym = (location) => {
  const query = "SELECT * FROM GYM WHERE Location = ?";
  try {
    const gym = sql.prepare(query).get(location);
    return gym;
  } catch (error) {
    console.error("Error fetching gym:", error);
    throw error;
  }
};

const getGymsByProgram = (programName) => {
  const query =
    "SELECT DISTINCT gym_location FROM GYM_PROVIDES_PROGRAM_SESSION WHERE PROGRAM_Name =?";
  try {
    const gyms = sql.prepare(query).all(programName);

    return gyms;
  } catch (error) {
    console.error("Error fetching gyms by program:", error);
    throw error;
  }
};
const getProgram = (Name) => {
  const query = "SELECT * FROM PROGRAM WHERE Name = ?";
  try {
    const program = sql.prepare(query).get(Name);
    return program;
  } catch (error) {
    console.error("Error fetching program:", error);
    throw error;
  }
};

const findUserByEmail = (email, password) => {
  //Φέρε μόνο μια εγγραφή (το LIMIT 0, 1) που να έχει email και password ίσο με email και password
  const query = sql.prepare(
    "SELECT email FROM USER WHERE email = ? and password = ? LIMIT 0, 1"
  );
  try {
    const user = query.run(email, password);
    return user;
  } catch (err) {
    throw err;
  }
};

const getSubscriptionsByUserId = (userId) => {
  const query = sql.prepare(
    "SELECT * FROM USER_SUBSCRIPTION WHERE [USER-ID] = ?"
  );
  try {
    const subrscriptions = query.all(userId);
    return subrscriptions;
  } catch (err) {
    throw err;
  }
};

const getUserByEmail = (email) => {
  const query = sql.prepare(
    "SELECT ID, Email, password FROM USER WHERE Email = ? LIMIT 0, 1"
  );
  try {
    const user = query.get(email);

    return user;
  } catch (err) {
    throw err;
  }
};
const userSubscribes = (userId, subscriptionId, gym_Location) => {
  let subDuration;
  try {
    const subQuery = sql.prepare(
      "SELECT CATEGORY_Duration FROM SUBSCRIPTION WHERE ID = ?"
    );
    const subDurationRow = subQuery.get(subscriptionId);
    subDuration = subDurationRow ? subDurationRow.CATEGORY_Duration : null;
  } catch (err) {
    throw err;
  }

  if (!subDuration) {
    const error = new Error("Invalid subscription ID");
    error.status = 404;
    throw error;
  }

  // Δημιουργούμε το string '+X months'
  const durationString = `+${subDuration} months`;

  const insertQuery = sql.prepare(`
    INSERT INTO USER_SUBSCRIPTION 
      ([USER-ID], [SUBSCRIPTION-ID], gym_Location, Start_Date, End_Date)
    VALUES (?, ?, ?, CURRENT_DATE, DATE('now', ?))
  `);

  try {
    insertQuery.run(userId, subscriptionId, gym_Location, durationString);
  } catch (err) {
    throw err;
  }
};
//Η συνάρτηση δημιουργεί έναν νέο χρήστη με password
// ...existing code...

const registerUser = async (name, password, email, phone, address, surname) => {
  // Έλεγχος αν υπάρχει χρήστης με αυτό το email
  if (!name || !surname || !address) {
    return { message: "Λείπουν υποχρεωτικά πεδία" };
  }
  const userEm = getUserByEmail(email);
  if (userEm != undefined) {
    return { message: "Υπάρχει ήδη χρήστης με αυτό το Email" };
  } else {
    try {
      const hashedPassword = await argon2d.hash(password, 10);
      const query = sql.prepare(
        "INSERT INTO USER(Name,ID,Email,Password,Phone,Location,Surname) VALUES (?,null, ?, ?, ?, ?, ?)"
      );
      const info = query.run(
        name,
        email,
        hashedPassword,
        phone,
        address,
        surname
      );
      return info.lastInsertRowid;
    } catch (error) {
      throw error;
    }
  }
};
const getUserById = (id) => {
  const query = sql.prepare("SELECT * FROM USER WHERE ID = ? LIMIT 0, 1");
  try {
    const user = query.get(id);
    return user;
  } catch (err) {
    throw err;
  }
};

const getSessionsByGym = (gymLocation) => {
  // Παίρνουμε όλα τα sessions που παρέχει το συγκεκριμένο γυμναστήριο
  const query = `
    SELECT 
      S.ID, S.Max_Number_Of_People, S.Date, S.Time, GPS.PROGRAM_NAME
    FROM 
      GYM_PROVIDES_PROGRAM_SESSION GPS
    JOIN 
      SESSION S ON GPS.SESSION_ID = S.ID
    WHERE 
      GPS.GYM_LOCATION = ?
    ORDER BY S.Date, S.Time
  `;
  try {
    const sessions = sql.prepare(query).all(gymLocation);
    return sessions;
  } catch (error) {
    console.error("Error fetching sessions by gym:", error);
    throw error;
  }
};

const getSubscriptionsById_gymLoc = (id, gym_Location) => {
  if (
    id === undefined ||
    gym_Location === undefined ||
    id === null ||
    gym_Location === null
  ) {
    throw new Error("Invalid arguments: id and gym_Location must be defined");
  }

  // Παίρνουμε όλες τις συνδρομές του γυμναστηρίου
  const query = sql.prepare(
    "SELECT * FROM SUBSCRIPTION WHERE ID = ? and gym_Location = ? LIMIT 0 ,1"
  );
  try {
    const subscriptions = query.get(id, gym_Location);
    return subscriptions;
  } catch (error) {
    console.error(
      "Error fetching subscriptions by gym location:",
      error,
      id,
      gym_Location
    );
    throw error;
  }
};

const getAllSubscriptionsByGymLocation = (gymLocation) => {
  const query = `
    SELECT * FROM SUBSCRIPTION
    WHERE gym_Location = ?
    GROUP BY ID
    ORDER BY price DESC
  `;
  try {
    return sql.prepare(query).all(gymLocation);
  } catch (error) {
    console.error("Error fetching all subscriptions by gym location:", error);
    throw error;
  }
};
const getSessionUserCount = () => {
  const query = `
    SELECT [SESSION-ID] as sessionId, COUNT([USER-ID]) as count
    FROM USER_RESERVES_SESSION
    GROUP BY [SESSION-ID]
  `;
  const rows = sql.prepare(query).all();
  const result = {};
  rows.forEach((row) => {
    result[row.sessionId] = row.count;
  });
  return result;
};
const getUserSessionsId = (userId) => {
  const query =
    "SELECT [SESSION-ID] FROM USER_RESERVES_SESSION WHERE [USER-ID] = ?";
  try {
    const sessions = sql.prepare(query).all(userId);
    return sessions;
  } catch (error) {
    console.error("Error fetching user sessions:", error);
    throw error;
  }
};
const userReservesSession = (userId, sessionId) => {
  const insertQuery = sql.prepare(`
    INSERT INTO USER_RESERVES_SESSION 
      ([USER-ID], [SESSION-ID])
    VALUES (?, ?)
  `);

  try {
    insertQuery.run(userId, sessionId);
  } catch (err) {
    throw err;
  }
};
const userUnreservesSession = (userId, sessionId) => {
  const deleteQuery = sql.prepare(`
    DELETE FROM USER_RESERVES_SESSION 
    WHERE [USER-ID] = ? AND [SESSION-ID] = ?
  `);

  try {
    deleteQuery.run(userId, sessionId);
  } catch (err) {
    throw err;
  }
};
const getUserSessions = (userId) => {
  const query = sql.prepare(`SELECT *  FROM USER_RESERVES_SESSION AS US 
    JOIN SESSION AS S ON US.[SESSION-ID]=S.ID 
    JOIN GYM_PROVIDES_PROGRAM_SESSION AS GPS ON GPS.SESSION_ID=S.ID 
    WHERE US.[USER-ID]=?`);
  try {
    const userSession = query.all(userId);
    return userSession;
  } catch (err) {
    throw err;
  }
};
const userRenewsSubscription = (
  userId,
  subscriptionId,
  gym_Location,
  newEndDate
) => {
  let duration;
  if (!newEndDate) {
    try {
      const subQuery = sql.prepare(
        "SELECT CATEGORY_Duration FROM SUBSCRIPTION WHERE ID = ?"
      );
      const subDurationRow = subQuery.get(subscriptionId);
      duration = subDurationRow ? subDurationRow.CATEGORY_Duration : null;
    } catch (err) {
      throw err;
    }

    if (!duration) {
      const error = new Error("Invalid subscription ID");
      error.status = 404;
      throw error;
    }

    // Δημιουργούμε το string '+X months'
    const durationString = `+${duration} months`;

    const updateQuery = sql.prepare(`
    UPDATE USER_SUBSCRIPTION SET
     Start_Date = CURRENT_DATE,
      End_Date = DATE('now', ?)
    WHERE [USER-ID] = ? AND [SUBSCRIPTION-ID] = ? AND gym_Location = ?
  `);

    try {
      updateQuery.run(durationString, userId, subscriptionId, gym_Location);
    } catch (err) {
      throw err;
    }
  } else {
    const insertQuery = sql.prepare(`
    UPDATE USER_SUBSCRIPTION SET
      End_Date = ?
    WHERE [USER-ID] = ? AND [SUBSCRIPTION-ID] = ? AND gym_Location = ?
  `);

    try {
      insertQuery.run(newEndDate, userId, subscriptionId, gym_Location);
    } catch (err) {
      throw err;
    }
  }
};

export {
  getAllGyms,
  getAllPrograms,
  getAllSubscriptions,
  getSubscriptionsByGym,
  getGym,
  getProgram,
  getGymsByProgram,
  getUserByEmail,
  registerUser,
  findUserByEmail,
  userSubscribes,
  getSessionsByGym,
  getSubscriptionsByUserId,
  getUserById,
  getSessionUserCount,
  getUserSessionsId,
  userReservesSession,
  userUnreservesSession,
  getSubscriptionsById_gymLoc,
  userRenewsSubscription,
  getAllSubscriptionsByGymLocation,
  getUserSessions,
};
