package main

import (
	"bufio"
	"crypto/sha1"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"golang.org/x/crypto/ssh/terminal"
)

var version string

func main() {
	// Print version
	fmt.Printf("pwned %s\n", version)

	// Ask for password without echoing to terminal
	fmt.Print("Enter Password: ")
	bytePassword, err := terminal.ReadPassword(0)
	if err != nil {
		log.Fatal(err)
	}
	password := strings.TrimSpace(string(bytePassword))

	fmt.Print("\n\n")

	// Calculate SHA1 hash
	h := sha1.New()
	h.Write([]byte(password))
	bs := h.Sum(nil)
	hexHash := fmt.Sprintf("%X", bs)

	// Query webservice
	urlStart := "https://api.pwnedpasswords.com/range/"

	resp, err := http.Get(urlStart + hexHash[:5])
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	// Check if hash is part of database
	hexTail := hexHash[5:]
	scanner := bufio.NewScanner(resp.Body)
	var pwcount int

	for scanner.Scan() {
		s := strings.Split(scanner.Text(), ":")
		if ntok := len(s); ntok != 2 {
			log.Fatalf("Expected 2 tokens per line, got %d\n", ntok)
		}

		hentry := s[0]
		hcount, err := strconv.Atoi(s[1])
		if err != nil {
			log.Printf("Error converting the string %s to integer\n", s[1])
			hcount = -1
		}
		if hentry == hexTail {
			pwcount = hcount
			break
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Password seen %d times in the Pwned Passwords database.\n", pwcount)
}
