---
layout: post
title: "The Power of Pathfinding"
date: 2014-09-05 16:08:45 -0400
comments: true
categories: 
author: "Alex Browne"
gravatar_url: http://www.gravatar.com/avatar/c2c5b5e4028c774cf620fe99133a3a54.png
---

Path-finding is a powerful (but currently not well-documented) feature of the Stellar
protocol. In short, it allows two parties who don't trust each other, don't trust
the same gateway, and don't even deal in the same currencies to transact with one
another seamlessly.

The best way to explain why this feature kicks ass is with an
example. So a bulk of this post contains step-by-step instructions for executing a
transaction which utilizes path-finding on the Stellar test network.

If you want to find out more about Stellar and everything it has to offer,
visit the [official Stellar website](http://stellar.org). You can also read my
[previous post](/blog/2014/08/22/the-role-of-trust-in-the-stellar-network/) to
learn more about what trusting a gateway means.

### Prerequisites

The following instructions are as simple as possible and only require that you
are familiar with using terminal or command prompt. The instructions will frequently
make use of curl, a command line tool for sending a variety of http requests which
is available for most major operating systems. If you are using Windows, you may
need to [download it and install a windows version](http://www.confusedbycode.com/curl/).

### Step-By-Step Example

The hypothetical scenario we will be creating in this example is as follows:

- User A wishes to send money to User B.
- User A trusts Gateway A but not Gateway B.
- User B trusts Gateway B but not Gateway A.
- User A deals only with USD and does not want to hold other currencies.
- User B deals only with EUR and does not want to hold other currencies.
- Market Maker trusts both Gateway A and Gateway B and wants to make a profit by facilitating the transfer of funds between them.

There are 5 parties, so we will need to create 5 Stellar accounts:

1. User A
2. User B
3. Gateway A
4. Gateway B
5. Market Maker

#### Creating Accounts

To create a new Stellar account and get the associated private key, we can send
a ["create_keys" command](https://www.stellar.org/api/#api-create_keys) to the Stellar API.

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '{ "method" : "create_keys" }'
{% endcodeblock %}

Assuming the request is successful, you will see a response that looks like this:

{% codeblock lang:json %}
{
	"result" : {
		"account_id" : "gJU8rYpFo83EKnTyAuGsSjGaDEjVM8yBzZ",
		"master_seed" : "sfZ7e76taaEVA5uemki2LLpVxexyW3DHUyMPQ2aaQkod7xDEcjA",
		"master_seed_hex" : "364AD5D4CA27ADEEB0D3B47D5414DBC85A70D06914498921DFC23E92A10B9AAA",
		"public_key" : "pEr6kLY8vRFCJvTUqipxAtmsYJKYuGexjpiVvUKD7gkEVYRV6Rc",
		"public_key_hex" : "3AA450F08918998364D034F0878F81B822B964B05FB5B40912FBD351CBAB0A0D",
		"status" : "success"
	}
}
{% endcodeblock %}

You should repeat this process 5 times and store the `account_id` and `master_seed` fields
for each of the 5 parties in a file somewhere. For example, when I did this, I stored all the
keys in a json file that looks like this:

{% codeblock lang:json %}
{
	"User A": {
		"account_id": "gPCLdFSdGz5hjcRHAaHJmyjHKFTwKrj9ah",
		"master_seed": "sfC2bHDbxjSi43EK9z7YEUjbWWpiyjrhYBDJvdA9eQpVLAGudic"
	},
	"User B": {
		"account_id": "g4cMXBXsvfY4bDj3ySePy1yFqStkgmkBRU",
		"master_seed": "sfzUFM8LeEP2ZpsgtrBmk9S52JUEXj7qCzjUNXcD5HxHgzkjtLU"
	},
	"Gatway A": {
		"account_id": "gwUvTMv3tk2BSvtbSDCAARKRMaxUNzTbAC",
		"master_seed": "s9ghgeWGHpgabZoKWStZtPGZA7V44MohUGzmDS45eRAR1XQC5HG"
	},
	"Gateway B": {
		"account_id": "gDvG7eksMqoUmzpaFvUkHmbMTn9JqfUCy",
		"master_seed": "sf5qnvbSPf5m6ea4L4Ae9PrNnkDRqgAi4dGXgT3KLz1RobRNA7Y"
	},
	"Market Maker": {
		"account_id": "gsFuBehN2GqGzv49yYvE6ufTNU6yPvw46e",
		"master_seed": "sfQ8UcLAT1Pfmzzi96y6dVoX8FCEQB2H2rJzpYhuW17WG8WR1tj"
	}
}
{% endcodeblock %}

#### Getting STR

Every account needs a minimum amount of STR to start making transactions and issuing trust
on the gateway. Luckily, since we're on the test network, we can use friendbot to get these
STR for free.

To send 1000 STR (more than enough) to an account on the test network,
use the following curl request:

{% codeblock lang:bash %}
curl https://api-stg.stellar.org/friendbot?addr=yourAddressHere
{% endcodeblock %}

You will need to do this once for each account. Once all 5 accounts have some STR, we can
continue.

#### Setting Trust

To continue creating our scenario, we will need to have User A issue trust to Gateway A
and User B issue trust to Gateway B. What "trust" means in this context is that a user is
willing to accept credit from a gateway and trusts that they
will be able to redeem that credit for real fiat at a later date. To do this, we're going to
use the [submit method with a TransactionType of "TrustSet"](https://www.stellar.org/api/#api-trustset).

If you're following along, your keys and addresses will be different than mine. So throughout
the rest of this post, I'm going to use dot notation for the different
keys and addresses you will need. So `UserA.account_id` simply means the account_id for User A.
Since these attributes are strings, don't forget to wrap them in quotes.

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "submit",
  "params": [
    {
      "secret": UserA.master_seed,
      "tx_json": {
        "TransactionType": "TrustSet",
        "Account": UserA.account_id,
        "LimitAmount": {
          "currency": "USD",
          "value": "1000",
          "issuer": GatewayA.account_id
        }
      }
    }
  ]
}'
{% endcodeblock %}

After you have run the command, User A will trust Gateway A for up to 1000 USD. You will also
need to do this for User B and Gatway B, though this time extending trust for 1000 EUR.

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "submit",
  "params": [
    {
      "secret": UserB.master_seed,
      "tx_json": {
        "TransactionType": "TrustSet",
        "Account": UserB.account_id,
        "LimitAmount": {
          "currency": "EUR",
          "value": "1000",
          "issuer": GatewayB.account_id
        }
      }
    }
  ]
}'
{% endcodeblock %}

And finally, Market Maker need to trust both gateways, so you will need submit two more
SetTrust transactions:

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "submit",
  "params": [
    {
      "secret": MarketMaker.master_seed,
      "tx_json": {
        "TransactionType": "TrustSet",
        "Account": MarketMaker.account_id,
        "LimitAmount": {
          "currency": "EUR",
          "value": "1000",
          "issuer": GatewayB.account_id
        }
      }
    }
  ]
}'
{% endcodeblock %}

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "submit",
  "params": [
    {
      "secret": MarketMaker.master_seed,
      "tx_json": {
        "TransactionType": "TrustSet",
        "Account": MarketMaker.account_id,
        "LimitAmount": {
          "currency": "USD",
          "value": "1000",
          "issuer": GatewayA.account_id
        }
      }
    }
  ]
}'
{% endcodeblock %}

