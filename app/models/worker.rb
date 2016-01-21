class Worker



  def self.execute


    # account = Account.first
    # if account.nil?
    #   puts 'no account'
    #   return nil
    # end
    @operator = WebOperator.new


    # @operator.user= account.user
    # @operator.password= account.password
    #
    # result = @operator.login
    # unless result
    #   puts 'logging in was failed'
    # end


    result = @operator.search
    unless result
      puts 'searching was failed'
    end


  end

end