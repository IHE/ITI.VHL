Instance: VerifyDocumentSignature
InstanceOf: Requirements 
Usage: #definition 
* name = "VerifyDocumentSignature"
* title = "Verify Document Signature"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Receiver](ActorDefinition-VHLReceiver.html), upon receiving a digitally signed health document from a [VHL Sharer](ActorDefinition-VHLSharer.html), MAY verify the document's digital signature using previously retrieved PKI material.

This verification process confirms the authenticity, integrity, and provenance of the document independently of the Verified Health Link (VHL) itself.

The public key used for this verification MAY:
* Originate from a different trust network than the one used to validate the VHL
* Be unrelated to the key used to validate the VHL signature

Implementers SHOULD consult cross-profile guidance regarding interoperability with the [IHE Document Digital Signature (DSG) profile](https://profiles.ihe.net/ITI/TF/Volume1/ch-38.html), particularly in cases where additional attestation, long-term non-repudiation, or multi-party signatures are involved.
"""
* actor[+] = Canonical(VHLReceiver)


Instance: RecordConsent
InstanceOf: Requirements 
Usage: #definition 
* name = "RecordConsent"
* title = "Record Consent"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Sharer](ActorDefinition-VHLSharer.html) SHALL record the consent granted by a [VHL Holder](ActorDefinition-VHLHolder.html) to authorize the sharing of their health data via a Verified Health Link (VHL). This consent confirms that the Holder agrees to the creation of a VHL and its use by authorized [VHL Receivers](ActorDefinition-VHLReceiver.html) to access specific health documents.

In this requirement, the VHL Sharer acts as a Consent Recorder, as defined in the [Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/index.html) profile. Specifically, the Sharer SHALL initiate the [Access Consent - ITI-108](https://profiles.ihe.net/ITI/PCF/ITI-108.html) transaction to formally capture the Holder's consent.

The resulting `Consent` resource SHALL document:
* The data subject (VHL Holder)
* The purpose of use
* The authorized data recipients (i.e., permitted VHL Receivers)
* The scope of data (e.g., specific documents or resource types)
* The duration or validity period of the consent

The ITI-108 transaction SHOULD be invoked as part of the actions triggered by a Generate VHL request, particularly when legal, jurisdictional, or organizational policy requires explicit, recorded consent prior to enabling document sharing.

This requirement enables lawful, transparent sharing of personal health information across organizations and trust domains.
"""
* actor[+] = Canonical(VHLSharer)


Instance: RecordAccessToHealthData
InstanceOf: Requirements 
Usage: #definition 
* name = "RecordAccessToHealthData"
* title = "Record Access to Health Data"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Sharer](ActorDefinition-VHLSharer.html) MAY record audit events when health data is accessed through a Verified Health Link (VHL). These events support accountability, traceability, and compliance with applicable security and privacy regulations.

Audit records MAY include the following metadata:
* Timestamp of the access event
* Identity of the accessing actor (e.g., person or system)
* Type and identifier of the accessed resource (e.g., DocumentReference)
* Purpose of access, where available (e.g., treatment, consent verification)
* Outcome of the event (e.g., success, failure)

Audit events SHALL be represented using the FHIR `AuditEvent` resource, and SHOULD conform to applicable IHE profiles such as ATNA where appropriate. Implementers MAY define additional audit logging behavior to meet jurisdictional or organizational policies.
"""
* actor[+] = Canonical(VHLSharer)


Instance:   AuditEventAccess
InstanceOf: Requirements 
Usage: #definition 
* name = "AuditEvent"
* title = "Audit Event - Accessed Health Data"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
**Purpose:**  
Ensure that the VHL Sharer records audit events when health documents are accessed or retrieved using a Verified Health Link (VHL).

**Description:**  
The [VHL Sharer](ActorDefinition-VHLSharer.html) MAY record audit events for critical events involving document access. These MAY include:
* A request from a [VHL Holder](ActorDefinition-VHLHolder.html) to generate a VHL
* A request from a [VHL Receiver](ActorDefinition-VHLReceiver.html) to retrieve one or more health documents using a valid VHL
* Any access to protected health content triggered by the use of a VHL
"""
* derivedFrom = Canonical(RecordAccessToHealthData)
* actor[+] = Canonical(VHLSharer)


Instance:   AuditEventReceived
InstanceOf: Requirements 
Usage: #definition 
* name = "AuditEventReceived"
* title = "Audit Event - Received Health Data"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
**Purpose:**  
Ensure that the VHL Receiver generates audit records when receiving and using a Verified Health Link (VHL) to retrieve health information, in support of accountability and traceability.

