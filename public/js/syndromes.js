document.addEventListener("DOMContentLoaded", function () {
  const select = document.getElementById("gym-select");
  const buttons = document.querySelectorAll(".content button");

  function toggleButtons() {
    const isSelected = select.value !== "";
    buttons.forEach((btn) => (btn.disabled = !isSelected));
    
  }
  select.addEventListener("change", () => {
    const selectedGym = select.value;
    if (selectedGym) {
      window.location.href = `/syndromes?gym=${encodeURIComponent(
        selectedGym
      )}#gym-select`;
    }
  });
  select.addEventListener("change", toggleButtons);
  toggleButtons();
});

function confirmPurchase(duration, id) {
  const gym = document.getElementById("gym-select").value;
  let message = [];
  if (Number(duration) === 1) {
    message = `Είστε σίγουροι ότι θέλετε να αγοράσετε τη συνδρομή για ${duration} μήνα στο γυμναστήριο ${gym} ;`;
  } else {
    message = `Είστε σίγουροι ότι θέλετε να αγοράσετε τη συνδρομή για ${duration} μήνες στο γυμναστήριο ${gym} ;`;
  }

  showModal(
    message,
    () => {
      window.location.href = `/syndromes/${id}?gym=${encodeURIComponent(gym)}`;
    },
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
function showToast(success, duration = 3000) {
  const toast = document.getElementById("toast");
  if (success === true) {
    message = "Η συνδρομή αγοράστηκε με επιτυχία!";
  } else {
    message = "Η αγορά της συνδρομης απέτυχε";
  }
  toast.style.background = success ? "green" : "red"; // Ορισμός χρώματος κειμένου
  toast.textContent = message;
  toast.classList.remove("hidden"); // κάνε το ορατό (opacity 1)

  // Μετά το χρόνο duration, ξεκινάμε το fade out (opacity 0)
  setTimeout(() => {
    toast.classList.add("hidden"); // ξεκινά fade out
  }, duration);
}
