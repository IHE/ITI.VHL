
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}


## 2:3.YY1 Generate VHL
 {% assign reqGenerateVHLRequest = site.data.Requirements-InitiateVHLGenerationRequest %}
 {% assign reqGenerateVHLResponse = site.data.Requirements-RespondtoGenerateVHLRequest %}


### 2:3.YY1.1 Scope

{% assign reqGenerateVHLRequestTitle = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqGenerateVHLResponseTitle = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqGenerateVHLRequestDescription = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqGenerateVHLResponseDescription = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY1.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlh}} | {{ reqGenerateVHLRequestTitle.valueString }}     |
| {{ linkvhls }}            | {{ reqGenerateVHLResponseTitle.valueString }} |
{: .grid}


### 2:3.YY1.3 Referenced Standards


### 2:3.YY1.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY1.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Interaction Diagram</p>
</figure>

#### 2:3.YY1.4.1 Generate VHL Request Message
This message is implemented as an HTTP GET operation from the client app used by the Holder to the VHL Sharer using the FHIR $generate-vhl operation described in [2:3.YY1.4.1.2 Message Semantics](#23yy1412-message-semantics).


##### 2:3.YY1.4.1.1 Trigger Events
{{ reqGenerateVHLRequestDescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqGenerateVHLRequest  %}
##### 2:3.YY1.4.1.2 Message Semantics
The Get Corresponding Identifiers message is a FHIR operation request as
defined in FHIR (<http://hl7.org/fhir/operations.html>) with the [$generate-vhl operation definition](OperationDefinition-Generate.VHL.html)
and the input parameters shown in Table 2:3.83.4.1.2-1.

Given that the parameters are not complex types, the HTTP GET operation shall be used as defined in FHIR (<http://hl7.org/fhir/operations.html#request>).

The name of the operation is `$generate-vhl`, and it is applied to FHIR Patient Resource type.

The URL for this operation is: `[base]/Patient/$generate-vhl`

Where **[base]** is the URL of VHL Sharer Service provider.

The Generate VHL message is performed by an HTTP GET command shown below:

```
GET [base]/Patient/$generate-vhl?sourceIdentifier=[token]{&targetSystem=[uri]}{&_format=[token]}
```

**Table 2:3.83.4.1.2-1: $generate-vhl Message HTTP query Parameters**

| Query parameter Name | Cardinality | Search Type | Description                                                                                                                                                                                                      |
| -------------------- | ----------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| sourceIdentifier     | \[1..1\]    | token       | The Patient Identifier that will be used by the Patient Identifier Cross-reference Manager to find cross matching identifiers associated with the Patient. See Section 2:3.83.4.1.2.1. |
| targetSystem         | \[0..\*\]   | uri         | The Assigning Authorities for the Patient Identifier Domains from which the returned identifiers shall be selected. See Section 2:3.83.4.1.2.2.                                                                    |
| \_goal             | \[0..1\]    | token       | returned VHL rendering type |
| expirationTime      |  \[0..1\]  | token        | expiration time in Epoch seconds |
| flag |  \[0..1\]  | token        | Flag to indicate if Passcode is required |


##### 2:3.YY1.4.1.3 Expected Actions
{{ reqGenerateVHLResponseDescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqGenerateVHLResponse site=site  %}

#### 2:3.YY1.4.2  Generate VHL Response Message 
The {{ linkvhls }} returns failure, or generates and returns zero to many VHL. Depending on the use case, the VHL maybe rendered using formats such as QR code, Verifiable Credentials, Bluetooth, or NFC.

##### 2:3.YY1.4.2.1 Trigger Events
This message shall be sent when a request initiated by the {{linkvhlh}} has been processed successfully. 

##### 2:3.YY1.4.2.2  Message Semantics

See [ITI TF-2: Appendix Z.6](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html#z.6-populating-the-expected-response-format) for more details on response format handling.

The response message is a FHIR operation response (<http://hl7.org/fhir/operations.html#response>).

On Failure, the response message is an HTTP status code of 4xx or 5xx
indicates an error, and an OperationOutcome Resource shall be returned
with details.

##### 2:3.YY1.4.2.3 Expected Actions
The VHL Sharer processes the results according to application-defined rules.


### 2:3.YY1.5 Security Considerations 
