Instance: UseCaseGDHCN
InstanceOf: ExampleScenario
Usage: #definition
* name = "GDHCN"
* status = $pubStatus#active
* publisher = "IHE"
* purpose = """
The World Health Organization (WHO) operates the [Global Digital Health Certification Network (GDHCN)](https://smart.who.int/trust), a trust network for public-sector health jurisdictions. The GDHCN provides the infrastructure for the bilateral verification and utilization of Verifiable Digital Health Certificates across participating jurisdictions.

The GDHCN uses the notion of a **Trust Domain** which is defined by a set of:
- use cases and business processes related to the utilization of Verifiable Digital Health Certificates
- open, interoperable technical specifications that define the applicable Trusted Services and verifiable digital health certificates for the use case
- policy and regulatory standards describing expected behavior of participants for the use case

**How Trust is Established:**

Trust in the GDHCN is established through a Public Key Infrastructure (PKI). Each participating jurisdiction submits its PKI material — including Signing Certificate Authority (SCA) certificates and Document Signer Certificates (DSCs) — to the WHO Trust Anchor through a formal onboarding process. The Trust Anchor publishes this key material in trust lists that other participants can retrieve and use to verify the digital signatures on health certificates.


**DID-Based Trust List Distribution:**

The GDHCN distributes trust lists using [Decentralized Identifiers (DIDs)](https://www.w3.org/TR/did-core/). Each participating jurisdiction's key material is represented as a DID Document containing verification methods with the jurisdiction's public keys. These DID Documents are published as endpoints by the Trust Anchor, analogous to how the [IHE mCSD Profile](https://profiles.ihe.net/ITI/mCSD/) distributes service endpoints for Organizations. This enables participants to discover and retrieve the PKI material needed for signature verification through a standardized, cacheable, and federated mechanism.

**Verifiable Credential Option:**

Because GDHCN participants are already registered in the trust network with DID Documents, they are well-positioned to use the Verifiable Credential Option for ITI-YY5 Retrieve Manifest authentication. A VHL Receiver acting within the GDHCN can self-issue a JWT-encoded Verifiable Credential (`application/vc+jwt`) using its registered DID and present it to the VHL Sharer via `Authorization: JWT-VC <token>`, without requiring any additional authorization server infrastructure.

**Trust Network Gateway:**

The GDHCN Trust Network Gateway (TNG) provides a federated architecture that enables multiple trust anchors and cross-gateway trust propagation. The TNG supports both an API gateway method and DID-based resolution for trust list distribution, ensuring interoperability across diverse jurisdictional implementations.

The PKI operated by the WHO supports a variety of trust domains, two of which — the Hajj Pilgrimage and the Pan-American Highway for Health — are described below.

<figure>
  <img src="trust_network.png" caption="WHO GDHCN Trust Network" style="width:45em; max-width:100%;"/>
  <p id="fX.X.X.X-TN" class="figureTitle">Figure X.X.X.X-TN: WHO GDHCN Trust Network</p>
</figure>
"""
* process.title = "GDHCN Trust Establishment"
* process.description = "Process for establishing trust within the WHO GDHCN trust network through PKI material submission and trust list distribution."
* process.preConditions = "Jurisdiction has completed the GDHCN onboarding process and has generated SCA and DSC certificates."
* process.postConditions = "Jurisdiction's PKI material is published in the GDHCN trust list and available for retrieval by other participants."
* process.step[0].operation.number = "1"
* process.step[0].operation.name = "Jurisdiction Onboarding"
* process.step[0].operation.description = "A participating jurisdiction completes the GDHCN onboarding process and submits its Signing Certificate Authority (SCA) and Document Signer Certificates (DSCs) to the WHO Trust Anchor. The Trust Anchor validates the submitted certificates and onboards the jurisdiction into the trust network."
* process.step[1].operation.number = "2"
* process.step[1].operation.name = "Trust List Publication"
* process.step[1].operation.description = "The WHO Trust Anchor publishes the jurisdiction's PKI material as DID Documents in the GDHCN trust list. Each DID Document contains verification methods with the jurisdiction's public keys, distributed as endpoints that can be discovered and retrieved by other trust network participants."
* process.step[2].operation.number = "3"
* process.step[2].operation.name = "Trust List Retrieval"
* process.step[2].operation.description = "Participating jurisdictions (acting as VHL Sharers or VHL Receivers) retrieve the trust list from the Trust Anchor. The retrieved DID Documents provide the public keys needed to verify digital signatures on health certificates and to establish secure channels for document exchange."


