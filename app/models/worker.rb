class Worker

  include LogManager

  def self.execute


    # account = Account.first
    # if account.nil?
    #   write_log 'no account'
    #   return nil
    # end
    @operator = WebOperator.new


    # @operator.user= account.user
    # @operator.password= account.password
    #
    # result = @operator.login
    # unless result
    #   write_log 'logging in was failed'
    # end


    result = @operator.search
    unless result
      write_log 'searching was failed'
    end

    result = @operator.rooms
    if result.content.blank?
      write_log  result.message if result.message.present?
      write_log 'rooms were not found'
    end

    result

  end

end