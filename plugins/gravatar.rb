# This is a plugin for generating gravatar urls from an email address.
#
# The value you provide to the tag should be a variable, not a string literal.
# You can create a new variable by using {% assign email = "youremail@example.com" %}
#
# Returns a url, not an img tag.
# 
# Usage: {% gravatar email %}
#
# Paolo Perego, <thesp0nge@gmail.com>, v20120504.a
# based on https://github.com/thesp0nge/octopress_gravatar_plugin
#
require 'digest/md5'

module Jekyll
	class Gravatar < Liquid::Tag
		@email_address = nil

		# find the value of a given variable,
		# supports nested hash variables via the "." operator
		# e.g. post.email
		def look_up(context, name)
			lookup = context

			name.split(".").each do |value|
				lookup = lookup[value]
			end

			lookup
		end

		def initialize(tagname, email_address, tokens)
			email_address ||= ""
			@email_address = email_address
			super
		end

		# downcase and hash the email address to create a
		# gravatar url
		def render(context)
			if @email_address =~ /([\w]+(\.[\w]+)*)/i
				parsed = look_up(context, $1)
				if parsed.nil? || @email_address == ""
					# TODO: if email address not provided, use a default hubble logo
					hash = Digest::MD5.hexdigest("")
					return "http://www.gravatar.com/avatar/#{hash}?d=retro"
				end
				@email_address = parsed
			end
			hash = Digest::MD5.hexdigest(@email_address.downcase.gsub(/\s+/, ""))
	      "http://www.gravatar.com/avatar/#{hash}"
		end

	end
end

Liquid::Template.register_tag('gravatar', Jekyll::Gravatar)
