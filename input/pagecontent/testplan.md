<div markdown="1" class="stu-note">

We expect the maturity of the content will improve over time.  For now, we summarize high level testing scope and available tools. Comments are welcome.
</div>


## Introduction

VHL is an API between four actors: Trust Anchor, VHL Sharer, VHL Holder, and VHL Receiver. The Trust Anchor manages and distributes PKI material to enable digital signature verification across the trust network. The VHL Sharer generates Verifiable Health Links and responds to manifest retrieval requests. The VHL Holder is a person who possesses a VHL and presents it to a VHL Receiver. The VHL Receiver validates the VHL, retrieves the manifest, and accesses health documents from the VHL Sharer.

The testing focuses on the five transactions defined in this profile: Submit PKI Material with DID [ITI-YY1], Retrieve Trust List with DID [ITI-YY2], Generate VHL [ITI-YY3], Provide VHL [ITI-YY4], and Retrieve Manifest [ITI-YY5]. Testing is primarily focused on server-side actor expectations (Trust Anchor and VHL Sharer) where transaction semantics can be validated against conformance criteria, as well as VHL Receiver decoding and verification behavior.

Overall test plan leverages the Profiles, and Examples shown on the [Artifacts Summary](artifacts.html). The [Profiles](artifacts.html#structures-resource-profiles) listed are describing the constraints that would be adhered to by actors claiming conformance to this implementation guide. Thus any applicable resources that are known to have been published by an app or server MUST be conformant to these profiles as appropriate.

The Examples listed in [Example Instances](artifacts.html#example-example-instances) are example instances. Some are conformant to the profiles. Other examples that either assist with the structure of the examples (e.g. Patient) or are examples that should be able to handle in various ways.

This section will be filled in as the IHE-Connectathon need drives the creation of the test plans, test procedures, test tools, and reporting.


### High-level Test Scope

#### Trust Establishment

The Trust Anchor must be tested for its ability to receive and validate PKI material submissions [ITI-YY1] using Decentralized Identifiers (DIDs) conformant to the W3C DID Core 1.0 specification. This includes validating DID Document structure, verification methods, and public key formats (JWK or multibase). The Trust Anchor must also be tested for responding to trust list retrieval requests [ITI-YY2], including support for single DID resolution, bulk DID queries, and filtering by status (active, revoked, expired).

#### VHL Generation and Provision

The VHL Sharer must be tested for its ability to process `$generate-vhl` operation requests [ITI-YY3] from a VHL Holder, including validation of input parameters (sourceIdentifier, targetSystem, exp, flag, label, passcode) and generation of a correctly structured QR code containing an HCERT/CWT-encoded VHL with the HC1: prefix. The VHL Holder's ability to present the VHL to a VHL Receiver [ITI-YY4] via QR code is tested as part of the end-to-end workflow.

#### VHL Decoding and Verification

The VHL Receiver must be tested for its ability to correctly perform the full VHL decoding process [ITI-YY4]: scanning the QR code, verifying the HC1: prefix, Base45 decoding, ZLIB/DEFLATE decompression, CBOR Web Token (CWT) parsing, COSE digital signature verification, CWT claims validation, SHL payload extraction, and SHL payload validation.

#### Manifest Retrieval

The VHL Receiver and VHL Sharer must be tested for the Retrieve Manifest transaction [ITI-YY5]. This includes the VHL Receiver's ability to construct and send a valid FHIR search request on the List resource with appropriate search parameters (_id, code, status, patient.identifier, _include) and SHL parameters (recipient, passcode). The VHL Sharer must be tested for returning a conformant searchset Bundle. Authentication via HTTP Message Signatures (RFC 9421) is required and must be validated.

#### Options Testing

Testing of actor options includes:
- **Sign Manifest Request Option** - VHL Receiver digitally signs manifest requests; VHL Sharer verifies the signature for mutual authentication and non-repudiation.
- **Include DocumentReference Option** - VHL Receiver requests and VHL Sharer returns DocumentReference resources in the manifest response using `_include=List:item`.
- **Verify Document Signature Option** - VHL Receiver verifies digital signatures on retrieved documents using previously obtained PKI material.
- **OAuth with FAST Option** - VHL Receiver and VHL Sharer use OAuth 2.0 access tokens as an alternative authentication mechanism for ITI-YY5.





### Unit Test Procedure

Unit Tests in this context is where a SUT is tested against a simulator or validator.  A simulator is a implementation of an actor that is designed specifically to test the opposite pair actor. The simulator might be a reference implementation or may be a specially designed test-bench. Where a reference implementation is used the negative tests are harder to simulate. A validator is a implementation that can check conformance. A validator may be a simulator, but may also be a standalone tool used to validate only a message encoding. Some reference implementations may be able to validate to a StructureDefinition profile, but often these do not include sufficient constraints given the overall actor conformance criteria. 

**Trust Anchor**
- [ITI-YY2] : On receipt of a Retrieve Trust List Request Msg, the TA responds with the DID
- [ITI-YY1]: On receipt of DID , validate, organize and sign the trust list, ack
- retrieve TRust List (test1),
- submit a trust list and retrieve it (Test2)

**VHL Sharer**
- [ITI-YY1] : Submit PKI Material with DID
    - validate DID semantic
- [ITI-YY3] : Generate VHL
   - test the operation defn, given inputs validate the output


**VHL Receiver**
- [ITI-YY4] : Provided QR code is decoded
- [ITI-YY5] : 

### Integration Test Procedure

Integration Tests in this context is where two SUT of paired actors test against each other. In this case the subset of tests that can be tested is the intersection. Testing only this intersection is necessary but not sufficient. The testing must also include the capability of the client to exercise the test scenarios that this SUT can test, to determine that failure-modes are handled properly by both SUT.

**Integration**
- Establish Trust
- Generate/Provide/Retrieve
----specific keys are available to use
