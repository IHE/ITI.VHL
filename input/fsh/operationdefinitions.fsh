Instance: OperationDefinition-generate-vhl
InstanceOf: OperationDefinition
Usage: #definition
* url = "http://example.org/fhir/OperationDefinition/generate-vhl"
* title = "Generate VHL"
* description = "This operation generates a signed Verifiable Health Link (VHL) and optionally a QR code for transmission or display.\n\nInput Parameters:\n- sourceIdentifier: Patient identifier (required)\n- targetSystem: Target Patient Identifier Assigning Authority (optional)\n- exp: Expiration time in Epoch seconds (optional)\n- flag: Single-character flags in alphabetical order - L (long-term use), P (Passcode required), U (direct file access) (optional)\n- label: Short description up to 80 characters (optional)\n- passcode: User-supplied passcode for passcode-protected VHLs (optional)\n- goal: Specifies output - 'vhl', 'qrcode', or 'both' (optional, defaults to 'both')\n\nOutput Generation:\n- When goal='vhl' or 'both': Returns the VHL URL as a uri parameter. The VHL contains the SHL payload (base64url-encoded JSON with url, flag, key, label, exp) that can be used to access the manifest.\n- When goal='qrcode' or 'both': Returns a Binary resource containing the QR code image (PNG or SVG format) that encodes the complete SMART Health Link (vhlink:/...) for scanning.\n- The QR code embeds the full SHL payload including the manifest URL and decryption key for secure access to health documents."
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
  * documentation = "Optional. String created by concatenating single-character flags in alphabetical order. L (long-term use), P (Passcode required), U (direct file access)."
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
  * name = #goal
  * use = #in
  * min = 0
  * max = "1"
  * type = #code
  * documentation = "Specifies what to generate: 'vhl' (VHL only), 'qrcode' (QR code only), or 'both' (both VHL and QR code). If not specified, defaults to 'both'."
  * binding
    * strength = #required
    * valueSet = "http://example.org/fhir/ValueSet/vhl-generation-goal"
* parameter[+]
  * name = #vhl
  * use = #out
  * min = 0
  * max = "*"
  * type = #uri
  * documentation = "The signed VHL URL containing the SMART Health Link payload.\n\nVHL Generation Process:\n1. Generate a unique folder ID with 256-bit entropy to serve as the List resource identifier\n2. Generate a 32-byte (256-bit) random encryption key, base64url-encode it (resulting in 43 characters) - this is the 'key' parameter\n3. Construct the manifest URL as a query on the base List resource:\n   - If VHL Sharer supports Include DocumentReference Option:\n     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[patient-id]&_include=List:item\n   - If VHL Sharer does NOT support Include DocumentReference Option:\n     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[patient-id]\n4. Create the SHL payload as a JSON object with:\n   - url: the manifest URL from step 3\n   - key: the base64url-encoded encryption key from step 2 (43 characters)\n   - exp: (optional) expiration time in Epoch seconds\n   - flag: (optional) flags string (e.g., 'P' for passcode, 'L' for long-term, 'U' for direct file access)\n   - label: (optional) description string (max 80 characters)\n   - v: version number (defaults to 1)\n5. Minify the JSON (remove whitespace)\n6. Base64url-encode the minified JSON\n7. Construct the final VHL URL: vhlink:/[base64url-encoded-payload]\n\nFor complete specification details, see: https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html#construct-a-smart-health-link-payload"
