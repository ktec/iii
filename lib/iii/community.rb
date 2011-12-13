module Iii
	class Community
		def initialize(options)
			# TODO Look into setting up color output http://linuxtidbits.wordpress.com/2008/08/11/output-color-on-bash-scripts/
	    # concensus
	    doc = Iii::Site.get("http://www.iii.co.uk/community/")
	    @list = []
	    doc.css(".tabular tr").each do |row|
	      #result[:hottest] << [link.text.to_s,`./bin/iii consensus -c #{link.text.to_s} --sb -p 1`]
	      begin
		      inst = {
	        	:code => row.css("td:nth-child(1)")[0].text.strip,
	        	:price => row.css("td:nth-child(4)")[0].text.strip,
	        	:change => row.css("td:nth-child(6)")[0].text.strip
		      }
	      rescue
	        next
	      end
	      @list << inst
	    end
	    @table_headings = options[:table_headings]
	    @delimiter = options[:delimiter]
	    @plain = options[:plain]
	    # sorting options
	    @list.sort_by!{|k| k[:price].to_f } if options[:sort] =~ /p/
	    @list.sort_by!{|k| k[:change].to_f } if options[:sort] =~ /c/
	    @list.reverse! if options[:sort] =~ /_desc/
		end
		def to_s
			str = @table_headings ? "code#{@delimiter}price#{@delimiter}change (%+/-)" : "" 
			if @plain
		    @list.inject(str) {|x,i| x << "#{" " unless x.empty?}#{i[:code]}"}
			else
		    @list.inject(str) {|x,i| x << "#{"\n" unless x.empty?}#{i[:code]}#{@delimiter}#{i[:price]}#{@delimiter}#{i[:change]}"}
			end
		end
	end
end