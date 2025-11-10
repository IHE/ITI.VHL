{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY4 Provide VHL
 {% assign provideVHL = site.data.Requirements-ProvideVHL %}
 {% assign provideVHLResp = site.data.Requirements-RespondtoProvideVHL %}


### 2:3.YY4.1 Scope

{% assign provideVHLTitle = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign provideVHLRespTitle = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign provideVHLDescription = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign provideVHLRespDescription = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

The Provide VHL transaction enables a {{ linkvhlh }} to transmit a Verified Health Link (VHL) to a {{ linkvhlr }}. The VHL serves as a signed authorization mechanism that allows the Receiver to subsequently retrieve one or more health documents from a VHL Sharer (via ITI-YY5).

Depending on the use case, the VHL MAY be rendered or transmitted using formats such as QR code, Verifiable Credentials, Bluetooth, or NFC.

### 2:3.YY4.2 Actor Roles


| Actor | Role |
|-------|------|
| {{ linkvhlh }} | Provides the VHL to a VHL Receiver through a supported transmission mechanism |
| {{ linkvhlr }} | Receives the VHL from a VHL Holder and prepares to retrieve the referenced health documents |
{: .grid}

### 2:3.YY4.3 Referenced Standards
- **RFC 7515**: JSON Web Signature (JWS)
- **RFC 7519**: JSON Web Token (JWT)  
- **ISO/IEC 18004:2015**: QR Code specification
- **W3C Verifiable Credentials Data Model v1.1**: For VC-based transmission

### 2:3.YY4.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY4.svg%}
  </div>
  <p id="fX.X.X.X-4" class="figureTitle">Figure X.X.X.X-4: Provide VHL Interaction Diagram</p>
</figure>

#### 2:3.YY4.4.1 Provide VHL Request Message

##### 2:3.YY4.4.1.1 Trigger Events
{{ provideVHLDescription.valueMarkdown}}

A VHL Holder initiates the Provide VHL transaction when:
- The VHL Holder wishes to grant access to their health documents to a VHL Receiver
- The VHL Holder has obtained a valid VHL from a VHL Sharer (via ITI-YY3 Generate VHL transaction)
- The VHL Holder encounters a VHL Receiver capable of processing VHLs in a relevant healthcare context

##### 2:3.YY4.4.1.2 Message Semantics

The VHL payload structure is defined in [Volume 3](volume-3.html). The VHL contains at minimum:
- Manifest URL (HTTPS URL pointing to document manifest)
- Digital Signature (JWS signature by VHL Sharer)
- Issuer Identifier (VHL Sharer identifier)
- Optional: Expiration timestamp, passcode flag, usage constraints

**Transmission Options**

Implementations SHALL support at least one of the following transmission mechanisms:

**Option 1: QR Code Rendering**
- VHL encoded as QR code (ISO/IEC 18004:2015)
- Suitable for in-person encounters, walk-in clinics, emergency departments

**Option 2: Deep Link Sharing**
- VHL transmitted as HTTPS URL via secure messaging, email
- Suitable for telehealth, asynchronous coordination

**Option 3: Verifiable Credential Presentation**
- VHL formatted as W3C Verifiable Credential
- Suitable for wallet-based implementations

**Option 4: Proximity-based Transmission (NFC/Bluetooth)**
- VHL transmitted via NFC or Bluetooth LE
- Suitable for contactless check-in scenarios

##### 2:3.YY4.4.1.3 Expected Actions - VHL Holder

The VHL Holder SHALL:
1. Verify VHL validity (not expired)
2. Select appropriate transmission mechanism
3. Render/transmit VHL
4. Provide passcode out-of-band if VHL is passcode-protected

The VHL Holder MAY:
- Maintain record of VHL transmissions
- Revoke VHL access if supported by VHL Sharer

##### 2:3.YY4.4.1.3 Expected Actions - VHL Receiver

{{ provideVHLRespDescription.valueMarkdown }}

Upon receiving a VHL, the VHL Receiver SHALL:

1. **Parse the VHL**: 
   - Decode VHL from transmission format
   - Extract JWS structure including header and payload
   - Identify VHL Sharer from issuer identifier

2. **Validate Digital Signature Against Trusted Key**:
   - Obtain VHL Sharer's public key from Trust Anchor
   - Verify JWS signature using VHL Sharer's public key
   - Confirm VHL Sharer is valid participant in trust network
   - Ensure VHL payload has not been tampered with

3. **Prepare to Retrieve Associated Health Documents**:
   - Extract manifest URL from validated VHL payload
   - Validate expiration timestamp if present
   - Validate usage constraints if present
   - Prepare to initiate document retrieval [(ITI-YY5)](ITI-YY5.html)

The VHL Receiver MAY:
- Prompt user for passcode if required (validated during document retrieval)
- Display VHL label/description
- Record audit event per **[Audit Event – Received Health Data](Requirements-AuditEventReceived.html)**
- Cache VHL for subsequent access attempts

**Error Handling:**

If signature verification fails:
- VHL Receiver SHALL reject the VHL
- VHL Receiver SHALL NOT attempt to retrieve documents
- VHL Receiver SHOULD inform user/operator
- VHL Receiver MAY log failed verification

If VHL expired:
- VHL Receiver SHALL reject the VHL
- VHL Receiver SHOULD inform user/operator
- User may request new VHL from VHL Holder

#### 2:3.YY4.4.2  Provide VHL Response Message 

##### 2:3.YY4.4.2.1 Trigger Events
The VHL Receiver MAY provide optional acknowledgment to VHL Holder confirming receipt and validation. This is transmission-mechanism dependent.

##### 2:3.YY4.4.2.2 Message Semantics

For transmission mechanisms supporting bidirectional communication, response MAY include:

| Element | Cardinality | Description |
|---------|-------------|-------------|
| Acknowledgment | 0..1 | Confirmation VHL received and validated |
| Receipt Identifier | 0..1 | Unique identifier for receipt transaction |
| Receiver Identifier | 0..1 | Identifier of VHL Receiver organization |
| Timestamp | 0..1 | ISO 8601 timestamp of receipt |
{: .grid}

##### 2:3.YY4.4.2.3 Expected Actions

**VHL Receiver:**
- MAY send acknowledgment if supported
- SHALL NOT include sensitive health information

**VHL Holder:**
- MAY receive and store receipts
- SHALL NOT rely on acknowledgment for security decisions

### 2:3.YY4.5 Security Considerations

#### 2:3.YY4.5.1 VHL Integrity and Authenticity
- Digital signature ensures VHL issued by trusted VHL Sharer
- VHL Receivers MUST verify signatures before trusting content

#### 2:3.YY4.5.2 VHL Confidentiality
- VHL does NOT contain PHI
- VHL only contains reference (URL) to retrieve documents
- Actual documents retrieved over secure channel (ITI-YY5)

#### 2:3.YY4.5.3 Replay Attacks
- VHL Sharers SHOULD include expiration timestamps
- VHL Receivers SHOULD enforce expiration validation
- VHL Sharers MAY implement single-use VHLs

#### 2:3.YY4.5.4 Passcode Protection
- Passcode communicated out-of-band (not in VHL)
- Passcode validated during document retrieval (ITI-YY5)
- VHL Sharers SHOULD implement rate limiting

#### 2:3.YY4.5.5 Trust Network Validation
VHL Receivers MUST:
- Validate VHL Sharer is current participant in trust network
- Check certificate revocation status where applicable
- Reject VHLs from untrusted participants

#### 2:3.YY4.5.6 Transmission Security

**QR Codes:**
- Can be photographed/copied
- Use for time-limited scenarios
- Suitable for supervised encounters

**Deep Links:**
- Use HTTPS
- May be forwarded unintentionally
- Include expiration/single-use constraints

**Verifiable Credentials:**
- Strongest binding to holder identity
- Suitable for long-term use cases

**Proximity Transmission:**
- Physical access control
- Use encrypted protocols
- Suitable for high-security environments

### 2:3.YY4.6 Conformance

**VHL Holder SHALL:**
- Provide passcodes out-of-band when required

**VHL Receiver SHALL:**
- Support at least one transmission option
- Verify VHL digital signatures before trusting content
- Validate VHL expiration when present
- Retrieve public keys from trusted Trust Anchors
- Reject VHLs with invalid signatures or expired validity
