# ALTERNATIVE APPROACH: Option-Based PKI Exchange

> **NOTE**: This file represents an alternative organizational approach to PKI material exchange. 
> See `volume-1.md` for the current (DID-only optional transaction) approach.

## Key Differences from Current Approach

### Current Approach (volume-1.md)
- **Transaction Name**: "Submit PKI Material with DID" and "Retrieve Trust List with DID"
- **Transaction Optionality**: Optional (O) for VHL Sharer/Receiver, Required (R) for Trust Anchor
- **DID Usage**: DID is the ONLY defined mechanism; alternatives are "out of scope"
- **Actor Options**: No PKI-related options (removed from option table)

### Alternative Approach (this file)
- **Transaction Name**: "Submit PKI Material" and "Retrieve Trust List" (generic)
- **Transaction Optionality**: Required (R) for all actors that need trust establishment
- **DID Usage**: DID is one OPTION among potentially many
- **Actor Options**: "DID-based PKI Exchange Option" available to all actors

## Option-Based Structure

### Actor Options Table

| Actor          | Option Name                    |
|----------------|--------------------------------|
| Trust Anchor   | DID-based PKI Exchange         |
| VHL Receiver   | DID-based PKI Exchange         |
| ^              | Verify Document Signature      |
| VHL Sharer     | DID-based PKI Exchange         |
| ^              | Record Consent                 |
| ^              | Audit Event                    |

### DID-based PKI Exchange Option

**Description:**

Actors claiming the DID-based PKI Exchange Option SHALL:
- Submit PKI material formatted as DID Documents per W3C DID Core specification (ITI-YY1)
- Retrieve PKI material as DID Documents (ITI-YY2)
- Implement the message semantics specified in ITI-YY1 Section 2:3.YY1.4.1.2.1 and ITI-YY2 Section 2:3.YY2.4.1.2.1

This option enables interoperability testing at IHE Connectathons by providing a standardized format for PKI material exchange.

**When NOT Claimed:**

Actors that do NOT claim this option:
- Are still REQUIRED to submit and retrieve PKI material (transactions are mandatory)
- SHALL define their own PKI material format and exchange mechanisms
- SHOULD document their approach in their IHE Integration Statement
- Cannot participate in IHE Connectathon testing for PKI exchange functionality

**Applicability:**
- Trust Anchor: SHOULD claim this option to support maximum interoperability
- VHL Sharer: SHOULD claim this option when participating in cross-jurisdictional trust networks
- VHL Receiver: SHOULD claim this option when receiving VHLs from multiple jurisdictions

### Transaction Descriptions

#### Submit PKI Material [ITI-YY1]

This transaction is used by a VHL Receiver or VHL Sharer to submit PKI material to a Trust Anchor.

**Optionality**: REQUIRED (R) for all actors

**Message Semantics:**
- **With DID-based PKI Exchange Option**: PKI material formatted as DID Documents per W3C DID Core
- **Without DID-based PKI Exchange Option**: Jurisdiction-specific format (X.509, JWK, custom)

For details see: ITI-YY1-copy.md

#### Retrieve Trust List [ITI-YY2]

This transaction is used by a VHL Receiver or VHL Sharer to retrieve trusted PKI material from a Trust Anchor.

**Optionality**: REQUIRED (R) for all actors

**Message Semantics:**
- **With DID-based PKI Exchange Option**: Retrieves DID Documents per W3C DID Core
- **Without DID-based PKI Exchange Option**: Jurisdiction-specific retrieval mechanism

For details see: ITI-YY2-copy.md

## Comparison: When to Use Each Approach

### Use Current Approach (DID-only optional) When:
- You want simplicity: one transaction definition, DID-only
- Your jurisdiction has fully committed to DID-based infrastructure
- You want to clearly signal that alternatives are "out of scope"
- You're okay with vendors not implementing if they use alternatives

### Use Alternative Approach (option-based) When:
- You want to emphasize that trust establishment is mandatory
- You want DID as the recommended interoperable path, but not exclusive
- You want to follow traditional IHE option patterns more closely
- You want to make clear that "Submit PKI Material" is required, format is flexible

## Advantages and Disadvantages

### Current Approach Advantages:
✅ Simpler documentation - only one semantic path described in detail
✅ Clearer Connectathon expectations - DID or nothing
✅ Encourages standardization on DID

### Current Approach Disadvantages:
❌ May appear to make trust establishment optional (even though it isn't)
❌ Less familiar option structure for IHE veterans
❌ Could be interpreted as "trust is optional" even though alternatives are required

### Alternative Approach Advantages:
✅ Makes clear that trust establishment is REQUIRED
✅ Follows traditional IHE option patterns (like XDM media types, MHD options)
✅ Allows testing of non-DID implementations if they're standardized later
✅ More explicit about the mandatory nature of PKI exchange

### Alternative Approach Disadvantages:
❌ More complex documentation
❌ Could be misinterpreted as "anything goes" for non-DID implementations
❌ Requires more careful specification of what's required vs. what's optional

## Recommendation

**For Connectathon-focused implementations**: Current approach (DID-only optional)
- Clear testing path
- Simple documentation
- Encourages standardization

**For broad deployment with jurisdiction flexibility**: Alternative approach (option-based)
- Makes trust mandatory, format flexible
- Traditional IHE pattern
- Clear path for jurisdictions with existing PKI infrastructure

## Actor Table Example (Alternative Approach)

| Actors         | Transactions          | Initiator/Responder | Optionality | Reference   |
|----------------|-----------------------|---------------------|-------------|-------------|
| Trust Anchor   | Submit PKI Material   | Responder           | R           | ITI TF-2: 3.YY1 |
|                | Retrieve Trust List   | Responder           | R           | ITI TF-2: 3.YY2 |
| VHL Receiver   | Submit PKI Material   | Initiator           | R           | ITI TF-2: 3.YY1 |
|                | Retrieve Trust List   | Initiator           | R           | ITI TF-2: 3.YY2 |
|                | Provide VHL           | Responder           | R           | ITI TF-2: 3.YY4 |
|                | Retrieve Manifest     | Initiator           | R           | ITI TF-2: 3.YY5 |
| VHL Sharer     | Submit PKI Material   | Initiator           | R           | ITI TF-2: 3.YY1 |
|                | Retrieve Trust List   | Initiator           | R           | ITI TF-2: 3.YY2 |
|                | Generate VHL          | Responder           | R           | ITI TF-2: 3.YY3 |
|                | Retrieve Manifest     | Responder           | R           | ITI TF-2: 3.YY5 |

Note: In this alternative, transactions are R (required) but the FORMAT is determined by options.
