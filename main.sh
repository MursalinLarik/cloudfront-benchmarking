#!/bin/bash

# Define the website URL
URL="http://muhmoh-bucket2-lab1.s3-website-us-west-1.amazonaws.com"

# Number of times to test the website
NUM_TESTS=50

# CSV file to store the results
CSV_FILE="website_loading_times.csv"

rm $CSV_FILE

# Perform website loading time tests
echo "TestNumber,LoadingTime (ms)" > $CSV_FILE

for ((i = 1; i <= $NUM_TESTS; i++)); do
    loading_time=$(curl -o /dev/null -s -H "Cache-Control: no-cache" --compressed -w "%{time_total}\n" $URL)
    echo "$i,$loading_time" >> $CSV_FILE
    echo "Test $i: $loading_time ms"
done

# Calculate the average loading time
average_loading_time=$(awk -F',' '{ sum += $2 } END { print sum / NR }' $CSV_FILE)
echo "Average Loading Time: $average_loading_time ms"

# Create a line graph using gnuplot
gnuplot -persist << EOF
set terminal png size 800,400
set output 'website_loading_times.png'
set title 'Website Loading Times'
set xlabel 'Test Number'
set ylabel 'Loading Time (ms)'
set datafile separator ","
plot "$CSV_FILE" using 1:2 with lines
EOF
