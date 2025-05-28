import dotenv from "dotenv";
import dayjs from "dayjs";
import "dayjs/locale/el.js";
dayjs.locale("el");
if (process.env.NODE_ENV !== "production") {
  dotenv.config();
}

const model = await import(
  `../model/${process.env.MODEL}/model-${process.env.MODEL}.mjs`
);

export async function allGymsRender(req, res) {
  try {
    const gyms = await model.getAllGyms();

    res.render("gymnastiria", {
      title: "Γυμναστήρια",
      gyms: gyms,
      css: "gymnastiria.css",
    });
  } catch (error) {
    throw error;
  }
}

export async function allProgramsRender(req, res) {
  try {
    const programs = await model.getAllPrograms();
    res.render("programmata", {
      title: "Προγράμματα",
      programs,
      css: "programmata.css",
      metaDescription:
        "Ανακάλυψε τα προγράμματα γυμναστικής που σου ταιριάζουν.",
    });
  } catch (error) {
    throw error;
  }
}
export async function userGetSubscription(req, res) {
  try {
    const subscriptionId = req.params.id;
    let userSubs = await model.getSubscriptionsByUserId(
      req.session.loggedUserId
    );

    const alreadySubCheck = userSubs.some(
      (sub) =>
        String(sub["SUBSCRIPTION-ID"]) === String(subscriptionId) &&
        String(sub.gym_Location) === String(req.query.gym)
    );
    if (alreadySubCheck) {
      await model.userRenewsSubscription(
        req.session.loggedUserId,
        subscriptionId,
        req.query.gym,
        null
      );
    } else {
      if (req.session.loggedUserId) {
        await model.userSubscribes(
          req.session.loggedUserId,
          subscriptionId,
          req.query.gym
        );
      } else {
        res.redirect("/login");
      }
    }

    res.redirect(`/syndromes-user?success=1&gym=${req.query.gym}#gym-select`);
  } catch (error) {
    console.log(error);
    res.redirect(`/syndromes-user?success=0&gym=${req.query.gym}#gym-select`);
  }
}
export async function allSubscriptionsRender(req, res) {
  try {
    const selectedGym = req.query.gym || null; // Αν υπάρχει query parameter gym, χρησιμοποίησέ το
    const gyms = await model.getAllGyms();
    if (req.session.loggedUserId) {
      res.redirect("/syndromes-user");
      return;
    }

    let syndromes = [];
    if (selectedGym) {
      // Φέρε μόνο τις συνδρομές του συγκεκριμένου γυμναστηρίου
      syndromes = await model.getSubscriptionsByGym(selectedGym);
    } else {
      // Φέρε όλες τις συνδρομές
      syndromes = await model.getAllSubscriptions();
    }

    let success = null;
    if (req.query.success === "1") success = true;
    else if (req.query.success === "0") success = false;
    res.render("syndromes", {
      title: "Συνδρομές",
      syndromes,
      gyms,
      selectedGym,
      success,
      customJs: "/js/syndromes.js",
      css: "syndromes.css",
      userId: req.session.loggedUserId,
    });
  } catch (error) {
    throw error;
  }
}
export async function userSubscriptionsRender(req, res) {
  try {
    const selectedGym = req.query.gym || null;
    const gyms = await model.getAllGyms();
    const userID = req.session.loggedUserId || null;
    const usSubs = [];
    const othSubs = [];

    if (userID) {
      const userSubs = (await model.getSubscriptionsByUserId(userID)) || [];
      let syndromes = selectedGym
        ? await model.getAllSubscriptionsByGymLocation(selectedGym)
        : await model.getAllSubscriptions();

      for (const sub of syndromes) {
        const userSub = userSubs.find(
          (userS) =>
            userS.gym_Location === sub.gym_Location &&
            userS["SUBSCRIPTION-ID"] === sub.ID
        );
        if (userSub) {
          // Υπολογισμός ημερών που απομένουν
          const endDate = new Date(userSub.End_Date);
          const now = new Date();
          const diffDays = Math.ceil((endDate - now) / (1000 * 60 * 60 * 24));
          const subDetails = await model.getSubscriptionsById_gymLoc(
            sub.ID,
            sub.gym_Location
          );
          if (subDetails) {
            subDetails.Days_Left = diffDays;
            subDetails.gym_Location = sub.gym_Location;
            if (diffDays > 0) {
              usSubs.push(subDetails); // Ενεργή συνδρομή
            } else {
              othSubs.push(sub); // Ληγμένη συνδρομή, διαθέσιμη για αγορά
            }
          }
        } else {
          othSubs.push(sub);
        }
      }
    }

    let success = null;
    if (req.query.success === "1") success = true;
    else if (req.query.success === "0") success = false;

    res.render("syndromes-user", {
      title: "Συνδρομές",
      syndromes: {
        my_subs: usSubs,
        other_subs: othSubs,
      },
      gyms,
      selectedGym,
      success,
      customJs: "/js/syndromes-user.js",
      css: "syndromes.css",
      userId: userID,
    });
  } catch (error) {
    throw error;
  }
}

