---
layout: post
title: "the role of trust in the Stellar network"
date: 2014-08-22 14:59:50 -0400
comments: true
categories:
author: "Alex Browne"
author_email: stephenalexbrowne@gmail.com
---

(TODO: Insert introduction)

### Trusting a Gateway

Somewhat confusingly, Stellar is both the name of the currency and the name of the overarching
distributed network. For the purposes of this article, I will refer to the currency by its three
letter abbreviation (STR) and will only use the word Stellar when referring to the network as a
whole.

It is, perhaps, important to start by dispelling a common misunderstanding about how STR works. In
many ways, STR functions exactly like BTC or any of a host of other cryptocurrencies. It  is free of
counterparty risk. It is transferable without relying on a third party and without requiring that
either party trust the other. When you send STR to someone you are sending the asset itself,
***not*** an IOU or a credit. And just like with other cryptocurrencies, your STR is controlled by a
private key and can be stored in a private wallet outside of the control of any third party. In
principle, STR is just as trustless as BTC or many other cryptocurrencies, and that is by design.

STR serves two purposes in the Stellar network. First, it helps protect the network from DoS
attacks. Every user on the network is required to hold a minisculy small amount of STR (fractions of
a penny, at current prices). Second, every transaction incurs a small fee (currently 10 µSTR, which
again is fractions of a penny) which is destroyed after the transaction is accepted. I.e. the fee
does not go to the Stellar Foundation, to an issuing gateway, or to anyone else. The transaction fee
is set dynamically by servers in the network, so under periods of high traffic (e.g. during a DoS
attack), the fee increases.

However, the Stellar protocol is somewhat unique in that it does not just support transactions of
STR, but it also supports transactions between any two asset pairs (e.g. EUR <-> USD). Unlike STR,
these other assets do involve counterparty risk. They are credits or IOUs and do not represent
assets themselves. But like STR they can be transacted and traded instantly in a peer-to-peer
fashion. Support for any asset is a core part of the Stellar protocol and was baked in from the very
beginning.

In order to get non-native assets onto the Stellar network, you need to go through a gateway.
Gateways accept customer deposits in some asset and issue credits to those customers on the Stellar
network. A gateway can function in different ways. Some will work more like banks, others will work
like exchanges, and still others may find ways of setting up their business that we haven't even
thought of yet. But all gateways accept deposits and issue credits. The credits they issue are
forever attached to their Stellar address, so dollars issued by Bank A are not considered equivalent
to dollars issued by Bank B. Issued assets can act like currency (similar to the way depositing
funds in a bank gives you credit you can spend at a store) and are transferable within the Stellar
network for essentially no cost. (There is a miniscule fee, currently 10 µSTR, for every
transaction. The fee does not go to the issuing gateway but is destroyed). The only condition is
that in order to receive an asset you must explicitly issue trust to the gateway who backs the
asset. That makes sense because you wouldn't want to receive credit from a gateway you considered
untrustworthy.

People are not unjustified in criticizing this aspect of the Stellar network. In dealing with IOUs,
you run the risk that, for whatever reason, an issuing gateway might not be able to redeem your
funds. Although steps can be taken on behalf of both the gateway (insuring customer deposits, hiring
auditors), and the customer (distributing assets between more than one gateway, redeeming IOUs as
soon as possible), it is nonetheless a real risk. In an ideal world, every transaction would be free
of counterparty risk and reliance on third parties. However, we don't live in that world yet. It is
my belief that people will still be dealing with fiat currencies and other non-digital assets for a
long time. I don't view Stellar as a replacement for Bitcoin and everything that the cryptocurrency
community stands for. Rather, I see Stellar as an intermediate step, co-existing with the rest of
the cryptocurrency ecosystem while providing a faster, easier, cheaper, and safer way to deal with
fiat currencies for as long as we'll need to.

Consider this- the easiest way for an average person to acquire BTC today is to go through an
exchange. The process of buying BTC from an exchange is far from trustless, and usually involves
depositing USD or some other currency into an account that the exchange controls. As we all saw in
the case of Mt. Gox, it is possible for customers to loose the deposits they trusted the exchange to
hold for them.

An exchange built on the Stellar network would not require any more or any less trust. However, it
would come with the advantages of the Stellar network. Namely:

1. A shared decentralized order book.
	- market makers can more easily operate on multiple exchanges, increasing liquidity for everyone
	- easier for new exchanges to enter the market
2. Once assets enter the network through a gateway, they can be traded freely.
	- Peer-to-peer trades happen without the involvement of the issuing gateway or any third party
	- Instant, with near-zero transaction fees.
3. It is easier to hold balances in multiple gateways, so if one goes down you won't lose all your funds

TODO: more benefits here.




### Trust in the Concencus Protocol

- Bitcoin and many other cryptocurrencies have a battle-tested concensus algorithm,
which relies on two assumptions:
	- The software and cryptographic backbone (e.g. ECDSA and SHA-256) of the network is secure.
		- This is a reasonable assumption.
		- The algorithms were created by smart people and have been intensely scrutinized.
		- They have been battle-tested in the real world.
		- They will last for around 60 years, plenty of time to update to a better algorithm.
	- No single party will obtain 51% of all computing power in the network and act maliciously
		- Based on game theory and basic economics:
			- People won't collude
			- It would be expensive to try and buy enough hardware to get 51%
		- Mathematical proof that 6 confirmations is good enough
		- However, some altcoins have suffered from 51% attacks
		- Even bitcoin has had some parties control 51% of the network, but luckily they did not act maliciously.
- It works. And it works very very well.

- Stellar uses a completely different protocol
	- Unfortunately not very clearly documented, but that will change soon
	- David (inventor of bcrypt) is working on a white paper and mathematical proof
		- And my hunch is if he finds a problem he will fix it
	- Stellar is a fork of ripple, so we know that currently the protocol is very similar
	- Link to video
	- The UNL is a component that many people are concerned about, and perhaps justifiably so
		- UNL is ***not*** a list of nodes you trust
		- It ***is*** a list of nodes whom you trust not to collude with one another
		- Why it's called a ***unique*** node list and not a ***trusted*** node list
		- Again, based on game theory and a bit of economics
	- Say you're a validating node, what happens if you receive an invalid transaction from a node on your UNL?
