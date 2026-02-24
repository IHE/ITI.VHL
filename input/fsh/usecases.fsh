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

- while not the main point of security, leveraging the PIN is a weakness, need to enable better options for future consideration (e.g. biometrics, other authorization methods)
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
health, including optimizing available human resources through international telehealth, validating digital certificates, ensuring continuity of care, and regional resilience to face health emergencies by sharing data for public health. During the IDB-PAHO co-led event, RELACSIS 4.0,1 a plan was launched to strengthen regional digital health services and resilience, through regional data exchange and policy harmonization. Sixteen countries successfully exchanged digital vaccine certificates (COVID-19, Polio, Measles, and Yellow Fever) and critical clinical information
(diagnosis, allergy, and prescription information) using international standards during the 2nd Regional LACPASS Connectathon.2 Regional bodies and network such as the Council of Ministers of Health of Central America and the Dominican Republic (COMISCA), The Caribbean Public Health Agency (CARPHA), and the LAC Digital Health Network (RACSEL) have all identified cross-border data sharing as a priority."  
[footnote](https://ewsdata.rightsindevelopment.org/files/documents/46/IADB-RG-T4546_BBZnmFh.pdf)

The Pan American Health Organization (PAHO) and the InterAmerican Development Bank (IADB) are supporting the development of policues and digital infrastructrue to support this need. One particular priority is to improve the continuity of care for internal migrants within the region, by ensuring individuals have access to and can share their vaccination records and the International Patient Summary.

The Pan-American Highway for Health (PH4H)  "aims to provide patients with better healthcare services, regardless of their location. It will also enhance healthcare for those who move temporarily for work or study, as well as for migrants, by enabling them to share their health history, thus improving their employability and access to education. "  
[footnote](https://ewsdata.rightsindevelopment.org/files/documents/46/IADB-RG-T4546_BBZnmFh.pdf)

While there currently there is no single legal framework that broadly enables data sharing across the region, there are sub-regional networks (e.g. COMISCA, CARPHA) that have policies that can be leveraged in the short term while neccesary data sharing agreements are developed.   Thus, individuals in this region will need to be able to move through overlapping trust networks.

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

<figure>
  <img src="ehds_legal.png" caption="European Health Data Spaces" style="width:45em; max-width:100%"/>
</figure>
"""