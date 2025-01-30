package flags

import (
	"fmt"
	"os"
	"strings"
)

func validateFlags(wordsArray []string) {
	if *StartPrefix == "" {
		if len(wordsArray) >= *PrefixLength {
			*StartPrefix = strings.Join(wordsArray[:*PrefixLength], " ")
		} else {
			fmt.Fprintln(os.Stderr, "ERROR: your prefix length is greater than the available words")
			os.Exit(1)
		}
	} else {
		*StartPrefix = strings.Join(strings.Fields(*StartPrefix), " ")
		if len(strings.Fields(*StartPrefix)) < 1 {
			fmt.Fprintln(os.Stderr, "ERROR: start prefix must have at least 2 words")
			os.Exit(1)
		}
	}

	if *WordLimit < 0 || *WordLimit > 10000 {
		fmt.Fprintln(os.Stderr, "ERROR: Words count must be between 0 and 10'000")
		os.Exit(1)
	}

	if len(strings.Fields(*StartPrefix)) < 1 {
		fmt.Fprintln(os.Stderr, "ERROR: Start prefix must have more than 1 word")
		os.Exit(1)
	}

	if *PrefixLength < 1 || *PrefixLength > 5 {
		fmt.Fprintln(os.Stderr, "ERROR: Prefix length must be between 1 and 5")
		os.Exit(1)
	} else if *PrefixLength != len(strings.Fields(*StartPrefix)) {
		fmt.Fprintln(os.Stderr, "ERROR: Prefix length must match the number of words in the start prefix")
		os.Exit(1)
	}
	if len(wordsArray) < *PrefixLength+1 {
		fmt.Fprintln(os.Stderr, "ERROR: Prefix length")
		os.Exit(1)
	}
}