export async function someGymsRender(req, res) {
  try {
    const gyms = await model.getAllGyms();
    const selectedGyms = gyms.slice(0, 6); // Επιλέγουμε τα πρώτα 4 γυμναστήρια
    res.render("index", { title: "GYM-ON Home", gyms: selectedGyms });
  } catch (error) {
    throw error;
  }
}
export async function gymRender(req, res, next) {
  try {
    let location = req.params.gym;

    const gym = await model.getGym(location);
    if (!gym) {
      // Δημιουργία custom error με status code
      const error = new Error("Το γυμναστήριο δεν βρέθηκε.");
      error.status = 404;
      throw error;
    }
    if (req.session.loggedUserId) {
      res.render("perigrafh-gym", {
        title: location,
        userId: req.session.loggedUserId,
        gym,
        css: "perigrafh-gym.css",
      });
    } else {
      res.render("perigrafh-gym", {
        title: location,
        gym,
        css: "perigrafh-gym.css",
      });
    }
  } catch (error) {
    next(error);
  }
}

export async function programRender(req, res, next) {
  try {
    let programName = req.params.program;
    const gyms = await model.getGymsByProgram(programName);

    const program = await model.getProgram(programName);
    if (!program) {
      // Δημιουργία custom error με status code
      const error = new Error("Το πρόγραμμα δεν βρέθηκε.");
      error.status = 404;
      throw error;
    }
    const formattedDescription = program.Description.replace(/\n/g, "<br>");
    program.Description = formattedDescription;

    res.render("perigrafh-program", {
      title: programName,
      program,
      gyms,
      customJs: "/js/perigrafh-program.js",
      css: "perigrafh-program.css",
    });
  } catch (error) {
    next(error);
  }
}

