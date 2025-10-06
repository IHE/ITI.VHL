## 6.YY.2 PKI Submission Content Module

### 6.YY.2.1 Purpose

This content module defines the semantic structure and required metadata elements for all PKI material submissions to a Trust Anchor, independent of transport mechanism.

Conformance to this content module ensures:
- Consistent validation criteria across jurisdictions
- Semantic interoperability between trust networks
- Support for trust domain-specific key management
- Clear participant and key usage identification

### 6.YY.2.2 Scope

This content module applies to:
- X.509 certificate submissions
- JSON Web Key (JWK) submissions  
- DID Document submissions
- Any other public key format used within VHL trust networks

### 6.YY.2.3 Required Metadata Elements

All PKI submissions **SHALL** include the following metadata elements:

**Table 6.YY.2-1: Required PKI Submission Metadata**

| Element | Cardinality | Type | Description | Based On |
|---------|-------------|------|-------------|----------|
| `participantId` | 1..1 | Identifier | Unique identifier of the submitting participant within the trust network. **SHOULD** use ISO 3166-1 alpha-3 country code or URN format | WHO TNG Participant ID |
| `trustDomain` | 1..* | CodeableConcept | Trust domain(s) for which this key material is valid (e.g., "DDCC", "IPS-PILGRIMAGE", "PH4H", "EU-EHDS") | WHO TNG Trust Domain |
| `keyUsage` | 1..* | CodeableConcept | Intended cryptographic usage of the key material. **SHALL** use values from Key Usage Value Set | WHO TNG Certificate Types |
| `keyMaterial` | 1..* | Choice | The public key material itself. **MAY** be X.509 certificate (PEM/DER), JWK, JWK Set, or DID Document | WHO TNG DSC/SCA/TLS/Upload Certificates |
| `algorithm` | 1..1 | CodeableConcept | Cryptographic algorithm and parameters (e.g., "RSA-2048", "ECDSA-P256", "Ed25519") | RFC 7517, RFC 5280 |
| `validFrom` | 1..1 | dateTime | Start of key validity period (ISO 8601 format) | X.509 notBefore |
| `validTo` | 1..1 | dateTime | End of key validity period (ISO 8601 format) | X.509 notAfter |
| `submissionDate` | 1..1 | dateTime | Timestamp of submission | - |

### 6.YY.2.4 Optional Metadata Elements

PKI submissions **MAY** include the following optional metadata elements:

**Table 6.YY.2-2: Optional PKI Submission Metadata**

| Element | Cardinality | Type | Description |
|---------|-------------|------|-------------|
| `participantName` | 0..1 | String | Human-readable name of submitting organization |
| `keyId` | 0..1 | String | Unique key identifier (e.g., "2024-vhl-signing-key-001") |
| `certificateChain` | 0..* | Certificate[] | Certificate chain establishing trust path to root CA |
| `revocationEndpoint` | 0..1 | uri | URL for CRL or OCSP responder |
| `geographicScope` | 0..* | CodeableConcept | Jurisdiction(s) where key is valid (ISO 3166 codes) |
| `purpose` | 0..1 | String | Business or operational context (e.g., "COVID-19 vaccination certificates") |
| `contactInfo` | 0..1 | ContactDetail | Administrative contact for key lifecycle management |
| `signature` | 0..1 | Signature | Digital signature over submission for proof of origin |

### 6.YY.2.5 Key Usage Value Set

The `keyUsage` element **SHALL** use one or more of the following codes:

**Table 6.YY.2-3: Key Usage Value Set**

| Code | Display | Description | Based On |
|------|---------|-------------|----------|
| `SCA` | Signing Certificate Authority | Long-lived certificate authority that issues DSCs | WHO TNG SCA |
| `DSC` | Document Signer Certificate | Short-lived certificate for signing health documents | WHO TNG DSC |
| `UPLOAD` | Upload Signature | Key for signing data packages uploaded to Trust Anchor | WHO TNG Upload |
| `TLS` | TLS Authentication | Certificate for mTLS client or server authentication | WHO TNG TLS |
| `VHL-SIGN` | VHL Signing | Key specifically for signing VHL payloads | VHL-specific |
| `VHL-ENC` | VHL Encryption | Key for encrypting VHL content (if supported) | VHL-specific |

### 6.YY.2.6 Trust Domain Value Set

The `trustDomain` element **SHALL** use codes from a trust network-specific value set. Common examples include:

**Table 6.YY.2-4: Example Trust Domain Codes**

| Code | Display | Description |
|------|---------|-------------|
| `DDCC` | Digital Documentation of COVID-19 Certificates | WHO COVID-19 certificate trust domain |
| `IPS-PILGRIMAGE` | IPS Pilgrimage | International Patient Summary for pilgrimage use cases (e.g., Hajj) |
| `PH4H` | Pan-American Highway for Health | PAHO regional trust domain |
| `EU-EHDS` | European Health Data Space | European Union health data sharing |
| `EVC` | European Vaccination Card | EU vaccination record trust domain |

