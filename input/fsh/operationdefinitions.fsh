Instance: OperationDefinition-generate-vhl
InstanceOf: OperationDefinition
Usage: #definition
* url = "http://example.org/fhir/OperationDefinition/generate-vhl"
* title = "Generate VHL"
* description = "This operation generates a signed Verifiable Health Link (VHL) and optionally a QR code for transmission or display.\n\nInput Parameters:\n- sourceIdentifier: Patient identifier (required)\n- targetSystem: Target Patient Identifier Assigning Authority (optional)\n- exp: Expiration time in Epoch seconds (optional)\n- flag: Single-character flags in alphabetical order - L (long-term use), P (Passcode required), U (direct file access) (optional)\n- label: Short description up to 80 characters (optional)\n- goal: Specifies output - 'vhl', 'qrcode', or 'both' (optional, defaults to 'both')\n\nOutput Generation:\n- When goal='vhl' or 'both': Returns the VHL URL as a uri parameter. The VHL contains the SHL payload (base64url-encoded JSON with url, flag, key, label, exp) that can be used to access the manifest.\n- When goal='qrcode' or 'both': Returns a Binary resource containing the QR code image (PNG or SVG format) that encodes the complete SMART Health Link (shlink:/...) for scanning.\n- The QR code embeds the full SHL payload including the manifest URL and decryption key for secure access to health documents."
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
  * documentation = "The signed VHL URL."
* parameter[+]
  * name = #qrcode
  * use = #out
  * min = 0
  * max = "*"
  * type = #Binary
  * documentation = "A Binary resource containing the QR code (e.g., PNG or SVG format)."


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
