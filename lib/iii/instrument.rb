module Iii
	class Instrument
		attr_reader :title,:bid,:price
		def initialize(code)
			@code = code
      doc = Iii::Site.get("http://www.iii.co.uk/investment/detail?code=cotn:#{@code}")
      begin
	      #@title = doc.css("#doc-title")[0].text.strip
	      #@summary = doc.css("p:nth-child(10)")[0].text.strip
	      @bid = doc.css(".symbol-val-bid")[0].text.strip
	      @ask = doc.css(".symbol-val-ask")[0].text.strip
	      @price = doc.css(".symbol-calc-midprice")[0].text.strip
	      @previous = doc.css(".symbol-val-previousclosingprice")[0].text.strip
	      @last = doc.css(".symbol-val-lastprice")[0].text.strip
	      @volume = doc.css(".symbol-val-totalvolume")[0].text.strip
	      @high = doc.css(".symbol-val-high")[0].text.strip
	      @low = doc.css(".symbol-val-low")[0].text.strip
	      @months_biggest_mover = doc.css(".panel tr:nth-child(1) td:nth-child(1) a")[0].text.strip
	    rescue
	    	puts "something didnt work"
	    end
		end
		def to_s
      "code\tbid\task\tprice\tprevious\tlast\tvolume\thigh\tlow\n" + 
      "#{@code}\t#{@bid}\t#{@ask}\t#{@price}\t#{@previous}\t#{@last}\t#{@volume}\t#{@high}\t#{@low}"
		end
	end
end