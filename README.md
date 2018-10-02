# pwned
A small command line utility to check if a password has appeared in Pwned Passwords database

I wrote this just to get a little more experience with Go. Feel free to use this if you want. It
is safe to use to check your own passwords as it creates a SHA-1 hash of your password, then requests
from the Pwned Passwords API (see <https://haveibeenpwned.com/API/v2#PwnedPasswords>) all SHA-1 hashes
of passwords which start with the 5 hexadecimal digits of the SHA-1 hash of your password. It will then
check if your password's hash is present in the returned list and indicate how many times that password
shows up in the database (or 0 if it does not show up).
