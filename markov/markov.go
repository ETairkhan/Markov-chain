package markov

import (
	"fmt"
	"math/rand"
	"os"
	"strings"
)

type Chain struct {
	Chain     map[string][]string
	prefixlen int
}

func NewChain(prefixlen int) *Chain {
	return &Chain{
		Chain:     make(map[string][]string),
		prefixlen: prefixlen,
	}
}

func (c *Chain) BuildMarkovChain(words []string) {
	for i := 0; i < len(words)-c.prefixlen; i++ {
		prefix := strings.Join(words[i:i+c.prefixlen], " ")
		suffix := words[i+c.prefixlen]
		c.Chain[prefix] = append(c.Chain[prefix], suffix)
	}
}

func (c *Chain) GenerateText(startPrefix string, wordLimit int) string {
	words := strings.Fields(startPrefix)
	if len(words) != c.prefixlen {
		return "ERROR: Start prefix length must match prefix length."
	}

	prefix := strings.Join(words, " ")

	if _, exists := c.Chain[prefix]; !exists {
		fmt.Println("ERROR: prefix 'invalid prefix' not found")
		os.Exit(1)
	}

	var result []string
	for i := 0; i < len(words) && len(result) < wordLimit; i++ {
		result = append(result, words[i])
	}
	for len(result) < wordLimit {
		prefix := strings.Join(words[len(words)-c.prefixlen:], " ")
		choices, exists := c.Chain[prefix]
		if !exists {
			break
		}
		nextWord := choices[rand.Intn(len(choices))]
		result = append(result, nextWord)
		words = append(words, nextWord)
	}
	return strings.Join(result, " ")
}