Instance: UseCaseHajjPilgrimage
InstanceOf: ExampleScenario
Usage: #definition
* name = "HajjPilgrimage"
* status = $pubStatus#active
* publisher = "IHE"
* purpose = """
During the Hajj pilgrimage, the Kingdom of Saudi Arabia (KSA) hosts approximately two million pilgrims from across the globe as part of a mass gathering event. Temporary hospitals and clinics, comprising over a thousand beds, are established to provide care to the pilgrims over the four-week period of Hajj.

Starting with Hajj 1445 AH (2024 CE), pilgrims from Oman, Malaysia, and Indonesia were able to share their health records utilizing the International Patient Summary (IPS) with verification of health documents provided through the WHO Global Digital Health Certification Network (GDHCN) infrastructure.

Key Features:
- Trust established through WHO GDHCN trust network
- Multi-country interoperability (Oman, Malaysia, Indonesia to KSA)
- IPS-based continuity of care
- Consent captured and enforced through IPS Advanced Directives
- PIN protection for additional security on printed cards
- Support for both physical and digital VHL provisioning

Some of the challenges faced during the pilot implementation, though not necessarily to be taken up in this profile, include:

- while not the main point of security, leveraging the PIN is a weakness, need to enable better options for future consideration (e.g. biometrics, other authorization methods). The Verifiable Credential Option for ITI-YY5 provides one such improvement: KSA healthcare system VHL Receivers can self-issue a JWT-encoded VC using their DID registered in the GDHCN trust network, presenting it to the VHL Sharer without requiring a PIN or separate authorization server.
- in planning for expansion to umrah and general tourism, there will not in general be a health check which presents some process challenges such as not having a encounter point to record consent prior to a visit
- how to scale and automate some of the health checks (e.g. are vaccinations sufficient) using verifiable health documents (e.g. the IPS).


<figure>
  <img src="hajj-diagram.png" caption="Hajj Pilgrimage VHL Flow" style="width:42em; max-width:100%;"/>
</figure>
"""
* process.title = "Hajj Pilgrimage VHL Flow"
* process.description = "Process for sharing pilgrim health records during Hajj using VHL with WHO GDHCN trust infrastructure for cross-border verification."
* process.preConditions = "Pilgrim has received health assessment in home country. Home country has registered PKI material with WHO GDHCN Trust Anchor. Pilgrim has provided consent (verbal or digital) to share health records."
* process.postConditions = "KSA healthcare providers can access pilgrim health records as IPS."
* process.step[0].operation.number = "1"
* process.step[0].operation.name = "Pre-Departure Health Check"
* process.step[0].operation.description = "Pilgrims begin their journey in their home country where they receive a health check and are educated on the use of QR codes (a version of Verifiable Health Links) and provide the consent to share their health records. This consent may be provided verbally or recorded digitally. When recorded, there are two notions of consent recorded:

- for their home country in which they agree that health records from their home country can be shared with appropriate authorities during Hajj
- for KSA is to permit utilization of these health records within the Saudi System. These consent records are recorded into the IPS Advanced Directives section and are included with the IPS when it is shared."
* process.step[1].operation.number = "2"
* process.step[1].operation.name = "VHL Generation"
* process.step[1].operation.description = "The verifiable health link is provided by their home jurisdiction during their health check as a QR code.
Depending on the digital infrastructure pilgrim's origin country, jurisdictional policies and digital capabilities (e.g. access to smart phones) of the pilgrim's origin country, the verifiable health link may be:

