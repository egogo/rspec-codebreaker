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
      
      context 'game over' do
        before { game.start(secret,1) }
  
        it 'shows "Game Over" when number of attempts exceeds' do
          output.should_receive(:puts).with('Game Over!')
          game.guess('1111')
        end
  
        it 'displays the code after game is over' do
          output.should_receive(:puts).with("The code is: #{secret}")
          game.guess('1111')
        end
      end
    end

    context 'right code' do
      before { game.stub(:gets).and_return('Name') }

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
      
      it 'restarts the game when "restart" command received' do
        game.should_receive(:start)
        game.guess('restart')
      end

      it 'shows "no such command" message and the list of available commands' do
        output.should_receive(:puts).with("No such command, available commands: exit, hint, restart")
        game.guess('foo')
      end
    end
  end
end
