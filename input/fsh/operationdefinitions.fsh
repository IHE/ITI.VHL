Instance: OperationDefinition-generate-vhl
InstanceOf: OperationDefinition
Usage: #definition
* url = "http://example.org/fhir/OperationDefinition/generate-vhl"
* title = "Generate VHL"
* description = "This operation generates a signed Verifiable Health Link (VHL) and optionally a QR code for transmission or display. Input must include either:\n- a patient identifier (e.g., an official national identifier), or\n- a Bundle with the patient's clinical information (e.g., IPS).\n\nThe `goal` parameter specifies what to generate: the VHL, QR code, or both."
* name = "GenerateSignedVHL"
* status = #active
* kind = #operation
* code = #generate-signed-vhl
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
  * name = #goal
  * use = #in
  * min = 1
  * max = "1"
  * type = #code
  * documentation = "What to generate: 'vhl', 'qrcode', or 'both'."
  * binding
    * strength = #required
    * valueSet = "http://example.org/fhir/ValueSet/vhl-generation-goal"
* parameter[+]
  * name = #goal
  * use = #in
  * min = 1
  * max = "1"
  * type = #code
  * documentation = "What to generate: 'vhl', 'qrcode', or 'both'."
  * binding
    * strength = #required
    * valueSet = "http://example.org/fhir/ValueSet/vhl-generation-goal"
* parameter[+]
  * name = #goal
  * use = #in
  * min = 1
  * max = "1"
  * type = #code
  * documentation = "What to generate: 'vhl', 'qrcode', or 'both'."
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
