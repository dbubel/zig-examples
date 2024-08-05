package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
)

func main() {
	file, err := os.Open("data.jsonl")
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	vecData := [][]float32{}
	centroids := [][]float32{}
	tempCentroids := [][]float32{}
	_ = tempCentroids

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	for scanner.Scan() {
		line := scanner.Bytes()
		vec := []float32{}
		err = json.Unmarshal(line, &vec)
		if err != nil {
			return
		}

		vecData = append(vecData, vec)
	}

	var guesses map[int]struct{}
	guesses = make(map[int]struct{})

	for len(guesses) < 2 {
		guess := rand.Intn(2)
		if _, exists := guesses[guess]; !exists {
			guesses[guess] = struct{}{}
			centroids = append(centroids, vecData[guess])
		}
	}

	for _, c := range centroids {
		fmt.Println(c)
	}
}