export async function showProfileRender(req, res) {
  const userId = req.session.loggedUserId;
  if (!userId) {
    // Δημιουργία custom error με status code
    const error = new Error("Ο χρήστης δεν βρέθηκε.");
    error.status = 404;
    throw error;
  }
  let sub_id = [];
  let gym_location = [];

  const user = await model.getUserById(userId);

  let user_subscriptions = (await model.getSubscriptionsByUserId(userId)) || [];

  const currentDate = dayjs().format("YYYY-MM-DD");
  user_subscriptions = user_subscriptions.filter(
    (sub) => sub.End_Date >= currentDate
  );
  for (const subscription of user_subscriptions) {
    sub_id = subscription["SUBSCRIPTION-ID"];
    gym_location = subscription.gym_Location;
    const endDate = dayjs(subscription.End_Date, "YYYY-MM-DD");
    const now = dayjs();
    const diffDays = Math.max(0, endDate.diff(now, "day"));
    subscription.my_subscription = await model.getSubscriptionsById_gymLoc(
      sub_id,
      gym_location
    );
    if (subscription.my_subscription) {
      subscription.my_subscription.Days_Left = diffDays;
    }
  }

  if (!user_subscriptions) {
    // Δημιουργία custom error με status code
    const error = new Error("Οι συνδρομές του χρήστη δεν βρέθηκαν.");
    error.status = 404;
    throw error;
  }
  let userSessions = (await model.getUserSessions(userId)) || [];
  let hasUserSessions = userSessions.length > 0;
  let sortedDays;
  let sortedHours;
  const currentPeriod = getSeasonalPeriod(dayjs());
  let filteredSessions = [];
  // Φιλτράρει τις συνεδρίες του χρήστη ώστε να εμφανίζονται μόνο όσες ανήκουν στην τρέχουσα περίοδο (εαρινό/χειμερινό)
  if (userSessions) {
    filteredSessions = userSessions.filter((session) => {
      return getSeasonalPeriod(session.Date) === currentPeriod;
    });

    const daysSet = new Set();
    const hoursSet = new Set();
    if (filteredSessions && filteredSessions.length > 0) {
      filteredSessions.forEach((session) => {
        if (session.Time) {
          const parsed = dayjs(session.Time, ["HH:mm:ss", "HH:mm"]);
          session.Time = parsed.isValid()
            ? parsed.format("HH:mm")
            : String(session.Time).slice(0, 5);
        }
      });
    }
    // Υπολογίζει τις μοναδικές ημέρες και ώρες που υπάρχουν στις συνεδρίες του χρήστη για να εμφανιστούν στο πρόγραμμα
    filteredSessions.forEach((userSession) => {
      userSession.day = dayjs(userSession.Date).format("dddd");
      daysSet.add(userSession.day);
      hoursSet.add(userSession.Time);
    });
    /* στο hbs περνάμε μονο τις συγκεκριμενες ωρες και ημερες*/
    sortedHours = Array.from(hoursSet).sort();
    const weekDays = [
      "Δευτέρα",
      "Τρίτη",
      "Τετάρτη",
      "Πέμπτη",
      "Παρασκευή",
      "Σάββατο",
      "Κυριακή",
    ];
    sortedDays = weekDays.filter((d) => daysSet.has(d));
  }

  res.render("profile", {
    title: "Προφίλ Χρήστη",
    user: user,
    currentPeriod,
    userSessions: filteredSessions,
    hasUserSessions,
    sortedDays,
    sortedHours,
    user_subscriptions: user_subscriptions,
    customJs: "/js/profile.js",
    css: "profile.css",
  });
}

export async function gymSessionsRender(req, res, next) {
  try {
    const gymLocation = req.query.gym;
    const gym = await model.getGym(gymLocation);

    let gyms = await model.getAllGyms();
    const currentPeriod = getSeasonalPeriod(dayjs());
    if (!gym) {
      res.render("programma-gym", {
        title: "Προγράμματα Γυμναστηρίου",
        gyms,
        currentPeriod,
        customJs: "/js/programma-gym.js",
        css: "programma-gym.css",
      });
      return;
    }

    const sessionsRaw = await model.getSessionsByGym(gymLocation);

    // Format την ημερομηνία πριν το στείλεις στο frontend
    const sessions = sessionsRaw.map((session) => {
      // Αν το session.Time υπάρχει, κάνε parsing και format, αλλιώς άφησέ το ως null
      let formattedTime = null;
      if (session.Time) {
        const parsed = dayjs(session.Time, ["HH:mm:ss", "HH:mm"]);
        formattedTime = parsed.isValid()
          ? parsed.format("HH:mm")
          : session.Time.slice(0, 5);
      }
      return {
        ...session,
        Time: formattedTime,
      };
    });

    const sessionUserCount = await model.getSessionUserCount();
    sessions.forEach((session) => {
      const count = sessionUserCount[session.ID] || 0;
      session.availableSpots = session.Max_Number_Of_People - count;
      session.day = dayjs(session.Date).format("dddd");
    });

    if (req.session.loggedUserId) {
      let userSessions = await model.getUserSessionsId(
        req.session.loggedUserId
      );
      sessions.forEach((session) => {
        session.userHasReserved = userSessions.some(
          (userSession) => userSession["SESSION-ID"] === session.ID
        );
      });
    }
    const filteredSessions = sessions.filter((session) => {
      return getSeasonalPeriod(session.Date) === currentPeriod;
    });
    res.render("programma-gym", {
      title: `Πρόγραμμα Μαθημάτων - ${gymLocation}`,
      gyms,
      gym,
      currentPeriod,
      sessions: filteredSessions,
      customJs: "/js/programma-gym.js",
      css: "programma-gym.css",
    });
  } catch (error) {
    next(error);
  }
}
function getSeasonalPeriod(dateInput) {
  const date = dayjs(dateInput);
  const month = date.month() + 1;
  const year = date.year();

  if (month >= 3 && month <= 9) {
    return `Εαρινό ${year}`;
  } else {
    // Για Ιανουάριο–Φεβρουάριο, θεωρούμε ότι ανήκουν στο χειμερινό του προηγούμενου έτους
    return `Χειμερινό ${month <= 2 ? year - 1 : year}`;
  }
}

