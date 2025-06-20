
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:XX Submit PKI Material

{% assign reqSubmitPKI = site.data.Requirements-SubmitPKIMaterial %}
{% assign reqDistributePKI = site.data.Requirements-DistributePKIMaterial %}


{% assign reqSubmitPKItitle = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqDistributePKItitle = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqSubmitPKIdescription = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqDistributePKIdescription = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}



### 2:XX.1 Scope

The Submit PKI Material transaction enables entities within a trust network—specifically, {{ linkvhls }}s and {{ linkvhlr }}s—to submit their public key material to a designated {{ linkta }}. This process facilitates the {{ linkta }}’s role in aggregating, validating, and distributing a trusted list of public keys (Trust List) essential for verifying digital signatures and establishing secure communications within the VHL ecosystem.

### 2:XX.2 Actor Roles



| Actor | Role |
|-------|------|
| {{ linkvhlr}}, {{ linkvhls}} | {{ reqSubmitPKItitle.valueString }}     |
| {{ linkta }}            | {{ reqDistributePKItitle.valueString }} |
{: .grid}


### 2:XX.3 Referenced Standards


### 2:XX.4 Messages

#### 2:XX.4.1 Submit PKI Material Request Message
##### 2:XX.4.1.1 Trigger Events
{{ reqSubmitPKIdescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqSubmitPKI  %}

##### 2:XX.4.1.2 Message Semantics
The message semantics and transport mechanism for the **submission** of public key material to the {{ linkta }} SHALL be defined by the implementing jurisdiction of the trust network. The {{ linkta }} is responsible for validating, cataloging, and securely redistributing key material as part of the canonical Trust List.

Different submission pathways MAY be defined based on the sensitivity, intended use, or organizational classification of the key material. For example:

- **Indirect publication**: Key material is published at a URL under the control of the submitting organization and its location is communicated to the {{ linkta }} via:
    - Publication on a well-known, jurisdictionally recognized website
    - Secure transmission of the URL through official channels (e.g., signed correspondence, notarized documentation)
        
- **Direct submission**: Key material is submitted directly to the {{ linkta }} over a secure, mutually authenticated connection:
    - Use of an API endpoint exposed by the {{ linkta }} requiring mTLS or other credentialed authentication
    - Use of a secure upload portal with logging and role-based access controls
        
- **Offline submission**: In scenarios requiring maximal assurance of origin and identity:
    - Submission of key material on a secure physical medium (e.g., USB token, smart card) during a verified in-person encounter, with formal identity attestation

All submission mechanisms SHOULD be accompanied by sufficient **provenance metadata** to support validation by the {{ linkta }}. At minimum, this SHOULD include:

- The asserted identity of the submitting entity
- The intended usage scope of the key(s) (e.g., signature, encryption, mTLS)
- An expiry date or revocation mechanism, if applicable
- A digital signature or certification path establishing the authenticity of the submission
    
Jurisdictions MAY further constrain the permitted submission methods based on policy, threat models, or operational constraints. The Trust Anchor SHOULD reject submissions that do not meet the validation criteria defined within the trust framework.


##### 2:XX.4.1.3 Expected Actions
{{ reqDistributePKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqDistributePKI site=site  %}

#### 2:XX.4.2 Submit PKI Material Response Message 

There is no Submit PKI Material Response Message defined in this profile.  This is up to the implementing jurisdiction of the {{ linkta }}


### 2:XX.5 Security Considerations 
The secure and verifiable exchange of public key infrastructure (PKI) material is foundational to the operation of a Verified Health Link (VHL) trust network. Any compromise in the integrity, authenticity, or provenance of this material undermines the ability of network participants to verify digital signatures, authenticate service endpoints, or enforce trust relationships.

Accordingly, implementers SHOULD ensure that:

- Submission and retrieval of PKI material occurs only over secure channels (e.g., mutually authenticated TLS),
- Submitted key material includes cryptographic proof of origin (e.g., embedded signatures or certification paths),
- Each key’s usage scope and validity period are clearly defined and enforced,
- All accepted material is validated against the criteria and policies established by the Trust Anchor’s governance authority.
    
Jurisdictions MAY define additional security controls, such as key size requirements, certificate chaining policies, Certificate Revocation List (CRL) or OCSP usage, offline verification workflows, or restrictions on submission endpoints.

The {{ linkta }} SHOULD reject key material that fails to meet the validation requirements established by the trust framework or the implementing jurisdiction.






