#!/bin/bash
set -euo pipefail

source .env

if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed"
    exit 1
fi

places_jp=(
    "Mount Fuji"
    "Kinkaku-ji Temple in Kyoto"
    "Tokyo Tower"
    "Itsukushima Shrine"
    "Nara Park"
    "Okinawa Churaumi Aquarium"
    "Nikko Toshogu Shrine"
    "Himeji Castle"
    "Otaru Canal in Hokkaido"
    "Yakushima Island"
    "Fushimi Inari Shrine in Kyoto"
    "Shibuya Crossing in Tokyo"
    "Matsumoto Castle"
    "Arashiyama Bamboo Grove"
    "Kenroku-en Garden in Kanazawa"
    "Miyajima Island"
    "Senso-ji Temple in Asakusa"
    "Kumano Kodo Pilgrimage Trail"
    "Jigokudani Monkey Park"
    "Shuri Castle in Okinawa"
)

places_us=(
    "Statue of Liberty"
    "Grand Canyon"
    "Golden Gate Bridge"
    "Times Square"
    "Niagara Falls"
    "Hollywood Sign"
    "Mount Rushmore"
    "Yellowstone National Park"
    "Las Vegas Strip"
    "Brooklyn Bridge"
    "Central Park in New York"
    "Walt Disney World"
    "Yosemite National Park"
    "White House"
    "Space Needle in Seattle"
    "Waikiki Beach in Hawaii"
    "Antelope Canyon"
    "Monument Valley"
    "Glacier National Park"
    "French Quarter in New Orleans"
)

places_eu=(
    "Eiffel Tower"
    "Big Ben"
    "Colosseum"
    "Sagrada Familia"
    "Brandenburg Gate"
    "Acropolis"
    "Tower Bridge"
    "Louvre Museum"
    "Neuschwanstein Castle"
    "Anne Frank House"
    "Santorini Island in Greece"
    "Charles Bridge in Prague"
    "Hallstatt Village in Austria"
    "Duomo di Milano"
    "Plitvice Lakes in Croatia"
    "Alhambra in Granada"
    "Stonehenge"
    "Matterhorn in Switzerland"
    "Rialto Bridge in Venice"
    "Mont Saint-Michel in France"
)

places_cn=(
    "Great Wall of China"
    "Forbidden City"
    "Terracotta Army"
    "The Bund in Shanghai"
    "West Lake in Hangzhou"
    "Li River in Guilin"
    "Potala Palace"
    "Tiananmen Square"
    "Zhangjiajie National Forest Park"
    "Victoria Harbour in Hong Kong"
    "Temple of Heaven in Beijing"
    "Jiuzhaigou Valley"
    "Yellow Mountains"
    "Summer Palace in Beijing"
    "Leshan Giant Buddha"
    "Chengdu Panda Base"
    "Mogao Caves in Dunhuang"
    "Tiger Leaping Gorge in Yunnan"
    "Shanghai Tower"
    "Macau Historic Centre"
)

places_sea=(
    "Angkor Wat"
    "Marina Bay Sands"
    "Ha Long Bay"
    "Borobudur Temple"
    "Phi Phi Islands"
    "Bali Rice Terraces"
    "Merlion Park"
    "Petronas Twin Towers"
    "El Nido in Palawan"
    "Temples of Bagan"
    "Hoi An Ancient Town"
    "Komodo Island"
    "Luang Prabang"
    "Chocolate Hills in Bohol"
    "Gardens by the Bay in Singapore"
    "Tanah Lot Temple in Bali"
    "Railay Beach in Thailand"
    "Cu Chi Tunnels in Vietnam"
    "Inle Lake in Myanmar"
    "Raja Ampat Islands"
)

places=("${places_jp[@]}" "${places_us[@]}" "${places_eu[@]}" "${places_cn[@]}" "${places_sea[@]}")
random_index=$((RANDOM % ${#places[@]}))
background="${places[$random_index]}"

prompt="Subject: A beautiful anime girl character
Background: ${background}
Style: Anime
Composition: Full body shot
Mood: Cheerful and bright
Requirements: No text in the image"

output_file="docs/images/output_$(date +%Y%m%d_%H%M%S).jpg"

response=$(curl -s https://api.openai.com/v1/images/generations \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${OPENAI_API_KEY}" \
    -d "$(jq -n --arg prompt "$prompt" '{
        model: "gpt-image-1.5",
        prompt: $prompt,
        n: 1,
        size: "1024x1024",
        quality: "high",
        output_format: "jpeg"
    }')")

b64=$(echo "$response" | jq -r '.data[0].b64_json')
if [ -z "$b64" ] || [ "$b64" = "null" ]; then
    echo "Error: API request failed"
    echo "$response" | jq .
    exit 1
fi

echo "$b64" | base64 --decode > "${output_file}"
echo "Image saved to ${output_file}"
