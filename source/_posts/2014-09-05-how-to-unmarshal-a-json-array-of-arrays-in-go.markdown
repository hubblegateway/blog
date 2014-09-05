---
layout: post
title: "How to Unmarshal a JSON Array of Arrays in Go"
date: 2014-09-05 09:46:46 -0400
comments: true
categories: 
author: "Fabio Berger"
gravatar_url: http://www.gravatar.com/avatar/b0adf63ce95744ed0a8989110277175f.png
---

I recently was dealing with a JSON object returned from an external API. I wanted to decode the JSON object into Golang structs so that I could then process and store its contents in my application. Go has a nifty [JSON Package](http://golang.org/pkg/encoding/json/) that makes this process very easy by using the Unmarshal function that takes both the JSON and a pointer to a holder struct into which it is to be decoded. 

	err := json.Unmarshal(b, &m)  // b must contain valid JSON that fits into m

This is very straightforward when dealing with JSON objects that contain objects or array of objects. But what if the API returns an array of arrays? In this case, you will need to unmarshal the JSON into a struct containing an array of arrays of either a specific type (i.e string) or an empty interface (i.e interface{}). As an example, if the API returns the following JSON:

	
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
		
	
I now want to create a struct called subject out of the inner array values listed under men. To do this, I will define a holder struct with an array of arrays and then unmarshal the JSON into it:

	holder := struct {
			Men [][]string `json:"men"`
		}{}
	if err := json.Unmarshal(data, &holder); err != nil {
			return err
		}
		
This struct has one property (Men), an array of arrays. In order to create the subject structs, we now need to loop over holder as follows:

	for _, man := range holder.Men {
			height := man[1]
			weight := man[0]
			subject := Subject{
				Height:    height,
				Weight:     weight,
			}
			subjects.Men = append(subjects.Men, subject)
		}
		
In this way, we are able to turn a JSON array of arrays into structs in Go. 

If you are dealing with arrays of arrays that contain values with variable data types, you will need to use the following holder:

	holder := struct {
			Men [][]interface{} `json:"men"`
		}{}
	if err := json.Unmarshal(data, &holder); err != nil {
			return err
		}
			
The interface{} (empty interface) serves as a general container and can therefore accept any data type. You will however have to assert the type expected for each value before using the values retrieved in holder.		