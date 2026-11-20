Extension: RemainingPasscodeAttempts
Id:        remaining-passcode-attempts
Title:     "Remaining Passcode Attempts"
Description: """
The number of incorrect passcode attempts remaining before the VHL is disabled.

The [SMART Health Links manifest request](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html#smart-health-link-manifest-request) requires the error response for an invalid passcode to carry `remainingAttempts`. A VHL manifest request returns an `OperationOutcome` rather than the plain JSON body SHL defines, so the count is carried in this extension to keep it machine-readable for the VHL Receiver.
"""
* ^context[+].type = #element
* ^context[=].expression = "OperationOutcome.issue"
* value[x] only integer
* valueInteger 1..1


Instance:   InvalidPasscodeOutcome
InstanceOf: OperationOutcome
Usage:      #example
Title:      "Invalid Passcode with Remaining Attempts"
Description: "Response to a Retrieve Manifest request carrying an incorrect passcode. The 401 response reports how many attempts remain before the VHL is disabled."
* issue.severity = #error
* issue.code = #security
* issue.diagnostics = "Invalid passcode"
* issue.extension[+].url = "https://profiles.ihe.net/ITI/VHL/StructureDefinition/remaining-passcode-attempts"
* issue.extension[=].valueInteger = 2