export async function sessionManage(req, res) {
  const sessionId = req.params.id;
  const userId = req.session.loggedUserId;
  if (!userId) {
    res.redirect("/login");
    return;
  }
  const gymLocation = req.query.gym;
  let userSessions = await model.getUserSessionsId(req.session.loggedUserId);

  const session = userSessions.some(
    (userSession) => String(userSession["SESSION-ID"]) === String(sessionId)
  );

  if (!session) {
    await model.userReservesSession(userId, sessionId);
  } else {
    await model.userUnreservesSession(userId, sessionId);
  }
  if (req.query.profile) {
    res.redirect("/profile#userSchedule");
  } else {
    res.redirect(
      `/programma-gym?gym=${encodeURIComponent(gymLocation)}#gym-select`
    );
  }
}

export async function renewSubscription(req, res) {
  const subscriptionId = req.params.id;
  const gymLocation = req.query.gym;

  const userId = req.session.loggedUserId;

  if (!userId) {
    res.redirect("/login");
    return;
  }
  let userSubscriptions = await model.getSubscriptionsByUserId(userId);

  const currentDate = dayjs().format("YYYY-MM-DD");
  userSubscriptions.forEach((userSubscription) => {
    userSubscription.End_Date = dayjs(userSubscription.End_Date).format(
      "YYYY-MM-DD"
    );
  });
  userSubscriptions = userSubscriptions.filter(
    (sub) => sub.End_Date >= currentDate
  );

  const subscription = await model.getSubscriptionsById_gymLoc(
    subscriptionId,
    gymLocation
  );

  const userSubscription = userSubscriptions.find(
    (sub) =>
      String(sub["SUBSCRIPTION-ID"]) === String(subscriptionId) &&
      sub.gym_Location === gymLocation
  );

  if (!userSubscription) {
    throw new Error("Η συνδρομή δεν βρέθηκε.");
  }

  // Πάρε το End_Date από τη userSubscription
  const currentEndDate = userSubscription.End_Date
    ? dayjs(userSubscription.End_Date)
    : dayjs();
  const monthsToAdd = subscription.CATEGORY_Duration || 1;
  // Ενημερώνει το End_Date μιας συνδρομής προσθέτοντας τη διάρκεια (σε μήνες) στην τρέχουσα ημερομηνία λήξης
  const newEndDate = currentEndDate
    .add(monthsToAdd, "month")
    .format("YYYY-MM-DD");

  if (!subscription) {
    const err = new Error("Η συνδρομή δεν βρέθηκε");
    err.status = 404;
    throw err;
  } else {
    await model.userRenewsSubscription(
      userId,
      subscriptionId,
      gymLocation,
      newEndDate
    );
  }
  res.redirect(`/profile#syndromes`);
}
