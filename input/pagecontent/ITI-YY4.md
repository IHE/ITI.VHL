
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY4 Provide VHL
 {% assign provideVHL = site.data.Requirements-ProvideVHL %}
 {% assign provideVHLResp = site.data.Requirements-RespondtoProvideVHL %}


### 2:3.YY4.1 Scope
This section corresponds to transaction [ITI-YY4] of the IHE Technical Framework. Transaction [ITI-YY4] is used by the VHL Holder and VHL Receiver Actors. This transaction is used to provide a mechanism for sharing a VHL and retrieving health documents.


{% assign provideVHLTitle = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign provideVHLRespTitle = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign provideVHLDescription = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign provideVHLRespDescription = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY4.2 Actor Roles
| Actor | Role |
|-------|------|
| VHL Holder | Provides the VHL to a VHL Receiver through a supported transmission mechanism |
| VHL Receiver | Receives the VHL from a VHL Holder and prepares to retrieve the referenced health documents |
{: .grid}



### 2:3.YY4.3 Referenced Standards


### 2:3.YY4.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY4.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Interaction Diagram</p>
</figure>

#### 2:3.YY4.4.1 Re Provide VHL Request Message
The VHL Holder initiates transmission of a VHL to the VHL Receiver.

##### 2:3.YY4.4.1.1 Trigger Events
A VHL Holder initiates the Provide VHL transaction when:
- The VHL Holder wishes to grant access to their health documents to a VHL Receiver
- The VHL Holder has obtained a valid VHL from a VHL Sharer (via ITI-YY1 Generate VHL transaction)
- The VHL Holder encounters a VHL Receiver capable of processing VHLs in a relevant healthcare context

{{ provideVHLDescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=provideVHLDescription  %}

##### 2:3.YY4.4.1.2 Message Semantics

##### 2:3.YY4.4.1.2.2 VHL Message Structure
The Provide VHL Transaction SHALL utilize the VHL generated as per the ITI-YY1 Generate VHL transaction.

##### 2:3.YY4.4.1.2.2 Transmission Options

Implementers SHALL support at least one of the following transmission options. Implementations MAY support multiple options.

**Option 1: QR Code Rendering**

The VHL Holder renders the VHL payload as a QR code following ISO/IEC 18004:2015. The VHL Receiver scans the QR code using a camera or scanner device.

- The QR code SHALL encode either:
  - The complete VHL payload (for compact VHLs)
  - A short URL that resolves to the VHL payload
- The VHL Holder MAY display the QR code on a mobile device screen or print it on paper
- The VHL Receiver SHALL be capable of decoding QR codes and extracting the VHL payload

This option is particularly suitable for in-person care encounters, walk-in clinics, and emergency departments.

**Option 2: Deep Link Sharing**

The VHL Holder transmits the VHL as a deep link (URL) through secure messaging, email, or other electronic communication channels.

- The URL SHALL use HTTPS protocol
- The URL MAY be a short URL that redirects to the full VHL payload
- The VHL Receiver receives the URL through their communication application and opens it in a VHL-capable application or browser

This option is suitable for telehealth encounters, asynchronous care coordination, and patient-provider messaging.

**Option 3: Verifiable Credential Presentation**

The VHL Holder presents the VHL as a W3C Verifiable Credential through a digital wallet application using standard VC presentation protocols.

- The VHL SHALL be formatted as a Verifiable Credential conforming to W3C VC Data Model v1.1 or later
- Presentation MAY occur via QR code, deep link, or direct wallet-to-wallet protocols
- The VHL Receiver SHALL be capable of verifying VC signatures and extracting the VHL payload

This option is suitable for jurisdictions implementing digital identity infrastructure and wallet-based health data sharing.

**Option 4: Proximity-based Transmission (NFC/Bluetooth)**

The VHL Holder transmits the VHL using near-field communication (NFC) or Bluetooth protocols when devices are in physical proximity.

- Transmission SHALL use secure protocols (e.g., NFC NDEF, Bluetooth LE with encryption)
- The VHL Holder initiates transmission after explicit user action (tap, button press)
- The VHL Receiver accepts the transmission and extracts the VHL payload

This option is suitable for contactless check-in scenarios and high-throughput environments.

---


##### 2:3.YY4.4.1.3 Expected Actions - VHL Holder

The VHL Holder SHALL:

1. **Verify VHL Validity**: Confirm that the VHL has not expired and meets any applicable usage constraints
2. **Select Transmission Method**: Choose an appropriate transmission mechanism based on:
   - Available device capabilities
   - VHL Receiver capabilities  
   - Care encounter context
   - User preference
3. **Render/Transmit VHL**: Execute the selected transmission method
4. **Provide Passcode (if required)**: If the VHL is passcode-protected, communicate the passcode to the VHL Receiver through an out-of-band channel (verbal, printed, separate message)

The VHL Holder MAY:
- Maintain a record of VHL transmissions for personal tracking
- Revoke VHL access through mechanisms provided by the VHL Sharer (if supported)

---
##### 2:3.YY4.4.1.3 Expected Actions - VHL Receiver

1. **Parse the VHL**: 
   - Decode the VHL from the transmission format (QR code, URL, VC, NFC, etc.)
   - Extract the JWS structure including header and payload
   - Identify the VHL Sharer from the issuer identifier (`iss` claim)

2. **Validate Digital Signature Against Trusted Key**:
   - Obtain the VHL Sharer's public key from a recognized Trust Anchor using previously retrieved trust lists (ITI-YY3 Retrieve Trust List transaction)
   - Verify the JWS signature using the VHL Sharer's public key
   - Confirm that the VHL Sharer is a valid participant in the trust network
   - Ensure the VHL payload has not been tampered with

3. **Prepare to Retrieve Associated Health Documents**:
   - Extract the manifest URL from the validated VHL payload
   - If expiration timestamp is present, verify that the VHL is still valid
   - If usage constraints are present, validate that the intended use aligns with those constraints
   - Prepare to initiate document retrieval requests (typically via subsequent HTTP requests over mTLS)

The VHL Receiver MAY:
- Prompt the user to enter a passcode if the `flag` indicates passcode protection
- Display the VHL label/description to confirm the contents with the user
- Record an audit event documenting receipt of the VHL (see Section 2:3.YY4.5)
- Cache the VHL payload for subsequent access attempts within the validity period

**Failure Scenarios:**

If signature verification fails, the VHL Receiver SHALL:
- Reject the VHL
- NOT attempt to retrieve any health documents
- Inform the user/operator of the verification failure
- Record the failed verification attempt in audit logs

If the VHL has expired, the VHL Receiver SHALL:
- Reject the VHL
- Inform the user/operator that the VHL is no longer valid
- Request a new VHL from the VHL Holder if appropriate

---
#### 2:3.YY4.4.2  Provide VHL Response Message 

##### 2:3.YY4.4.2.1 Trigger Events
The VHL Receiver MAY provide an optional acknowledgment to the VHL Holder confirming receipt and validation of the VHL. This response is transmission-mechanism dependent and is typically supported only in digital channels (not QR code scanning).

##### 2:3.YY4.4.2.2 Message Semantics

For transmission mechanisms that support bidirectional communication (e.g., deep links with callback URLs, VC presentations with receipts), the response MAY include:

**Table 2:3.YY4.4.2.2-1: Optional Response Elements**

| Element | Cardinality | Description |
|---------|-------------|-------------|
| Acknowledgment | 0..1 | Confirmation that VHL was successfully received and validated |
| Receipt Identifier | 0..1 | Unique identifier for this receipt transaction |
| Receiver Identifier | 0..1 | Identifier of the VHL Receiver organization |
| Timestamp | 0..1 | ISO 8601 timestamp of receipt |
{: .grid}

The response format is transmission-mechanism specific and is defined in **[Volume 3](volume-3.html)**.

##### 2:3.YY4.4.2.3 Expected Actions

**VHL Receiver (Responder):**
- MAY send an acknowledgment if supported by the transmission mechanism
- SHALL NOT include sensitive health information in the acknowledgment

**VHL Holder (Initiator):**
- MAY receive and store acknowledgment receipts for personal records
- SHALL NOT rely on acknowledgment for security or access control decisions

---

### 2:3.YY4.5 Security Considerations

#### 2:3.YY4.5.1 VHL Integrity and Authenticity

The digital signature on the VHL ensures that:
- The VHL was issued by a trusted VHL Sharer
- The VHL payload has not been modified since issuance
- The VHL Receiver can validate the trust chain through the Trust Anchor

VHL Receivers MUST verify signatures before trusting any VHL content.

#### 2:3.YY4.5.2 VHL Confidentiality

The VHL itself is not encrypted and may be transmitted over public channels (e.g., QR codes, email). However:
- The VHL does NOT contain Protected Health Information (PHI)
- The VHL only contains a reference (URL) to retrieve health documents
- Actual health documents are retrieved over secure mTLS connections (separate transactions)

If the manifest URL itself is considered sensitive, implementers MAY use short URLs or encryption wrappers.

#### 2:3.YY4.5.3 Replay Attacks

To mitigate replay attacks:
- VHL Sharers SHOULD include expiration timestamps in all VHLs
- VHL Receivers SHOULD enforce expiration validation
- VHL Sharers MAY implement single-use VHLs that become invalid after first access
- VHL Sharers MAY implement access quotas limiting the number of retrievals

#### 2:3.YY4.5.4 Passcode Protection

When VHLs are passcode-protected:
- The passcode SHALL be communicated through an out-of-band channel (not in the VHL itself)
- The passcode is required during document retrieval, not during VHL reception
- VHL Sharers SHOULD implement rate limiting and account lockout for passcode attempts
- Passcodes SHOULD have sufficient entropy to resist brute-force attacks

#### 2:3.YY4.5.5 Trust Network Validation

VHL Receivers MUST:
- Validate that the VHL Sharer is a current participant in the trust network
- Check certificate revocation status where applicable  
- Reject VHLs from untrusted or expired participants

#### 2:3.YY4.5.6 Audit Logging

VHL Receivers MAY record audit events when receiving VHLs, including:
- Timestamp of receipt
- VHL Holder identifier (if available)
- VHL Sharer identifier
- VHL identifier or manifest URL
- Outcome of signature verification
- Subsequent document retrieval attempts

Audit events SHALL comply with the [Audit Event – Received Health Data](Requirements-AuditEventReceived.html) requirement and SHOULD conform to ATNA audit message formats.

#### 2:3.YY4.5.7 User Consent and Authorization

The act of a VHL Holder providing a VHL to a VHL Receiver represents authorization for access. However:
- Jurisdictional policies may require additional consent verification
- VHL Sharers may have recorded consent during VHL generation (ITI-YY1)
- VHL Holders retain the right to revoke access where supported

#### 2:3.YY4.5.8 Transmission Security

Different transmission mechanisms have different security profiles:

**QR Codes:**
- Can be photographed or copied without detection
- Should be used for time-limited access scenarios
- Are suitable for supervised in-person encounters

**Deep Links:**
- Should use HTTPS to prevent interception
- May be forwarded or shared unintentionally
- Should include expiration and single-use constraints where appropriate

**Verifiable Credentials:**
- Provide strongest binding to holder identity
- May include holder authentication mechanisms
- Are suitable for long-term use cases

**Proximity Transmission:**
- Provides physical access control (must be present)
- Should use encrypted transport protocols
- Is suitable for high-security environments

---

### 2:3.YY4.6 Conformance

To claim conformance with this transaction:

**VHL Holder:**
- SHALL support at least one transmission option defined in Section 2:3.YY4.4.1.2.2
- SHALL transmit VHL payloads conforming to the structure defined in Volume 3
- SHALL provide passcodes through out-of-band channels when required

**VHL Receiver:**
- SHALL support at least one transmission option defined in Section 2:3.YY4.4.1.2.2
- SHALL verify VHL digital signatures before trusting VHL content
- SHALL validate VHL expiration when present
- SHALL retrieve public keys from trusted Trust Anchors
- SHALL reject VHLs with invalid signatures or expired validity periods

---
