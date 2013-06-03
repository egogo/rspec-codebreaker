require 'codebreaker/marker'

module Codebreaker
  class Game
    def initialize(output=STDOUT)
      @output = output
    end

    def start(secret, attempts=25)
      @secret, @attpempts = secret, attempts
      @output.puts 'Welcome to CodeBreaker!'
      @output.puts 'Enter the code:'
    end

    def guess(guess)
      if guess =~ /\A[1-6]{4}\z/
        @attpempts -= 1
        if @attpempts > 0 && guess == @secret
          @output.puts Codebreaker::Marker.mark(@secret, guess)
          @output.puts 'Congratulations! You won the game!'
          @output.puts 'Please enter your name to save score:'
          name = gets.chomp
          @output.puts "Score saved: #{name} --- #{@attpempts}"
        elsif @attpempts == 0
          @output.puts 'Game Over!'
          @output.puts "The code is: #@secret"
        else
          @output.puts Codebreaker::Marker.mark(@secret, guess)
        end
      else
        command(guess)
      end
    end

    private

    def command(command)
      case
        when command == 'hint'
          @output.puts "Here is the number: #{@secret[rand(0..3)]}"
        when command == 'exit'
          exit
        else
          @output.puts 'No such command, available commands: exit, hint'
      end
    end

  end
end
