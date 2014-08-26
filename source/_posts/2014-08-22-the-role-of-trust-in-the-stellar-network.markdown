---
layout: post
title: "the role of trust in the Stellar network"
date: 2014-08-22 14:59:50 -0400
comments: true
categories:
author: "Alex Browne"
author_email: stephenalexbrowne@gmail.com
---

Stellar is a brand new decentralized protocol which supports sending transactions in any currency pair
from anywhere in the world, all in a matter of seconds and with near-zero transaction fees.
You can find out more about Stellar on their official website: [stellar.org](https://www.stellar.org).

In this post, I will examine closely the role of trust in the Stellar network, dispel some
common misunderstandings about how the protocol works, evaluate some of the pros and cons of
Stellar's approach, and comment on Stellar's place in the cryptocurrency ecosystem as a whole.

There are two main areas where trust is involved in the Stellar network:

1. When transacting in non-native assets on the Stellar network, you must trust that the party
who issued those assets (known as a gateway) will be able to redeem them.
2. The consensus algorithm which powers Stellar relies on trusting a set of nodes not to collude
with one another to defraud the system. 

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
STR serves two purposes in the Stellar network: it helps protect the network from DoS attacks, and
it can serve as a bridge currency for transactions involving different foreign currencies.

The Stellar protocol is somewhat unique in that it does not just support transactions of STR, but it
also supports transactions between any two asset pairs (e.g. EUR <-> USD). Due to the fact that they
are credits and do not represent assets themselves, these other assets do involve trust and
counterparty risk. But like STR they can be transacted and traded instantly on a peer-to-peer network,
and all transactions are signed by your private key. Support for any asset is a core part of the
Stellar protocol and was baked in from the very beginning, and it is a big part of what makes
Stellar so powerful.

In order to get non-native assets onto the Stellar network, you need to go through a gateway, which
requires trust. Gateways accept customer deposits in some asset and issue credits to those customers
on the Stellar network. Some gateways can also offer exchange services, such as a web interface to
access order books, but that is not a requirement. The credits issued by a gateway can act like
currency (similar to the way depositing funds in a bank gives you credit you can spend at a store)
and they are transferable within the Stellar network for essentially no cost. The only condition is
that in order to receive an asset you must explicitly issue trust to the gateway who backs the
asset. That makes sense because you wouldn't want to receive credit from a gateway you considered
untrustworthy.

People are not unjustified in criticizing this aspect of the Stellar network. In dealing with these
credits, you run the risk that, for whatever reason, an issuing gateway might not be able to redeem
your funds. Although steps can be taken on behalf of both the gateway (insuring customer deposits,
hiring auditors), and the customer (distributing assets between more than one gateway, redeeming
credits as soon as possible), it is nonetheless a real risk. In an ideal world, every transaction
would be free of counterparty risk and reliance on third parties. However, **not all assets can be
represented in a trustless digital form**. People will still be dealing with fiat currencies for a
long time. Even in a world without government-backed fiat, physical assets such as gold and simple
financial instruments like loans could not be traded digitally without some element of trust. We
shouldn't view Stellar as a replacement for Bitcoin and everything that the cryptocurrency community
stands for. Rather, we should see Stellar as co-existing with the rest of the cryptocurrency
ecosystem while providing a faster, easier, cheaper, and safer way to deal with fiat currencies and
other real-world assets when we need to.

Consider this - the easiest way for an average person to acquire BTC today is to go through an
exchange. The process of buying BTC from an exchange is far from trustless, and usually involves
depositing USD or some other currency into an account that the exchange controls. As we all saw in
the case of Mt. Gox, it is possible for customers to lose the deposits they trusted the exchange to
hold for them.

An exchange built on the Stellar network would not require any more or any less trust. However, it
would come with the advantages of the Stellar network. Namely:

1. **A shared decentralized order book**. This means that market makers can more easily operate on
multiple exchanges, increasing liquidity for everyone. It also means it is easier for new exchanges
to enter the market.
2. **Freely traded assets**. From the perspective of an exchange, there is a cost to letting customers
deposit and withdraw funds, because those requests would hit their servers and go through their backend.
However once assets enter the network through an exchange, they can be traded peer-to-peer on the
Stellar network without touching the exchange's servers. An exchange would be able to charge transaction
fees on these trades through a special AccountSet flag in the Stellar API, but they wouldn't necessarily
need to. It's likely that competitive pressure from other gateways will drive these fees down.
3. **Hedging risk**. If several exchanges
operate on the Stellar gateway, it is relatively easy to spread your balance between them. So if one
goes down you won't lose all your funds. You could do the same thing with existing exchanges, but it
would require you setting up an account at each exchange and there would not be as much liquidity
between exchanges.



### Trust in the Consensus Algorithm

Bitcoin has a battle-tested, Proof-of-Work-based consensus algorithm which relies on two
assumptions: the software and cryptographic backbone (e.g. ECDSA and SHA-256) of the network is
secure, and no single party will obtain 51% of all computing power in the network and act
maliciously. So far, both of these assumptions have held true. Even though a mining pool called 
GHash
[did control over 51% of computing power](http://www.extremetech.com/extreme/184427-one-bitcoin-group-now-controls-51-of-total-mining-power-threatening-entire-currencys-safety)
for a short time, they did not act maliciously, because it would not have been in their best
interest to do so. Furthermore, the community acted quickly to remedy the issue. Bitcoin is
revolutionary not because it is the first trustless digital currency, but because it is the
first one that has lived up to its promise after being heavily tested in the real world. The
protocol works, and it works very well.

However, the Bitcoin consensus algorithm, like all PoW-based systems, comes with the caveat that
transactions take a long time to confirm (a minimum recommended time of about 1 hour for Bitcoin).
It is mainly this problem that Stellar aims to solve. By using a completely different algorithm for
reaching consensus between all nodes in the network, the Stellar network is able to confirm
transactions within 3-20 seconds. Like Bitcoin, the Stellar consensus process relies on the
assumptions that the software and cryptographic foundation are sound, and that a majority of nodes
on the network will not collude in order to defraud the system.

Before I continue explaining how Stellar's algorithm works, I must admit that unfortunately it is
not very clearly documented. All of the code for Stellar is
[open source](https://github.com/stellar/stellard), and one could understand exactly how it works by
reading the source code. I have browsed the code, but since C++ is not a language I am fluent in,
that is not my primary source for understanding the protocol. Instead, I have paid close attention to
the documentation on the Ripple consensus algorithm, on which Stellar's is based. (In fact, Stellar is
a fork of Ripple and retains many similarities for now, while also introducing a few improvements).
[This video](https://www.youtube.com/watch?v=pj1QVb1vlC0&feature=youtu.be) and
[this wiki page](https://ripple.com/wiki/Consensus) do a decent job of explaining how the algorithm
works.

The Stellar consensus algorithm ***does not*** require that you trust the Stellar Foundation, or
any centralized party. Anyone can start a validating node, just like anyone can start mining
Bitcoins. The consensus process on the Stellar network is decentralized.

One aspect of the algorithm which people tend to get hung up on is the UNL, a list of nodes on the
network whom you *trust* not to collude. However, that does not mean that you need to trust any
***single node*** on the network. If a single node tries to send a fraudulent transaction, any honest
validator will notice ***immediately*** and refuse to accept the transaction. Because every
validating node has a full copy of the ledger, they can determine whether someone is trying to spend
more than they have. And since all transactions are signed with a private key associated with the
sender's address, it would also be immediately obvious if a node tried to send you a transaction
which was not approved by the sender. In either case, the invalid transaction is simply discarded,
and if a node shows a pattern of sending invalid transactions, you can remove them from your UNL and
ignore all transactions they send in the future.

So the Stellar consensus algorithm does not require you to trust a centralized party, and it
does not require you to trust any single node on the network. What it does require, is that you
trust the nodes on your UNL not to ***collude***. The network is only at risk if a majority of 
nodes on the majority of UNLs collude in order to defraud the entire system. This is not so different
from a 51% attack on the Bitcoin network. 

In order to minimize the chance that nodes on your UNL collude, it is good practice to include
nodes from all over the world in many different industries, and sometimes from nodes which compete
against each other in the same industry. For example, your list could contain universities, non-profits,
businesses such as exchanges or banks, and other types of entities, all ideally from several different
continents. It doesn't matter whether a particular node in your UNL is considered trustworthy (recall
that any attempts by a singe node to commit fraud are easily foiled). It just matters that all the
nodes in your UNL are unique and that they are unlikely to collude to cheat the system. That's why
it's called a ***Unique*** Node List and not a ***Trusted*** Node List.

Admittedly, for now the Stellar consensus algorithm is neither well-documented or battle-tested.
However, David Mazières, creator of the bcrypt hashing algorithm and Chief Scientist at Stellar, is
currently working on a white paper and mathematical proof along the lines of what Satoshi Nakomoto
released for Bitcoin. Having a solid proof will help, but we can only wait and see if the Stellar
algorithm will stand the test of time.

