
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY4 Provide VHL
 {% assign provideVHL = site.data.Requirements-ProvideVHL %}
 {% assign provideVHLResp = site.data.Requirements-RespondtoProvideVHL %}


### 2:3.YY4.1 Scope
This section corresponds to transaction [ITI-YY4] of the IHE Technical Framework. Transaction [ITI-YY4] is used by the VHL Holder and VHL Receiver Actors. This transaction is used to provide a mechanism for sharing a VHL and retrieving health documents.


{% assign provideVHLTitle = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign provideVHLRespTitle = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign provideVHLDescription = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign provideVHLRespDescription = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY4.2 Actor Roles
| Actor | Role |
|-------|------|
| VHL Holder | Provides the VHL to a VHL Receiver through a supported transmission mechanism |
| VHL Receiver | Receives the VHL from a VHL Holder and prepares to retrieve the referenced health documents |
{: .grid}



### 2:3.YY4.3 Referenced Standards


### 2:3.YY4.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY4.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Interaction Diagram</p>
</figure>

#### 2:3.YY4.4.1 Re Provide VHL Request Message
The VHL Holder initiates transmission of a VHL to the VHL Receiver.

##### 2:3.YY4.4.1.1 Trigger Events
A VHL Holder initiates the Provide VHL transaction when:
- The VHL Holder wishes to grant access to their health documents to a VHL Receiver
- The VHL Holder has obtained a valid VHL from a VHL Sharer (via ITI-YY1 Generate VHL transaction)
- The VHL Holder encounters a VHL Receiver capable of processing VHLs in a relevant healthcare context

{{ provideVHLDescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=provideVHLDescription  %}

##### 2:3.YY4.4.1.2 Message Semantics
OPTIONS TO DISCUSS:


##### 2:3.YY4.4.1.3 Expected Actions


#### 2:3.YY4.4.2  Provide VHL Response Message 

##### 2:3.YY4.4.2.1 Trigger Events


##### 2:3.YY4.4.2.2  Message Semantics


##### 2:3.YY4.4.2.3 Expected Actions
{{ provideVHLResp.valueMarkdown }}

{% include requirements-list-statements.liquid req=provideVHLResp site=site  %}


### 2:3.YY4.5 Security Considerations 






