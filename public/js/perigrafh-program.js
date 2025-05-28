document.addEventListener("DOMContentLoaded", function () {
  const select = document.getElementById("gym-select");
  const button = document.querySelector(".description-selection button");
  function toggleButton() {
    const isSelected = select.value !== "";
    button.disabled = !isSelected;
    // window.location.href = `?gym=${select.value}`;
  }
  button.addEventListener("click", () => {
    const selectedGym = select.value;
    if (selectedGym) {
      window.location.href = `/programma-gym?gym=${encodeURIComponent(
        selectedGym
      )}#gym-select`;
    }
  });
  select.addEventListener("change", toggleButton);

  toggleButton();
});
