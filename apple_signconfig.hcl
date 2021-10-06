source = ["./build/darwinuniversal/pwned"]
bundle_id = "com.idolstarastronomer.pwned"

apple_id {
  password = "@env:AC_PASSWORD"
}

sign {
  application_identity = "Developer ID Application: Christopher De Vries (HV3HRV5DGR)"
}

dmg {
  output_path = "dist/pwned-amd64.dmg"
  volume_name = "Pwned"
}

zip {
  output_path = "dist/pwned-amd64.zip"
}
