document.addEventListener("scroll", () => {
  const header = document.querySelector("header");
  if (window.scrollY > 50) {
    header.classList.add("scrolled");
  } else {
    header.classList.remove("scrolled");
  }
});
function toggleMenu() {
  const menu = document.getElementById("mobileMenu");
  const bars = document.getElementById("mobile_bars");
  const x = document.getElementById("mobile_x");
  menu.classList.toggle("open");
  if (menu.classList.contains("open")) {
    bars.style.display = "none";
    x.style.display = "inline";
  } else {
    bars.style.display = "inline";
    x.style.display = "none";
  }
}
document.addEventListener("DOMContentLoaded", () => {
  const path = window.location.pathname;
  const navLinks = document.querySelectorAll(".tab-item");

  navLinks.forEach((link) => {
    const href = link.getAttribute("href");
    if (path === href || path.startsWith(href + "/")) {
      link.setAttribute("data-active", "true");
    } else {
      link.removeAttribute("data-active");
    }
  });
});
