Instance: OperationDefinition-generate-vhl
InstanceOf: OperationDefinition
Usage: #definition
* url = "http://example.org/fhir/OperationDefinition/generate-vhl"
* title = "Generate VHL"
* description = "This operation generates a QR code containing a Verifiable Health Link (VHL) for transmission or display.\n\nInput Parameters:\n- sourceIdentifier: Patient identifier (required)\n- targetSystem: Target Patient Identifier Assigning Authority (optional)\n- exp: Expiration time in Epoch seconds (optional)\n- flag: Single-character flags in alphabetical order - L (long-term use), P (Passcode required), U (direct file access) (optional)\n- label: Short description up to 80 characters (optional)\n- passcode: User-supplied passcode for passcode-protected VHLs (optional)\n\nOutput Generation:\n- Returns a Binary resource containing the QR code image (PNG or SVG format) that encodes the VHL as an HCERT/CWT structure.\n- The QR code embeds the full SHL payload including the manifest URL and decryption key for secure access to health documents."
* name = "GenerateVHL"
* status = #active
* kind = #operation
* code = #generate-vhl
* system = false
* type = true
* instance = false
* parameter[0]
  * name = #sourceIdentifier
  * use = #in
  * min = 1
  * max = "1"
  * type = #Identifier
  * documentation = "An identifier for the patient. Required if 'bundle' is not provided."
* parameter[+]
  * name = #targetSystem
  * use = #in
  * min = 0
  * max = "1"
  * type = #uri
  * documentation = "The target Patient Identifier Assigning Authority from which the returned identifiers should be selected."
* parameter[+]
  * name = #exp
  * use = #in
  * min = 0
  * max = "1"
  * type = #integer
  * documentation = "Optional. Number representing expiration time in Epoch seconds, as a hint to help the SHL Receiving Application determine if this QR is stale."
* parameter[+]
  * name = #flag
  * use = #in
  * min = 0
  * max = "1"
  * type = #string
  * documentation = "Optional. String created by concatenating single-character flags in alphabetical order. L (long-term use), P (Passcode required)"
* parameter[+]
  * name = #label
  * use = #in
  * min = 0
  * max = "1"
  * type = #string
  * documentation = "Optional. String no longer than 80 characters that provides a short description of the data behind the SHLink."
* parameter[+]
  * name = #passcode
  * use = #in
  * min = 0
  * max = "1"
  * type = #string
  * documentation = "Optional. User-supplied passcode for passcode-protected VHLs. If provided, the VHL Sharer SHALL securely hash and store this passcode for validation during manifest retrieval (ITI-YY5). The 'P' flag SHALL be included in the flag parameter when a passcode is set."


* parameter[+]
  * name = #qrcode
  * use = #out
  * min = 1
  * max = "1"
  * type = #Binary
  * documentation = "A Binary resource containing the QR code image (PNG or SVG format) that encodes the VHL as a CWT with HCERT structure.\n\nQR Code Generation Process (HCERT/CWT encoding):\n1. Generate a unique folder ID with 256-bit entropy to serve as the List resource identifier\n2. Generate a 32-byte (256-bit) random encryption key, base64url-encode it (resulting in 43 characters) - this is the 'key' parameter\n3. Construct the manifest URL as a query on the base List resource:\n   - If VHL Sharer supports Include DocumentReference Option:\n     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[patient-id]&_include=List:item\n   - If VHL Sharer does NOT support Include DocumentReference Option:\n     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[patient-id]\n4. Create the SHL payload as a JSON object with:\n   - url: the manifest URL from step 3\n   - key: the base64url-encoded encryption key from step 2 (43 characters)\n   - exp: (optional) expiration time in Epoch seconds\n   - flag: (optional) flags string (e.g., 'P' for passcode, 'L' for long-term, 'U' for direct file access)\n   - label: (optional) description string (max 80 characters)\n   - v: version number (defaults to 1)\n5. Create a CBOR Web Token (CWT) structure per RFC 8392 with protected header containing:\n   - alg (algorithm): ES256 (primary) or PS256 (secondary)\n   - kid (key identifier): truncated SHA-256 fingerprint of DSC (first 8 bytes)\n6. Add CWT claims:\n   - iss (issuer, claim key 1): optional ISO 3166-1 alpha-2 country code\n   - iat (issued at, claim key 6): timestamp in NumericDate format\n   - exp (expiration, claim key 4): timestamp in NumericDate format\n   - hcert (health certificate, claim key -260): object containing:\n     * claim key 5: the SHL payload object from step 4\n7. Sign the CWT using asymmetric signature (COSE, RFC 8152)\n8. Compress the signed CWT using ZLIB (RFC 1950) with Deflate (RFC 1951)\n9. Encode compressed CWT as Base45\n10. Prefix with context identifier 'HC1:'\n11. Generate QR code using ISO/IEC 18004:2015:\n   - Error correction level: Q (25% recommended)\n   - Mode: Alphanumeric (Mode 2)\n   - Recommended diagonal size: 35-60mm\n\nFor complete HCERT specification, see: https://smart.who.int/trust/hcert_spec.html\nFor HCERT logical model, see: https://smart.who.int/trust/StructureDefinition-HCert.html\nFor SHL payload details, see: https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html#construct-a-smart-health-link-payload"




