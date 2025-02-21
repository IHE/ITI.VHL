

Instance:   publish-pki-material
InstanceOf: Requirements
Usage: #definition
* title = "Publish PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Publish trust material to a Trust Anchor"
* actor[+] = Canonical(VHLSharer)
* actor[+] = Canonical(VHLReceiver)



Instance:   receive-pki-material
InstanceOf: Requirements
Usage: #definition
* title = "Receive PKI material"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Receive trust material from a VHL Sharer or VHL Receiver, as trust network participants, for distribution amongst "
* actor[+] = Canonical(TrustAnchor)



Instance:   accept-mtls-connection
InstanceOf: Requirements
Usage: #definition
* title = "Accept mTLS"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Accept an mTLS in order to conduct further transactions under a secure channel"
* actor[+] = Canonical(VHLSharer)


Instance:   initiate-mtls-connection
InstanceOf: Requirements
Usage: #definition
* title = "Initiate mTLS"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Initiate an mTLS in order to conduct further transactions under a secure channel"
* actor[+] = Canonical(VHLReceiver)


Instance:   provide-a-vhl-to-a-receiver
InstanceOf: Requirements
Usage: #definition
* title = "Provide VHL"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Is able to provide a VHL authorization mechanism to a VHL Receiver"
* actor[+] = Canonical(VHLHolder)


Instance:   receive-a-vhl
InstanceOf: Requirements
Usage: #definition
* title = "Receive VHL"
* status = $pubStatus#active
* publisher = "IHE"
* description = "Is able to receive a VHL authorization mechanism from a VHL Holder"
* actor[+] = Canonical(VHLSharer)