#### Issuing Credit

With all parties having set trust for their respective gateways, those gateways can now issue credit 
to them. In the real world, the gateways would be accepting customer deposits and then issuing the same
amount (minus fees) of credit.

To issue credit, we will use the
[submit method with a TransactionType of "Payment"](https://www.stellar.org/api/#api-payment).

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "submit",
  "params": [
    {
      "secret": GatewayA.master_seed,
      "tx_json": {
        "TransactionType": "Payment",
        "Account": GatewayA.account_id,
        "Destination": UserA.account_id,
        "Amount": {
          "currency": "USD",
          "value": "1000",
          "issuer": GatewayA.account_id
        }
      }
    }
  ]
}'
{% endcodeblock %}

Gateway A just sent 1,000 USD to User A. Since Gateway A is the issuer of the currency,
they can send as much as they want to anyone who trusts them. If you want, you can verify that
User A has 1,000 USD by searching for User A's address on the
[Stellar Explorer](https://www.stellar.org/viewer/#test). (Make sure you set it to look in the
test network by clicking the "Test" button!)

We'll also need to have Gateway B issue Market Maker some EUR. Do that with the following command:

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "submit",
  "params": [
    {
      "secret": GatewayB.master_seed,
      "tx_json": {
        "TransactionType": "Payment",
        "Account": GatewayB.account_id,
        "Destination": MarketMaker.account_id,
        "Amount": {
          "currency": "EUR",
          "value": "1000",
          "issuer": MarketMaker.account_id
        }
      }
    }
  ]
}'
{% endcodeblock %}


#### Market Making

There is one more piece we need to add in order for path-finding to work. Market Maker
will need to submit an order to facilitating transactions between Gateway A
and Gateway B. To do this, we'll use the
[submit method with a TransactionType of "OfferCreate"](https://www.stellar.org/api/#api-offercreate)

{% codeblock lang:bash%}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "submit",
  "params": [
    {
      "secret": MarketMaker.master_seed,
      "tx_json": {
        "TransactionType": "OfferCreate",
        "Account": MarketMaker.account_id,
        "TakerGets": {
          "currency": "EUR",
          "value": "765",
          "issuer": GatewayB.account_id
        },
        "TakerPays": {
          "currency": "USD",
          "value": "1000",
          "issuer": GatewayA.account_id
        }
      }
    }
  ]
}'
{% endcodeblock %}

