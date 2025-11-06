# markov-chain

Learning Objectives
    Implement the Markov Chain algorithm.
    Practice working with algorithms, file I/O, and basic software design.
    Understand the importance of data structures in program design.

Abstract
    The goal of this project is to develop a text generator using the Markov Chain algorithm. This algorithm statistically models input text to generate coherent random text by examining sequences of words. Such methods are similar to predictive text systems used in modern keyboards.

By completing this project, you will:

    Design and implement efficient data structures for storing and accessing word sequences.
    Generate random text based on word probabilities derived from the input.

Context
    Core Idea: Analyze input text to build a state-based model where each state represents a prefix of N words, and transitions to suffix words are determined by statistical frequencies in the original text.

    Challenge: Efficiently store and retrieve prefixes and suffixes for large input datasets (e.g., books with 100,000+ words).

Algorithm Overview
    Input Parsing:
        Read input text as a sequence of words, including punctuation.
        Define "words" as sequences of characters between spaces.

    Model Construction:
        Use a sliding window to extract prefixes of length N (default: 2).
        For each prefix, track the possible suffixes and their frequencies.

    Text Generation:
        Start with a specified prefix or the first N words of the input.
        Randomly choose a suffix based on the observed frequencies.
        Update the prefix and repeat until reaching the desired output length or the end of input.

Data Structure
Prefix-Suffix Mapping:
    Use a hash table (dictionary in Python) where:
        Keys: Tuples of N words (prefix).
        Values: Lists of possible suffixes.
    Example: For a prefix ("data", "structures"), the suffixes could be ["are", "can", "often"].

Mandatory Features

1. Basic Text Generation
    Read input text from stdin or file.
    Generate text using the default settings:
        Prefix length = 2.
        Maximum words = 100.
    Stop when reaching the word limit or the end of text.

Error Handling: If no input is provided, print an error message.

Example:

    $ echo "Hello world. Hello universe." | ./markovchain
    Hello world. Hello universe. Hello world.


2. Word Limit Option
    Accept a -w argument to specify the maximum number of words to generate.
    Constraints:
        Must be a positive integer.
        Cannot exceed 10,000.
    Error message for invalid input.
Example:

    $ echo "Hello world. Hello universe." | ./markovchain -w 5
    Hello world. Hello universe. Hello


3. Custom Prefix
    Accept a -p argument for the starting prefix.
    Constraints:
        Prefix must exist in the input text.
        Prefix length must match the specified or default prefix length.
    Error message for invalid prefixes.
Example:

    $ echo "To be or not to be." | ./markovchain -p "To be" -w 6
    To be or not to be or

4. Variable Prefix Length
    Accept a -l argument to specify prefix length.
    Constraints:
        Must be between 1 and 5.
        Error message for invalid values.
Example:

    $ echo "Data structures are important." | ./markovchain -l 3 -w 7
    Data structures are important. Data structures are

5. Help Command
    Print usage information with the --help flag.
Example:
```bash
    $ ./markovchain --help
    Markov Chain text generator.

    Usage:
    markovchain 
    
    [-w <N>] 
    
    [-p <S>]
    
    [-l <N>]


    markovchain --help

    Options:
    --help  Show this help text.

    -w N    Maximum number of words (default: 100)

    -p S    Starting prefix (default: first prefix in text)

    -l N    Prefix length (default: 2)

```
General Criteria
    Code must adhere to standard formatting (e.g., gofumpt for Go).
    Must compile without errors.
    Handle edge cases gracefully (e.g., empty input, invalid arguments).
    Use only built-in packages.
    Build command:

    $ go build -o markovchain .

Resources
    Input text file (e.g., the_great_gatsby.txt) for testing.
    Recommended development language: Go.

Support
    Debug using provided example inputs and outputs.
    Use test cases to verify correctness.
    If stuck, review the algorithm description and constraints.
