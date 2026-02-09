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
