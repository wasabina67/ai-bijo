const IMAGE_COUNT = 20;
const imageNum = Math.floor(Math.random() * IMAGE_COUNT) + 1;
document.getElementById("bg-image").src = "../images/" + imageNum + ".jpg";

const weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
let displayYear, displayMonth;

const now = new Date();
displayYear = now.getFullYear();
displayMonth = now.getMonth();

function updateTime() {
  const t = new Date();
  document.getElementById("date-text").textContent = t.toLocaleDateString(
    "en-US",
    { year: "numeric", month: "2-digit", day: "2-digit" }
  );
  document.getElementById("time-text").textContent = t.toLocaleTimeString(
    "en-US",
    { hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: false }
  );
}

function renderCalendar() {}

document.getElementById("prev-btn").addEventListener("click", function () {
  displayMonth--;
  if (displayMonth < 0) {
    displayMonth = 11;
    displayYear--;
  }
  renderCalendar();
});

document.getElementById("next-btn").addEventListener("click", function () {
  displayMonth++;
  if (displayMonth > 11) {
    displayMonth = 0;
    displayYear++;
  }
  renderCalendar();
});

renderCalendar();
updateTime();
setInterval(updateTime, 1000);