**Description:**  
The [VHL Receiver](ActorDefinition-VHLReceiver.html) MAY record audit events for critical events during its handling of a VHL. These MAY include:
* Receipt of a VHL from a [VHL Holder](ActorDefinition-VHLHolder.html)
* Verification of the VHL's digital signature and trust chain
* Use of the VHL to retrieve referenced health documents from a [VHL Sharer](ActorDefinition-VHLSharer.html)
* Access, rendering, or internal processing of the retrieved documents
"""
* derivedFrom = Canonical(RecordAccessToHealthData)
* actor[+] = Canonical(VHLReceiver)



Instance:   EstablishTrust
InstanceOf: Requirements 
Usage: #definition 
* name = "EstablishTrust"
* title = "Establish Trust"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
Before participating in any Verified Health Link (VHL) transactions, the [VHL Sharer](ActorDefinition-VHLSharer.html) and [VHL Receiver](ActorDefinition-VHLReceiver.html) SHALL establish a trust relationship based on shared acceptance of a designated [Trust Anchor](ActorDefinition-TrustAnchor.html).

Trust is established by referencing and accepting public key material published and distributed in accordance with this specification (e.g., via [Distribute PKI Material](Requirements-DistributePKIMaterial.html) and [Receive PKI Material](Requirements-ReceivePKIMaterial.html) transactions).

All participants MUST validate digital signatures using keys that are anchored in the agreed trust framework.
"""
* actor[+] = Canonical(VHLSharer)
* actor[+] = Canonical(VHLReceiver)


Instance:   SubmitPKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "SubmitPKIMaterial"
* title = "Submit PKI Material"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
When a [VHL Sharer](ActorDefinition-VHLSharer.html) or [VHL Receiver](ActorDefinition-VHLReceiver.html) generates a new public-private key pair for use within the VHL trust network, they SHALL submit the corresponding public key material to the [Trust Anchor](ActorDefinition-TrustAnchor.html) for validation and inclusion in the trust list.

The submission MAY include metadata to support categorization of key usage (e.g., digital signatures, encryption, mTLS) and business or operational context.
"""
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(VHLSharer)
* actor[+] = Canonical(VHLReceiver)

* statement[+].key = "generate-private-public-key-pair"
* statement[=].label = "Generate Private-Public Key Pair"
* statement[=].requirement = """
Generate one or more private-public key pairs for use within the VHL trust network. Key pairs SHOULD be scoped to specific usage contexts (e.g., signing, encryption, or mTLS) and MAY be categorized by business domain or participant role.
"""

* statement[+].key = "prepare-submission-metadata"
* statement[=].label = "Prepare Submission Metadata"
* statement[=].requirement = """
Include relevant metadata to support validation and categorization. This MAY include:
* Intended key usage
* Organizational identifier or participant reference
* Certificate validity period
* Trust path information (e.g., issuing CA)
"""

* statement[+].key = "submit-to-trust-anchor"
* statement[=].label = "Submit to Trust Anchor"
* statement[=].requirement = """
Submit the public key material and associated metadata to the [Trust Anchor](ActorDefinition-TrustAnchor.html) using the designated secure channel for validation and trust list inclusion.
"""

* statement[+].key = "support-future-distribution"
* statement[=].label = "Support Future Distribution"
* statement[=].requirement = """
Ensure that the submitted PKI material can be validated, signed, and distributed by the Trust Anchor to other trust network participants through [Distribute PKI Material](Requirements-DistributePKIMaterial.html).
"""


Instance:   DistributePKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "DistributePKIMaterial"
* title = "Distribute PKI Material"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
Upon receipt of public key material from a [VHL Sharer](ActorDefinition-VHLSharer.html) or [VHL Receiver](ActorDefinition-VHLReceiver.html), the [Trust Anchor](ActorDefinition-TrustAnchor.html) SHALL validate, organize, sign, and expose the PKI material as part of a trusted, canonical trust list.

This signed trust list enables all participants in the VHL trust network to verify digital signatures and establish secure connections in accordance with the governance policies of the Trust Anchor.
"""
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(TrustAnchor)

* statement[+].key = "receive-pki-distribution-request"
* statement[=].label = "Receive PKI Distribution Request"
* statement[=].requirement = "Receive a PKI material submission from a VHL Sharer or VHL Receiver."

