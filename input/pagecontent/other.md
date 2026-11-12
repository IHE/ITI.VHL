<div markdown="1" class="stu-note">
This section modifies other IHE profiles or the General Introduction appendices and is not a part of the VHL Profile. The content here will be incorporated into the target narrative at a future time, usually when VHL Profile goes normative.
</div>

## IHE Technical Frameworks General Introduction Appendix A: Actors

|------------------------------------------------|
| Editor, add the following new or modified actors to the [IHE Technical Frameworks General Introduction Appendix A](https://profiles.ihe.net/GeneralIntro/ch-A.html): |
{:.grid .bg-info}

| Actor                         | Definition                                                                                |
| ----------------------------- | ------------------------------------------------------------------------------------------|
| none |  |
{:.grid .table-striped}



## IHE Technical Frameworks General Introduction Appendix B: Transactions

|------------------------------------------------|
| Editor, add the following new or modified transactions to the [IHE Technical Frameworks General Introduction Appendix B](https://profiles.ihe.net/GeneralIntro/ch-B.html): |
{:.grid .bg-info}


| Transaction                    | Definition                                                                              |
| ------------------------------ | --------------------------------------------------------------------------------------- |
| none |  |
{:.grid .table-striped}

## IHE Technical Frameworks General Introduction Appendix D: Glossary

|------------------------------------------------|
| Editor, add the following new or modified terms to the [IHE Technical Frameworks General Introduction Appendix D](https://profiles.ihe.net/GeneralIntro/ch-D.html): |
{:.grid .bg-info}

| Term                         | Definition                                                    | Acronyms/Abbreviations | Synonyms    |
| ---------------------------- | --------------------------------------------------------------| -----------------------| ------------|
| Trust Network | A federated community of organizations that have agreed to mutually recognize each other's digital identities and credentials. Participation is governed by a legal or policy framework (a Trust Framework) that defines eligibility criteria, obligations, and rules of engagement. Technically, a trust network is anchored by one or more Trust Anchors — root CA certificates or DID-based keys — whose public keys are published in a shared Trust List. A new participant joins by obtaining an X.509 certificate or DID issued or endorsed by the trust network operator, and having that credential published in the Trust List. Relying parties then verify a participant's identity by confirming that their certificate or key chains to a recognized Trust Anchor in the Trust List. | | Federated Trust Community; Trust Community |
| Trust List | A list, published and signed by a Trust Anchor (or the trust network operator), of the PKI material — public keys, X.509 certificates, or DID Documents — of the participants recognized by a Trust Network, together with the usage each key is authorized for. Relying parties retrieve the Trust List to verify signatures and authenticate other participants. Because withdrawn or revoked key material is removed from subsequent versions, recipients verify the Trust List's signature against the Trust Anchor key established at onboarding, check its freshness, and do not accept a version older than one already held. | | Trust Registry; Trusted List |
{:.grid .table-striped}



