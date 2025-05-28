"use strict";
import argon2d from "argon2";

import pkg from "pg";
pkg.types.setTypeParser(1082, (str) => str);
const { Pool } = pkg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL, // θα το ορίσεις στο Render
  ssl: {
    rejectUnauthorized: false, // σημαντικό για Render
  },
});

// Παράδειγμα ερώτησης
const result = await pool.query(`SELECT * FROM "USER"`);

const getAllGyms = async () => {
  const query = `SELECT "Location" FROM "GYM"`;
  try {
    const { rows } = await pool.query(query);
    return rows;
  } catch (error) {
    throw error;
  }
};

const getAllPrograms = async () => {
  const query = `SELECT "Name" FROM "PROGRAM"`;
  try {
    const { rows } = await pool.query(query);
    return rows;
  } catch (error) {
    console.error("Error fetching programs:", error);
    throw error;
  }
};

const getAllSubscriptions = async () => {
  const query = `
        SELECT DISTINCT ON ("ID") *
        FROM "SUBSCRIPTION"
        ORDER BY  "ID", "Price" DESC
    `;
  try {
    const { rows } = await pool.query(query);
    return rows;
  } catch (error) {
    console.error("Error fetching subscriptions:", error);
    throw error;
  }
};
const getSubscriptionsByGym = async (gymLocation) => {
  const subQuery = `SELECT "SUBSCRIPTION-ID" FROM "USER_SUBSCRIPTION" WHERE "gym_Location" = $1`;
  try {
    const { rows: subIdsRows } = await pool.query(subQuery, [gymLocation]);
    const subIds = subIdsRows.map((row) => row["SUBSCRIPTION-ID"]);
    if (subIds.length === 0) return [];
    const placeholders = subIds.map((_, i) => `$${i + 1}`).join(",");
    const query = `
            SELECT DISTINCT ON ("ID") *
                FROM "SUBSCRIPTION"
                WHERE "ID" IN (${placeholders})
                ORDER BY "ID", "Price" DESC
            `;
    const { rows } = await pool.query(query, subIds);
    return rows;
  } catch (error) {
    console.error("Error fetching subscriptions by gym:", error);
    throw error;
  }
};

const getGym = async (location) => {
  const query = `SELECT * FROM "GYM" WHERE "Location" = $1`;
  try {
    const { rows } = await pool.query(query, [location]);
    return rows[0];
  } catch (error) {
    console.error("Error fetching gym:", error);
    throw error;
  }
};

const getGymsByProgram = async (programName) => {
  const query = `SELECT DISTINCT "GYM_Location"
FROM "GYM_PROVIDES_PROGRAM_SESSION"
WHERE "PROGRAM_Name" = $1`;
  try {
    const { rows } = await pool.query(query, [programName]);
    return rows;
  } catch (error) {
    console.error("Error fetching gyms by program:", error);
    throw error;
  }
};
const getProgram = async (name) => {
  const query = `SELECT * FROM "PROGRAM" WHERE "Name" = $1`;
  try {
    const { rows } = await pool.query(query, [name]);
    return rows[0];
  } catch (error) {
    console.error("Error fetching program:", error);
    throw error;
  }
};

const findUserByEmail = async (email, password) => {
  const query = `SELECT "Email" FROM "USER" WHERE "Email" = $1 AND "Password" = $2 LIMIT 1`;
  try {
    const { rows } = await pool.query(query, [email, password]);
    return rows[0];
  } catch (err) {
    throw err;
  }
};

