{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

 {% assign reqGenerateVHLRequest = site.data.Requirements-InitiateVHLGenerationRequest %}
 {% assign reqGenerateVHLResponse = site.data.Requirements-RespondtoGenerateVHLRequest %}
  

### 2:3.YY3.1 Scope

{% assign reqGenerateVHLRequestTitle = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqGenerateVHLResponseTitle = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqGenerateVHLRequestDescription = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqGenerateVHLResponseDescription = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
The Generate VHL transaction enables a {{ linkvhlh }} to request a Verifiable Health Link (VHL) from a {{ linkvhls }} for a Patient identified by a business identifier (e.g., MRN, passport number, national ID). The {{ linkvhls }} locates the Patient, authorizes the caller, assembles a folder of available health documents, and returns a VHL that the {{ linkvhlh }} can subsequently transmit to a {{ linkvhlr }} via [ITI-YY4 Provide VHL](ITI-YY4.html) for downstream document retrieval via [ITI-YY5 Retrieve Manifest](ITI-YY5.html).

The VHL payload conforms to the [SMART Health Links payload format](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html) and carries the manifest URL, a symmetric decryption key, and optional metadata (expiration, flags, label, purpose-of-use bindings). By default the VHL is returned as a QR code encoded as an HCERT/CWT structure per the [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html). When the {{ linkvhls }} supports the [VC Enveloped VHL Carrier Option](#vc-enveloped-vhl-carrier-option--formatvc), the caller MAY instead request the VHL as a signed W3C Verifiable Credential (`application/vc+ld+json`).

The transaction also supports optional passcode protection, purpose-of-use authorization metadata (which MAY populate an IHE PCF `Consent.provision.purpose` when the {{ linkvhls }} is grouped with a Consent Creator/Recipient), and the OAuth with SSRAA Option for downstream authenticated manifest retrieval.

### 2:3.YY3.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlh}} | {{ reqGenerateVHLRequestTitle.valueString }}     |
| {{ linkvhls }}            | {{ reqGenerateVHLResponseTitle.valueString }} |
{: .grid}


### 2:3.YY3.3 Referenced Standards

- **SMART Health Links Specification**: [SMART Health Links and SMART Health Cards](http://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html)
- **RFC 4648**: Base64url Encoding
- **RFC 7515**: JSON Web Signature (JWS)
- **ISO/IEC 18004:2015**: QR Code specification
- **FHIR R4**: [HL7 FHIR Release 4](http://hl7.org/fhir/R4/)

**OAuth with SSRAA (Optional):**
- **RFC 7519**: JSON Web Token (JWT)
- **HL7 Security for Scalable Registration, Authentication, and Authorization IG**: [SSRAA](http://hl7.org/fhir/us/udap-security/) — used by the VHL Receiver to perform UDAP Discovery and Dynamic Client Registration with the VHL Sharer prior to making authenticated manifest requests

**VC Enveloped VHL Option(Optional):**
- **W3C VC Data Model v2**: [Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/)
- **W3C Data Integrity**: [Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/) — `DataIntegrityProof`
- **W3C Data Integrity ECDSA Cryptosuites**: [ecdsa-2019](https://www.w3.org/TR/vc-di-ecdsa/)


### 2:3.YY3.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY3.svg%}
  </div>
  <p id="figure-2.3.YY3-1" class="figureTitle">Figure 2:3.YY3-1: Generate VHL Interaction Diagram</p>
</figure>
<br clear="all">

#### 2:3.YY3.4.1 Generate VHL Request Message
This message is implemented as an HTTP GET operation from the client app used by the Holder to the VHL Sharer using the FHIR $generate-vhl operation described in [2:3.YY3.4.1.2 Message Semantics](#23yy3412-message-semantics).


##### 2:3.YY3.4.1.1 Trigger Events
{{ reqGenerateVHLRequestDescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqGenerateVHLRequest  %}
##### 2:3.YY3.4.1.2 Message Semantics

The Generate VHL message is a FHIR operation request as defined in FHIR (<http://hl7.org/fhir/operations.html>) with the [$generate-vhl operation definition](OperationDefinition-generate-vhl.html).

Given that the parameters are not complex types, the HTTP GET operation shall be used as defined in FHIR (<http://hl7.org/fhir/operations.html#request>).

The name of the operation is `$generate-vhl`, and it is applied to FHIR Patient Resource type.

The URL for this operation is: `[base]/Patient/$generate-vhl`

Where **[base]** is the URL of VHL Sharer Service provider.

The Generate VHL message is performed by an HTTP GET command shown below:

```
GET [base]/Patient/$generate-vhl?sourceIdentifier=[token]{&exp=[positiveInt]}{&flag=[string]}{&label=[string]}{&passcode=[string]}{&purposeOfUse=[token]}{&format=[token]}
```

Each `purposeOfUse` value is serialized in FHIR token form (`system|code`, e.g., `http://terminology.hl7.org/CodeSystem/v3-ActReason|TREAT`) and MAY repeat.

**Note:** By default the operation generates a QR code containing the VHL encoded as an HCERT/CWT structure. When the VHL Sharer supports the **VC Enveloped VHL Option** the caller MAY set `format=vc` to request the VHL as a signed Verifiable Credential instead. See [Output Carrier Options](#output-carrier-options) below for both carrier definitions.

**Table 2:3.YY3.4.1.2-1: $generate-vhl Message HTTP query Parameters**

| Query parameter Name | Cardinality | Search Type | Description |
| -------------------- | ----------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| sourceIdentifier     | [1..1]    | token  | A FHIR [Identifier](http://hl7.org/fhir/R4/datatypes.html#Identifier) (business identifier — e.g., MRN, passport number, national ID) that the VHL Sharer uses to locate the Patient record and that Patient's documents.|
| exp      |  [0..1]  | postiveInt        | Optional. Number representing expiration time in Epoch seconds. |
| flag |  [0..1]  | string        | Optional. String created by concatenating single-character flags in alphabetical order. L (long-term use), P (Passcode required), U (direct file access). |
| label |  [0..1]  | string        | Optional. String no longer than 80 characters that provides a short description of the data behind the VHL. |
| passcode |  [0..1]  | string        | Optional. User-supplied passcode for passcode-protected VHLs. If provided, the VHL Sharer SHALL securely hash and store this passcode for validation during manifest retrieval (ITI-YY5). The 'P' flag SHALL be included in the flag parameter when a passcode is set. |
| purposeOfUse | [0..*] | token | Optional. Purpose(s) of use the VHL Holder is authorizing for this share, bound (extensible) to [PurposeOfUse](http://terminology.hl7.org/ValueSet/v3-PurposeOfUse) (e.g., `TREAT`, `HPAYMT`, `HRESCH`). Serialized as FHIR `system|code`. See [Purpose of Use Handling](#purpose-of-use-handling). |
| format | [0..1] | token | Optional. Requested carrier for the returned VHL. Allowed values: `qrcode` (default) or `vc`. `vc` requires the VHL Sharer to support the [VC Enveloped VHL Carrier Option](#vc-enveloped-vhl-carrier-option--formatvc); if unsupported, the VHL Sharer SHALL return an OperationOutcome error. See [Output Carrier Options](#output-carrier-options) below. |

<a name="output-carrier-options"></a>

###### 2:3.YY3.4.1.2.1 Output Carrier Options

The `format` request parameter selects one of two carriers for the returned VHL. Both carriers convey the same VHL payload (manifest URL, decryption key, flags, label, expiration, optional extension); they differ only in encoding, signature format, and the trust chain used for verification. **On a successful response**, exactly one of the response output parameters `qrcode` or `verifiableCredential` (see [2:3.YY3.4.2.2 Message Semantics](#23yy3422--message-semantics)) SHALL be populated; on failure, the response is an `OperationOutcome` with neither output parameter populated.

**QR Code Carrier (Default — `format=qrcode`)**

The default carrier when `format` is omitted or set to `qrcode`. The VHL payload is embedded in an [HCERT](https://smart.who.int/trust/StructureDefinition-HCert.html) structure at claim key 5 per the [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html), signed as a CWT, and rendered as a QR code with the `HC1:` prefix. The VHL Receiver verifies the CWT signature against the trust list. See [2:3.YY3.4.1.3 Expected Actions](#23yy3413-expected-actions) for the full VHL Payload Construction and HCERT/CWT encoding steps, including a worked example.

<a name="vc-enveloped-vhl-carrier-option--formatvc"></a>

**VC Enveloped VHL Carrier (Option — `format=vc`)**

Optional carrier. Available only when the {{ linkvhls }} supports the **VC Enveloped VHL Option** (see [Volume 1 §XX.2.6 VC Enveloped VHL Option](volume-1.html#xx26-vc-enveloped-vhl-option-vhl-sharer)); if requested but unsupported, the {{ linkvhls }} SHALL return an `OperationOutcome` error. The same VHL payload is carried under `credentialSubject` of a JSON-LD W3C Verifiable Credential ([VC Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/)) with an embedded `DataIntegrityProof` ([VC Data Integrity 1.0](https://www.w3.org/TR/vc-di-ecdsa/)) signed by the {{ linkvhls }} using its trust-network key — no new trust framework is introduced. See [2:3.YY3.4.1.3 Expected Actions](#23yy3413-expected-actions) for the full construction steps and a worked example.

> **Naming note:** This "VC Enveloped VHL Option" at ITI-YY3/YY4 carries the VHL itself. It is distinct from the "Verifiable Credential Option" at [ITI-YY5](ITI-YY5.html#23yy5415-authentication-option---verifiable-credential-option), which is a separate option for {{ linkvhlr }} authentication where the Receiver self-issues a VC as the manifest request body.


##### 2:3.YY3.4.1.3 Expected Actions
{{ reqGenerateVHLResponseDescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqGenerateVHLResponse site=site  %}

Based on the requested `format`, the {{ linkvhls }} generates the VHL as either a QR code (HCERT/CWT-encoded per the [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html), with the VHL payload embedded at claim key 5) or a Verifiable Credential (JSON-LD per the [W3C VC Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/), with the VHL payload under `credentialSubject`). Both carriers share the same VHL payload construction.

The generation process is as follows:

<a name="vhl-payload-construction"></a>

**VHL Payload Construction**

The VHL payload SHALL be constructed in alignment with the [SMART Health Links specification](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html). The VHL Sharer SHALL:

1. Generate a unique folder ID with 256-bit entropy to serve as the List resource identifier

2. Generate a 32-byte (256-bit) random encryption key, base64url-encode it (resulting in 43 characters) - this is the 'key' parameter. The {{ linkvhlr }} uses this key to decrypt document binaries retrieved via [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html); see [ITI-YY5 Document Encryption](ITI-YY5.html#23yy5425-document-encryption).

3. Construct the manifest URL as a query on the base List resource:
   - **If VHL Sharer supports the Include DocumentReference Option:**
     ```
     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[sourceIdentifier-system|value]&_include=List:item
     ```
   - **If VHL Sharer does NOT support the Include DocumentReference Option:**
     ```
     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[sourceIdentifier-system|value]
     ```
   
   Note: The manifest URL is a FHIR search on `List` using the search parameters that the Document Responder in [IHE MHD ITI-66 Find Document Lists](https://profiles.ihe.net/ITI/MHD/ITI-66.html) is required to support — specifically `_id`, `code`, `status`, and the patient identifier expressed as a chained search on the `patient` reference parameter (`patient.identifier=system|value`). `_include=List:item` is added only when the {{ linkvhls }} supports the Include DocumentReference Option.

4. Create the VHL payload (using the SHL payload format) as a JSON object with:
   - `url`: the manifest URL from step 3
   - `key`: the base64url-encoded encryption key from step 2 (43 characters). Used by the {{ linkvhlr }} as the symmetric key for JWE `dir`/`A256GCM` decryption of document binaries; see [ITI-YY5 Document Encryption](ITI-YY5.html#23yy5425-document-encryption).
   - `exp`: (optional) expiration time in Epoch seconds, as a hint to help the VHL Receiver determine if this QR is stale
   - `flag`: (optional) flags string (e.g., 'P' for passcode, 'L' for long-term, 'U' for direct file access)
   - `label`: (optional) description string (max 80 characters)
   - `v`: version number (defaults to 1)
   - `extension`: (conditional) object containing implementation-defined extensions. Required when the {{ linkvhls }} supports the OAuth with SSRAA Option, in which case it SHALL include:
     - `fhirBaseUrl`: the FHIR base URL of the {{ linkvhls }} (e.g., `https://vhl-sharer.example.org`). This enables the {{ linkvhlr }} to perform UDAP Discovery (per Section 2 of the HL7 Security for Scalable Registration, Authentication, and Authorization IG) and Dynamic Client Registration (per Section 3) with the {{ linkvhls }} before making an authenticated manifest request via ITI-YY5.

5. The JSON Payload is then:
    - Minified
    - Base64urlencoded
    - Prefixed with vhlink:/

**Example VHL Construction:**

```json
// Step 4: VHL Payload JSON (SHL payload format, with OAuth with SSRAA extension)
{
  "url": "https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
  "key": "86F8LY5LlWAa1-OS_FgrTnYNqFHJP2ey5RSKLJBN9jk",
  "exp": 1735689600,
  "flag": "LP",
  "label": "Patient Health Summary",
  "v": 1,
  "extension": {
    "fhirBaseUrl": "https://vhl-sharer.example.org"
  }
}
```

```text
// Step 5: Minify, Base64url-encode, and prefix with vhlink:/

// Step 5a – Minified JSON:
{"url":"https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item","key":"86F8LY5LlWAa1-OS_FgrTnYNqFHJP2ey5RSKLJBN9jk","exp":1735689600,"flag":"LP","label":"Patient Health Summary","v":1,"extension":{"fhirBaseUrl":"https://vhl-sharer.example.org"}}

// Step 5b – Base64url-encoded:
eyJ1cmwiOiJodHRwczovL3ZobC1zaGFyZXIuZXhhbXBsZS5vcmcvTGlzdC9fc2VhcmNoP19pZD1hYmMxMjNkZWY0NTYmY29kZT1mb2xkZXImc3RhdHVzPWN1cnJlbnQmcGF0aWVudC5pZGVudGlmaWVyPXVybjpvaWQ6Mi4xNi44NDAuMS4xMTM4ODMuMi40LjYuM3xQQVNTUE9SVDEyMyZfaW5jbHVkZT1MaXN0Oml0ZW0iLCJrZXkiOiI4NkY4TFk1TGxXQWExLU9TX0ZnclRuWU5xRkhKUDJleTVSU0tMSkJOOWprIiwiZXhwIjoxNzM1Njg5NjAwLCJmbGFnIjoiTFAiLCJsYWJlbCI6IlBhdGllbnQgSGVhbHRoIFN1bW1hcnkiLCJ2IjoxLCJleHRlbnNpb25zIjp7ImZoaXJCYXNlVXJsIjoiaHR0cHM6Ly92aGwtc2hhcmVyLmV4YW1wbGUub3JnIn19

// Step 5c – Final VHL link (prefixed with vhlink:/):
vhlink:/eyJ1cmwiOiJodHRwczovL3ZobC1zaGFyZXIuZXhhbXBsZS5vcmcvTGlzdC9fc2VhcmNoP19pZD1hYmMxMjNkZWY0NTYmY29kZT1mb2xkZXImc3RhdHVzPWN1cnJlbnQmcGF0aWVudC5pZGVudGlmaWVyPXVybjpvaWQ6Mi4xNi44NDAuMS4xMTM4ODMuMi40LjYuM3xQQVNTUE9SVDEyMyZfaW5jbHVkZT1MaXN0Oml0ZW0iLCJrZXkiOiI4NkY4TFk1TGxXQWExLU9TX0ZnclRuWU5xRkhKUDJleTVSU0tMSkJOOWprIiwiZXhwIjoxNzM1Njg5NjAwLCJmbGFnIjoiTFAiLCJsYWJlbCI6IlBhdGllbnQgSGVhbHRoIFN1bW1hcnkiLCJ2IjoxLCJleHRlbnNpb25zIjp7ImZoaXJCYXNlVXJsIjoiaHR0cHM6Ly92aGwtc2hhcmVyLmV4YW1wbGUub3JnIn19

// NOTE: extension.fhirBaseUrl is only present when the VHL Sharer supports the OAuth with SSRAA Option
// The VHL link (step 5c) will be embedded in the HCERT structure (see QR Code Generation below)
```

**QR Code Generation (HCERT/CWT Encoding) — `format=qrcode`**

After constructing the VHL payload (steps 1–4 above), the {{ linkvhls }} SHALL encode it within an [HCERT](https://smart.who.int/trust/StructureDefinition-HCert.html) structure per the WHO SMART Trust specification with the VHL payload at HCERT claim 5, then generate the QR code per the [HCERT Specification](https://smart.who.int/trust/hcert_spec.html).

**Example HCERT/CWT Structure:**

```json
// CWT Claims
{
  "1": "US",                    // iss: issuer country code
  "4": 1735689600,              // exp: expiration timestamp
  "6": 1704067200,              // iat: issued at timestamp
  "-260": {                     // hcert: health certificate claim
    "5": "vhlink:/eyJ1cmwiOiJodHRwczovL3ZobC1zaGFyZXIuZXhhbXBsZS5vcmcvTGlzdC9fc2VhcmNoP19pZD1hYmMxMjNkZWY0NTYmY29kZT1mb2xkZXImc3RhdHVzPWN1cnJlbnQmcGF0aWVudC5pZGVudGlmaWVyPXVybjpvaWQ6Mi4xNi44NDAuMS4xMTM4ODMuMi40LjYuM3xQQVNTUE9SVDEyMyZfaW5jbHVkZT1MaXN0Oml0ZW0iLCJrZXkiOiI4NkY4TFk1TGxXQWExLU9TX0ZnclRuWU5xRkhKUDJleTVSU0tMSkJOOWprIiwiZXhwIjoxNzM1Njg5NjAwLCJmbGFnIjoiTFAiLCJsYWJlbCI6IlBhdGllbnQgSGVhbHRoIFN1bW1hcnkiLCJ2IjoxLCJleHRlbnNpb25zIjp7ImZoaXJCYXNlVXJsIjoiaHR0cHM6Ly92aGwtc2hhcmVyLmV4YW1wbGUub3JnIn19"
  }
}

// After signing, compressing, and Base45 encoding:
HC1:NCF3R0KLBBA...V8N8W.CE8WY
```

**VC Envelope Generation (Option — `format=vc`)**

When `format=vc` is requested and the {{ linkvhls }} supports the [VC Enveloped VHL Option](#vc-enveloped-vhl-carrier-option--formatvc), the {{ linkvhls }} SHALL construct a JSON-LD document per the [W3C VC Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/) with an embedded `proof` of type `DataIntegrityProof` per the [W3C VC Data Integrity 1.0](https://www.w3.org/TR/vc-di-ecdsa/) specification (cryptosuite selected per the central [Cryptographic Algorithm Selection](volume-1.html#xx53-cryptographic-algorithm-selection)). The `issuer` SHALL identify the {{ linkvhls }} using a key from the same trust network used for HCERT/CWT signatures — no new trust framework is introduced. The `credentialSubject` SHALL carry the VHL payload from step 4 (`url`, `key`, `flag`, `label`, `exp`, `v`, `extension`). The VC is delivered to the {{ linkvhlh }} and subsequently transmitted to the {{ linkvhlr }} per [ITI-YY4 Provide VHL](ITI-YY4.html).

**Example VC carrying the VHL payload:**

```json
{
  "@context": ["https://www.w3.org/ns/credentials/v2"],
  "type": ["VerifiableCredential", "VHLEnvelopeCredential"],
  "issuer": "did:web:vhl-sharer.example.org",
  "issuanceDate": "2024-01-01T00:00:00Z",
  "expirationDate": "2025-01-01T00:00:00Z",
  "credentialSubject": {
    "url": "https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
    "key": "86F8LY5LlWAa1-OS_FgrTnYNqFHJP2ey5RSKLJBN9jk",
    "exp": 1735689600,
    "flag": "LP",
    "label": "Patient Health Summary",
    "v": 1,
    "extension": {
      "fhirBaseUrl": "https://vhl-sharer.example.org"
    }
  },
  "proof": {
    "type": "DataIntegrityProof",
    "cryptosuite": "ecdsa-2019",
    "created": "2024-01-01T00:00:00Z",
    "verificationMethod": "did:web:vhl-sharer.example.org#sharer-key-1",
    "proofPurpose": "assertionMethod",
    "proofValue": "z3FD9sJ8kL2m9pQ7rT4vW5xY6zAb3cD4eF5gH6iJ7kL8mN9oP0qR1sT2uV3wX4yZ"
  }
}
```

**Handling Notes**

The following handling rules apply within the steps above:

**sourceIdentifier Validation** — The {{ linkvhls }} SHALL parse `sourceIdentifier` as a FHIR `Identifier` in `system|value` form, resolve it to a known Patient, authorize the caller, and echo the exact `system|value` into the manifest URL as `patient.identifier` (never substituting `Patient.id`). In patient-constrained contexts (e.g., SMART `launch/patient` scope), mismatches with the patient-in-context SHALL be rejected with `403`. Other failures return `OperationOutcome` with `400` / `404` / `403` as appropriate.

<a name="purpose-of-use-handling"></a>

**Purpose of Use Handling (if provided)** — The {{ linkvhls }} SHALL validate each `purposeOfUse` value against [PurposeOfUse](http://terminology.hl7.org/ValueSet/v3-PurposeOfUse) (extensible binding) and persist the value(s) against the folder ID for downstream enforcement at [ITI-YY5](ITI-YY5.html). When grouped with an IHE PCF [Consent Creator](https://profiles.ihe.net/ITI/PCF/) or [Consent Recipient](https://profiles.ihe.net/ITI/PCF/), the persisted value(s) SHALL populate `Consent.provision.purpose`. `purposeOfUse` value(s) SHALL NOT be embedded in the QR code, VC, or VHL payload — they are share metadata held by the {{ linkvhls }}, not content consumed by the {{ linkvhlr }}.

**Passcode Handling (if provided)** — The {{ linkvhls }} SHALL hash the passcode with a strong one-way function (e.g., bcrypt, Argon2, PBKDF2), store the hash against the folder ID for ITI-YY5 validation, and set the `P` flag in the VHL payload. The plaintext passcode SHALL NOT appear in the VHL URL, QR code, or VC, and SHALL NOT be stored by the {{ linkvhls }}; the {{ linkvhlh }} retains it for out-of-band sharing with the {{ linkvhlr }}.


#### 2:3.YY3.4.2  Generate VHL Response Message 
The {{ linkvhls }} returns failure, or generates and returns a QR code containing the VHL encoded as an HCERT/CWT structure.

##### 2:3.YY3.4.2.1 Trigger Events
This message shall be sent when a request initiated by the {{linkvhlh}} has been processed successfully. 

##### 2:3.YY3.4.2.2  Message Semantics

See [ITI TF-2: Appendix Z.6](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html#z.6-populating-the-expected-response-format) for more details on response format handling.

The response message is a FHIR operation response (<http://hl7.org/fhir/operations.html#response>).

On Failure, the response message is an HTTP status code of 4xx or 5xx
indicates an error, and an OperationOutcome Resource shall be returned
with details.

**Success Response:**

The response SHALL include exactly one of the following output parameters, selected by the `format` input:

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| qrcode | Binary | [0..1] | QR code image containing HCERT-encoded VHL. Populated when `format=qrcode` or when format is absent, as the default format. |
| verifiableCredential | Binary | [0..1] | A Verifiable Credential (`application/vc+ld+json`) carrying the VHL. Populated when `format=vc` and the VHL Sharer supports the [VC Enveloped VHL Carrier Option](#vc-enveloped-vhl-carrier-option--formatvc). |
{: .grid}

**QR Code Output:**
- SHALL be encoded as HCERT with `HC1:` prefix
- SHALL contain the VHL payload embedded in HCERT claim structure (claim key -260, key 5)
- SHALL be suitable for camera scanning
- SHALL be in PNG or SVG format

**Verifiable Credential Output (VC Enveloped VHL Option only):**
- SHALL be a JSON-LD document per W3C VC Data Model v2 with `Content-Type: application/vc+ld+json`
- SHALL carry the VHL payload under `credentialSubject` (same fields otherwise embedded at HCERT claim key 5)
- SHALL be signed by the VHL Sharer using a `DataIntegrityProof` with its trust-network key (cryptosuite selected per [Cryptographic Algorithm Selection](volume-1.html#xx53-cryptographic-algorithm-selection))

##### 2:3.YY3.4.2.3 Expected Actions

The VHL Holder SHALL:
- Display or print the QR code for scanning by VHL Receivers
- Cache the encryption key securely (extracted from VHL payload) for future document decryption
- If a passcode was provided during generation:
  - Securely store the plaintext passcode separately from the QR code
  - Provide the passcode to authorized VHL Receivers for manifest retrieval (ITI-YY5)
  - Use secure transmission methods when sharing the passcode out-of-band

The VHL Holder MAY:
- Maintain record of QR code presentations
- Revoke VHL access if supported by VHL Sharer


### 2:3.YY3.5 Security Considerations 

#### 2:3.YY3.5.1 Encryption Key Security
- The 32-byte encryption key SHALL be generated using a cryptographically secure random number generator
- The key is embedded in the VHL payload within the QR code and SHALL be kept confidential
- Loss of the key means loss of access to encrypted documents
- The encryption key is not directly visible in the QR code as it is embedded within the signed and compressed HCERT structure

#### 2:3.YY3.5.2 QR Code Security
- QR codes contain the complete VHL including the encryption key
- QR codes can be photographed or copied - use time-limited expiration
- QR codes SHALL be encoded as HCERT with digital signatures for authenticity
- Display QR codes in controlled environments when possible
- Consider short expiration times (minutes to hours) for high-security scenarios

#### 2:3.YY3.5.3 Passcode Security
- If a passcode is provided, it SHALL be securely hashed before storage using industry-standard algorithms (bcrypt, Argon2, PBKDF2)
- The plaintext passcode SHALL NOT be included in the VHL URL or QR code
- The plaintext passcode SHALL NOT be stored by the VHL Sharer
- The VHL Holder SHOULD securely store the plaintext passcode for sharing with authorized VHL Receivers
- During ITI-YY5 Retrieve Manifest, the VHL Receiver provides the passcode which the VHL Sharer validates against the stored hash
- Use of passcode adds an additional authentication factor beyond VHL possession

#### 2:3.YY3.5.4 Manifest URL Construction
- The manifest URL SHALL include all mandatory FHIR search parameters
- The `_include` parameter SHOULD only be included if the VHL Sharer supports the Include DocumentReference Option
- This ensures VHL Receivers can successfully retrieve the manifest using ITI-YY5

#### 2:3.YY3.5.5 OAuth with SSRAA Option — FHIR Base URL Extension
When the {{ linkvhls }} supports the OAuth with SSRAA Option, it SHALL include `extension.fhirBaseUrl` in the VHL payload:
- The `fhirBaseUrl` value SHALL be the canonical FHIR base URL of the {{ linkvhls }} (e.g., `https://vhl-sharer.example.org`)
- This URL is used by the {{ linkvhlr }} to perform UDAP Discovery (`{fhirBaseUrl}/.well-known/udap`) and, if not already registered, Dynamic Client Registration with the {{ linkvhls }} before initiating ITI-YY5
- The `fhirBaseUrl` value is typically derivable from the `url` field (manifest URL) by stripping the path, but including it explicitly avoids ambiguity when the authorization server is hosted separately
- The `fhirBaseUrl` field SHALL NOT be present if the {{ linkvhls }} does not support the OAuth with SSRAA Option, to avoid misleading {{ linkvhlr }}s into attempting UDAP Discovery unnecessarily

#### 2:3.YY3.5.6 VC Enveloped VHL Option
- The VC's `DataIntegrityProof` SHALL chain to a trust anchor in the trust list (same framework used for HCERT/CWT verification).
- The VC `expirationDate` SHOULD be consistent with the VHL payload `exp`; the VHL Receiver SHALL reject the VHL if either has passed.
- Confidentiality considerations are equivalent to the QR form: the VC carries the `key` and MUST be treated as sensitive.
- VHL Sharers MAY issue single-use VCs; short lifetimes are RECOMMENDED for high-security scenarios.
