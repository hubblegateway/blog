---
layout: post
title: "Understanding Regular Keys in Stellar"
date: 2014-08-25 10:06:11 -0400
comments: true
categories: 
author: "Fabio Berger"
gravatar_url: http://www.gravatar.com/avatar/b0adf63ce95744ed0a8989110277175f.png
---

One awesome feature of the Bitcoin protocol is the ability to easily generate a new private key and corresponding wallet address on your computer. Moving over all your funds into this newly created account is easy and can be done periodically in order to defend against a potentially compromised  private key. On the Stellar protocol, you can generate new wallets the exact same way -- the only issue is that Stellar wallet addresses can have trust relationships that won't move along with your funds. Losing these “trust lines” can be very annoying and so the concept of a regular key was invented. 

To be a bit more concrete, imagine I have a Stellar wallet address with 50,000 STR, a trust line of 100 Dollars to a USD gateway and another for 200 Euros to a Euro gateway I trust. If I were to create a new wallet address and move my 50,000 STR, the trust relationships to the two gateways will not automatically be re-assigned to the new address. They would need to be re-added, something possible as long as you are the issuer of the “trust line”. If you are on the receiving end of the trust, the person who is trusting you would have to trust your new address. In order to limit the need for such cumbersome tasks, the Stellar developers created the concept of a regular key in addition to one’s private key.

A Regular Key is a secondary private key that can be assigned to your Stellar wallet address. This secondary key is granted the same privileges as the master key, letting you sign any transaction. The only exception is the ability to generate a new regular key, which only a master key will let you do. You can now give your regular key to a gateway you work with instead of your master private key. This way, you can store your master private key offline and know that it has not been compromised. In order for additional security guarantees, you can now periodically generate a new regular key in order to neutralize any stolen or floating around copies of your previous regular key. The difference with doing this versus generating a new Stellar wallet address is that you can keep your initial Stellar wallet address and will not have to re-create all the trust relationships to and from your account.

## Creating and assigning a regular key

NOTE: This code is not intended for actual use. If you are to do this process, it is highly recommended you generate a Stellar Wallet Address and private key using a random generator on your local computer instead of via an API call.

1. The first step is to generate a Stellar wallet address and private key:

{% codeblock lang:json %}
curl -X POST https://live.stellar.org:9002 -d '{
	"method" : "create_keys"
}'
{% endcodeblock %}

Result:

{% codeblock lang:json %}
{
  "result": {
    "account_id": "gGC7FTRFLjNTRk3gWCM7zwwWWbLSgT6A6y",
    "master_seed": "s3j9fcVnSNwnVTMZScpGExQg95cV4rSYJcPmhcCm3T2eJehwxNV",
    "master_seed_hex": "CFEE1389FBBB82321C6B661726504248BE868C881CE4A62669DEF6EFF19DC8D0",
    "public_key": "pEiEgTbDQHSLeCpmDdy6TmC12AZ1oZn83rc9nzjzxYkpHuinjhh",
    "public_key_hex": "504D206EADF04B079BBF66BE1729F0425AC39B65C1F23F451F80A2140044C547",
    "status": "success"
  }
}
{% endcodeblock %}

You should save this output in a safe place as it includes your new regular key (master_seed).

The next step is to assign this new regular key to our existing account:

{% codeblock lang:json %}
curl -X POST https://live.stellar.org:9002 -d '

{
  "method": "submit",
  "params": [
    {
      "secret": "YOUR_SECRET_HERE",
      "tx_json": {
        "TransactionType": "SetRegularKey",
        "RegularKey": "s3j9fcVnSNwnVTMZScpGExQg95cV4rSYJcPmhcCm3T2eJehwxNV",
      }
    }
  ]
}
'
{% endcodeblock %}

Once this returns successfully, the regular key will be set on your Stellar address and you can now use the regular key when dealing with your Stellar wallet address. If this key ever becomes compromised or you want to revoke its permissions over your wallet, you can call this exact same API call while omitting the RegularKey parameter. If you want to overwrite this regular key with a newly generated key, just call this method again with a new regular key defined. 

Although this isn't a perfect solution to the difficult problem of safeguarding one's private key, it does add an additional layer of security, especially when it comes changing your private key regularly and revoking third-party access rights to your funds. In the Bitcoin protocol, the only way to revoke these rights is to move your funds to a new address outside of the third-parties platform. In Stellar this can be done by simply revoking the regular key you have supplied to the third-party. 

