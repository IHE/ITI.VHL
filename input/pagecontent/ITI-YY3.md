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
GET [base]/Patient/$generate-vhl?sourceIdentifier=[token]{&exp=[number]}{&flag=[string]}{&label=[string]}{&passcode=[string]}{&purposeOfUse=[token]}{&format=[token]}
```

Each `purposeOfUse` value is serialized in FHIR token form (`system|code`, e.g., `http://terminology.hl7.org/CodeSystem/v3-ActReason|TREAT`) and MAY repeat.

**Note:** By default the operation generates a QR code containing the VHL encoded as an HCERT/CWT structure. When the VHL Sharer supports the **VC Enveloped VHL Option** (see [2:3.YY3.4.3](#23yy343-vc-enveloped-vhl)) the caller MAY set `format=vc` to request the VHL as a signed Verifiable Credential instead.

**Table 2:3.YY3.4.1.2-1: $generate-vhl Message HTTP query Parameters**

| Query parameter Name | Cardinality | Search Type | Description |
| -------------------- | ----------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| sourceIdentifier     | [1..1]    | token  | A FHIR [Identifier](http://hl7.org/fhir/R4/datatypes.html#Identifier) (business identifier — e.g., MRN, passport number, national ID) that the VHL Sharer uses to locate the Patient record and that Patient's documents.|
| exp      |  [0..1]  | number        | Optional. Number representing expiration time in Epoch seconds, as a hint to help the VHL Receiver determine if this QR is stale. |
| flag |  [0..1]  | string        | Optional. String created by concatenating single-character flags in alphabetical order. L (long-term use), P (Passcode required), U (direct file access). |
| label |  [0..1]  | string        | Optional. String no longer than 80 characters that provides a short description of the data behind the VHL. |
| passcode |  [0..1]  | string        | Optional. User-supplied passcode for passcode-protected VHLs. If provided, the VHL Sharer SHALL securely hash and store this passcode for validation during manifest retrieval (ITI-YY5). The 'P' flag SHALL be included in the flag parameter when a passcode is set. |
| purposeOfUse | [0..*] | token | Optional. Purpose(s) of use the VHL Holder is authorizing for this share, bound (extensible) to [PurposeOfUse](http://terminology.hl7.org/ValueSet/v3-PurposeOfUse) (e.g., `TREAT`, `HPAYMT`, `HRESCH`). Serialized as FHIR `system\|code`. See [Purpose of Use Handling](#purpose-of-use-handling). |
| format | [0..1] | token | Optional. Requested carrier for the returned VHL. Allowed values: `qrcode` (default) or `vc`. `vc` requires the VHL Sharer to support the [VC Enveloped VHL Option](#23yy343-vc-enveloped-vhl-option); if unsupported, the VHL Sharer SHALL return an OperationOutcome error. |


##### 2:3.YY3.4.1.3 Expected Actions
{{ reqGenerateVHLResponseDescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqGenerateVHLResponse site=site  %}

The {{linkvhls}} generates a QR code containing the VHL. The QR code is encoded as an HCERT/CWT structure per the [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html) and contains the VHL payload embedded at claim key 5 within the hcert claim (claim key -260).

The generation process is as follows:

**sourceIdentifier Validation**

Before generating the VHL, the {{ linkvhls }} SHALL:

- Parse `sourceIdentifier` as a FHIR `Identifier` in `system|value` form, resolve it to a known Patient, and authorize the caller for that Patient — rejecting with an `OperationOutcome` (`400`, `404`, or `403` respectively) on failure.
- In patient-constrained contexts (e.g., patient-facing app, SMART `launch/patient` scope), verify the `sourceIdentifier` resolves to the patient-in-context; reject mismatches with `403`.
- Echo this exact `system|value` into the manifest URL as `patient.identifier` (see [VHL Payload Construction](#vhl-payload-construction) below) — never substitute a `Patient.id`.

<a name="purpose-of-use-handling"></a>

**Purpose of Use Handling (if provided)**

If one or more `purposeOfUse` values are provided, the VHL Sharer SHALL:

1. Validate each value against the [PurposeOfUse](http://terminology.hl7.org/ValueSet/v3-PurposeOfUse) value set (extensible binding — jurisdiction- or use-case-specific codes are permitted).
2. Persist the value(s) against the generated folder ID so that they remain discoverable for downstream enforcement at ITI-YY5.
3. When grouped with an IHE PCF [Consent Creator](https://profiles.ihe.net/ITI/PCF/) or [Consent Recipient](https://profiles.ihe.net/ITI/PCF/), populate `Consent.provision.purpose` on any Consent created for or bound to this folder from the persisted value(s).

At [ITI-YY5](ITI-YY5.html) the {{ linkvhls }} MAY use the recorded purpose to enforce consistency with the {{ linkvhlr }}'s declared purpose claim — for example, the `purposeOfUse` claim of an OAuth access token under the OAuth with SSRAA Option, the `sub_purpose` extension of a UDAP assertion, or an equivalent claim carried in a Verifiable Credential under the Verifiable Credential Option. Inconsistent purposes MAY be rejected with HTTP `403 Forbidden`.

The `purposeOfUse` value(s) SHALL NOT be embedded in the QR code or the VHL payload; they are metadata about the share held by the {{ linkvhls }}, not content consumed by the {{ linkvhlr }}.

**Passcode Handling (if provided)**

If the `passcode` parameter is provided:
1. The VHL Sharer SHALL securely hash the passcode using a strong one-way hash function (e.g., bcrypt, Argon2, PBKDF2)
2. The VHL Sharer SHALL store the hashed passcode associated with the folder ID for later validation during ITI-YY5 Retrieve Manifest
3. The VHL Sharer SHALL include the 'P' flag in the `flag` parameter of the VHL payload
4. The passcode itself SHALL NOT be included in the VHL URL or QR code
5. The VHL Holder SHALL securely store the plaintext passcode for future use by the VHL Receiver during manifest retrieval

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
   
   Note: The manifest URL includes all mandatory FHIR search parameters (_id, code, status) and the patient identifier via FHIR chained search on the patient reference parameter (`patient.identifier=system|value`). It optionally includes `_include=List:item` if the VHL Sharer supports the Include DocumentReference Option.

4. Create the VHL payload (using the SHL payload format) as a JSON object with:
   - `url`: the manifest URL from step 3
   - `key`: the base64url-encoded encryption key from step 2 (43 characters). Used by the {{ linkvhlr }} as the symmetric key for JWE `dir`/`A256GCM` decryption of document binaries; see [ITI-YY5 Document Encryption](ITI-YY5.html#23yy5425-document-encryption).
   - `exp`: (optional) expiration time in Epoch seconds
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

**QR Code Generation (HCERT/CWT Encoding)**

After constructing the VHL payload (steps 1-4 above), the VHL Sharer SHALL encode it within an [HCERT](https://smart.who.int/trust/StructureDefinition-HCert.html) structure as per the WHO SMART TRUST specification. The HCERT claim SHALL be 5 for VHL.

The VHL Sharer shall than generate the QR Code as per the [HCERT Specification](https://smart.who.int/trust/hcert_spec.html).

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

**Manifest URL Construction Notes:**

The manifest URL constructed in step 3 SHALL include all mandatory FHIR search parameters required by ITI-YY5:
- `_id`: The unique folder ID (required)
- `code`: The List type, typically "folder" (required)
- `status`: The List status, typically "current" (required)
- `patient.identifier`: The patient identifier using FHIR chained search on the patient reference parameter, in `system|value` format (required). 
- `_include=List:item`: Include DocumentReferences (optional - only if VHL Sharer supports Include DocumentReference Option)

The VHL Receiver will use this exact manifest URL when performing the ITI-YY5 Retrieve Manifest transaction, adding the SHL-defined manifest parameters (`recipient`, `passcode`, `embeddedLengthMax` — per the [SMART Health Links specification](http://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html)) separately in Part 2 of the multipart request.


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
| qrcode | Binary | [0..1] | QR code image containing HCERT-encoded VHL. Populated when `format=qrcode` (default). |
| verifiableCredential | Binary | [0..1] | A Verifiable Credential (`application/vc+ld+json`) carrying the VHL. Populated when `format=vc` and the VHL Sharer supports the [VC Enveloped VHL Option](#23yy343-vc-enveloped-vhl-option). |
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


#### 2:3.YY3.4.3 VC Enveloped VHL Option

VHL Sharers MAY support the **VC Enveloped VHL Option**, in which the VHL payload is returned as a signed W3C Verifiable Credential instead of a QR code. This is selected at request time via `format=vc` and returned in the `verifiableCredential` output parameter. It is an alternative carrier for the same VHL payload — the manifest URL, decryption key, flags, label, expiration, and optional extension are identical to those otherwise embedded at HCERT claim key 5.

The {{ linkvhls }} SHALL construct the VC as a JSON-LD document per the [W3C Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/) with an embedded `proof` of type `DataIntegrityProof` per the [W3C Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-di-ecdsa/) specification (cryptosuite selected per the central [Cryptographic Algorithm Selection](volume-1.html#xx53-cryptographic-algorithm-selection)). The `issuer` SHALL identify the {{ linkvhls }} using a key from the same trust network used for HCERT/CWT signatures (no new trust framework is introduced — the {{ linkvhlr }} verifies the VC proof against the trust list via the existing trust framework).

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

The VC is delivered to the {{ linkvhlh }} and subsequently transmitted to the VHL Receiver per [ITI-YY4 Provide VHL](ITI-YY4.html) using any channel capable of conveying JSON (HTTPS, email attachment, file transfer, etc.).

> **Naming note:** This "VC Enveloped VHL Option" at ITI-YY3/YY4 carries the VHL itself. It is distinct from the "Verifiable Credential Option" at [ITI-YY5](ITI-YY5.html#23yy5415-authentication-option---verifiable-credential-option), which is a separate option for VHL Receiver authentication where the Receiver self-issues a VC as the manifest request body.

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
- The {{ linkvhlr }} SHOULD cache its UDAP registration per `fhirBaseUrl` to avoid re-registering on every VHL scan
- The `fhirBaseUrl` field SHALL NOT be present if the {{ linkvhls }} does not support the OAuth with SSRAA Option, to avoid misleading {{ linkvhlr }}s into attempting UDAP Discovery unnecessarily

#### 2:3.YY3.5.6 VC Enveloped VHL Option
- The VC's `DataIntegrityProof` SHALL chain to a trust anchor in the trust list (same framework used for HCERT/CWT verification).
- The VC `expirationDate` SHOULD be consistent with the VHL payload `exp`; the VHL Receiver SHALL reject the VHL if either has passed.
- Confidentiality considerations are equivalent to the QR form: the VC carries the `key` and MUST be treated as sensitive.
- VHL Sharers MAY issue single-use VCs; short lifetimes are RECOMMENDED for high-security scenarios.
