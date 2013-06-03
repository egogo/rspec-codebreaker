require 'spec_helper'

describe Codebreaker::Game do
  let(:output) { mock('output').as_null_object }
  let(:secret) { '1234' }
  let(:game) { Codebreaker::Game.new(output) }

  describe '#start' do
    it 'should start game with welcome message' do
      output.should_receive(:puts).with('Welcome to CodeBreaker!')
      game.start(secret)
    end

    it 'should add a prompt for code' do
      output.should_receive(:puts).with('Enter the code:')
      game.start(secret)
    end
  end

  describe '#guess' do
    before { game.start(secret,2) }

    context 'wrong code' do

      it 'shows marked result' do
        output.should_receive(:puts).with('++--')
        game.guess('1243')
      end

      it 'shows "Game Over" when number of attempts exceeds' do
        game.guess('1111')
        output.should_receive(:puts).with('Game Over!')
        game.guess('1111')
      end

      it 'displays the code after game is over' do
        game.guess('1111')
        output.should_receive(:puts).with("The code is: #{secret}")
        game.guess('1111')
      end
    end

    context 'right code' do
      before { game.stub!(:gets).and_return('Name') }

      it 'shows ++++' do
        output.should_receive(:puts).with('++++')
        game.guess(secret)
      end

      it 'shows congratulation message' do
        output.should_receive(:puts).with('Congratulations! You won the game!')
        game.guess(secret)
      end

      it 'prompts to save score' do
        output.should_receive(:puts).with('Please enter your name to save score:')
        game.guess(secret)
      end

      it 'saves score' do
        output.should_receive(:puts).with('Score saved: Name --- 1')
        game.guess(secret)
      end
    end

    context 'command' do
      it 'exits the game when "exit" command received' do
        lambda { game.guess('exit') }.should raise_error SystemExit
      end

      it 'shows hint when "hint" command received' do
        output.should_receive(:puts).with(/Here is the number: [#{secret}]/)
        game.guess('hint')
      end

      it 'shows "no such command" message and the list of available commands' do
        output.should_receive(:puts).with("No such command, available commands: exit, hint")
        game.guess('foo')
      end
    end
  end

    # Code-breaker starts game
    # The code-breaker opens a shell, types a command, and sees
    # a welcome message and a prompt to enter the first guess.
    #
    # Code-breaker submits guess
    # The code-breaker enters a guess, and the system replies by
    # marking the guess according to the marking algorithm.
    #
    # Code-breaker wins game
    # The code-breaker enters a guess that matches the secret
    # code exactly. The system responds by marking the guess with
    # four + signs and a message congratulating the code-breaker
    # on breaking the code in however many guesses it took.
    #
    # Code-breaker loses game
    # After some number of turns, the game tells the code-breaker
    # that the game is over (need to decide how many turns and whether to reveal the code).
    #
    # Code-breaker plays again
    # After the game is won or lost, the system prompts the code-breaker
    # to play again. If the code-breaker indicates yes, a new game begins.
    # If the code-breaker indicates no, the system shuts down.
    #
    # Code-breaker requests hint
    # At any time during a game, the code-breaker can request a hint,
    # at which point the system reveals one of the numbers in the secret code.
    #
    # Code-breaker saves score
    # After the game is won or lost, the code-breaker can opt to save
    # information about the game: who (initials?), how many turns, and so on.
end
