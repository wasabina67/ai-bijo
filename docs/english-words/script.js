const IMAGE_COUNT = 50;
const imageNum = Math.floor(Math.random() * IMAGE_COUNT) + 1;
document.getElementById("bg-image").src = "../images/" + imageNum + ".jpg";

let words = [];
let currentIndex = 0;

function renderWord() {
  const w = words[currentIndex];
  document.getElementById("word-text").textContent = w.word;
  document.getElementById("meaning-text").textContent = w.meaning;
  document.getElementById("example-text").textContent = w.example;
  document.getElementById("counter").textContent =
    (currentIndex + 1) + " / " + words.length;
}

function goPrev() {
  currentIndex--;
  if (currentIndex < 0) {
    currentIndex = words.length - 1;
  }
  renderWord();
}

function goNext() {
  currentIndex++;
  if (currentIndex >= words.length) {
    currentIndex = 0;
  }
  renderWord();
}

// Fisher–Yates shuffle
function shuffleArray(array) {
  const shuffled = [...array];
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }
  return shuffled;
}

document.getElementById("prev-btn").addEventListener("click", goPrev);

document.getElementById("next-btn").addEventListener("click", goNext);

document.addEventListener("keydown", function (e) {
  const key = e.key.toLowerCase();
  if (key === "p") {
    goPrev();
  } else if (key === "n") {
    goNext();
  }
});

fetch("data.json")
  .then(function (res) { return res.json(); })
  .then(function (data) {
    words = shuffleArray(data);
    renderWord();
  });