* statement[+].key = "validate-pki-material"
* statement[=].label = "Validate PKI Material"
* statement[=].requirement = "Validate submitted PKI material in accordance with the certificate governance policies of the Trust Anchor. Validation SHALL include checks on cryptographic algorithm conformity, expiration dates, and valid certificate chains to a trusted authority."

* statement[+].key = "assemble-trust-list"
* statement[=].label = "Assemble Trust List"
* statement[=].requirement = "Organize validated PKI material into a structured trust list. The Trust Anchor SHOULD support categorization by submitting participant, key usage type (e.g., signing, encryption, mTLS), and operational context."

* statement[+].key = "sign-trust-list"
* statement[=].label = "Sign Trust List"
* statement[=].requirement = "Digitally sign the assembled trust list using the Trust Anchor's private key, ensuring the integrity and authenticity of the distributed material."

* statement[+].key = "make-keys-available-at-distribution-endpoint"
* statement[=].label = "Expose Trust List Distribution Endpoint"
* statement[=].requirement = "Make the signed trust list available via one or more distribution endpoints accessible to authorized trust network participants."



Instance: RequestVHLDocuments
InstanceOf: Requirements
Usage: #definition
* name = "RequestVHLDocuments"
* title = "Request VHL Documents"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Receiver](ActorDefinition-VHLReceiver.html) SHALL initiate a request to retrieve a set of health documents from a [VHL Sharer](ActorDefinition-VHLSharer.html), using a previously received and validated Verified Health Link (VHL).

This transaction SHALL be conducted over a mutually authenticated TLS (mTLS) channel. Both the Receiver and Sharer SHALL validate each other's participation in the trust network using PKI material published by the [Trust Anchor](ActorDefinition-TrustAnchor.html).

**Optional behaviors:**
* The VHL Sharer MAY record an audit event documenting the access request by the Receiver, in accordance with the [Audit Event – Received Health Data](Requirements-AuditEventReceived.html) requirement.
"""
* actor[+] = Canonical(VHLReceiver)


Instance: RequestVHLDocument
InstanceOf: Requirements
Usage: #definition
* name = "RequestVHLDocument"
* title = "Request VHL Document"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Receiver](ActorDefinition-VHLReceiver.html) SHALL initiate a request to retrieve a single health document from a [VHL Sharer](ActorDefinition-VHLSharer.html), using a previously received and validated Verified Health Link (VHL).

This transaction SHALL be conducted over a mutually authenticated TLS (mTLS) channel. Both the Receiver and Sharer SHALL validate each other's participation in the trust network using PKI material published by the [Trust Anchor](ActorDefinition-TrustAnchor.html).

**Optional behaviors:**
* The VHL Receiver MAY verify the digital signature of the returned health document to confirm its authenticity, integrity, and provenance, as defined in the [Verify Document Signature](Requirements-VerifyDocumentSignature.html) requirement.
* The VHL Sharer MAY record an audit event documenting the access request by the Receiver, in accordance with the [Audit Event – Received Health Data](Requirements-AuditEventReceived.html) requirement.
"""
* actor[+] = Canonical(VHLReceiver)


Instance: ProvideVHL
InstanceOf: Requirements
Usage: #definition
* name = "ProvideVHL"
* title = "Provide VHL"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Sharer](ActorDefinition-VHLSharer.html) SHALL generate a Verified Health Link (VHL) to be issued to a [VHL Holder](ActorDefinition-VHLHolder.html). This includes preparing or retrieving the referenced health content, constructing the VHL payload, and digitally signing it to ensure authenticity and integrity.

The Sharer SHALL perform all necessary steps to assemble the content for sharing. These steps MAY include:
* Querying for existing health documents (e.g., IPS, CDA, FHIR Bundles)
* Generating new content in real time
* Applying digital signatures to selected documents or bundles

The Sharer SHALL construct the VHL payload in accordance with the applicable VHL content profile, and SHALL cryptographically sign the VHL to make it verifiable.

**Optional behaviors:**
* The Sharer MAY record consent in accordance with the [Record Consent](Requirements-RecordConsent.html) requirement.
* The Sharer MAY log an audit event describing the creation of the VHL, as defined in the [Audit Event – Accessed Health Data](Requirements-AuditEventAccess.html) requirement.

