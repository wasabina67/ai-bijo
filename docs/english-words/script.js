const IMAGE_COUNT = 20;
const imageNum = Math.floor(Math.random() * IMAGE_COUNT) + 1;
document.getElementById("bg-image").src = "../images/" + imageNum + ".jpg";