* parameter[+]
  * name = #qrcode
  * use = #out
  * min = 0
  * max = "*"
  * type = #Binary
  * documentation = "A Binary resource containing the QR code image (PNG or SVG format) that encodes the VHL as a CWT with HCERT structure.\n\nQR Code Generation Process (HCERT/CWT encoding):\n1. Create a CBOR Web Token (CWT) structure per RFC 8392 with protected header containing:\n   - alg (algorithm): ES256 (primary) or PS256 (secondary)\n   - kid (key identifier): truncated SHA-256 fingerprint of DSC (first 8 bytes)\n2. Add CWT claims:\n   - iss (issuer, claim key 1): optional ISO 3166-1 alpha-2 country code\n   - iat (issued at, claim key 6): timestamp in NumericDate format\n   - exp (expiration, claim key 4): timestamp in NumericDate format\n   - hcert (health certificate, claim key -260): object containing:\n     * For SHL: claim key 5 with the SHL payload object\n3. Sign the CWT using asymmetric signature (COSE, RFC 8152)\n4. Compress the signed CWT using ZLIB (RFC 1950) with Deflate (RFC 1951)\n5. Encode compressed CWT as Base45\n6. Prefix with context identifier 'HC1:'\n7. Generate QR code using ISO/IEC 18004:2015:\n   - Error correction level: Q (25% recommended)\n   - Mode: Alphanumeric (Mode 2)\n   - Recommended diagonal size: 35-60mm\n\nFor complete HCERT specification, see: https://smart.who.int/trust/hcert_spec.html\nFor HCERT logical model, see: https://smart.who.int/trust/StructureDefinition-HCert.html"


Instance: OperationDefinition-retrieve-manifest
InstanceOf: OperationDefinition
Usage: #definition
* url = "http://example.org/fhir/OperationDefinition/retrieve-manifest"
* title = "Retrieve Manifest"
* description = "This operation retrieves a manifest (searchset Bundle) of available health documents using a previously obtained and validated Verifiable Health Link (VHL). The operation is authenticated via a signed request that includes the manifest URL and optional passcode. This operation aligns with MHD ITI-66 Find Document Lists transaction."
* name = "RetrieveManifest"
* status = #active
* kind = #operation
* code = #retrieve-manifest
* resource[0] = #List
* system = false
* type = true
* instance = false
* parameter[0]
  * name = #url
  * use = #in
  * min = 1
  * max = "1"
  * type = #string
  * documentation = "The manifest url obtained from the VHL payload"
* parameter[+]
  * name = #passcode
  * use = #in
  * min = 0
  * max = "1"
  * type = #string
  * documentation = "User-provided passcode if the VHL is passcode-protected."
* parameter[+]
  * name = #recipient
  * use = #in
  * min = 1
  * max = "1"
  * type = #string
  * documentation = "A string describing the recipient (e.g., the name of an organization or person)."
* parameter[+]
  * name = #receiverSignature
  * use = #in
  * min = 1
  * max = "1"
  * type = #string
  * documentation = "JWS signature from the VHL Receiver containing url and optional passcode."
* parameter[+]
  * name = #searchParams
  * use = #in
  * min = 0
  * max = "*"
  * type = #string
  * documentation = "Optional FHIR search parameters to filter the document manifest (e.g., type, date, status)."
* parameter[+]
  * name = #embeddedLengthMax
  * use = #in
  * min = 0
  * max = "1"
  * type = #integer
  * documentation = "Integer upper bound on the length of embedded payloads. Aligns with MHD ITI-66 parameter."
* parameter[+]
  * name = #return
  * use = #out
  * min = 1
  * max = "1"
  * type = #Bundle
  * documentation = "A FHIR Bundle of type 'searchset' containing List resources for documents authorized by the VHL. List resources reference DocumentReference resources via List.entry."
  
  
ValueSet: VHLGenerationGoal
Id: vhl-generation-goal
Title: "VHL Generation Goal"
* ^url = "http://example.org/fhir/ValueSet/vhl-generation-goal"
* ^status = #active
* ^description = "The intended goal of the generate-signed-vhl operation."
* include codes from system http://example.org/fhir/CodeSystem/vhl-goal

CodeSystem: VHLGoal
Id: vhl-goal
Title: "VHL Generation Goal Codes"
* ^url = "http://example.org/fhir/CodeSystem/vhl-goal"
* ^status = #active
* ^content = #complete
* #vhl "Generate VHL only"
* #qrcode "Generate QR code only"
* #both "Generate both VHL and QR code"