const getSubscriptionsByUserId = async (userId) => {
  const query = `SELECT * FROM "USER_SUBSCRIPTION" WHERE "USER-ID" = $1`;
  try {
    const { rows } = await pool.query(query, [userId]);
    return rows;
  } catch (err) {
    throw err;
  }
};
const getUserByEmail = async (email) => {
  const query = `SELECT "ID", "Email", "Password" FROM "USER" WHERE "Email" = $1 LIMIT 1`;
  try {
    const { rows } = await pool.query(query, [email]);
    return rows[0];
  } catch (err) {
    throw err;
  }
};
const userSubscribes = async (userId, subscriptionId, gym_Location) => {
  let subDuration;
  try {
    const subQuery = `SELECT "CATEGORY_Duration" FROM "SUBSCRIPTION" WHERE "ID" = $1`;
    const { rows } = await pool.query(subQuery, [subscriptionId]);
    subDuration = rows[0] ? rows[0].CATEGORY_Duration : null;
  } catch (err) {
    throw err;
  }
  if (!subDuration) {
    const error = new Error("Invalid subscription ID");
    error.status = 404;
    throw error;
  }
  // Δημιουργούμε το string '+X months'
  // Υπολογισμός ημερομηνιών για PostgreSQL
  const insertQuery = `
    INSERT INTO "USER_SUBSCRIPTION" 
      ("USER-ID", "SUBSCRIPTION-ID", "gym_Location", "Start_Date", "End_Date")
    VALUES ($1, $2, $3, CURRENT_DATE, CURRENT_DATE + interval '${subDuration} months')
  `;
  try {
    await pool.query(insertQuery, [userId, subscriptionId, gym_Location]);
  } catch (err) {
    throw err;
  }
};
//Η συνάρτηση δημιουργεί έναν νέο χρήστη με password
const registerUser = async (name, password, email, phone, address, surname) => {
  // Έλεγχος αν υπάρχει χρήστης με αυτό το email
  if (!name || !surname || !address) {
    return { message: "Λείπουν υποχρεωτικά πεδία" };
  }
  const userEm = await getUserByEmail(email);
  if (userEm != undefined) {
    return { message: "Υπάρχει ήδη χρήστης με αυτό το Email" };
  } else {
    try {
      const hashedPassword = await argon2d.hash(password, 10);
      const query = `INSERT INTO "USER" ("Name", "Email", "Password", "Phone", "Location", "Surname") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "ID"`;
      const { rows } = await pool.query(query, [
        name,
        email,
        hashedPassword,
        phone,
        address,
        surname,
      ]);
      return rows[0]?.ID;
    } catch (error) {
      throw error;
    }
  }
};
const getUserById = async (id) => {
  const query = `SELECT * FROM "USER" WHERE "ID" = $1 LIMIT 1`;
  try {
    const { rows } = await pool.query(query, [id]);
    return rows[0];
  } catch (err) {
    throw err;
  }
};

const getSessionsByGym = async (gymLocation) => {
  const query = `
    SELECT 
      s."ID", s."Max_Number_Of_People", s."Date", s."Time", gps."PROGRAM_Name"
    FROM 
      "GYM_PROVIDES_PROGRAM_SESSION" gps
    JOIN 
      "SESSION" s ON gps."SESSION_ID" = s."ID"
    WHERE 
      gps."GYM_Location" = $1
    ORDER BY s."Date", s."Time"
  `;
  try {
    const { rows } = await pool.query(query, [gymLocation]);
    return rows;
  } catch (error) {
    console.error("Error fetching sessions by gym:", error);
    throw error;
  }
};

const getSubscriptionsById_gymLoc = async (id, gym_Location) => {
  if (
    id === undefined ||
    gym_Location === undefined ||
    id === null ||
    gym_Location === null
  ) {
    throw new Error("Invalid arguments: id and gym_Location must be defined");
  }
  const query = `SELECT * FROM "SUBSCRIPTION" WHERE "ID" = $1 AND "gym_Location" = $2 LIMIT 1`;
  try {
    const { rows } = await pool.query(query, [id, gym_Location]);
    return rows[0];
  } catch (error) {
    console.error(
      "Error fetching subscriptions by gym Location:",
      error,
      id,
      gym_Location
    );
    throw error;
  }
};