- generated and printed on the pilgrim's health card and distributed to the pilgrim at the time of the health check; or
- provisioned to the pilgrim through an existing digital health platform or wallet. For similar reasons, the verifiable health link may refer to:
- an instance of the IPS rendered as a PDF;
- an instance of the IPS rendered as JSON; or
- a folder containing at least the PDF of JSON rendering of the IPS as well associated digital signatures."
* process.step[2].operation.number = "3"
* process.step[2].operation.name = "VHL Provision During Care"
* process.step[2].operation.description = "During a care encounter in KSA, the pilgrim provides their verifiable health link as a QR code to their care provider. Once a VHL is shared by a pilgrim during a care encounter in KSA:

- the VHL is verified through the GDHCN infrastructure
- an mTLS connection is established between the KSA EMRs and the origin country national infrastructure using key material exchanged via GDHCN
- a manifest of IPS related files including a PDF and JSON renderings and associated digital signatures
- The EMR retrieves the requisite files"


Instance: UseCasePH4H
InstanceOf: ExampleScenario
Usage: #definition
* name = "PH4H"
* status = $pubStatus#active
* publisher = "IHE"
* purpose = """
In the region of the Americas,  "countries identified several priorities for cross-border digital
health, including optimizing available human resources through international telehealth, validating digital certificates, ensuring continuity of care, and regional resilience to face health emergencies by sharing data for public health. During the IDB-PAHO co-led event, RELACSIS 4.0.1 a plan was launched to strengthen regional digital health services and resilience, through regional data exchange and policy harmonization. Sixteen countries successfully exchanged digital vaccine certificates (COVID-19, Polio, Measles, and Yellow Fever) and critical clinical information (diagnosis, allergy, and prescription information) using international standards during the 2nd Regional LACPASS Connectathon.2 Regional bodies and network such as the Council of Ministers of Health of Central America and the Dominican Republic (COMISCA), The Caribbean Public Health Agency (CARPHA), and the LAC Digital Health Network (RACSEL) have all identified cross-border data sharing as a priority."  
[footnote](https://ewsdata.rightsindevelopment.org/files/documents/46/IADB-RG-T4546_BBZnmFh.pdf)

The Pan American Health Organization (PAHO) and the InterAmerican Development Bank (IADB) are supporting the development of policies and digital infrastructrue to support this need. One particular priority is to improve the continuity of care for internal migrants within the region, by ensuring individuals have access to and can share their vaccination records and the International Patient Summary.

The Pan-American Highway for Health (PH4H)  "aims to provide patients with better healthcare services, regardless of their location. It will also enhance healthcare for those who move temporarily for work or study, as well as for migrants, by enabling them to share their health history, thus improving their employability and access to education. "  
[footnote](https://ewsdata.rightsindevelopment.org/files/documents/46/IADB-RG-T4546_BBZnmFh.pdf)

While there currently there is no single legal framework that broadly enables data sharing across the region, there are sub-regional networks (e.g. COMISCA, CARPHA) that have policies that can be leveraged in the short term while necessary data sharing agreements are developed.   Thus, individuals in this region will need to be able to move through overlapping trust networks.

<figure>
  <img src="PH4H.png" caption="Pan-American Highway for Digital Health Goals" style="width:38em; max-width: 100%;"/>
</figure>
"""



