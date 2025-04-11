Instance:   VerifyDocumentSignature
InstanceOf: Requirements 
Usage: #definition 
* name = "VerifyDocumentSignature"
* title = "VerifyDocumentSignature"
* status = $pubStatus#active
* publisher = "IHE"
* description = "In this option the VHL Receiver, after receipt of a digitally signed document from a VHL Sharer, shall verify the digtial signature using previosuly retrieved PKI material.  This key material may or may not be distributed under the same trust network under which the VHL was distributed.  This key material may or may not be the same key material that was used to verify the VHL.

See cross-profile considerations for a discussion of the relationship of this option to the IHE Document Signature profile.
"
* actor[+] = Canonical(VHLReceiver)


Instance:   RecordConsent
InstanceOf: Requirements 
Usage: #definition 
* name = "RecordConsent"
* title = "Record Consent"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Record the consent given by the Holder for the creation and utilization of the VHL.

In this option the VHL Sharer acts a Consent Recorder from the Privacy Consent on FHIR (PCF) profile.  In this option, the VHL Sharer SHALL initiate a [Access Consent : ITI-108)(https://profiles.ihe.net/ITI/PCF/ITI-108.html)
transaction as part of the Expected Actions after receipt of a Generate VHL request.   The Access Consent transaction is used to record the consent declarations by the VHL Holder for the sharing of the (set of) health document(s) by the VHL Sharer to any authorized VHL Receiver within the trust network for a specified use case.

"
* actor[+] = Canonical(VHLSharer)

Instance: RecordAccessToHealthData
InstanceOf: Requirements 
Usage: #definition 
* name = "RecordAccessToHealthData"
* title = "RecordAccessToHealthData"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Record an event for audit purpose related to the access of health data such as when, which enitity or natural person, ehich data was accessed."
* actor[+] = Canonical(VHLSharer)


Instance:   AuditEventAccess
InstanceOf: Requirements 
Usage: #definition 
* name = "AuditEvent"
* title = "Audit Event - Accessed Health Data"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Record an event for audit purpose related to the issuance of a VHL.

In this option the VHL Sharer records an audit event for critical events in the access of health documents including:
* Request for the generation of a VHL by a VHL Holder; and
* Request for access to a (set of) health document(s) by a VHL Receiver.
"
* derivedFrom = Canonical(RecordAccessToHealthData)
* actor[+] = Canonical(VHLSharer)


Instance:   AuditEventReceived
InstanceOf: Requirements 
Usage: #definition 
* name = "AuditEventReceived"
* title = "Audit Event - Received Health Data"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Record an event for audit purpose related to the issuance of a VHL.

In this option the VHL Receiver records an audit event for critical events in the access of health documents, for example, including:
* provisioning of VHL from a Holder
* retrieval of health data from the a VHL Sharer
"
* derivedFrom = Canonical(RecordAccessToHealthData)
* actor[+] = Canonical(VHLReceiver)



Instance:   EstablishTrust
InstanceOf: Requirements 
Usage: #definition 
* name = "EstablishTrust"
* title = "Establish Trust"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Establish a trust relationship as participants in a trust network" 
* actor[+] = Canonical(VHLSharer)
* actor[+] = Canonical(VHLReceiver)





Instance:   SubmitPKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "SubmitPKIMaterial"
* title = "Submit PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = """When a trust network participant, a [VHL Sharer](ActorDefinition-VHLSharer.html) or a [VHL Receiver](ActorDefinition-VHLReceiver.html), generates a set of public-private key pair, it initiates submits this key material for validation and distribution by the [VHL Receiver](ActorDefinition-VHLReceiver.html).   
"""
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(VHLSharer)
* actor[+] = Canonical(VHLReceiver)
* statement[+].key = "generate-private-public-key-pair"
* statement[=].label = "Generate Private-Public Key Pair"
* statement[=].requirement = "Generate one or more sets of private-public key pair for usage within a trust network.  The key pairs may be categorized in one or more ways.  For example, categories could include key usage type (e.g. signatures, encryption, mTLS) or by use contest / business domain."
* statement[+].key = "create-trust-list"
* statement[=].label = "Create Trust List"
* statement[=].requirement = "Create a trust list of the PKI material from the key pairs including any necessary data needed for categorization of PKI material in order to:
 * validate the submitted key material
 * ensure its proper usage by trust network participants for the expected workflows."
* statement[+].key = "publish-trust-list"
* statement[=].label = "Publish Trust List"
* statement[=].requirement = "Publish the trust list of created PKI material to the Trust Anchor for distribution among the trust network participants."







Instance:   DistributePKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "DistributePKIMaterial"
* title = "Distribute PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Upon receipt of a set of public key material from a VHL Sharer or VHL Receiver, as trust network participants, the [Trust Anchor](ActorDefinition-TrustAnchor.html) validates and makes available a digitally signed version of the trust list."
* derivedFrom = Canonical(EstablishTrust)
* actor[+] = Canonical(TrustAnchor)
* statement[+].key = "receive-pki-distribution-request"
* statement[=].label = "Receive PKI distribution request"
* statement[=].requirement = "Receive a PKI distribution request from a trust network participant."
* statement[+].key = "validate-pki-material"
* statement[=].label = "Validate PKI material"
* statement[=].requirement = "Validate submitted PKI material based on the certificate governance policies of the Trust Anchor.  Validation may include enforcing, for example the governance of cryptographic algorithms used material, expiry times, or the presence of certificate chains back to certificate authorities."
* statement[+].key = "assemble-trust-list"
* statement[=].label = "Assemble Trust List"
* statement[=].requirement = "Assemble, if not previously done so, the necessary PKI material for distribution as part of a trust list. Distribution of PKI material should allow for the categorization of PKI material such as by participant, by key usage type, and usage/business context."
* statement[+].key = "sign-trust-list"
* statement[=].label = "Sign trust list"
* statement[=].requirement = "Sign the trust list of PKI material using the private key of the Trust Anchor."
* statement[+].key = "make-keys-available-at-distribution-endpoint"
* statement[=].label = "Make trustlist distribution endpoint available"
* statement[=].requirement = "Make appropriate endpoints available for distribution of the signed key material in response to the request from a trust network participant."



Instance: RequestVHLDocuments
InstanceOf: Requirements
Usage: #definition
* name = "RequestVHLDocuments"
* title = "Request VHL Documents"
* status = $pubStatus#active
* publisher = "IHE"
* description = "This transactions is initiated by a VHL Receiver to request a set of health documents from a VHL Sharer.  This transaction should be conducted in such a manner that the VHL Receiver and VHL Sharer can validate one another's participation in the same trust network. The VHL Sharer shall optionally be able to record an audit event for the access of the folder by the VHL Receiver upon the transaction request under the Audit Event option.


"
* actor[+] = Canonical(VHLReceiver)

Instance: RequestVHLDocument
InstanceOf: Requirements
Usage: #definition
* name = "RequestVHLDocument"
* title = "Request VHL Document"
* status = $pubStatus#active
* publisher = "IHE"
* description = "This  transaction is initiated by a VHL Receiver to request a single health document from a VHL Sharer.  This transaction should be conducted in such a manner that the VHL Receiver and VHL Sharer can validate their respective participation in the same trust network.  The VHL Receiver shall optionally be able to validate that the veracity of the health document received through this transaction under the Verify Document Signature option.  The VHL Sharer shall optionally be able to record an audit event for the access of the folder by the VHL Receiver upon the transaction request under the Audit Event option. "
* actor[+] = Canonical(VHLReceiver)


Instance:   ProvideVHL
InstanceOf: Requirements
Usage: #definition
* name = "ProvideVHL"
* title = "Provide VHL"
* status = $pubStatus#active
* publisher = "IHE"
* description = "This transacation is initiated by a VHL Holder to transmit a VHL to the VHL Receiver.   Depending on the use case and context, the payload comprising the VHL may be rendered/serialized and transmitted through various mechanisms, for example as a QR-code, Verifiable Credentials, bluetooth or near-field communication protocols.  These mechanisms are described in [Volume 3](volume-3.html). " 
* actor[+] = Canonical(VHLHolder)




Instance:   ProvidePKIMaterial
InstanceOf: Requirements
Usage: #definition
* name = "ProvidePKIMaterial"
* title = "Provide PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = """On receipt of a Retrieve PKI Material Request, a [Trust Anchor](ActorDefinition-TrustAnchor.html) should validate the appropriate of the request.
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
* description = """A participant of a trust network, a [VHL Sharer](ActorDefinition-VHLSharer.html) or a [VHL Receiver](ActorDefinition-VHLReceiver.html),  SHOULD cache the received public material to reduce network and server load. 
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
* description = """A participant of a trust network, a [VHL Sharer](ActorDefinition-VHLSharer.html) or a [VHL Receiver](ActorDefinition-VHLReceiver.html), wishes to retrieve public key material in order to perform necessary actions such the validation of a digital signature, the establishment of a secure connection, or the decryption of encrypted content.    The received key material, or trust list, SHOULD be cached  by the trust network participant to reduce network and server load. 

Preconditions:
* The trust network participant knows in advance the endpoint at which to initiate the Retrieve PKI material from, which is provided by the [Trust Anchor](ActorDefinition-TrustAnchor,html).

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
* description = "Accept an mTLS in order to conduct further transactions under a secure channel"
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
* description = "Accept an mTLS in order to conduct further transactions under a secure channel"
* derivedFrom = Canonical(CreateTrustedChannel)
* actor[+] = Canonical(VHLSharer)


Instance:   InitiateMTLSConnection
InstanceOf: Requirements
Usage: #definition
* name = "InitiateMTLSConnection"
* title = "Initiate mTLS"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Initiate an mTLS in order to conduct further transactions under a secure channel"
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
A [VHL Holder](ActorDefinition-VHLHolder.html) triggers a request for a VHL authorization mechanism to be generated from a [Sharer](ActorDefinition-VHLSharer.html) in order to share health documents with a [VHL Receiver](ActorDefinition-VHLReceiever.html). 

The [VHL Holder](ActorDefinition-VHLHolder.html) requests that a VHL authorization mechanism be issued to provide access to one or more health documents.

The [VHL Holder]((ActorDefinition-VHLHolder.html) MAY provide optional parameters.  The parameters may be to protect or constrain the scope of the authorization (e.g. configure a pass code, set the time period for which these documents should be made available).


Preconditions:
  * The [Holder](ActorDefinition-VHLHolder.html) SHALL trust that [Sharer](ActorDefinition-VHLSharer.html) has been authorized by its jurisidiction to authorize and provide access to health documents.
  * (optional) the [Holder](ActorDefinition-VHLHolder.html) has selected consent and selective disclosure directives. 

"""
* actor[+] = Canonical(VHLHolder)


Instance:   ReceiveVHL
InstanceOf: Requirements
Usage: #definition
* name = "ReceiveVHL"
* title = "Receive VHL authorization mechanism"
* status = $pubStatus#active
* publisher = "IHE"
* description = """Is able to receive a VHL authorization mechanism from a VHL Holder

  
The [Holder](ActorDefinition-VHLHolder.Html) accepts the VHL for storage on wallet or other utilization.


"""
* actor[+] = Canonical(VHLReceiver)



Instance:   GenerateVHL
InstanceOf: Requirements
Usage: #definition
* name = "GenerateVHL"
* experimental = true
* title = "Generate a VHL authorization mechanism based on query parameters"
* status = $pubStatus#active
* publisher = "IHE"
* description = """
The [VHL Sharer](ActorDefinition-VHLSharer.html) shall generate a VHL to issue to a [VHL Holder](ActorDefinition-VHLHolder.html).

The [VHL Sharer](ActorDefinition-VHLSharer.html) SHALL conduct or perform any necessary tasks to create or populate the folder of health documents that that [VHL Holder](ActorDefinition-VHLHolder.html) has requested to be shared.  It is left to content profiles and other implementation guides to provide any further requirements but these MAY include:
 * generation of documents; 
 * querying for existing documents associated to the [VHL Holder](ActorDefinition-VHLHolder.html) of the requested type; or
 * creation of digital signatures.
 
Once these tasks are completed, [VHL Sharer](ActorDefinition-VHLSharer.html) shall generate a VHL authorization mechanism according to a content profile.

A [VHL Sharer](ActorDefinition-VHLSharer.html) may optionally:
* record the consent of the individual to share their information under the Record Consent option.
* create an audit trail of the creation of the VHL under the Audit Event option. 

"""
// * useContext[+].code = $interactions#transaction
* actor[+] = Canonical(VHLSharer)
* statement[+].key = "collect-content"
* statement[=].label = "Collect content"
* statement[=].requirement = "Collect any pre-existing content and/or generate any necessary content that will be referenced as part of the VHL."
* statement[=].conformance = #SHALL
* statement[+].key = "generate-vhl-payload"
* statement[=].label = "Generate VHL Payload"
* statement[=].requirement = "Generate the payload for the VHL."
* statement[=].conformance = #SHALL
* statement[+].key = "sign-VHL"
* statement[=].label = "Sign VHL"
* statement[=].requirement = "Sign the VHL payload  to produce a Verifiable Health Link."
* statement[=].conformance = #SHALL