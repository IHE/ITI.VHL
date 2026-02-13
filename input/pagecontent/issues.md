
## Significant Changes

### Significant Changes from Revision x.x

- initial draft of Vol 1


## Issues

### Submit an Issue

### Open Issues

- ToDo_001: Should we introduce a Trust Network Participant (TNP) actor that does the retrieve and publish of keys and then make the VHL Sharer and VHL Receiver grouped actor with the TNP?

- ToDo_004: Some of the language has the QR code as synonymous with the VHL.  Should be careful in Vol 1 that QR is only an example of a type of a VHL that is used for low-bandwidth/contactless/access.  May be other access mechanisms - bluetooth or NFC modalities are used in the future for the providing of a VHL by a VHL Holder to a VHL Receiver.   

- ToDo_006: ITI-YY5 Receiver Authentication for Sharer using Embedded JWS/VC as an option

### Closed Issues

- ToDo_002: Can we use the same transaction to retrieve a single doc VHL as well as retrieve the docs in a folder VHL?
  - **Resolution:** The specification defines a _include option in the ITI-YY5 transaction that supports both single document and folder-based VHL retrieval using the same transaction.

- ToDo_003: Do we want to talk about the general notion of a health link, and then both the verifiable and shared health links?  The SHL model has a different trust network assumption (no pre-coordination of sharer and receiver) so it may be cumbersome to take on in the first pass as the workflow is different?
  - **Resolution:** The current scope focuses exclusively on Verifiable Health Links (VHL), deferring Shared Health Links (SHL) to a future revision due to the differing trust network assumptions and workflow complexity. This approach allows the specification to establish a solid foundation for pre-coordinated trust models before addressing the more open trust model of SHL.

- ToDo_005: Should we specify an API mechanism for the Publish PKI Material transaction?  It may be enough to treat them as Content Creator/Consumer pairs where the content is the location of a trustlist (as a DID).
  - **Resolution:** The specification treats the Publish PKI Material transaction as a Content Creator/Consumer interaction where the published content is a DID-referenced trustlist, rather than defining a separate API mechanism. This approach leverages existing IHE content sharing patterns and avoids introducing unnecessary complexity for PKI material distribution.