Instance: UseCaseEVAC
InstanceOf: ExampleScenario
Usage: #definition
* name = "EUVAC"
* status = $pubStatus#active
* publisher = "IHE"
* purpose = """
The [European Vaccination Card (EVC)](https://euvabeco.eu/news/european-vaccination-card-evc-a-citizen-held-card-to-foster-informed-decision-making-on-vaccination-and-improve-continuity-of-care-across-the-eu/) is a citizen-held card to foster informed decision-making on vaccination, and improve continuity of care across the EU.

The EVC will allow "Member States to bilaterally verify the authenticity of digital records through an interoperable trust architecture. While similar to the EU Digital COVID Certificate in being a portable vaccination record, the EVC serves a different purpose. Unlike the certificate, which often fulfilled legal or health mandates, the EVC is specifically designed to empower individuals by granting them control over their vaccination information. This empowerment is crucial for ensuring continuity of care for those crossing borders or transitioning between healthcare systems."

The EVC will operate in the context of the European Health Data Spaces that requires detailed information on access the health data to be recorded.

<figure >
  <img src="ehds_legal.png" caption="Figure X.X.X.X-8: European Health Data Spaces" style="width:45em; max-width:100%"/>
  <p id="fX.X.X.X-8" class="figureTitle">Figure X.X.X.X-8: European Health Data Spaces </p>
</figure>

For more information see Regulation (EU) 2025/327 of the European Parliament and of the Council of 11 February 2025 on the European Health Data Space and amending Directive 2011/24/EU and Regulation (EU) 2024/2847. Specifically:
* [ANNEX II - Essential requirements for the harmonised software components of EHR systems and for products for which interoperability with EHR systems has been claimed](https://eur-lex.europa.eu/eli/reg/2025/327/oj#anx_II)
* [Article 9 - Right to obtain information on accessing data](https://eur-lex.europa.eu/eli/reg/2025/327/oj#art_9)

A critical privacy requirement for the EVC is unlinkability: Article 5a(16) of [Regulation (EU) No 910/2014 as amended](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A02014R0910-20241018) **Article 5a(16):** The technical framework of the European Digital Identity Wallet shall:

> (a) not allow providers of electronic attestations of attributes or any other party, after the issuance of the attestation of attributes, to obtain data that allows transactions or user behaviour to be tracked, linked or correlated, or knowledge of transactions or user behaviour to be otherwise obtained, unless explicitly authorised by the user;

> (b) enable privacy preserving techniques which ensure unlinkability, where the attestation of attributes does not require the identification of the user.
"""


Instance: UseCaseTEFCA
InstanceOf: ExampleScenario
Usage: #definition
* name = "TEFCA"
* status = $pubStatus#active
* publisher = "IHE"
* purpose = """
The [Trusted Exchange Framework and Common Agreement (TEFCA)](https://www.healthit.gov/topic/interoperability/policy/trusted-exchange-framework-and-common-agreement-tefca) is a United States initiative established by the Office of the National Coordinator for Health IT (ONC) and operated by the Sequoia Project as the Recognized Coordinating Entity (RCE). TEFCA provides a single on-ramp for nationwide health information exchange by establishing a common set of principles, terms, and conditions that enable nationwide interoperability.

Under TEFCA, Qualified Health Information Networks (QHINs) serve as the primary exchange intermediaries, facilitating data sharing among Health Information Networks (HINs), healthcare providers, payers, and public health agencies. Each QHIN must meet rigorous security, privacy, and technical requirements to participate in the TEFCA ecosystem.

**Relevance to VHL:**

TEFCA's trust model aligns with the VHL profile's trust network architecture. In the context of VHL:
- QHINs and their participants can act as VHL Sharers and VHL Receivers within the TEFCA trust framework
- TEFCA's credential and certificate management infrastructure can serve as a trust anchor for VHL exchanges
- The individual (patient) retains control over sharing their health records via VHL, consistent with TEFCA's patient access principles

**OAuth with SSRAA Option:**

Organizations already using OAuth with UDAP (via the [HL7 SSRAA IG](http://hl7.org/fhir/us/udap-security/)) can leverage VHL for health record sharing without additional authentication infrastructure. TEFCA participants, for example, can use their existing TEFCA-issued X.509 certificates and UDAP Dynamic Client Registration to authenticate VHL exchanges, enabling seamless interoperability within established national-scale health information networks.

**Verifiable Credential Option:**

TEFCA participants that have registered DID Documents in the trust network can alternatively use the Verifiable Credential Option for ITI-YY5 Retrieve Manifest authentication. A VHL Receiver acting within TEFCA self-issues a JWT-encoded Verifiable Credential (`application/vc+jwt`) using its registered DID, and presents it to the VHL Sharer via `Authorization: JWT-VC <token>`. This eliminates the need for a separate OAuth authorization server, making it well-suited for direct peer-to-peer exchanges between QHINs and participants who are already enrolled in a DID-based trust network.
"""