class Helper

  def announcing(msg)
    puts "\e[32m*\e[0m #{msg} \n"
    yield
  end 
 
  def silent(command)
    #system "#{command} &> /dev/null"
    system "#{command}"
  end

end
