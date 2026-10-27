Alias: $ShlPayload = http://hl7.org/fhir/uv/smart-health-cards-and-links/StructureDefinition/ShlPayload

Logical:    VHLPayload
Id:         VHLPayload
Parent:     $ShlPayload
Title:      "VHL Payload"
Description: """
The payload carried by a Verifiable Health Link.

This model specializes the [SMART Health Link Payload](http://hl7.org/fhir/uv/smart-health-cards-and-links/StructureDefinition-ShlPayload.html) rather than restating it: `url`, `key`, `exp`, `flag`, `label` and `v` are inherited unchanged in shape, which is what it means for a VHL to adopt the SHL payload format. The difference between a VHL and an SHL is the trust model, not the payload structure.

A populated instance is minified, base64url-encoded, prefixed with `vhlink:/`, and then carried either inside an HCERT structure at claim key 5 and signed as a CWT (the QR carrier), or as the `credentialSubject.id` of a signed Verifiable Credential under the VC Enveloped VHL Option.

Two things distinguish this model from its parent, both narrowing rather than extending the SHL format: the `U` flag is not used, and `extension.fhirBaseUrl` is defined for the OAuth with SSRAA Option. See [Generate VHL [ITI-YY3]](ITI-YY3.html) for the construction steps.
"""
* ^status = $pubStatus#active
* ^publisher = "IHE"

// Inherited elements, re-documented where this profile narrows how they are used.

* url ^definition = "The manifest URL for this VHL, expressed as a FHIR search URL on the List resource. This profile requires the URL to carry `_id`, `code`, `status` and `patient.identifier`; `_include=List:item` is added only where the VHL Sharer supports the Include DocumentReference Option. The folder ID conveyed in `_id` is the primary authorization mechanism for the VHL."

* key ^definition = "Decryption key for the files returned in the manifest: 32 random bytes, base64url-encoded, giving 43 characters. The VHL Receiver uses this as the symmetric key for JWE `dir` / `A256GCM` decryption of document binaries retrieved via ITI-68."

* flag ^definition = "String formed by concatenating single-character flags in alphabetical order. This profile uses `L` (long-term use: the folder is expected to remain available and may change over time) and `P` (a passcode is required when retrieving the manifest), so a VHL that is both carries `LP`. This profile does not use the SHL `U` flag and a VHL Sharer SHALL NOT set it: a VHL always references a folder whose contents are reached through Retrieve Manifest [ITI-YY5], which is where the Receiver is authenticated against the trust network and any passcode and consent filtering are applied."

// Added by this profile.

* extension 0..1 BackboneElement "Implementation-defined extensions" """
Object carrying implementation-defined extensions. Required when the VHL Sharer supports the OAuth with SSRAA Option.
"""

* extension.fhirBaseUrl 0..1 string "FHIR base URL of the VHL Sharer" """
The FHIR base URL of the VHL Sharer, for example `https://vhl-sharer.example.org`. It lets the VHL Receiver perform UDAP Discovery and Dynamic Client Registration with the VHL Sharer before making an authenticated manifest request through ITI-YY5.

Where the VHL Sharer does not support the OAuth with SSRAA Option this element SHALL NOT be present, so that VHL Receivers are not led into attempting UDAP Discovery unnecessarily.
"""