Depending on the use case, the VHL MAY be rendered or transmitted using formats such as QR code, Verifiable Credentials, Bluetooth, or NFC. Supported mechanisms are defined in [Volume 3](volume-3.html).
"""
* actor[+] = Canonical(VHLSharer)


Instance:   ProvidePKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "ProvidePKIMaterial"
* title = "Provide PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
Upon receiving a Retrieve PKI Material request, the [Trust Anchor](ActorDefinition-TrustAnchor.html) SHALL validate the request and respond with appropriate public key material.

This MAY include:
* Public key certificates, trust chains, or JWKS structures
* Revocation data (CRL or OCSP)
* Usage metadata (e.g., key type, scope, intended usage)

The Trust Anchor SHALL only respond with validated and trustworthy material in accordance with the governance policies of the VHL trust framework.
"""
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(TrustAnchor)


Instance:   ReceivePKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "ReceivePKIMaterial"
* title = "Receive PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
A [VHL Sharer](ActorDefinition-VHLSharer.html) or [VHL Receiver](ActorDefinition-VHLReceiver.html), after receiving PKI material from a [Trust Anchor](ActorDefinition-TrustAnchor.html), SHALL validate and process the trust information for subsequent cryptographic operations.

Participants SHOULD:
* Cache the received trust list or certificate material to reduce network and server load
* Validate digital signatures or trust paths before use in VHL validation or mTLS sessions
* Monitor certificate expiration or revocation status where applicable
"""
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(VHLSharer)
* actor[+] = Canonical(VHLReceiver)


Instance:   RequestPKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "RequestPKIMaterial"
* title = "Request PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
A [VHL Sharer](ActorDefinition-VHLSharer.html) or [VHL Receiver](ActorDefinition-VHLReceiver.html), as a participant in the trust network, SHALL be capable of requesting public key infrastructure (PKI) material from a designated [Trust Anchor](ActorDefinition-TrustAnchor.html).

The retrieved material MAY include:
* Public key certificates and associated trust lists
* Certificate revocation data (e.g., CRLs, OCSP responses)
* Metadata used to:
  - Validate digital signatures on VHLs and related resources
  - Establish mutually authenticated TLS (mTLS) connections
  - Decrypt content protected via asymmetric encryption

Participants SHOULD cache the received trust list to reduce network and server load.

**Preconditions:**
* The requesting participant knows in advance the endpoint from which to retrieve PKI material, as published or distributed by the Trust Anchor.
"""
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(VHLSharer)
* actor[+] = Canonical(VHLReceiver)


Instance:   CreateTrustedChannel
InstanceOf: Requirements
Usage: #definition
* name = "CreateTrustedChannel"
* title = "Create Trusted Channel"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Sharer](ActorDefinition-VHLSharer.html) and [VHL Receiver](ActorDefinition-VHLReceiver.html) SHALL jointly establish a mutually authenticated TLS (mTLS) connection prior to executing any Verified Health Link (VHL) transactions involving the exchange of sensitive data.

This requirement entails:
* The VHL Receiver initiating the mTLS handshake as the client and presenting a valid X.509 certificate
* The VHL Sharer responding as the server, presenting its own certificate and validating the client's certificate against a trusted Certificate Authority or Trust Anchor

Establishing this trusted channel ensures confidentiality, integrity, and bilateral authentication of all subsequent communications, and fulfills the trust obligations defined in the [Establish Trust](Requirements-EstablishTrust.html) requirement.
"""
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(VHLReceiver)
* actor[+] = Canonical(VHLSharer)


Instance:   AcceptMTLSConnection
InstanceOf: Requirements
Usage: #definition
* name = "AcceptMTLSConnection"
* title = "Accept mTLS"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Sharer](ActorDefinition-VHLSharer.html), when acting as a server in a Verified Health Link (VHL) transaction, SHALL accept a mutually authenticated TLS (mTLS) connection initiated by a [VHL Receiver](ActorDefinition-VHLReceiver.html).

During the TLS handshake, the Sharer SHALL:
* Present a valid X.509 server certificate that is anchored to a recognized Trust Anchor
* Validate the client certificate presented by the Receiver against the same trust framework
* Establish a secure channel over which all subsequent VHL-related transactions are conducted

Successful completion of the mTLS handshake is a prerequisite for all VHL operations involving sensitive data exchange. This requirement refines the bilateral obligations described in [Create Trusted Channel](Requirements-CreateTrustedChannel.html).
"""
* derivedFrom = Canonical(CreateTrustedChannel)
* actor[+] = Canonical(VHLSharer)


Instance:   InitiateMTLSConnection
InstanceOf: Requirements
Usage: #definition
* name = "InitiateMTLSConnection"
* title = "Initiate mTLS"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Receiver](ActorDefinition-VHLReceiver.html), when acting as a client in a Verified Health Link (VHL) transaction, SHALL initiate a mutually authenticated TLS (mTLS) connection to the [VHL Sharer](ActorDefinition-VHLSharer.html).

