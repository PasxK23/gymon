document.addEventListener("DOMContentLoaded", () => {
  const select = document.getElementById("gym-select");
  if (select) {
    select.addEventListener("change", () => {
      const selectedGym = select.value;
      if (selectedGym) {
        window.location.href = `/programma-gym?gym=${encodeURIComponent(
          selectedGym
        )}#gym-select`;
      }
    });
  }
});

function placeSessionsInTable(sessions) {
  // Πάρε τον πίνακα
  selectedGym = document.getElementById("gym-select").value;
  const table = document.getElementById("schedule-table");
  // Πάρε την πρώτη γραμμή (thead) για να βρεις index κάθε ημέρας
  const dayHeaders = Array.from(table.rows[0].cells); // includes "Ώρα", "Δευτέρα", ...

  sessions.forEach((session) => {
    // Βρες τη στήλη της ημέρας
    const colIndex = dayHeaders.findIndex(
      (cell) => cell.textContent.trim() === session.day
    );
    if (colIndex === -1) return; // άκυρη ημέρα

    // Βρες το row που έχει τη σωστή ώρα
    for (let i = 1; i < table.rows.length; i++) {
      const row = table.rows[i];
      const rowTime = row.cells[0].textContent.trim();
      if (rowTime === session.Time) {
        let stateAttr = "";
        if (session.userHasReserved) {
          stateAttr = "reserved";
          iconHtml = `<i class="fa-solid fa-arrow-left" style="margin-left:6px;"></i>`;
        } else if (session.availableSpots <= 0) {
          stateAttr = "unavailable";
          iconHtml = "";
        } else if (session.availableSpots <= 5) {
          stateAttr = "few";
          iconHtml = `<i class="fa-solid fa-arrow-right" style="margin-left:6px;"></i>`;
        } else {
          stateAttr = "available";
          iconHtml = `<i class="fa-solid fa-arrow-right" style="margin-left:6px;"></i>`;
        }
        let spotsHtml = "";
        if (session.availableSpots > 0) {
          spotsHtml = `<span class="session-max">Θέσεις : ${session.availableSpots}</span>`;
        }
        let anchorHref = "";
        if (session.availableSpots > 0 || session.userHasReserved) {
          anchorHref = `/programma-gym/${session.ID}?gym=${encodeURIComponent(
            selectedGym
          )}`;
        } else {
          anchorHref = "";
        }
        // Τοποθέτησε το session στον κατάλληλο κελί;
        const cell = row.cells[colIndex];
        cell.innerHTML += `
        <div class="cell-wrapper">
  <a ${
    anchorHref ? `href="${anchorHref}"` : ""
  } class="session-cell"${stateAttr}>
    <b>${session.PROGRAM_Name || ""}</b><br>
    <span class="session-max"> ${spotsHtml}</span><br>
   ${iconHtml}
  </a>
</div>
`;
        break;
      }
    }
  });
}