const getAllSubscriptionsByGymLocation = async (gymLocation) => {
  const query = `
    SELECT DISTINCT ON ("ID") *
        FROM "SUBSCRIPTION"
        WHERE "gym_Location" = $1
        ORDER BY "ID", "Price" DESC
  `;
  try {
    const { rows } = await pool.query(query, [gymLocation]);
    return rows;
  } catch (error) {
    console.error("Error fetching all subscriptions by gym Location:", error);
    throw error;
  }
};
const getSessionUserCount = async () => {
  const query = `
    SELECT "SESSION-ID" as sessionId, COUNT("USER-ID") as count
    FROM "USER_RESERVES_SESSION"
    GROUP BY "SESSION-ID"
  `;
  try {
    const { rows } = await pool.query(query);
    const result = {};
    rows.forEach((row) => {
      result[row.sessionid] = row.count;
    });
    return result;
  } catch (error) {
    throw error;
  }
};
const getUserSessionsId = async (userId) => {
  const query = `SELECT "SESSION-ID" FROM "USER_RESERVES_SESSION" WHERE "USER-ID" = $1`;
  try {
    const { rows } = await pool.query(query, [userId]);
    return rows;
  } catch (error) {
    console.error("Error fetching user sessions:", error);
    throw error;
  }
};
const userReservesSession = async (userId, sessionId) => {
  const insertQuery = `
    INSERT INTO "USER_RESERVES_SESSION" 
      ("USER-ID", "SESSION-ID")
    VALUES ($1, $2)
  `;
  try {
    await pool.query(insertQuery, [userId, sessionId]);
  } catch (err) {
    throw err;
  }
};
const userUnreservesSession = async (userId, sessionId) => {
  const deleteQuery = `
    DELETE FROM "USER_RESERVES_SESSION" 
    WHERE "USER-ID" = $1 AND "SESSION-ID" = $2
  `;
  try {
    await pool.query(deleteQuery, [userId, sessionId]);
  } catch (err) {
    throw err;
  }
};
const getUserSessions = async (userId) => {
  const query = `SELECT *  FROM "USER_RESERVES_SESSION" AS us 
    JOIN "SESSION" AS s ON us."SESSION-ID"=s."ID" 
    JOIN "GYM_PROVIDES_PROGRAM_SESSION" AS gps ON gps."SESSION_ID"=s."ID" 
    WHERE us."USER-ID"=$1`;
  try {
    const { rows } = await pool.query(query, [userId]);
    return rows;
  } catch (err) {
    throw err;
  }
};
const userRenewsSubscription = async (
  userId,
  subscriptionId,
  gym_Location,
  newEndDate
) => {
  let duration;
  if (!newEndDate) {
    try {
      const subQuery = `SELECT "CATEGORY_Duration" FROM "SUBSCRIPTION" WHERE "ID" = $1`;
      const { rows } = await pool.query(subQuery, [subscriptionId]);
      duration = rows[0] ? rows[0].CATEGORY_Duration : null;
    } catch (err) {
      throw err;
    }

    if (!duration) {
      const error = new Error("Invalid subscription ID");
      error.status = 404;
      throw error;
    }

    // Ενημέρωσε Start_Date και End_Date με βάση το duration
    const updateQuery = `
      UPDATE "USER_SUBSCRIPTION" SET
        "Start_Date" = CURRENT_DATE,
        "End_Date" = CURRENT_DATE + interval '${duration} months'
      WHERE "USER-ID" = $1 AND "SUBSCRIPTION-ID" = $2 AND "gym_Location" = $3
    `;
    try {
      await pool.query(updateQuery, [userId, subscriptionId, gym_Location]);
    } catch (err) {
      throw err;
    }
  } else {
    const updateQuery = `
    UPDATE "USER_SUBSCRIPTION" SET
      "End_Date" = $1
    WHERE "USER-ID" = $2 AND "SUBSCRIPTION-ID" = $3 AND "gym_Location" = $4
  `;
    try {
      await pool.query(updateQuery, [
        newEndDate,
        userId,
        subscriptionId,
        gym_Location,
      ]);
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
