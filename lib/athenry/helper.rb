class Helper
  LINE = 80

  def announcing(msg)
    print msg 
    yield
    print "." * (LINE - msg.size - 6)
    puts "\e[32m[DONE]\e[0m"
  end 
 
  def silent(command)
    #system "#{command} &> /dev/null"
    system "#{command}"
  end

end
