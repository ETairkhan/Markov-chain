package input

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func ReadingInput() (string, error) {
	start, err := os.Stdin.Stat()
	if err != nil {
		return "", fmt.Errorf("Couldn't read stdin!")
	}

	if (start.Mode() & os.ModeCharDevice) != 0 {
		return "", fmt.Errorf("error: no input text provided (ensure input is piped or redirected from a file)")
	}

	scanner := bufio.NewScanner(os.Stdin)
	result := []string{}

	for scanner.Scan() {

		line := scanner.Text()
		line = strings.TrimSpace(line)
		if line != "" {
			nilLine := strings.Join(strings.Fields(line), " ")
			result = append(result, nilLine)
		}
	}

	if err := scanner.Err(); err != nil {
		return "", fmt.Errorf("scanner error: %v", err)
	}

	if len(result) == 0 {
		return "", fmt.Errorf("ERROR: empty input text")
	}

	return strings.Join(result, " "), nil
}

func SplitTextToArray(s string) ([]string, error) {
	s = strings.TrimSpace(s)
	array := strings.Split(s, " ")

	if len(array) > 0 {
		return array, nil
	}
	return nil, fmt.Errorf("ERROR: couldn't split string")
}
