#!/bin/sh
cp iOSIcon.png iOSIcon1024.png
convert iOSIcon.png -resize 20x20 iOSIcon20.png
convert iOSIcon.png -resize 29x29 iOSIcon29.png
convert iOSIcon.png -resize 40x40 iOSIcon40.png
convert iOSIcon.png -resize 58x58 iOSIcon58.png
convert iOSIcon.png -resize 60x60 iOSIcon60.png
convert iOSIcon.png -resize 76x76 iOSIcon76.png
convert iOSIcon.png -resize 80x80 iOSIcon80.png
convert iOSIcon.png -resize 87x87 iOSIcon87.png
convert iOSIcon.png -resize 120x120 iOSIcon120.png
convert iOSIcon.png -resize 152x152 iOSIcon152.png
convert iOSIcon.png -resize 167x167 iOSIcon167.png
convert iOSIcon.png -resize 180x180 iOSIcon180.png

cp macOSIcon.png macOSIcon1024.png
convert macOSIcon.png -resize 16x16 macOSIcon16.png
convert macOSIcon.png -resize 32x32 macOSIcon32.png
convert macOSIcon.png -resize 64x64 macOSIcon64.png
convert macOSIcon.png -resize 128x128 macOSIcon128.png
convert macOSIcon.png -resize 256x256 macOSIcon256.png
convert macOSIcon.png -resize 512x512 macOSIcon512.png
