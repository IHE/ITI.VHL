{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}


## 2:3.YY3 Generate VHL
 {% assign reqGenerateVHLRequest = site.data.Requirements-InitiateVHLGenerationRequest %}
 {% assign reqGenerateVHLResponse = site.data.Requirements-RespondtoGenerateVHLRequest %}


### 2:3.YY3.1 Scope

{% assign reqGenerateVHLRequestTitle = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqGenerateVHLResponseTitle = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqGenerateVHLRequestDescription = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqGenerateVHLResponseDescription = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY3.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlh}} | {{ reqGenerateVHLRequestTitle.valueString }}     |
| {{ linkvhls }}            | {{ reqGenerateVHLResponseTitle.valueString }} |
{: .grid}


### 2:3.YY3.3 Referenced Standards

- **SMART Health Links Specification**: [SMART Health Links and SMART Health Cards](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html)
- **RFC 4648**: Base64url Encoding
- **RFC 7515**: JSON Web Signature (JWS)
- **ISO/IEC 18004:2015**: QR Code specification
- **FHIR R4**: [HL7 FHIR Release 4](http://hl7.org/fhir/R4/)


### 2:3.YY3.4 Messages

<figure>
{%include ITI-YY3.svg%}
<p id="figure-2.3.YY3-1" class="figureTitle">Figure 2:3.YY3-1: Generate VHL Interaction Diagram</p>
</figure>
<br clear="all">

#### 2:3.YY3.4.1 Generate VHL Request Message
This message is implemented as an HTTP GET operation from the client app used by the Holder to the VHL Sharer using the FHIR $generate-vhl operation described in [2:3.YY3.4.1.2 Message Semantics](#23yy3412-message-semantics).


##### 2:3.YY3.4.1.1 Trigger Events
{{ reqGenerateVHLRequestDescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqGenerateVHLRequest  %}
##### 2:3.YY3.4.1.2 Message Semantics

The Generate VHL message is a FHIR operation request as defined in FHIR (<http://hl7.org/fhir/operations.html>) with the [$generate-vhl operation definition](OperationDefinition-generate-vhl.html).

Given that the parameters are not complex types, the HTTP GET operation shall be used as defined in FHIR (<http://hl7.org/fhir/operations.html#request>).

The name of the operation is `$generate-vhl`, and it is applied to FHIR Patient Resource type.

The URL for this operation is: `[base]/Patient/$generate-vhl`

Where **[base]** is the URL of VHL Sharer Service provider.

The Generate VHL message is performed by an HTTP GET command shown below:

```
GET [base]/Patient/$generate-vhl?sourceIdentifier=[token]{&targetSystem=[uri]}{&_goal=[token]}{&expirationTime=[token]}{&flag=[token]}
```

**VHL Payload Construction**

The VHL payload SHALL be constructed in alignment with the [SMART Health Links specification](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html#construct-a-smart-health-link-payload). The VHL Sharer SHALL:

1. Generate a unique folder ID with 256-bit entropy to serve as the List resource identifier
2. Construct the manifest URL as a query on the base List resource with `_include` parameter:
   ```
   [base]/List/$retrieve-manifest?url=[base]/List?_id=[folder-id]&_include=List:item
   ```
3. Include this manifest URL in the VHL payload along with optional parameters (label, exp, flag, v)

**Table 2:3.YY3.4.1.2-1: $generate-vhl Message HTTP query Parameters**

| Query parameter Name | Cardinality | Type | Description |
| -------------------- | ----------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| sourceIdentifier     | [1..1]    | token       | The Patient Identifier that will be used to find documents associated with the Patient |
| targetSystem         | [0..*]   | uri         | The Assigning Authorities for the Patient Identifier Domains from which the returned identifiers shall be selected |
| _goal             | [0..1]    | token       | Returned VHL rendering type (vhl, qrcode, or both) |
| expirationTime      |  [0..1]  | integer        | Expiration time in Epoch seconds |
| flag |  [0..1]  | token        | Flag to indicate if Passcode is required (P for passcode required) |


##### 2:3.YY3.4.1.3 Expected Actions
{{ reqGenerateVHLResponseDescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqGenerateVHLResponse site=site  %}

#### 2:3.YY3.4.2  Generate VHL Response Message 
The {{ linkvhls }} returns failure, or generates and returns zero to many VHL. Depending on the use case, the VHL maybe rendered using formats such as QR code, Verifiable Credentials, Bluetooth, or NFC.

##### 2:3.YY3.4.2.1 Trigger Events
This message shall be sent when a request initiated by the {{linkvhlh}} has been processed successfully. 

##### 2:3.YY3.4.2.2  Message Semantics

See [ITI TF-2: Appendix Z.6](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html#z.6-populating-the-expected-response-format) for more details on response format handling.

The response message is a FHIR operation response (<http://hl7.org/fhir/operations.html#response>).

On Failure, the response message is an HTTP status code of 4xx or 5xx
indicates an error, and an OperationOutcome Resource shall be returned
with details.

##### 2:3.YY3.4.2.3 Expected Actions
The VHL Sharer processes the results according to application-defined rules.


### 2:3.YY3.5 Security Considerations 