**Note:** Jurisdictions **MAY** define additional trust domain codes as needed. New trust domain codes **SHOULD** be registered with the Trust Anchor coordinating authority.

### 6.YY.2.7 Submission Format Examples

#### Example 1: X.509 Certificate Submission (JSON)

```json
{
  "resourceType": "PKISubmission",
  "participantId": "urn:iso:std:iso:3166:-1:OMN",
  "participantName": "Oman Ministry of Health",
  "trustDomain": [
    {
      "coding": [{
        "system": "http://smart.who.int/trust/CodeSystem/trust-domain",
        "code": "IPS-PILGRIMAGE"
      }]
    }
  ],
  "keyUsage": [
    {
      "coding": [{
        "system": "http://profiles.ihe.net/ITI/VHL/CodeSystem/key-usage",
        "code": "DSC"
      }]
    }
  ],
  "algorithm": {
    "coding": [{
      "system": "urn:ietf:params:oauth:jwk-alg",
      "code": "ES256"
    }]
  },
  "keyMaterial": {
    "x509Certificate": "-----BEGIN CERTIFICATE-----\nMIICljCCAX4CCQ...\n-----END CERTIFICATE-----"
  },
  "certificateChain": [
    "-----BEGIN CERTIFICATE-----\nMIIDXTCCAkWg...\n-----END CERTIFICATE-----"
  ],
  "validFrom": "2024-01-01T00:00:00Z",
  "validTo": "2025-12-31T23:59:59Z",
  "submissionDate": "2024-01-15T10:30:00Z",
  "keyId": "2024-hajj-dsc-001",
  "revocationEndpoint": "http://crl.health.gov.om/hajj2024.crl",
  "purpose": "Hajj 2024 International Patient Summary signing",
  "signature": {
    "type": "JWS",
    "value": "eyJhbGc..."
  }
}
```

#### Example 2: JWK Submission (JSON)

```json
{
  "resourceType": "PKISubmission",
  "participantId": "urn:iso:std:iso:3166:-1:BRA",
  "participantName": "Brazil Ministry of Health",
  "trustDomain": [
    {
      "coding": [{
        "system": "http://smart.who.int/trust/CodeSystem/trust-domain",
        "code": "PH4H"
      }]
    }
  ],
  "keyUsage": [
    {
      "coding": [{
        "system": "http://profiles.ihe.net/ITI/VHL/CodeSystem/key-usage",
        "code": "VHL-SIGN"
      }]
    }
  ],
  "algorithm": {
    "coding": [{
      "system": "urn:ietf:params:oauth:jwk-alg",
      "code": "RS256"
    }]
  },
  "keyMaterial": {
    "jwk": {
      "kty": "RSA",
      "use": "sig",
      "kid": "2024-ph4h-vhl-001",
      "n": "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx...",
      "e": "AQAB"
    }
  },
  "validFrom": "2024-06-01T00:00:00Z",
  "validTo": "2026-05-31T23:59:59Z",
  "submissionDate": "2024-06-01T08:00:00Z",
  "keyId": "2024-ph4h-vhl-001",
  "geographicScope": [
    {
      "coding": [{
        "system": "urn:iso:std:iso:3166",
        "code": "BRA"
      }]
    }
  ],
  "contactInfo": {
    "name": "Brazil Digital Health Team",
    "telecom": [{
      "system": "email",
      "value": "digital-health@saude.gov.br"
    }]
  }
}
```

#### Example 3: DID Document Reference Submission

```json
{
  "resourceType": "PKISubmission",
  "participantId": "urn:iso:std:iso:3166:-1:SAU",
  "participantName": "Kingdom of Saudi Arabia - Ministry of Health",
  "trustDomain": [
    {
      "coding": [{
        "system": "http://smart.who.int/trust/CodeSystem/trust-domain",
        "code": "IPS-PILGRIMAGE"
      }]
    }
  ],
  "keyUsage": [
    {
      "coding": [{
        "system": "http://profiles.ihe.net/ITI/VHL/CodeSystem/key-usage",
        "code": "SCA"
      }]
    }
  ],
  "algorithm": {
    "coding": [{
      "system": "urn:ietf:params:oauth:jwk-alg",
      "code": "ES256"
    }]
  },
  "keyMaterial": {
    "didDocument": {
      "didReference": "did:web:health.gov.sa:trustlist:hajj-2024"
    }
  },
  "validFrom": "2024-01-01T00:00:00Z",
  "validTo": "2027-12-31T23:59:59Z",
  "submissionDate": "2024-01-10T12:00:00Z"
}
```

### 6.YY.2.8 Validation Rules

Trust Anchors **SHALL** validate submissions against the following rules:

