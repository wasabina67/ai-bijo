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

function renderCalendar() {
  const monthYear = document.getElementById("month-year");
  const grid = document.getElementById("calendar-grid");
  const mm = String(displayMonth + 1).padStart(2, "0");
  monthYear.textContent = displayYear + " / " + mm;

  grid.innerHTML = "";

  weekdays.forEach(function (d) {
    const div = document.createElement("div");
    div.className = "weekday";
    div.textContent = d;
    grid.appendChild(div);
  });

  const firstDay = new Date(displayYear, displayMonth, 1).getDay();
  const daysInMonth = new Date(displayYear, displayMonth + 1, 0).getDate();
  const prevDays = new Date(displayYear, displayMonth, 0).getDate();

  const today = new Date();
  const todayYear = today.getFullYear();
  const todayMonth = today.getMonth();
  const todayDate = today.getDate();

  for (let i = firstDay - 1; i >= 0; i--) {
    const div = document.createElement("div");
    div.className = "day other-month";
    div.textContent = prevDays - i;
    grid.appendChild(div);
  }

  for (let d = 1; d <= daysInMonth; d++) {
    const div = document.createElement("div");
    div.className = "day";
    if (displayYear === todayYear && displayMonth === todayMonth && d === todayDate) {
      div.classList.add("today");
    }
    div.textContent = d;
    grid.appendChild(div);
  }

  const totalCells = firstDay + daysInMonth;
  const remainder = totalCells % 7;
  if (remainder > 0) {
    for (let i = 1; i <= 7 - remainder; i++) {
      const div = document.createElement("div");
      div.className = "day other-month";
      div.textContent = i;
      grid.appendChild(div);
    }
  }
}

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
