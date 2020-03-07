package main

import (
	"bufio"
	"crypto/sha1"
	"crypto/tls"
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
	fmt.Printf("pwned version: %s\n", version)

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

	// Configure minimum TLS version to 1.2
	config := &tls.Config{
		MinVersion: tls.VersionTLS12,
	}

	tr := &http.Transport{TLSClientConfig: config}
	client := &http.Client{Transport: tr}

	req, err := http.NewRequest("GET", urlStart+hexHash[:5], nil)
	if err != nil {
		log.Fatal(err)
	}

	req.Header.Add("Add-Padding", "true")

	resp, err := client.Do(req)
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
