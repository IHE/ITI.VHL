# Status

CI build available at [ITI VHL](https://build.fhir.org/ig/IHE/ITI.VHL/branches/master/index.html)

# History

First draft of Volume 1 is [in a google document](https://docs.google.com/document/d/1yidC89m90LsoYU89dkodLU2Wd8BBNAzjAchrRbO51uE/edit?tab=t.0)

Below is a table summarizing the provided Verified Health Link (VHL) requirements, with columns for Requirement Name, Purpose, Actor(s), Key Actions, and Derived From.


| Requirement Name | Purpose | Actor(s) | Key Actions | Derived From | Related Transactions |
|------------------|---------|----------|-------------|--------------|---------------------|
| InitiateVHLGenerationRequest | Request VHL generation with optional constraints. | VHL Holder | Initiate VHL generation request with parameters (e.g., expiration, scope). | - | GenerateVHL | 
| RespondtoVHLGenerationRequest | Generate signed VHL based on query parameters. | VHL Sharer | Collect/generate content, create and sign VHL payload, optionally record consent or audit events. | - | GenerateVHL |
| RecordConsent | Record VHL Holder’s consent for lawful and transparent health data sharing. | VHL Sharer | Record FHIR Consent resource (data subject, purpose, recipients, scope, validity), support consent updates/revocation. | - | ITI PCF |
| EstablishTrust | Establish trust relationship via Trust Anchor’s public key material. | VHL Sharer, VHL Receiver | Validate digital signatures using keys from trust framework. | - | - |
| SubmitPKIMaterial | Submit public key material to Trust Anchor for trust list inclusion. | VHL Sharer, VHL Receiver | Generate key pairs, prepare metadata, submit to Trust Anchor, ensure material supports distribution. | EstablishTrust | Submit PKI Material |
| InitiateRequestTrustList | Request PKI material from Trust Anchor. | VHL Sharer, VHL Receiver | Request and cache PKI material for signature validation or mTLS. | EstablishTrust | RequestTrustList |
| RequestTrustListResponse ~ ValidateDocumentSignature| Validate, sign, and distribute PKI material as a trusted trust list. | Trust Anchor | Receive, validate, assemble, sign, and expose trust list. | EstablishTrust | RequestTrustList |
| ProvideVHL | Generate and sign VHL for secure document sharing. | VHL Holder | Provide VHL to receiver via NFC, email, or QR Code etc. | - | content profile |
| ReceiveVHL | Receive and validate VHL from VHL Holder. | VHL Receiver | Parse VHL, validate signature, prepare for document retrieval. | - | content profile |
| RequestVHLDocuments | Request multiple health documents using VHL over secure mTLS. | VHL Receiver | Initiate request, establish mTLS, optionally record audit events. | - | MHD + ATNA |
| RequestVHLDocument | Request a single health document using VHL over secure mTLS. | VHL Receiver | Initiate request, establish mTLS, optionally verify document signature, record audit events. | - | MHD + ATNA |
| RecordAccessToHealthData | Log audit events for health data access to ensure accountability and compliance. | VHL Sharer | Record FHIR AuditEvent with metadata (timestamp, accessor, resource type, purpose, outcome). | - | ATNA |
| AuditEventAccess | Record audit events for document access or VHL generation requests. | VHL Sharer | Log events for VHL generation or document retrieval requests. | RecordAccessToHealthData |ATNA |
| AuditEventReceived | Log audit events for VHL receipt, verification, and document retrieval. | VHL Receiver | Record events for VHL receipt, signature verification, document access. | RecordAccessToHealthData | ATNA |
| ~~AcceptMTLSConnection~~ AcceptSecureConnection | Accept mTLS connection as server in VHL transactions. | VHL Sharer | Present server certificate, validate client certificate, establish secure channel. | CreateTrustedChannel | ? |
| ~~InitiateMTLSConnection~~ InitiateSecureConnection | Initiate mTLS connection as client in VHL transactions. | VHL Receiver | Present client certificate, validate server certificate, establish secure channel. | CreateTrustedChannel | ? |
| CreateTrustedChannel | Establish secure mTLS connection for VHL transactions. | VHL Sharer, VHL Receiver | Initiate and accept mTLS, present and validate X.509 certificates. | EstablishTrust | ? |

