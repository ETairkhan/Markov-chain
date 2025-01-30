package flags

import (
	"flag"
	"fmt"
	"os"
	"strings"

	"markovchain/input"
	"markovchain/markov"
)

var (
	Help         = flag.Bool("help", false, "Show usage")
	WordLimit    = flag.Int("w", 100, "Number of max words")
	StartPrefix  = flag.String("p", "", "Starting prefix")
	PrefixLength = flag.Int("l", 2, "Prefix length")
)

func showUsage() {
	fmt.Println("Markov Chain text generator.")
	fmt.Println()
	fmt.Println("Usage:")
	fmt.Println("  markovchain [-w <N>] [-p <S>] [-l <N>]")
	fmt.Println("  markovchain --help")
	fmt.Println()
	fmt.Println("Options:")
	fmt.Println("  --help  Show this screen.")
	fmt.Println("  -w N    Number of maximum words")
	fmt.Println("  -p S    Starting prefix")
	fmt.Println("  -l N    Prefix length")
}

func ParseFlags() {
	flag.Parse()

	args := flag.Args()
	for _, arg := range args {
		if !strings.HasPrefix(arg, "-") {
			fmt.Fprintln(os.Stderr, arg+"-is invalid command")
			os.Exit(1)
		}
	}
	if *Help {
		showUsage()
		return
	}

	text, err := input.ReadingInput()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	wordsArray, err := input.SplitTextToArray(text)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	if *PrefixLength <= 0 {
		fmt.Fprintln(os.Stderr, "ERROR: prefix length can't be negative or zero")
		os.Exit(1)
	}

	validateFlags(wordsArray)

	markov := markov.NewChain(*PrefixLength)
	markov.BuildMarkovChain(wordsArray)

	answer := markov.GenerateText(*StartPrefix, *WordLimit)
	fmt.Println(answer)
}