The offer states that the taker (the person who accepts the offer) will get 765 EUR
in exchange for 1,000 USD. Market Maker will be able to earn a profit if someone accepts
this trade, because he is paying the taker slightly less EUR than
[what 1,000 USD is worth](https://www.google.com/search?q=convert+1000+USD+to+EUR)
(if we go by the prices at the time I wrote this post). He competes with other market
makers in an effort to provide the best deal for the taker.

With this offer on the books, we have everything in place to perform path-finding.

#### Finding a Path

Now, User A has a balance of 1000 USD and they want to send around 500 USD
to their friend. However User B does not deal in USD and would prefer to be paid
in EUR. We can use the ["static_path_find" method](https://www.stellar.org/api/#api-static_path_find)
to ask the network if there is a way for User A to convert their USD to EUR. In this
case, the API requires that we specify the amount of EUR that User B will get. We can just
go by the current market price and say that we want User B to receive 386 EUR.

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
  "method": "static_path_find",
  "params": [
    {
      "source_account": UserA.account_id,
      "destination_account": UserB.account_id,
      "destination_amount": {
        "currency": "EUR",
        "value": "386",
        "issuer": GatewayB.account_id
      }
    }
  ]
}'
{% endcodeblock %}

If everything worked, the reply will look something like this:

{% codeblock lang:json %}
{
    "result": {
        "alternatives": [
            {
                "paths_computed": [
                    [
                        {
                            "account": "gwUvTMv3tk2BSvtbSDCAARKRMaxUNzTbAC",
                            "type": 1
                        },
                        {
                            "currency": "EUR",
                            "issuer": "gDvG7eksMqoUmzpaFvUkHmbMTn9JqfUCy",
                            "type": 48
                        },
                        {
                            "account": "gDvG7eksMqoUmzpaFvUkHmbMTn9JqfUCy",
                            "type": 1
                        }
                    ]
                ],
                "source_amount": {
                    "currency": "USD",
                    "issuer": "gPCLdFSdGz5hjcRHAaHJmyjHKFTwKrj9ah",
                    "value": "504.5751633986928"
                }
            }
        ],
        "destination_account": "g4cMXBXsvfY4bDj3ySePy1yFqStkgmkBRU",
        "destination_currencies": [
            "EUR",
            "STR"
        ],
        "status": "success"
    }
}
{% endcodeblock %}

The Stellar network has automatically determined the cheapest path based on
what gateways User A and User B trust and what open offers exist. In this case,
the cheapest path was through the offer created by Market Maker. The part of
the reply that User A cares about most is how much it will cost them to send
386 EUR to their friend. `"value": "504.5751633986928"` tells us it would
cost about 504 USD.

Now we need to actually execute the transaction and take advantage of the
path we just found. To do that, we're going to use the 
[submit method with a TransactionType of "Payment"](https://www.stellar.org/api/#api-payment).
We'll also need to include two special parameters to the request to let
the Stellar network know we want to use the path we just found.

1. Paths: an array of possible paths to convert USD to EUR. Here we'll basically just copy the computed_paths from our static_path_find. 
2. SendMax: the maximum amount that User A is willing to pay. We'll give some wiggle room here in case the market changes and set the maximum to 505 USD.

Note that SendMax is the *maximum* amount that User A is willing to pay. Stellar will automatically
find the cheapest option for User A, so they may end up paying less.

{% codeblock lang:bash %}
curl -X POST https://test.stellar.org:9002 -d '
{
    "method": "submit",
    "params": [
        {
            "secret": "sfC2bHDbxjSi43EK9z7YEUjbWWpiyjrhYBDJvdA9eQpVLAGudic",
            "tx_json": {
                "TransactionType": "Payment",
                "Account": "gPCLdFSdGz5hjcRHAaHJmyjHKFTwKrj9ah",
                "Destination": "g4cMXBXsvfY4bDj3ySePy1yFqStkgmkBRU",
                "SendMax": {
                    "currency": "USD",
                    "value": "505",
                    "issuer": "gwUvTMv3tk2BSvtbSDCAARKRMaxUNzTbAC"
                },
                "Amount": {
                    "currency": "EUR",
                    "value": "386",
                    "issuer": "gDvG7eksMqoUmzpaFvUkHmbMTn9JqfUCy"
                },
                "Paths": [
                    [
                        {
                            "account": "gwUvTMv3tk2BSvtbSDCAARKRMaxUNzTbAC",
                            "type": 1
                        },
                        {
                            "currency": "EUR",
                            "issuer": "gDvG7eksMqoUmzpaFvUkHmbMTn9JqfUCy",
                            "type": 48
                        },
                        {
                            "account": "gDvG7eksMqoUmzpaFvUkHmbMTn9JqfUCy",
                            "type": 1
                        }
                    ]
                ]
            }
        }
    ]
}'
{% endcodeblock %}



