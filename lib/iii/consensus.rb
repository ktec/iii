module Iii
	class Consensus
		def initialize(code, options)
	    # concensus
	    period = options[:period] || 1
	    doc = Iii::Site.get("http://www.iii.co.uk/investment/detail?conperiod=#{period}&action=consensus&code=cotn%3A#{code}&display=consensus&it=le&type=consensus")
	    @title = doc.css("#doc-title").text.strip if options[:t]

	    @strong_buy_count = doc.css("tr:nth-child(1) td:nth-child(3)").text.strip
	    @weak_buy_count = doc.css("tr:nth-child(2) td:nth-child(3)").text.strip
	    @hold_user_count = doc.css("tr:nth-child(3) td:nth-child(3)").text.strip
	    @weak_sell_count = doc.css("tr:nth-child(4) td:nth-child(3)").text.strip
	    @strong_sell_count = doc.css("tr:nth-child(5) td:nth-child(3)").text.strip

	    @strong_buy = doc.css("tr:nth-child(1) td:nth-child(4)").text.strip
	    @weak_buy = doc.css("tr:nth-child(2) td:nth-child(4)").text.strip
	    @hold = doc.css("tr:nth-child(3) td:nth-child(4)").text.strip
	    @weak_sell = doc.css("tr:nth-child(4) td:nth-child(4)").text.strip
	    @strong_sell = doc.css("tr:nth-child(5) td:nth-child(4)").text.strip
		end
		def to_s
			"#{@title}\tBUY(#{@strong_buy},#{@strong_buy_count})\tSELL(#{@strong_sell},#{@strong_sell_count})"
		end
	end
end