1. **Mandatory Elements**: All required metadata elements per Table 6.YY.2-1 are present
2. **Participant Authorization**: `participantId` corresponds to an authorized participant
3. **Trust Domain Authorization**: Participant is authorized to submit keys for claimed `trustDomain`(s)
4. **Key Usage Validity**: `keyUsage` values are appropriate for participant role and trust domain
5. **Cryptographic Compliance**: `algorithm` meets minimum cryptographic requirements
6. **Temporal Validity**: `validFrom` < `validTo` and validity period conforms to policy
7. **Certificate Chain**: If provided, `certificateChain` validates to a recognized root
8. **Signature Verification**: If `signature` is present, it validates successfully
9. **No Conflicts**: Submission does not conflict with existing active keys for same participant/domain/usage

### 6.YY.2.9 Binding to Transport Mechanisms

This content module **MAY** be transported via any of the following mechanisms:

| Transport | Binding Specification |
|-----------|----------------------|
| RESTful API | POST to Trust Anchor endpoint with JSON payload |
| Published URL | Trust Anchor retrieves JSON from `https://{domain}/.well-known/vhl-trust/{participantId}.json` |
| Secure Messaging | S/MIME or PGP encrypted email with JSON attachment |
| Physical Media | JSON file on USB token or smart card |

Jurisdictions **SHALL** document their specific transport bindings in implementation guides.

### 6.YY.2.10 Cryptographic Requirements

#### 6.YY.2.10.1 Supported Algorithms

The following cryptographic algorithms are **RECOMMENDED** for use within VHL trust networks:

**Signature Algorithms:**

| Algorithm | Key Size | Hash Function | Notes |
|-----------|----------|---------------|-------|
| ECDSA | ≥ 256 bit (P-256, P-384) | SHA-256, SHA-384 | **RECOMMENDED** - Preferred for document signing |
| EdDSA | Ed25519, Ed448 | - | **RECOMMENDED** - Modern alternative |
| RSA-PSS | ≥ 2048 bit | SHA-256, SHA-384 | Acceptable fallback |
| RSA-PKCS#1 v1.5 | ≥ 2048 bit | SHA-256, SHA-384 | Legacy support only |

**Encryption Algorithms (if applicable):**

| Algorithm | Key Size | Notes |
|-----------|----------|-------|
| ECDH | ≥ 256 bit (P-256, P-384) | For key agreement |
| RSA-OAEP | ≥ 2048 bit | For key transport |

#### 6.YY.2.10.2 Algorithm Selection Guidance

- **For Document Signing Certificates (DSC)**: Use ECDSA with P-256 for optimal balance of security and size
- **For VHL Signing**: Use ECDSA with P-256 or EdDSA (Ed25519)
- **For mTLS Certificates**: Use ECDSA with P-256 or RSA-2048
- **For SCA Certificates**: Use ECDSA with P-384 or RSA-3072 for enhanced security

### 6.YY.2.11 Certificate Validity Periods

Trust networks **SHOULD** enforce the following maximum validity periods:

**Table 6.YY.2-5: Recommended Certificate Validity Periods**

| Certificate Type | Maximum Validity | Recommended Key Usage Period | Based On |
|------------------|------------------|------------------------------|----------|
| SCA | 4 years | 3 years | WHO TNG recommendations |
| DSC | 1 year | 10 months | WHO TNG recommendations |
| UPLOAD | 2 years | 18 months | WHO TNG recommendations |
| TLS | 2 years | 18 months | WHO TNG recommendations |
| VHL-SIGN | 2 years | 18 months | VHL-specific |

**Note:** Key usage period should be shorter than certificate validity to allow for overlap during renewal.

### 6.YY.2.12 Cross-Reference to Transaction

This content module is used by:
- **[ITI-YY2] Submit PKI Material** - Volume 2, Section 2:3.YY2
- **[ITI-YY3] Retrieve Trust List** - Volume 2, Section 2:3.YY3 (for understanding trust list contents)

### 6.YY.2.13 Conformance

A PKI submission conforms to this content module if:
1. All mandatory elements from Table 6.YY.2-1 are present and valid
2. `keyUsage` values are from Table 6.YY.2-3 or an approved extension
3. `trustDomain` values are from a recognized trust domain registry
4. `algorithm` meets or exceeds cryptographic requirements in Section 6.YY.2.10
5. All validation rules in Section 6.YY.2.8 pass successfully

### 6.YY.2.14 Implementation Notes

**For Implementers:**
- This content module defines the "what" (required structure), not the "how" (transport mechanism)
- Implementations **MAY** use FHIR resources, plain JSON, XML, or other formats as long as semantic equivalence is maintained
- When using X.509 certificates, certificate extensions **SHOULD** align with metadata elements where possible
- Trust Anchors **SHOULD** provide clear error messages when validation fails, referencing specific validation rules

**For Jurisdictions:**
- Define clear onboarding procedures for participant registration
- Document supported trust domains and their policies
- Specify which transport mechanisms are supported
- Publish cryptographic requirements and approved algorithms
- Establish key lifecycle management procedures (renewal, revocation)

**For Trust Anchors:**
- Maintain authoritative registry of participants and their authorizations
- Validate all submissions against this content module before acceptance
- Publish validated keys via [ITI-YY3] Retrieve Trust List transaction
- Provide audit logs of all submission activities
- Support key revocation and trust list updates