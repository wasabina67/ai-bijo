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

fetch("data.json")
  .then(function (res) { return res.json(); })
  .then(function (data) {
    words = data;
    renderWord();
  });

document.getElementById("prev-btn").addEventListener("click", function () {
  currentIndex--;
  if (currentIndex < 0) {
    currentIndex = words.length - 1;
  }
  renderWord();
});

document.getElementById("next-btn").addEventListener("click", function () {
  currentIndex++;
  if (currentIndex >= words.length) {
    currentIndex = 0;
  }
  renderWord();
});
