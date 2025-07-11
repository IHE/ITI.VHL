Instance: OperationDefinition-generate-vhl
InstanceOf: OperationDefinition
Usage: #definition
* url = "http://example.org/fhir/OperationDefinition/generate-vhl"
* title = "Generate VHL"
* description = "This operation generates a signed Verifiable Health Link (VHL) and optionally a QR code for transmission or display. Input must include either:\n- a patient identifier (e.g., an official national identifier), \n- a targetSystem.\n - flag \n - expirationTime \n - The `goal` parameter specifies what to generate: the VHL, QR code, or both."
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
  * name = #expirationTime
  * use = #in
  * min = 0
  * max = "1"
  * type = #uri
  * documentation = "expiration time in Epoch seconds"
* parameter[+]
  * name = #flag
  * use = #in
  * min = 1
  * max = "1"
  * type = #code
  * documentation = "Flag to indicate if Passcode is required"
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