This initiation includes:
* Presenting a valid X.509 client certificate
* Validating the Sharer's server certificate against an accepted Trust Anchor

Successful completion of the mTLS handshake is a prerequisite for all subsequent transactions involving sensitive data exchange, including the retrieval of VHLs or associated health documents.
"""
* derivedFrom = Canonical(CreateTrustedChannel)
* actor[+] = Canonical(VHLReceiver)


Instance:   RequestVHL
InstanceOf: Requirements
Usage: #definition
* name = "RquestVHL"
* title = "Request that a VHL authorization mechanism be issued"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
A [VHL Holder](ActorDefinition-VHLHolder.html) initiates a request to a [VHL Sharer](ActorDefinition-VHLSharer.html) to generate a Verified Health Link (VHL) that references one or more health documents. The resulting VHL allows the Holder to subsequently share access to those documents with a [VHL Receiver](ActorDefinition-VHLReceiver.html).
The Holder MAY include optional parameters to constrain or protect the issued VHL-such as defining an expiration period, scoping which documents are included, or requiring a passcode for retrieval. These parameters guide the Sharer's issuance of the VHL and influence the conditions under which the associated documents may be accessed.

**Preconditions:**
  * The [VHL Holder](ActorDefinition-VHLHolder.html) SHALL trust that the [VHL Sharer](ActorDefinition-VHLSharer.html) has been authorized by its jurisdiction to generate VHLs and to provide access to the corresponding health documents.
  * Optionally, the [VHL Holder](ActorDefinition-VHLHolder.html) has selected consent directives or selective disclosure preferences, as permitted by the applicable content profile. 
"""
* actor[+] = Canonical(VHLHolder)


Instance:   ReceiveVHL
InstanceOf: Requirements
Usage: #definition
* name = "ReceiveVHL"
* title = "Receive VHL authorization mechanism"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Receiver](ActorDefinition-VHLReceiver.html) SHALL be capable of receiving a Verified Health Link (VHL) from a [VHL Holder](ActorDefinition-VHLHolder.html) through a supported transport mechanism (e.g., QR code scan, direct URL, or digital message).

Upon receipt, the Receiver SHALL:
* Parse the VHL
* Validate its digital signature against a trusted key published by a recognized Trust Anchor
* Prepare to retrieve the associated health documents

Receipt of the VHL may occur through direct user interaction (e.g., scanning a QR code) or automated channels, depending on the implementation context.
"""
* actor[+] = Canonical(VHLReceiver)



Instance: GenerateVHL
InstanceOf: Requirements
Usage: #definition
* name = "GenerateVHL"
* experimental = true
* title = "Generate a VHL Authorization Mechanism Based on Query Parameters"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Sharer](ActorDefinition-VHLSharer.html) SHALL generate a Verified Health Link (VHL) to be issued to a [VHL Holder](ActorDefinition-VHLHolder.html).

The Sharer SHALL conduct all necessary tasks to prepare the content referenced by the VHL. These tasks MAY be further defined by applicable content profiles or implementation guides, and MAY include:
* Generation of new documents;
* Querying for existing documents associated with the VHL Holder; or
* Creation of digital signatures on one or more documents.

Once content preparation is complete, the Sharer SHALL construct the VHL payload and sign it to produce a cryptographically verifiable authorization mechanism.

**Optional behaviors:**
* The Sharer MAY record consent in accordance with the [Record Consent](Requirements-RecordConsent.html) requirement.
* The Sharer MAY log an audit event describing the VHL issuance, in accordance with the [Audit Event – Accessed Health Data](Requirements-AuditEventAccess.html) requirement.
"""
* actor[+] = Canonical(VHLSharer)

* statement[+].key = "collect-content"
* statement[=].label = "Collect Content"
* statement[=].requirement = "Collect any pre-existing content and/or generate any necessary content that will be referenced as part of the VHL."
* statement[=].conformance = #SHALL

* statement[+].key = "generate-vhl-payload"
* statement[=].label = "Generate VHL Payload"
* statement[=].requirement = "Generate the payload for the VHL in accordance with the applicable content profile."
* statement[=].conformance = #SHALL

* statement[+].key = "sign-VHL"
* statement[=].label = "Sign VHL"
* statement[=].requirement = "Sign the VHL payload to produce a verifiable and cryptographically bound artifact."
* statement[=].conformance = #SHALL