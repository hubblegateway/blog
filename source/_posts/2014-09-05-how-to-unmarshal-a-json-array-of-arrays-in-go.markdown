---
layout: post
title: "How to Unmarshal a JSON Array of Arrays in Go"
date: 2014-09-05 09:46:46 -0400
comments: true
categories: 
author: "Fabio Berger"
gravatar_url: http://www.gravatar.com/avatar/b0adf63ce95744ed0a8989110277175f.png
---

I recently was dealing with an external JSON API in a Golang application. I
wanted to decode the JSON object into structs so that I could then
process and store the data in my application. Go has a built-in
[JSON Package](http://golang.org/pkg/encoding/json/) that makes this process very
easy. You can use the Unmarshal function, which takes both the raw JSON data
and a pointer to a holder struct into which it is to be decoded, to convert
any arbitrary JSON data into data structures.

{% codeblock lang:go %}
err := json.Unmarshal(b, &m)  // b must contain valid JSON that fits into m
{% endcodeblock %}

Andrew Gerrand, one of the core developers working on the Go language, wrote an
[excellent post](http://blog.golang.org/json-and-go) on the official Go Blog which
explains the basics of JSON unmarshaling and provides some examples of working
with simple JSON data structures. But what if the API returns an array of arrays? In
this case, you will need to unmarshal the JSON into a struct containing an array of
arrays of either a specific type (i.e string) or an empty interface (i.e interface{}).
As an example, the API I was working with returned data that looked something like this:

{% codeblock lang:json %}
{
    "men": [
        [
            "1.80",
            "82"
        ],
        [
            "1.76",
            "75"
        ]
    ]
}
{% endcodeblock %}

I wanted to create a struct called subject out of the inner array values
listed under men. To do this, I will define a holder struct with a slice of
slices and then unmarshal the JSON into it:

{% codeblock lang:go %}
holder := struct {
	Men [][]string `json:"men"`
}{}
if err := json.Unmarshal(data, &holder); err != nil {
	return err
}
{% endcodeblock %}

This struct has one property (Men), a slice of slices. In order to create the
subject structs, we now need to loop over holder as follows:

{% codeblock lang:go %}
for _, man := range holder.Men {
	height := man[1]
	weight := man[0]
	subject := Subject{
		Height:    height,
		Weight:     weight,
	}
	subjects.Men = append(subjects.Men, subject)
}
{% endcodeblock %}
		
In this way, we are able to turn a JSON array of arrays into a slice of structs in Go. 

If you are dealing with arrays of arrays that contain values with variable data
types, you will need to use the following holder:

{% codeblock lang:go %}
holder := struct {
	Men [][]interface{} `json:"men"`
}{}
if err := json.Unmarshal(data, &holder); err != nil {
	return err
}
{% endcodeblock %}
			
The interface{} (empty interface) serves as a general container and can
therefore accept any data type. You will however have to assert the type
expected for each value before using the values retrieved in holder.

		