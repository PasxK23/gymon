function confirmRenew(duration, id, gym_Location) {
  let message;
  console.log("gym", gym_Location);
  if (Number(duration) === 1) {
    message = `Είστε σίγουροι ότι θέλετε να ανανεώσετε τη συνδρομή για ${duration} μήνα στο γυμναστήριο ${gym_Location};`;
  } else {
    message = `Είστε σίγουροι ότι θέλετε να ανανεώσετε τη συνδρομή για ${duration} μήνες στο γυμναστήριο ${gym_Location};`;
  }
  showModal(
    message,
    () =>
      (window.location.href = `/profile/${id}?gym=${encodeURIComponent(
        gym_Location
      )}`),

    () => console.log("Ακύρωση")
  );
}
function showModal(message, onConfirm, onCancel) {
  const modal = document.getElementById("custom-modal");
  const modalMessage = document.getElementById("modal-message");
  const modalOk = document.getElementById("modal-ok");
  const modalCancel = document.getElementById("modal-cancel");

  modalMessage.textContent = message;
  modal.classList.remove("hidden");

  modalOk.onclick = () => {
    modal.classList.add("hidden");
    onConfirm();
  };
  modalCancel.onclick = () => {
    modal.classList.add("hidden");
    onCancel();
  };
}

document.addEventListener("DOMContentLoaded", function () {
  const container = document.getElementById("syndromes");
  if (!container) return;
  // Βρες μόνο τα .card που δεν έχουν την κλάση plus-card
  const cards = Array.from(container.getElementsByClassName("card")).filter(
    (el) => !el.classList.contains("plus-card")
  );
  if (cards.length <= 2) {
    container.classList.add("flex-fit");
    container.classList.remove("grid");
  } else {
    container.classList.remove("flex-fit");
    container.classList.add("grid");
  }
});
